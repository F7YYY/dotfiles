
/* global $CC, Utils, $SD */

/**
 * Here are a couple of wrappers we created to help you quickly setup
 * your plugin and subscribe to events sent by Stream Deck to your plugin.
 */

/**
 * The 'connected' event is sent to your plugin, after the plugin's instance
 * is registered with Stream Deck software. It carries the current websocket
 * and other information about the current environmet in a JSON object
 * You can use it to subscribe to events you want to use in your plugin.
 */

$SD.on('connected', (jsonObj) => connected(jsonObj));

function connected(jsn) {
    // Subscribe to the willAppear and other events
    $SD.on('org.xiphis.ohs.action.willAppear', (jsonObj) => action.onWillAppear(jsonObj));
    $SD.on('org.xiphis.ohs.action.keyUp', (jsonObj) => action.onKeyUp(jsonObj));
    $SD.on('org.xiphis.ohs.action.sendToPlugin', (jsonObj) => action.onSendToPlugin(jsonObj));
    $SD.on('org.xiphis.ohs.action.didReceiveSettings', (jsonObj) => action.onDidReceiveSettings(jsonObj));
    //$SD.on('org.xiphis.ohs.action.propertyInspectorDidAppear', (jsonObj) => {
    //    console.log('%c%s', 'color: white; background: black; font-size: 13px;', '[app.js]propertyInspectorDidAppear:');
    //});
    //$SD.on('org.xiphis.ohs.action.propertyInspectorDidDisappear', (jsonObj) => {
    //    console.log('%c%s', 'color: white; background: red; font-size: 13px;', '[app.js]propertyInspectorDidDisappear:');
    //});
};

const engine = {
    cache: {},
    timer: 0,

    sensor: function(jsn) {
        return this.cache[jsn.context];
    },

    register: function(jsn, sensor) {
        this.cache[jsn.context] = sensor;

        if (this.timer === 0) {
            const self = this;
            this.timer = setInterval(function(sx) {
                self.onMyTimer();
            }, 1000);
        }
    },

    deregister: function(jsn) {
        delete this.cache[jsn.context];

        if (Object.keys(this.cache).length === 0 && this.timer !== 0) {
            window.clearInterval(this.timer);
            this.timer = 0;
        }

    },

    onMyTimer: function () {
        const self = this;
        var map = {};
        if (this.cache) {
            for (const [key, value] of Object.entries(this.cache)) {
                const sensor_name = value.getSensorName();
                var listeners = map[sensor_name];
                if (!listeners) {
                    listeners = [value];
                    map[sensor_name] = listeners;
                } else {
                    listeners.push(value);
                }
            }
        }
        OpenHardware.fetchData().then((sensors) => {
            for (const sensor of sensors) {
                const listeners = map[sensor.FullName];
                if (listeners) {
                    for (const listener of listeners) {
                        listener.updateValue(sensor);
                    }
                }
            }
        });
    },

};

// ACTIONS

