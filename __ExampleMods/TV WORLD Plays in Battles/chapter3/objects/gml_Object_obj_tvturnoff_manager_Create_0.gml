timer = 0;
timer2 = 0;
con = 0;
_alpha1 = 1;
_alpha2 = 1;
_xscale1 = 10;
_yscale1 = 10;
_xscale2 = 0.1;
_yscale2 = 0.1;
muted = 0;

if (scr_musicmod_batmusic_is_paused())
    muted = 1;

kind = 0;
roomtarg = -1;
entrance = "none";
facing = -1;
init = 0;
yoff = 0;
targx = room_width / 2;
targy = room_height / 2;
tennaending = false;
dialoguecon = 0;
dialoguetimer = 0;
curroom = room;
roomchange = false;
