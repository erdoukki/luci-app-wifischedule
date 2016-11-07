# luci-app-wifischedule
Turns WiFi on and off according to a schedule on an openwrt router

## Use cases
You can create user-defined events when to enable or disable WiFi. 
There are various use cases why you would like to do so:
1. Reduce power consumption and therefore reduce CO2 emissions.
2. Reduce emitted electromagnatic radiation.
3. Force busincess hours when WiFi is available.

Regarding 1: Please note, that you need to unload the wireless driver modules in order to get the most effect of saving power.
In my test scenario only disabling WiFi saves about ~0.4 Watt, unloading the modules removes another ~0.4 Watt.

Regarding 2: Think of a wireless accesspoint e.g. in your bedrom, kids room where you want to remove the ammount of radiation emitted.
I've heard stories where the option of disabling the WiFi during night increased the [WA-Factor](https://en.wikipedia.org/wiki/Wife_acceptance_factor) significantly.

Regarding 3: E.g. in a company, why would wireless need to be enabled weekends if no one is there working? 
Or think of an accesspoint in your kids room when you want the youngsters to sleep after 10 pm instead of facebooking...

## Configuration
You can create an arbitrary number of schedule events. Please note that there is on sanity check done wheather the start / stop times overlap or make sense.
If start and stop time are equal, this leads to disabling the WiFi at the given time.

Logging if enabled is done to the file /var/log/wifi_schedule.log and can be reviewed through the "View Logfile" tab.
The cron jobs created can be reviewed through the "View Cron Jobs" tab.

Please note that the "Unload Modules" function is currently considered as experimental. You can manually add / remove modules in the text field.
The button "Determine Modules Automatically" tries to make a best guess determining regarding the driver module and its dependencies.
When un-/loading the modules, there is a certain number of retries (`module_load`) performed.

The option "Force disabling wifi even if stations associated" does what it says - when activated it simply shuts down WiFi.
When unchecked, its checked every `recheck_interval` minutes if there are still stations associated. Once the stations disconnect, WiFi is disabled.

Please note, that the parameters <em>module_load</em> and <em>recheck_interval</em> are only accessible through uci.
