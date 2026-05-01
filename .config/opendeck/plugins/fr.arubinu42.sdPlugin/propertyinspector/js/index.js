let uuid = '',
  actionName = '',
  ignoreEmpty = [
    'script'
  ],
  pluginAction = null,
  actionSettings = {};

function SyncChange(event) {
  const name = this.dataset.sync,
    update = (event || !actionSettings.hasOwnProperty(name));

  let value = this.value;
  if (this.getAttribute('type') === 'checkbox') {
    value = this.checked;
  } else if (this.getAttribute('type') === 'radio') {
    for (const radio of document.querySelectorAll(`[name="${this.name}"]`)) {
      if (radio.checked) {
        value = radio.value;
      }
    }
  } else if (!value && ignoreEmpty.indexOf(name) >= 0) {
    return;
  }

  console.log('change:', name, 'value:', value, 'update:', update);
  actionSettings[name] = value;
  if (update) {
    $SD.api.setSettings($SD.uuid, actionSettings);
  }

  choice(this, value);
}

if ($SD) {
  $SD.on('connected', jsn => {
    const settings = jsn.actionInfo.payload.settings;

    actionName = jsn.actionInfo['action'].split('.action.')[1].replace(/-/gi, '_').toUpperCase();
    if (jsn.hasOwnProperty('actionInfo')) {
      pluginAction = jsn.actionInfo['action'];
    }

    const holders = document.querySelectorAll(`[data-action*="${actionName}"]:not([data-for])`);
    for (let i = 0; i < holders.length; ++i) {
      const el = holders[i];
      el.classList.remove('hidden');
    }
    const holdersRemove = document.querySelectorAll('.hidden:not([data-for])');
    for (let i = 0; i < holdersRemove.length; ++i) {
      const el = holdersRemove[i];
      el.parentElement.removeChild(el);
    }

    actionSettings = Utils.getProp(jsn, 'actionInfo.payload.settings', false);
    populate(actionSettings);

    for (const el of document.querySelectorAll('[data-sync]')) {
      el.addEventListener('change', SyncChange);
      el.addEventListener('input', SyncChange);
      el.addEventListener('blur', SyncChange);
    }

    //Sync value from plugin's storage
    $SD.api.getGlobalSettings($SD.uuid);

    if (actionName === 'SCRIPTS_MANAGER.TOGGLE_SCRIPT') {
      sendValueToPlugin('scripts', 'WS_REQUEST');
    }
  });

  $SD.on('localizationLoaded', language => {
    const el = (document.querySelector('.sdpi-wrapper') || document);

    let t;
    Array.from(el.querySelectorAll('sdpi-item-label')).forEach(e => {
      t = e.textContent.lox();
      if (e !== t) {
        e.innerHTML = e.innerHTML.replace(e.textContent, t);
      }
    });

    Array.from(el.querySelectorAll('*:not(script)')).forEach(e => {
      if (e.childNodes && e.childNodes.length > 0 && e.childNodes[0].nodeValue && typeof e.childNodes[0].nodeValue === 'string') {
        t = e.childNodes[0].nodeValue.lox();
        if (e.childNodes[0].nodeValue !== t) {
          e.childNodes[0].nodeValue = t;
        }
      }
    });
  });

  $SD.on('didReceiveGlobalSettings', jsn => {
    const settings = jsn.payload.settings;

    populate(settings);
    for (const el of document.querySelectorAll('[data-sync]')) {
      SyncChange.apply(el);
    }
  });

  $SD.on('sendToPropertyInspector', jsn => {
    if (jsn.payload.from === 'manager') {
      let name = jsn.payload.name;
      if (name === 'scripts') {
        name = 'script';
      }

      const el = document.querySelector(`[data-sync="${name}"]`);
      if (el) {
        el.innerHTML = '';
        for (const id in jsn.payload.data) {
          const option = document.createElement('option');
          option.setAttribute('value', id);
          option.innerText = jsn.payload.data[id].name;
          el.appendChild(option);
        }

        populate(Object.assign(actionSettings));
      }
    }
  });
};

function choice(input, value) {
  if (typeof value === 'undefined') {
    value = input.value;
  }

  if (input.name) {
    for (const el of document.querySelectorAll(`[data-for="${input.name}"]`)) {
      el.classList.toggle('hidden', (el.dataset.value !== value));
    }
  }
}

function populate(settings) {
  for (const key in settings) {
    if (key) {
      const input = document.querySelector(`#${key}, [data-sync="${key}"]`);
      if (input) {
        if (input.getAttribute('type') === 'checkbox') {
          input.checked = settings[key];
        } else if (input.getAttribute('type') === 'radio') {
          for (const radio of document.querySelectorAll(`[name="${input.name}"]`)) {
            radio.checked = (radio.value === settings[key]);
          }
        } else {
          input.value = settings[key];
        }

        choice(input, settings[key]);
      }
    }
  }

  if (settings.hasOwnProperty('WS_CONNECTED')) {
    document.getElementById('wsParams').style.display = (settings.WS_CONNECTED ? 'none' : 'block');
  }
}

function sendValueToPlugin(value, param) {
  if ($SD && $SD.connection) {
    var payload = {};
    payload[param] = value;

    $SD.api.sendToPlugin($SD.uuid, pluginAction, payload);
  }
}

function onConnect() {
  const ip = document.getElementById('WS_IP').value,
    port = document.getElementById('WS_PORT').value,
    pass = document.getElementById('WS_PASS').value;

  sendValueToPlugin({ ip, port, pass }, 'WS_DO_CONNECT');
}