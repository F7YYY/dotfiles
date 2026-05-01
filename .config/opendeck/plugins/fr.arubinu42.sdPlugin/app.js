/* global $CC, Utils, $SD */

let ws = null,
  connecting = false,
  last_context = false,
  reconnectTimeout = null;

/**
 * Actions & More
 */

const settingsCache = {
    WS_IP: 'localhost',
    WS_PORT: '5042',
    WS_CONNECTED: false
  },
  actions = {
    settings: {},

    onDidReceiveGlobalSettings: jsn => {
      const settings = (jsn.payload.settings || {});
      for (const key in settings) {
        if (key === 'WS_CONNECTED') {
          continue;
        }

        settingsCache[key] = settings[key];
      }

      if (settingsCache.WS_PORT) { // settingsCache.WS_PASS != undefined
        ws_connect(jsn.context);
      }
    },

    onDidReceiveSettings: jsn => {
      actions.settings = Utils.getProp(jsn, 'payload.settings', {});
      actions.setTitle(jsn);
    },

    onKeyUp: jsn => {
      const action = jsn.action,
        settings = jsn.payload.settings || {},
        actionName = action.split('.action.')[1].replace(/-/gi, '_').toUpperCase();

      if (actionName === 'SCRIPTS_MANAGER.CUSTOM_REQUEST' && settings.hasOwnProperty('message')) {
        if (settings.hasOwnProperty('isJson') && settings.isJson) {
          ws.send(JSON.stringify(JSON.parse(settings.message)));
        } else {
          ws.send(JSON.stringify(settings.message));
        }
      } else if (actionName === 'SCRIPTS_MANAGER.TOGGLE_SCRIPT' && settings.hasOwnProperty('script')) {
        ws.send(JSON.stringify({ target: 'manager', name: 'enabled', data: { name: settings.script, state: get_state(settings.state) } }));
      } else if (actionName === 'MULTI_ACTIONS.BUTTON' && settings.hasOwnProperty('id')) {
        ws.send(JSON.stringify({ target: 'multi-actions', name: 'block', data: parseInt(settings.id) }));
      } else if (actionName === 'MULTI_ACTIONS.VARIABLE_SETTER' && settings.hasOwnProperty('name') && settings.hasOwnProperty('type') && settings.hasOwnProperty('scope')) {
        let value = settings.string;
        if (settings.type === 'number') {
          value = parseInt(settings.number);
        } else if (settings.type === 'boolean') {
          value = settings.boolean === 'true';
        }

        ws.send(JSON.stringify({ target: 'multi-actions', name: 'variable', data: {
          name: settings.name,
          scope: settings.scope,
          value
        } }));
      } else if (actionName === 'NOTIFICATIONS.CORNER' && settings.hasOwnProperty('corner')) {
        ws.send(JSON.stringify({ target: 'notifications', name: 'corner', data: settings.corner }));
      } else if (actionName === 'NOTIFICATIONS.NEXT_SCREEN') {
        ws.send(JSON.stringify({ target: 'notifications', name: 'next-screen' }));
      } else if (actionName === 'STREAM_FLASH.NEXT_SCREEN') {
        ws.send(JSON.stringify({ target: 'stream-flash', name: 'next-screen' }));
      } else if (actionName === 'STREAM_FLASH.PAUSE' && settings.hasOwnProperty('state')) {
        let state = undefined;
        if (settings.hasOwnProperty('state')) {
          if (settings.state === 'enable') {
            state = true;
          } else if (settings.state === 'disable') {
            state = false;
          }
        }

        ws.send(JSON.stringify({ target: 'stream-flash', name: 'pause', data: { state } }));
      } else if (actionName === 'STREAM_WIDGETS.NEXT_SCREEN') {
        ws.send(JSON.stringify({ target: 'stream-widgets', name: 'next-screen' }));
      } else if (actionName === 'STREAM_WIDGETS.REPLACE_URL' && settings.hasOwnProperty('widget') && settings.hasOwnProperty('url')) {
        ws.send(JSON.stringify({ target: 'stream-widgets', name: 'replace-url', data: { name: settings.widget, url: settings.url } }));
      } else if (actionName === 'STREAM_WIDGETS.TOGGLE_WIDGET' && settings.hasOwnProperty('widget')) {
        ws.send(JSON.stringify({ target: 'stream-widgets', name: 'toggle-widget', data: { name: settings.widget, state: get_state(settings.state) } }));
      } else if (actionName === 'PHASMOPHOBIA.EVIDENCE') {
        ws.send(JSON.stringify({
          origin: 'arubinu42',
          data: {
            target: 'phasmophobia',
            name: `${settings.mode}-evidence`,
            data: settings.evidence
          }
        }));
      } else if (actionName === 'PHASMOPHOBIA.RESET') {
        ws.send(JSON.stringify({
          origin: 'arubinu42',
          data: {
            target: 'phasmophobia',
            name: 'reset-evidence',
            data: undefined
          }
        }));
      }
    },

    onSendToPlugin: jsn => {
      const payload = jsn.payload || {};
      if (payload.hasOwnProperty('WS_REQUEST')) {
        last_context = jsn.context;
        ws.send(JSON.stringify({ target: 'manager', name: payload.WS_REQUEST }));
      } else if (payload.hasOwnProperty('WS_DO_CONNECT')) {
        settingsCache.WS_IP = payload.WS_DO_CONNECT.ip;
        settingsCache.WS_PORT = payload.WS_DO_CONNECT.port;
        //settingsCache.WS_PASS = payload.WS_DO_CONNECT.pass;

        return ws_connect(jsn.context);
      }

      for (const key in payload) {
        if (settingsCache.hasOwnProperty(key)) {
          const newValue = payload[key];
          settingsCache[key] = newValue;
          //actions.saveSettings(jsn.context, { value: newValue });
        }
      }

      $SD.api.setGlobalSettings($SD.uuid, settingsCache);
    },

    saveSettings: (jsn, sdpi_collection) => {
      if (sdpi_collection.hasOwnProperty('key') && sdpi_collection.key != '') {
        if (sdpi_collection.value && sdpi_collection.value !== undefined) {
          actions.settings[sdpi_collection.key] = sdpi_collection.value;
          $SD.api.setSettings(jsn.context, actions.settings);
        }
      }
    },

    setTitle: jsn => {
      if (actions.settings && actions.settings.hasOwnProperty('mynameinput')) {
        $SD.api.setTitle(jsn.context, actions.settings.mynameinput);
      }
    },
  };

