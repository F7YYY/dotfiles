# Important Info:
1) Just download this package, then check if sha256 checksum of the package is like it is displayed on https://hyprtile.org/
If checksum is different, your download was corrupt or somebody hacked my webserver :-) In that case delete that file immediately!

But if all is correct, then move it to your home directory and unpack it to your home directory with
tar -xf HyprTile-v0.12.xz 

You then should have a directory called: ~/HyprTile/
This is HyprTile in your home directory. This must be the one and only place where this app can work correctly for now, though I am working on a more flexible version. I try to make this software as portable as possible. So you can move between distros, change from one pc to another etc.
All app, app logic and all generated files like small db files and screenshots / screenrecordings will be contained in this app.

2a) Edit your ~/.config/hypr/hyprland.conf config as follows: 

Add an autostart entry:
exec-once = ~/HyprTile/start-launcher.sh &

2b)
To get HyprTile started, just put this snippet in the end of your config:

# mandatory:
# HyprTile toggle binding so you can toggle it with $mainMod, ALT_L:
bind =  $mainMod, ALT_L, exec, sh -c "~/HyprLand/sendtoggle"

# HyprTile always floating
windowrulev2 = float, class:HyprTile

# For simple toggling of the HyprTile window
windowrulev2 = move 0 0, class:HyprTile
windowrulev2 = noborder, class:HyprTile
windowrulev2 = norounding, class:HyprTile
windowrulev2 = noanim, class:HyprTile


# optional:
# For the website monitoring feature (can safely skipped, if feature is not needed) 
windowrulev2 = float, title:^(WebScreenshotter)$
windowrulev2 = move -3000 -3000, title:^(WebScreenshotter)$
windowrulev2 = nofocus, title:^(WebScreenshotter)$
windowrulev2 = noborder, title:^(WebScreenshotter)$



That's all. Just download, unpack, set this config additions and that's it!

Which distributions are supported at the moment?
All arch based distributions are supported.

For what is needed to run this perfectly, just see these requirements:

#################
# Required
#################
+ Hyprland
+ Qt 6
+ SQLite3 + Qt SQLite driver
+ pulseaudio-utils OR pipewire-pulse (for volume feature)

#################
# Optional
#################
# Screenshot / Screenrecording:
+ grim
+ slurp
+ wf-recorder

# File Manager:
+ thunar (you can change your favourite file editor in settings now)

# Music Player (for music quickstart feature via "m filename"):
+ audacious (you can change your favourite music player in settings now)

# Video Player (for Video quickstart feature via "v filename"):
+ vlc (you can change your favourite video player in settings now)

# External URL Handler:
+ firefox (or configure a different browser)

############
# Notices:
############
This program is and will always be open source. Everyone is allowed to download and use it.
If you are afraid of spyware, malware etc. - be assured that this program is absolute ad and malware free.
It even does not need an internet connection.
Feel free to disassemble the software - you won't find a routine that will spy on you in any form.
I do not use any kind of telemetry in my software.

Why is this program so small? I hate bloat, so I tried to find the perfect way to build slim binaries, and I think that I found it rather well.
This is a rebel blow agains all the big corps build huge blobs of files. I want to show that you can build more with less. So this download is smaller than 1mb and a longtime goal is to stay under that limit.

Final words:
Have fun trying out my software, as this is my thank you to all linux developers and users in the world. You're welcome! Let's build a better future!
