// ==UserScript==
// @name         RU Captive Portal Auto Login
// @namespace    http://ru.ac.bd/
// @version      1.1
// @description  Auto-fills and submits RU captive portal login form
// @match        http://local.ru.ac.bd/*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    const USERNAME = "12341234";
    const PASSWORD = "12341234";

    function tryLogin() {
        const loginForm = document.forms["login"];
        const usernameInput = loginForm?.querySelector('input[name="username"][type="text"]');
        const passwordInput = loginForm?.querySelector('input[name="password"][type="password"]');

        if (usernameInput && passwordInput && typeof doLogin === 'function') {
            usernameInput.value = USERNAME;
            passwordInput.value = PASSWORD;
        } else {
            // Retry if DOM not yet ready
            setTimeout(tryLogin, 1000);
        }
    }

    window.addEventListener('load', tryLogin);
})();
