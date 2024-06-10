// ==UserScript==
// @name            BetterTTV
// @namespace       BTTV
// @description     Enhances Twitch with new features, emotes, and more.
// @copyright       NightDev, LLC
// @icon            https://cdn.betterttv.net/assets/logos/bttv_logo.png
//
// @grant           none
//
// @match           https://*.twitch.tv/*
// @match           https://*.youtube.com/*
//
// @version         0.0.2
// ==/UserScript==

// Adam: It looks like this is basically a header injection into the script.
(function betterttv() {
  var script = document.createElement("script");
  script.type = "text/javascript";
  script.src = "https://cdn.betterttv.net/betterttv.js";
  var head = document.getElementsByTagName("head")[0];
  if (!head) return;
  head.appendChild(script);
})();
