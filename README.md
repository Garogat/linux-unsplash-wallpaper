#### linux-unsplash-wallpaper
See a different awesome wallpaper every time you boot your computer.

##Setup

* Download the script.
* Put it somewhere
* Give it execution permission.
* Let it autostart (/etc/rc.loca) or just do a cronjob to get a new image every 5 Minutes (crontab -e):
```crontab
*/5 * * * * /path/to/desplashWallpaper.sh
```
