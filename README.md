# Appointment Finder Berlin

When moving to or within Germany, one has to (re-)register residency within two weeks.
In Berlin, this can be a bit challenging at times as the offices are overloaded.
This repository provides a little script that scrapes Berlin's
[service website](https://service.berlin.de/dienstleistung/120686/) for available appointments.

Further, this repository contains a [guide on how to find an apartment in Berlin](./ApartmentHowTo.md).

## Description

This is pretty basic script that scrapes the webpage displaying the calendar for appointments for the next month or so.
It does **NOT** book the appointment for you, but prints the relevant url for booking to the terminal.
You MAY encounter a captcha when clicking this url.
In the little amount of time taken by filling out the captcha the appointment will get taken.
We recommend to have the calendar page in a browser tab open already and just use the audio from this script to alert
you that a slot is open.
It looks for ANY appointment at all registration offices, hence you may get one super far from your place...

### Dependencies

* `bash`
* `wget`
* `libxml2` (povides `xmllint`)
* `notify-send` (Optional)

### Installing

* Clone the repo and make sure you have the dependencies

### Executing program

```shell
./finder.sh
```

**Note:** The script runs in an infinite loop until it's killed.
Do not run in a crontab without the crontab flag input (which is any argument after the script name)!

Thus, when running

```shell
./finder.sh cron
```

### Tips for making the booking

* This script only alerts; does not book
* Use [TamperMonkey](https://www.tampermonkey.net/) to pre-fill your information on the booking page saving you vital
  seconds.
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
            document.getElementById("email").value = "youremail@example.com";
            document.getElementsByName("surveyAccepted")[0].value = 1;
            document.getElementById("agbgelesen").checked = true;

            // I add issues with auto submitting so commented out
            //document.getElementById("register_submit").click();
        })();

</details>

## Acknowledgments

* [A broken script I found](https://gist.github.com/mugli/f538e8fb0554267c1028068b75e17c59)