const action = {
    type: 'org.xiphis.ohs.action',

    onDidReceiveSettings: function(jsn) {
        const settings = jsn.payload.settings;
        const sensor = engine.sensor(jsn);

        if (!settings || !sensor) return;

        if (settings.hasOwnProperty('sensor_name')) {
            sensor.setSensorName(settings.sensor_name);
        }

        if (settings.hasOwnProperty('sensor_type')) {
            sensor.setSensorType(settings.sensor_type);
        }

        if (settings.hasOwnProperty('sensor_foreground')) {
            sensor.setSensorForeground(settings.sensor_foreground);
        }

        if (settings.hasOwnProperty('sensor_background')) {
            sensor.setSensorBackground(settings.sensor_background);
        }

        if (settings.hasOwnProperty('sensor_valuecolour')) {
            sensor.setSensorValueColour(settings.sensor_valuecolour);
        }

        if (settings.hasOwnProperty('sensor_gradicule')) {
            sensor.setSensorGradicule(settings.sensor_gradicule);
        }

        if (settings.hasOwnProperty('sensor_fillcolour')) {
            sensor.setSensorFillColour(settings.sensor_fillcolour);
        }

        if (settings.hasOwnProperty('sensor_minimum')) {
            sensor.setSensorMinimum(settings.sensor_minimum);
        }

        if (settings.hasOwnProperty('sensor_maximum')) {
            sensor.setSensorMaximum(settings.sensor_maximum);
        }
    },

    /** 
     * The 'willAppear' event is the first event a key will receive, right before it gets
     * shown on your Stream Deck and/or in Stream Deck software.
     * This event is a good place to setup your plugin and look at current settings (if any),
     * which are embedded in the events payload.
     */

    onWillAppear: function (jsn) {
        if (!jsn.payload || !jsn.payload.hasOwnProperty('settings')) return;

        engine.register(jsn, new OpenHardwareSensor(jsn));

        this.onDidReceiveSettings(jsn);
    },

    onWillDisappear: function (jsn) {
        const sensor = engine.sensor(jsn);
        if (sensor) {
            sensor.destroySensor();
            engine.deregister(jsn);
        }
    },

    onKeyUp: function (jsn) {
        const sensor = engine.sensor(jsn);
        if (!sensor) {
            this.onWillAppear(jsn);
        } else {
            sensor.toggleSensor();
        }
    },

    onSendToPlugin: function (jsn) {
        /**
         * This is a message sent directly from the Property Inspector 
         * (e.g. some value, which is not saved to settings) 
         * You can send this event from Property Inspector (see there for an example)
         */ 

        const sdpi_collection = Utils.getProp(jsn, 'payload.sdpi_collection', {});
        if (sdpi_collection.value && sdpi_collection.value !== undefined) {
            this.doSomeThing({ [sdpi_collection.key] : sdpi_collection.value }, 'onSendToPlugin', 'fuchsia');            
        }
    },

    /**
     * This snippet shows how you could save settings persistantly to Stream Deck software.
     * It is not used in this example plugin.
     */

    saveSettings: function (jsn, sdpi_collection) {
        console.log('saveSettings:', jsn);
        if (sdpi_collection.hasOwnProperty('key') && sdpi_collection.key != '') {
            if (sdpi_collection.value && sdpi_collection.value !== undefined) {
                this.settings[sdpi_collection.key] = sdpi_collection.value;
                console.log('setSettings....', this.settings);
                $SD.api.setSettings(jsn.context, this.settings);
            }
        }
    },

    /**
     * Finally here's a method which gets called from various events above.
     * This is just an idea on how you can act on receiving some interesting message
     * from Stream Deck.
     */

    doSomeThing: function(inJsonData, caller, tagColor) {
        console.log('%c%s', `color: white; background: ${tagColor || 'grey'}; font-size: 15px;`, `[app.js]doSomeThing from: ${caller}`);
        // console.log(inJsonData);
    }, 
};

