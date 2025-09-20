if (window_get_fullscreen())
{
    window_set_fullscreen(false);
    ini_open("true_config.ini");
    ini_write_real("SCREEN", "FULLSCREEN", 0);
    ini_close();
    alarm[2] = 1;
}
else
{
    window_set_fullscreen(true);
    ini_open("true_config.ini");
    ini_write_real("SCREEN", "FULLSCREEN", 1);
    ini_close();
}

fullscreen_toggle = 0;
