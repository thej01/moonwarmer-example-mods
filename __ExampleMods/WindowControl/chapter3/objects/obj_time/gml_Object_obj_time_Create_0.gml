quit_timer = 0;
keyboard_active = 1;
gamepad_active = 1;
gamepad_check_timer = 0;
gamepad_id = 0;
axis_value = 0.4;
fullscreen_toggle = 0;
quicksaved = 0;
window_center_toggle = 0;
isfullscreen = 0;
window_size_toggle = 0;

if (global.is_console)
{
    if (!instance_exists(obj_gamecontroller))
        instance_create(0, 0, obj_gamecontroller);
    
    var border_controller = instance_create(0, 0, obj_border_controller);
    border_controller.init_border();
}

paused = false;
pausing = false;
screenshot = -1;
gif_recording = 0;
gif_timer = 0;
loaded = false;
border_fade_out = false;
border_fade_in = false;
border_alpha = 1;
border_fade_value = 0.025;
_border_image = border_line_1080;

if (instance_number(obj_time) > 1)
{
    instance_destroy();
}
else
{
    ini_open("true_config.ini");
    var fullscreen_option = ini_read_real("SCREEN", "FULLSCREEN", 0);
    var setwindowsize = ini_read_real("SCREEN", "SIZE", 0);
    ini_close();
    var display_height = display_get_height();
    var display_width = display_get_width();
    
    if (setwindowsize)
    {
        window_set_size(1280, 960);
        alarm[2] = 1;
    }
    else
    {
        window_set_size(640, 480);
        alarm[2] = 1;
    }
    
    if (fullscreen_option == 1 && !window_get_fullscreen())
        alarm[1] = 1;
    
    if (scr_is_switch_os())
    {
        switch_controller_support_set_defaults();
        switch_controller_support_set_singleplayer_only(true);
        switch_controller_set_supported_styles(7);
    }
    
    scr_controls_default();
    scr_ascii_input_names();
    
    for (i = 0; i < 10; i += 1)
    {
        global.input_pressed[i] = 0;
        global.input_held[i] = 0;
        global.input_released[i] = 0;
    }
    
    if (global.is_console)
    {
        application_surface_enable(true);
        application_surface_draw_enable(false);
    }
    
    scr_enable_screen_border(global.is_console);
}