function OpenHardwareSensor(jsonObj) {
    var jsb = jsonObj,
        context = jsonObj.context,
        canvas = null,
        name = "",
        value = "",
        type = "text",
        history = [],
        max_history = 60,
        count = 0,
        background = '#000000',
        gradicule = '#181818',
        foreground = '#ff8800',
        valueColour = '#ff8800',
        fillColour = '#ff8800',
        minimum = null,
        maximum = null,
        knob;

    function createSensor(settings) {
        canvas = document.createElement('canvas');
        canvas.width = 144;
        canvas.height = 144;
    }

    function toggleSensor() {
    
    }

    function drawSensor() {
        switch (type) {
        case "knob":
            value.Value && updateKnob();
            break;
        case "line":
            history && updateLine(false);
            break;
        case "fill":
            history && updateLine(true);
            break;
        case "text":
        default:
            value.Value && updateText();
            break;
        }
        $SD.setImage(context, canvas.toDataURL());
    }

    function updateLine(doFill) {
        const ctx = canvas.getContext('2d');
        const height = ctx.canvas.height;
        const width = ctx.canvas.width;
        const smaller = width < height ? width : height;
        const centerX = 0.5 * width;
        const centerY = 0.2 * height;
        const fontSize = 0.15 * smaller;
        const fontSizeString = fontSize.toString();
        const valueStr = value.Value;

        ctx.fillStyle = background;
        ctx.fillRect(0, 0, width, height);

        let w = [];
        for (var wx = 0, wd = (width - 1) / (max_history + 0.1); wx <= width; wx += wd) {
            w.push(wx);
        }

        const min = getMinValue();
        const max = Math.max(getMaxValue(), min + 1);
        const range = max - min;
        const scale = height / range;


        ctx.strokeStyle = gradicule;
        ctx.lineWidth = 3.1
        ctx.beginPath();
        ctx.moveTo(0, height + min * scale);
        ctx.lineTo(width, height + min * scale);
        ctx.stroke();
        
        var wp = [...w];
        ctx.beginPath();
        for (const h of history) {
            const x = wp.shift();
            if ((h.Ordinal % (max_history / 3)) === 0) {
                ctx.moveTo(x, 0);
                ctx.lineTo(x, height);
            }
        }
        ctx.stroke();

        ctx.strokeStyle = foreground;
        ctx.lineJoin = "round";
        ctx.lineWidth = 3.1;
        var draw;
        draw = function(x, y) {
            ctx.moveTo(x, y);
            draw = function(x1, y1) {
                ctx.lineTo(x1, y1);
            };
        };

        var last_x = 0;
        ctx.beginPath();
        for (const h of history) {
            const x = w.shift();
            const y = height - (parseFloat(h.Value) - min) * scale;
            draw(x, y);
            last_x = x;
        }
        if (doFill) {
            draw(last_x, height+1);
            draw(0, height+1);
            ctx.closePath();
            ctx.fillStyle = fillColour;
            ctx.fill();    
        }
        ctx.stroke();

        ctx.font = fontSizeString + 'px sans-serif';
        ctx.fillStyle = valueColour;
        ctx.strokeStyle = background;
        ctx.textAlign = 'center';
        ctx.textBaseline = 'middle';
        ctx.lineWidth = 3.1;
        ctx.shadowBlur = 3.8;
        ctx.shadowColor = background;
        ctx.strokeText(valueStr, centerX, centerY);
        ctx.lineWidth = 1;
        ctx.fillText(valueStr, centerX, centerY);

    }

    function updateText() {
        const ctx = canvas.getContext('2d');
        const height = ctx.canvas.height;
        const width = ctx.canvas.width;
        const smaller = width < height ? width : height;
        const centerX = 0.5 * width;
        const centerY = 0.5 * height;
        const fontSize = 0.3 * smaller;
        const fontSizeString = fontSize.toString();
        const valueStr = value.Value;
        ctx.fillStyle = background;
        ctx.fillRect(0, 0, width, height);
        ctx.font = fontSizeString + 'px sans-serif';
        ctx.fillStyle = valueColour;
        ctx.strokeStyle = background;
        ctx.textAlign = 'center';
        ctx.textBaseline = 'middle';
        ctx.lineWidth = 3;
        ctx.strokeText(valueStr, centerX, centerY);
        ctx.lineWidth = 1;
        ctx.fillText(valueStr, centerX, centerY);
    }

    function updateKnob() {
        if (!knob) {
            knob = pureknob.createKnob(144, 144);
            knob._canvas = canvas;
            knob.resize = function() {};
            knob.setProperty("angleStart", -0.75 * Math.PI);
            knob.setProperty("angleEnd", 0.75 * Math.PI);
            knob.setProperty("background", background);
            knob.setProperty("foreground", foreground);
            knob.setProperty("gradicule", gradicule);
            knob.setProperty("filling", fillColour);
            knob.setProperty("colorValue", valueColour);
            knob.setProperty("trackWidth", 0.4);
            knob.setProperty("fnValueToString", function(ignore) {
                return value.Value;
            })
        }
        knob.setProperty("valMin", getMinValue());
        knob.setProperty("valMax", getMaxValue());
        knob.setProperty("val", parseFloat(value.Value));
        knob.commit();
    }

    function getMinValue() {
        return minimum == null ? parseFloat(value.Min) : minimum;
    }

    function getMaxValue() {
        return maximum == null ? parseFloat(value.Max) : maximum;
    }

    function getSensorName() {
        return name;
    }

    function setSensorName(sensor_name) {
        name = sensor_name;
        drawSensor();
    }

    function setSensorType(sensorType) {
        type = sensorType;
        drawSensor();
    }

    function getSensorType() {
        return type;
    }

    function setSensorForeground(fg) {
        foreground = fg;
        if (knob) {
            knob.setProperty("foreground", foreground);
        }
        drawSensor();
    }

    function setSensorBackground(bg) {
        background = bg;
        if (knob) {
            knob.setProperty("background", background);
        }
        drawSensor();
    }

    function setSensorGradicule(fg) {
        gradicule = fg;
        if (knob) {
            knob.setProperty("colorBG", gradicule);
        }
        drawSensor();
    }

    function setSensorFillColour(bg) {
        fillColour = bg;
        if (knob) {
            knob.setProperty("colorFG", fillColour);
        }
        drawSensor();
    }

    function setSensorValueColour(fg) {
        valueColour = fg;
        if (knob) {
            knob.setProperty("colorValue", valueColour);
        }
        drawSensor();
    }

    function setSensorMinimum(value) {
        if (value == null || value == "") {
            minimum = null;
        } else {
            minimum = parseFloat(value);
        }
        drawSensor();
    }

    function setSensorMaximum(value) {
        if (value == null || value == "") {
            maximum = null;
        } else {
            maximum = parseFloat(value);
        }
        drawSensor();
    }

    function updateValue(sensorValue) {
        value = sensorValue;
        value.Ordinal = count++;
        let history_length = history.push(value);
        if (history_length > max_history) {
            history.shift();
        }
        drawSensor();
    }

    function destroySensor() {
    }

    createSensor();
    return {
        destroySensor: destroySensor,
        updateValue: updateValue,
        setSensorName: setSensorName,
        getSensorName: getSensorName,
        setSensorType: setSensorType,
        getSensorType: getSensorType,
        setSensorMinimum: setSensorMinimum,
        setSensorMaximum: setSensorMaximum,
        setSensorBackground: setSensorBackground,
        setSensorForeground: setSensorForeground,
        setSensorGradicule: setSensorGradicule,
        setSensorFillColour: setSensorFillColour,
        setSensorValueColour: setSensorValueColour
    }
}

