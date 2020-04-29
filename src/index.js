'use strict';

require('./index.html');

const { Elm } = require('./Main.elm');

var app = Elm.Main.init({
    node: document.getElementById('main'),
});

