# Amelung Finder Berlin

This repo is used for finding ANY available Amelung registration appointments.

## Description
This is pretty basic script that scrapes the webpage displaying the calendar 
for appointments for the next month or so. If your on MacOs it will alert 
you via a noise and in the terminal, but can be run on linux or via a crontab. 
It does NOT book the appointment for you, but prints the relevant url for 
booking to the terminal. You MAY encounter a captcha when clicking this url. 
In the little amount of time taken by filling out the captcha the appointment 
will get taken. It is recommended to have the calendar page in a browser tab 
already open and just use the audio from this script to alert you that a slot 
is open. It looks for ANY appointment at all registration offices so you may 
get one super far from your house.

### Dependencies
* Bash
* Curl
* Sed

### Installing

* Clone the repo and make sure you have the dependencies

### Executing program

* Locally on terminal
```
./finder.sh
```
Note: The script runs in a infinite loop until killed. Do not run in a crontab 
without the crontab flag input (which is any argument after executing)!
* As a crontab
```
./finder.sh is_cron
```

### Modifying

* External notification
There is a function named "zap" for making a zapier request. Use this function 
if you want to make a webhook to zapier. This would be if your running it as a 
cron on a server. Just add the function call "zap" after the function call "makeNoise".

### Tips for making the booking

* This script only alerts; does not book
* Use [TamperMonkey](https://chrome.google.com/webstore/detail/tampermonkey/dhdgffkkebhmkfjojejmpbldmpobfkfo?hl=en) to pre-fill your information on the booking page saving you vital seconds.
* <details>
  <summary>TamperMonkey Script Example</summary>

        // ==UserScript==
        // @name         New Userscript
        // @namespace    http://tampermonkey.net/
        // @version      0.1
        // @description  try to take over the world!
        // @author       You
        // @match        https://service.berlin.de/terminvereinbarung/termin/register/*
        // @icon         data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==
        // @grant        none
        // ==/UserScript==

        (function() {
            'use strict';
            document.getElementById("familyName").value = "Your full name";
            document.getElementById("email").value = "youremail@gmail.com";
            document.getElementsByName("surveyAccepted")[0].value = 1;
            document.getElementById("agbgelesen").checked = true;

            // I add issues with auto submitting so commented out
            //document.getElementById("register_submit").click();
        })();

</details>

## Acknowledgments

* [A broken script I found](https://gist.github.com/mugli/f538e8fb0554267c1028068b75e17c59)