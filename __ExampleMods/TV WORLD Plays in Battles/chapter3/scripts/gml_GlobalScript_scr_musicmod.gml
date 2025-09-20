function scr_musicmod_init()
{
    global.mus_mod_version = 3
    global.mus_mod_version_string = "v3"
    global.tvworld_mus_persist = true

    // dont continue music if encounter index is any of these
    global.mus_mod_ignore_encounters =
    [
        // Watercooler
        139,
        // Moonwarmer???
        140,
    ]

    // dont continue music if room index is any of these
    global.mus_mod_ignore_rooms =
    [
        room_dw_teevie_chef,
        room_dw_b3bs_watercooler,
        room_dw_teevie_watercooler,
        room_dw_b3bs_zapper_b,
        room_dw_ranking_c,
    ]
}

function scr_musicmod_enable_batmusic()
{
    global.flag[9] = 1
}

function scr_musicmod_disable_batmusic()
{
    global.flag[9] = 2
}

function scr_musicmod_current_song_name(song)
{
    for (var i = 0; i < instance_number(obj_astream); ++i;)
    {
        var a_stream = instance_find(obj_astream, i);
        if (a_stream.mystream == global.currentsong[0])
            return a_stream.songname;
    }

    return "";
}

function scr_musicmod_volume(volume = 1, duration = 1)
{
    if (global.flag[9] == 2)
        snd_volume(global.currentsong[1], volume, duration);
    else
        snd_volume(global.batmusic[1], volume, duration);
}

function scr_musicmod_pause_batmusic()
{
    if (global.flag[9] == 2)
        audio_pause_sound(global.currentsong[1]);
    else
        audio_pause_sound(global.batmusic[1]);
}

function scr_musicmod_resume_batmusic()
{
    if (global.flag[9] == 2)
        audio_resume_sound(global.currentsong[1]);
    else
        audio_resume_sound(global.batmusic[1]);
}

function scr_musicmod_batmusic_is_paused()
{
    if (global.flag[9] == 2)
        return audio_is_paused(global.currentsong[1]);
    else
        return audio_is_paused(global.batmusic[1]);
}

// do not use this
function scr_musicmod_is_song_playing()
{
    var msg = "do not use this"
    return false;
}

function scr_musicmod_zapper_volumeup()
{
    scr_musicmod_volume(1.4)
}

function scr_musicmod_zapper_volumedown()
{
    scr_musicmod_volume(1)
}

function scr_array_contains(arr, find)
{
    for (var i = 0; i < array_length(arr); i++)
    {
        if (arr[i] == find)
            return true;
    }

    return false;
}

function scr_musicmod_on_battle()
{

    if scr_array_contains(global.mus_mod_ignore_rooms, room)
        return;

    if scr_array_contains(global.mus_mod_ignore_encounters, global.encounterno)
        return;

    if (global.tvworld_mus_persist)
    {
        if (scr_musicmod_current_song_name() == "tv_world.ogg")
            scr_musicmod_disable_batmusic()
    }
}

function scr_musicmod_on_save()
{
    // this really isnt something that should be saved...
    if (global.chapter == 3)
        global.flag[9] = 1
}