#!/bin/bash
# Images are taken from the "hell so easy to use (basic) API" of Unsplash, they are totally free for all use.
PATH=/usr/local/bin:${PATH}

# The downloaded images are kept in ~/.local/share/unsplashLinux if the following switch is false.
DO_WE_ERASE_FILES=true

# Set desktop enviorment (GNOME or XFCE)
DESKTOP="XFCE"

# Set screen size
SIZE="1920x1080"

# Set home directory so cronjob can run this script
HOME="/home/anton"

WORKDIR=$HOME'/.local/share/unsplashLinux/'
RANT=$(date +%s)
mkdir -p $WORKDIR
mkdir -p $WORKDIR'old'

wget -q --spider http://google.com
if [ $? -ne 0 ]; then
        exit 1
fi

if $DO_WE_ERASE_FILES
then
        rm $WORKDIR*'.jpg'
else
        mv $WORKDIR*'.jpg' $WORKDIR'old/'
fi
wget -O ${WORKDIR}${RANT}'.jpg' -q https://source.unsplash.com/$SIZE

if [ "$DESKTOP" == "GNOME" ]; then
        gsettings set org.gnome.desktop.background picture-uri 'file://'${WORKDIR}${RANT}'.jpg'
elif [ "$DESKTOP" == "XFCE" ]; then
        # Cron support
        pid=$(ps -C xfce4-session -o pid=)
        # Hack to remove the leading space. Maybe not so nice, but it works.
        pid=$(echo $pid)
        # Get the environment variable from /proc
        export $(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$pid/environ)

        for i in $(xfconf-query -c xfce4-desktop -p /backdrop -l|egrep -e "screen.*/monitor.*image-path$" -e "screen.*/monitor.*/last-image$"); do
            xfconf-query -c xfce4-desktop -p $i -n -t string -s ${WORKDIR}${RANT}'.jpg'
            xfconf-query -c xfce4-desktop -p $i -s ${WORKDIR}${RANT}'.jpg'
        done
else
        echo "Can't find $DESKTOP support! Just downloaded the new wallpaper to ${WORKDIR}${RANT}.jpg"
fi