/**
 * Connect to Scripts Manager via WebSocket
 */
function ws_connect(context) {
  if (connecting || settingsCache.WS_CONNECTED === true) {
    return;
  }

  connecting = true;
  ws = new WebSocket(`ws://${settingsCache.WS_IP ? settingsCache.WS_IP : 'localhost'}:${settingsCache.WS_PORT}`);

  ws.onopen = () => {
    console.log('socket.onopen');

    connecting = false;
    const changed = settingsCache.WS_CONNECTED !== true;
    settingsCache.WS_CONNECTED = true;

    // If state has changed, tell the property inspector
    if (changed) {
      $SD.api.setGlobalSettings($SD.uuid, settingsCache);
    }
  };

  ws.onmessage = event => { // Received message from Stream Deck
    let data = event.data;
    if (typeof data === 'string')
    {
      try {
        data = JSON.parse(data);
      }
      catch (e) {}
    }

    if (typeof data === 'object' && typeof data.name === 'string' && last_context) {
      $SD.api.sendToPropertyInspector(last_context, data);
    }
  }

  ws.onclose = event => {
    if (event.wasClean) {
      console.log(`socket.onclose: Connection closed cleanly, code=${event.code} reason=${event.reason}`);
    } else {
      console.log('socket.onclose: Connection died');
    }

    const changed = settingsCache.WS_CONNECTED !== false;
    settingsCache.WS_CONNECTED = false;

    // If state has changed, tell the property inspector
    if (changed) {
      $SD.api.setGlobalSettings($SD.uuid, settingsCache);
    }

    connecting = false;
    clearTimeout(reconnectTimeout);
    reconnectTimeout = setTimeout(() => {
      ws_connect(context);
    }, 3000);
  };

  ws.onerror = error => {
    if (error.message) {
      console.log('socket.onerror:', error.message);
    }

    ws.close();
  };
}

/**
 * Methods
 */

function get_state(state) {
  if (state === 'enable') {
    return true;
  } else if (state === 'disable') {
    return false;
  }

  return undefined;
}

/**
 * Connection: Subscribe to events
 */

$SD.on('connected', jsn => {
  $SD.api.getGlobalSettings(jsn.uuid);

  for (const action of [
    'scripts-manager.custom-request',
    'scripts-manager.toggle-script',
    'multi-actions.button',
    'multi-actions.variable-setter',
    'notifications.corner',
    'notifications.next-screen',
    'stream-flash.next-screen',
    'stream-flash.pause',
    'stream-widgets.next-screen',
    'stream-widgets.replace-url',
    'stream-widgets.toggle-widget',
    'phasmophobia.evidence',
    'phasmophobia.reset'
  ]) {
    $SD.on(`fr.arubinu42.action.${action}.keyUp`, actions.onKeyUp);
    $SD.on(`fr.arubinu42.action.${action}.sendToPlugin`, actions.onSendToPlugin);
    $SD.on(`fr.arubinu42.action.${action}.didReceiveSettings`, actions.onDidReceiveSettings);
  }
});

$SD.on('didReceiveGlobalSettings', actions.onDidReceiveGlobalSettings);