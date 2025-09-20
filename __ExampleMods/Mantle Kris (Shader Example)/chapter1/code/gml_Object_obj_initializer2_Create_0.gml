global.is_console = scr_is_switch_os() || (os_type == os_ps4 || os_type == os_ps5);

if (!global.is_console)
    window_enable_borderless_fullscreen(true);

global.debug = 0;
var launch_data = scr_init_launch_parameters();
global.launcher = launch_data.is_launcher;

if (global.launcher)
{
    if (scr_is_switch_os() && !variable_global_exists("switchlogin"))
    {
        global.switchlogin = launch_data.switch_id;
        
        if (global.switchlogin >= 0)
            switch_save_data_mount(global.switchlogin);
        
        while (global.switchlogin < 0)
            global.switchlogin = switch_accounts_select_account(true, false, false);
        
        if (!switch_accounts_is_user_open(global.switchlogin))
            switch_accounts_open_user(global.switchlogin);
    }
}
else if (scr_is_switch_os() && !variable_global_exists("switchlogin"))
{
    var _id = -1;
    
    while (_id < 0)
        _id = switch_accounts_select_account(true, false, false);
    
    global.switchlogin = _id;
    switch_accounts_open_user(global.switchlogin);
}

if (!instance_exists(obj_event_manager))
{
    var event_manager = instance_create(0, 0, obj_event_manager);
    
    with (event_manager)
        init();
    
    if (os_type == os_ps4 || os_type == os_ps5)
    {
        with (event_manager)
            enable_trophies();
    }
}

global.chapter = 1;
global.screen_border_id = "Dynamic";
global.screen_border_active = true;
global.screen_border_alpha = 1;
global.screen_border_state = 0;
global.screen_border_dynamic_fade_id = 0;
global.screen_border_dynamic_fade_level = 0;
global.savedata_async_id = -1;
global.savedata_async_load = false;
global.savedata_error = false;
global.savedata_debuginfo = "";
global.version = "1.40";

if (scr_is_switch_os())
    global.version = "1.28";

if (os_type == os_ps4 || os_type == os_ps5)
    global.version = "1.28";

old_savedata_check = false;

scr_example_shader_init()

if (global.is_console)
{
    ossafe_init();
    ossafe_savedata_load();
    
    if (os_type == os_ps4 || os_type == os_ps5)
        window_set_cursor(cr_none);
}
else
{
    scr_84_init_localization();
    scr_84_load_ini();
    scr_gamestart();
    global.damagefont = font_add_sprite_ext(spr_numbersfontbig, "0123456789", 20, 0);
    global.hpfont = font_add_sprite_ext(spr_numbersfontsmall, scr_84_get_lang_string("obj_initializer2_slash_Create_0_gml_2_0"), 0, 2); // 0123456789-+
    
    for (i = 0; i < 100; i += 1)
        global.tempflag[i] = 0;
    
    global.heartx = 300;
    global.hearty = 220;
    scr_prefetch_textures();
    scr_load_audio();
    
    if (!instance_exists(obj_time))
        instance_create(0, 0, obj_time);
}
