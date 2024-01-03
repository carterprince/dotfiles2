// ==UserScript==
// @name         Just Comments Reddit
// @namespace    http://carterprince.us/
// @version      1.0
// @description  Restrict access to Reddit except for comment pages
// @author       Carter Prince
// @match        *://*.reddit.com/*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    function checkURL() {
        if (!window.location.href.includes("/comments/")) {
            window.stop(); // stop all requests
            document.head.innerHTML = '';
            document.body.innerHTML = '<h1>Access to this page is restricted</h1>';
        }
    }

    checkURL();
    document.addEventListener('click', function() {
        setTimeout(checkURL, 100);
    }, false);

})();
