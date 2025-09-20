if (scr_debug())
{
}

if (!global.is_console)
{
    var nowfullscreen = window_get_fullscreen();
    
    if (nowfullscreen != isfullscreen)
    {
        ini_open("true_config.ini");
        ini_write_real("SCREEN", "FULLSCREEN", nowfullscreen);
        ini_close();
        show_debug_message("fullscreen switched:" + string(nowfullscreen));
    }
    
    isfullscreen = nowfullscreen;
}
