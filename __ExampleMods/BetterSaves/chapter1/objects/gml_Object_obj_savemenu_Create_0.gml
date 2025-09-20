global.currentroom = scr_get_id_by_room_index(room);
cur_jewel = 0;
saved = 0;
coord = 0;
ini_ex = 0;
buffer = 3;
name = scr_84_get_lang_string("obj_savemenu_slash_Create_0_gml_7_0");
level = 1;
love = 1;
time = 0;
roome = 0;
endme = 0;
global.interact = 1;

if (ossafe_file_exists("dr.ini"))
{
    ini_ex = 1;
    iniread = ossafe_ini_open("dr.ini");
    var name_text = (global.lang == "ja") ? "クリス" : "Kris";
    var field = scr_bettersaves_ini_name(global.filechoice, false)
    name = ini_read_string(field, "Name", name_text);
    level = ini_read_real(field, "Level", 1);
    love = ini_read_real(field, "Love", 1);
    time = ini_read_real(field, "Time", 0);
    initlang = ini_read_real(field, "InitLang", 0);

    var room_id = ini_read_real(field, "Room", scr_get_id_by_room_index(room));
    
    if (room_id < 10000)
    {
        room_index = room_id;
        var room_offset = room_index;
        
        if (room_index < 0)
            room_offset = 0 + room_index;
        
        room_id = room_offset;
        room_id += 10000;
    }
    
    var room_index = scr_get_valid_room(1, room_id);
    roome = room_index;
    ossafe_ini_close();
    ossafe_savedata_save();
}

d = global.darkzone + 1;
minutes = floor(time / 1800);
seconds = round(((time / 1800) - minutes) * 60);

if (seconds == 60)
    seconds = 59;

if (seconds < 10)
    seconds = "0" + string(seconds);

scr_roomname(roome);

if (d == 2)
    heartsprite = spr_heart;

if (d == 1)
    heartsprite = spr_heartsmall;

if (d == 1)
    name = scr_84_get_lang_string("obj_savemenu_slash_Create_0_gml_43_0");

time_current = global.time;

save_count = scr_bettersaves_file_amount(global.chapter, false, true)
menuno = 0
mpos = global.filechoice
overwrite = 0
overcoord = 0

name_current = global.truename;
love_current = global.llv;
room_current = scr_roomname(room);
level_current = global.lv;
time_current = global.time;

for (var i = 0; i < save_count; i++)
{
    name_file[i] = "Kris";
    level_file[i] = 0;
    love_file[i] = 1;
    time_file[i] = 0;
    roome_file[i] = 0;
    initlang_file[i] = 0;
    
    if (ossafe_file_exists("dr.ini"))
    {
        var field = scr_bettersaves_ini_name(i)
        ini_ex_file[i] = 1;
        iniread_file[i] = ossafe_ini_open("dr.ini");
        name_file[i] = ini_read_string(field, "Name", scr_84_get_lang_string("obj_savemenu_slash_Create_0_gml_8_0"));
        level_file[i] = ini_read_real(field, "Level", 0);
        love_file[i] = ini_read_real(field, "Love", 1);
        time_file[i] = ini_read_real(field, "Time", 0);
        initlang_file[i] = ini_read_real(field, "InitLang", 0);
        var room_id = ini_read_real(field, "Room", scr_get_id_by_room_index(room));
        roome_file[i] = scr_get_valid_room(global.chapter, room_id);
        ossafe_ini_close();
        ossafe_savedata_save();
    }
}
