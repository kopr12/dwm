# Info

dwm for Gentoo with some of the patches   
Enable the ones you wish to use with USE flags   

`personal` USE flag is for some color, font and other custom settings that I use   
you can safely ignore it or modify it to your liking   

More patches could be added, I'm starting with these because that's what I use at the moment   
Feel free to add more via PR or ask for the ones you would like to see   

# Patches

* alphaborder
* attachaside
* barpadding
* center
* emojis
* hidevcacanttags
* pertag
* restartsig
* roundedcorners
* systray
* vanitygaps

# Usage

Copy `x11-wm/dwm` directory in your local overlay and emerge `dwm`   

if you already used dwm before with `savedconfig` USE flag enabled,   
you will need to backup that config file and delete it, in order for new config to be used.   

# Emojis

You will need patched libXft in order for dwm to display colored emojis   
Patch is located in libXft dir, place the file in /etc/portage/patches/x11-libs/libXft and re-emerge libXft and dwm   



![screenshot](https://raw.githubusercontent.com/kajzersoze/dwm/master/Screenshot.png)
