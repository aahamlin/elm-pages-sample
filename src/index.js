'use strict';

require('./index.html');

const { Elm } = require('./Main.elm');

var storageKey = 'elm-pages-sample';
var storedState = localStorage.getItem(storageKey);

console.log("Startup elm-pages-sample. storedState: " + JSON.stringify(storedState));

var app = Elm.Main.init({
    node: document.getElementById('main'),
    flags: storedState
});

app.ports.storeCache.subscribe(function (val) {
    console.log("storeCache received: " + JSON.stringify(val));
    if (val === null) {
	localStorage.removeItem(storageKey);
    } else {
	localStorage.setItem(storageKey, JSON.stringify(val));
    }

    setTimeout(function() {
	try {
	    app.ports.onStoreChange.send(val);
	    console.log("onStoreChange.send: " + JSON.stringify(val));
	}
	catch (e) {
	    console.error("Failed to call onStoreChange: " + e.message);
	}
    }, 0);
});

