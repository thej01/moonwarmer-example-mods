TYPE = 0;
scr_bettersaves_local_funcs()
scr_bettersaves_get_all_saves(-1, 0)
savefiles = savefiles_normal
if (scr_bettersaves_any_completion(savefiles))
    TYPE = 1

if (TYPE == 0)
{
    scr_windowcaption(scr_84_get_lang_string("DEVICE_MENU_slash_Create_0_gml_8_0"));
    global.currentsong[0] = snd_init("AUDIO_DRONE.ogg");
    global.currentsong[1] = mus_loop(global.currentsong[0]);
}

if (TYPE == 1)
{
    instance_create(0, 0, obj_fadein);
    global.tempflag[10] = 1;
    scr_windowcaption(scr_84_get_lang_string("DEVICE_MENU_slash_Create_0_gml_17_0"));
    global.currentsong[0] = snd_init("AUDIO_STORY.ogg");
    global.currentsong[1] = mus_loop_ext(global.currentsong[0], 1, 0.95);
}

BGMADE = 0;
BG_ALPHA = 0;
BG_SINER = 0;
OBMADE = 0;
OB_DEPTH = 0;
obacktimer = 0;
OBM = 0.5;
COL_A = c_green;
COL_B = c_lime;
COL_PLUS = merge_color(c_lime, c_white, 0.5);
input_enabled = true;

if (TYPE == 1)
{
    BGSINER = 0;
    BGMAGNITUDE = 6;
    COL_A = merge_color(c_ltgray, c_navy, 0.2);
    COL_B = c_white;
    COL_PLUS = merge_color(c_yellow, c_white, 0.5);
    BGMADE = 1;
    BG_ALPHA = 0;
    ANIM_SINER = 0;
    ANIM_SINER_B = 0;
    TRUE_ANIM_SINER = 0;
}

MENU_NO = 0;

for (i = 0; i < 8; i += 1)
    MENUCOORD[i] = 0;

XL = 210;
YL = 40;
YS = 5;
HEARTX = 75;
HEARTY = 110;
HEARTXCUR = 75;
HEARTYCUR = 75;
MOVENOISE = 0;
SELNOISE = 0;
BACKNOISE = 0;
DEATHNOISE = 0;
CANQUIT = 1;

if (global.is_console == 1)
    CANQUIT = 0;

ONEBUFFER = 2;
TWOBUFFER = 0;
THREAT = 0;
TEMPMESSAGE = " ";
MESSAGETIMER = 0;
version_text = global.version + " ";
scr_84_load_ini();

bottom_menu = array_length(MENUCOORD)
MENUCOORD[bottom_menu] = 0
bottom_menu_copy_ver = bottom_menu + 1
MENUCOORD[bottom_menu_copy_ver] = 0

bottom_menu_copy = 3
bottom_menu_erase = 4
bottom_menu_chselect = 5
bottom_menu_lang = 6
bottom_menu_quit = 7

scroll_y = 0
scroll_speed = 4
box_surf = -1
text_surf = -1

bottom_menu_alpha = 1
bottom_menu_fade = false
message_alpha = 1
message_fade = false

text_fade_speed = 0.1