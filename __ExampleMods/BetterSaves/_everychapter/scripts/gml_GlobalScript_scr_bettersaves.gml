function scr_bettersaves_init() 
{
    global.bettersaves_mod_version = 4
    global.bettersaves_mod_verstring = "v4"

    global.bettersaves_debug = true

    global.is_tempsave = false

    global.bettersaves_tracked_files = ds_list_create()
    // asset get index for improved mod compatability
    global.bettersaves_star_sprite = asset_get_index("spr_bettersaves_star")
    global.bettersaves_crystal_sprite = asset_get_index("spr_bettersaves_crystal")
    global.bettersaves_crystal_outline = c_ltgray

    // 100 percent star settings, you can change these to make them looser/more strict
    // since 100% check has the game load the save file, it could lag, so i've added a variable to enable/disable it
    global.bettersaves_100_percent_check_enabled = true
    global.bettersaves_100_percent_eggs = true
    global.bettersaves_100_percent_secret_bosses = true
    global.bettersaves_100_percent_mike = true
    global.bettersaves_100_percent_place_eggs = true
    global.bettersaves_100_percent_john_mantle = true

    // tracks ini keys in dr.ini save sections, and are handled automatically for copy/deleting a file, similar to tracked files (but for ini keys)
    global.bettersaves_tracked_ini_keys = ds_list_create()
    // you have to put the key, and a default value (which determines the type automatically)
    // if you wish to force a type, you can override it in parameter three
    scr_bettersaves_add_ini_tracking("Name", "[EMPTY]")
    scr_bettersaves_add_ini_tracking("Level", 0)
    scr_bettersaves_add_ini_tracking("Love", 0)
    scr_bettersaves_add_ini_tracking("Time", 0)
    scr_bettersaves_add_ini_tracking("Room", 0)
    scr_bettersaves_add_ini_tracking("Date", 0)
    scr_bettersaves_add_ini_tracking("UraBoss", 0)
    scr_bettersaves_add_ini_tracking("Version", "0")

    if (global.chapter >= 3)
        scr_bettersaves_add_ini_tracking("SideB", 0)

    // this might have to be >= but we dont know!! cuz ch5 aint out
    if (global.chapter == 4)
    {
        scr_bettersaves_add_ini_tracking("Ch4Boss", 0)
        scr_bettersaves_add_ini_tracking("Mic Sensitivity", 0)
        scr_bettersaves_add_ini_tracking("right_click_mic", 0)
        scr_bettersaves_add_ini_tracking("Microphone", 0)
    }

    // this function automatically makes this mod track files (copying them, deleting them)
    // however, you need to write your own bettersaves compatiable code for saving and loading
    global.bettersaves_config_struct = scr_bettersaves_add_file_tracking("config_", ".ini", false)
    global.bettersaves_key_struct = scr_bettersaves_add_file_tracking("keyconfig_", ".ini", false)

    // to do so, use the struct that scr_bettersaves_add_file_tracking gives and use
    // scr_bettersaves_get_track_filename(track_struct, savefile_struct) to get your file name
    // OR use
    // scr_bettersaves_get_track_filename_num(track_struct, fileindex, is_completion_file)

    global.bettersaves_save_types =
    {
        normal: "normal",
        completion: "completion",
        temp: "temp",
    }

    global.bettersaves_backup_folder = "BetterSaves_BACKUPS"

    // these are variables that increase the accuracy of the save system, but i have personally disabled because id rather
    // clean up files so they aren't huge

    // this one is the main factor of cleanness concern (makes kris save file reappear even if save has been played if this is off)
    global.bettersaves_accuracy_dont_del_sections = false
    // fuck you ura i hate you.
    global.bettersaves_accuracy_dont_del_ura = false

    // base game is "--:--" because of the old time format minute-second
    // ive updated it to the lts-demo format of hour-minute-second
    global.bettersaves_default_time_string = "--:--:--"

    // noooo for consoles
    if (!global.is_console)
    {
        if !ossafe_file_exists(game_save_id + "BETTERSAVES")
        {
            var file = ossafe_file_text_open_write(game_save_id + "BETTERSAVES")
            ossafe_file_text_close(file)
            scr_bettersaves_create_backup()
        }
    }
}

function scr_bettersaves_date_timestamp()
{
    return string(current_year) + "_" + string(current_month) + "_" + string(current_day)
}

function scr_bettersaves_exact_second_timestamp()
{
    return scr_bettersaves_date_timestamp() + "_" + string(current_hour) + "_" + string(current_minute) + "_" + string(current_second)
}

function scr_bettersaves_debug(txt)
{
    show_debug_message("BETTERSAVES: " + txt)
}

function scr_bettersaves_add_file_tracking(base_filename, append_after = "", per_chapter = true)
{
    var apt = per_chapter ? "per_chapter_file" : "per_file"
    var track_struct = 
    {
        file_name: base_filename,
        append_type: apt,
        append_after: append_after,
    }

    ds_list_add(global.bettersaves_tracked_files, track_struct)

    scr_bettersaves_debug("Now tracking file: " + base_filename)

    return track_struct;
}

function scr_bettersaves_add_ini_tracking(key, default_val, override_type = -1)
{
    var type = override_type < 0 ? typeof(default_val) : override_type

    var track_struct = 
    {
        key: key,
        default_val: default_val,
        type: type,
    }

    ds_list_add(global.bettersaves_tracked_ini_keys, track_struct)

    scr_bettersaves_debug("Now tracking dr.ini key: " + key)

    return track_struct;
}

function scr_bettersaves_read_tracked_ini(field, track_struct)
{
    if (track_struct.type == "string")
        return ini_read_string(field, track_struct.key, track_struct.default_val)

    return ini_read_real(field, track_struct.key, track_struct.default_val)
}

function scr_bettersaves_write_tracked_ini(field, track_struct, value)
{
    if (track_struct.type == "string")
        ini_write_string(field, track_struct.key, value)
    else
        ini_write_real(field, track_struct.key, value)
}

function scr_bettersaves_store_all_ini_tracked(field)
{
    var array = []
    for (var i = 0; i < ds_list_size(global.bettersaves_tracked_ini_keys); i++)
    {
        var my = ds_list_find_value(global.bettersaves_tracked_ini_keys, i)
        array[i] = 
        {
            track: my,
            val: scr_bettersaves_read_tracked_ini(field, my),
        }
    }
    return array;
}

function scr_bettersaves_write_all_ini_tracked(field, stored_array)
{
    for (var i = 0; i < array_length(stored_array); i++)
    {
        var my = stored_array[i]
        scr_bettersaves_write_tracked_ini(field, my.track, my.val)
    }
}

function scr_bettersaves_write_all_ini_tracked_default(field)
{
    for (var i = 0; i < ds_list_size(global.bettersaves_tracked_ini_keys); i++)
    {
        var my = ds_list_find_value(global.bettersaves_tracked_ini_keys, i)
        scr_bettersaves_write_tracked_ini(field, my, my.default_val)
    }
}

// generates a struct that helps with handling the weird file system
function scr_bettersaves_file_struct(fileindex, completion_data = false, chapter = -1)
{
    var ch = chapter < 0 ? global.chapter : chapter
    var data = 
    {
        true_file_index: fileindex,
        is_completion: completion_data,
        sub_index: 0,
        batch_index: 0,
        // note: this is more like "is a base game file" but i named it weird and i cant go back
        is_first_three: false,
        chapter: ch,
    }

    scr_bettersaves_calc_indexes(data)

    return data;
}

function scr_bettersaves_folder_name(batch_index)
{
    return "bettersaves_batch" + string(batch_index);
}

function scr_bettersaves_anyfile_from_struct(file_struct, base_file, as_dir = false, file_ext = "")
{
    var base = base_file
    if file_struct.is_first_three
    {
        if (as_dir)
            return game_save_id + base + file_ext;
        else
            return base + file_ext;
    }

    var result = base_file + "_" + string(file_struct.batch_index) + file_ext
    if (as_dir)
        result = game_save_id + scr_bettersaves_folder_name(file_struct.batch_index) + "/" + base_file + file_ext;

    return result;
}

function scr_bettersaves_file_name_from_struct(file_struct, chapter = -1)
{
    var ch = chapter < 0 ? file_struct.chapter : chapter
    var file = "filech" + string(ch) + "_" + string(file_struct.sub_index)
    return scr_bettersaves_anyfile_from_struct(file_struct, file, true);
}

function scr_bettersaves_ini_from_struct(file_struct, chapter = -1)
{
    var ch = chapter < 0 ? file_struct.chapter : chapter
    var field = "G_" + string(ch) + "_" + string(file_struct.sub_index);
    if (ch == 1)
        field = "G" + string(file_struct.sub_index);
    return scr_bettersaves_anyfile_from_struct(file_struct, field, false);
}

function scr_bettersaves_keyconfig_from_struct(file_struct)
{
    return scr_bettersaves_get_track_filename(global.bettersaves_key_struct, file_struct);
}

function scr_bettersaves_config_from_struct(file_struct)
{
    return scr_bettersaves_get_track_filename(global.bettersaves_config_struct, file_struct);
}

function scr_bettersaves_get_track_filename(track_struct, file_struct)
{
    var file = track_struct.file_name
    if (track_struct.append_type == "per_chapter_file")
        file += string(file_struct.chapter) + "_"

    file += string(file_struct.sub_index)
    return scr_bettersaves_anyfile_from_struct(file_struct, file, true, track_struct.append_after);
}

function scr_bettersaves_get_track_filename_num(track_struct, fileindex, is_completion_file)
{
    var fs = scr_bettersaves_file_struct(fileindex, is_completion_file)
    return scr_bettersaves_get_track_filename(track_struct, fs)
}

function scr_bettersaves_file_name(fileindex, completion_data = false, ch = -1)
{
    var fs = scr_bettersaves_file_struct(fileindex, completion_data, ch)
    return scr_bettersaves_file_name_from_struct(fs)
}

function scr_bettersaves_ini_name(fileindex, completion_data = false, ch)
{
    var fs = scr_bettersaves_file_struct(fileindex, completion_data, ch)
    return scr_bettersaves_ini_from_struct(fs)
}

function scr_bettersaves_keyconfig_name(fileindex, completion_data = false)
{
    return scr_bettersaves_get_track_filename_num(global.bettersaves_key_struct, fileindex, completion_data);
}

function scr_bettersaves_config_name(fileindex, completion_data = false)
{
    return scr_bettersaves_get_track_filename_num(global.bettersaves_config_struct, fileindex, completion_data);
}

// filter can be -1 for no filter, false/0 for only normal saves, true for only completion
// advanced enables logging, and extra data like shadow crystal img, star img, and metadata. Only recommended on the save menu
// NOTE: this returns a ds list!!! make sure to destroy it when you're done with it
function scr_bettersaves_get_all_saves(chapter = -1, filter = -1, advanced = true)
{
    var saves = -1
    switch filter
    {
        case 0:
            //if variable_instance_exists(id, "savefiles_normal")
                //ds_list_destroy(savefiles_normal)
            savefiles_normal = ds_list_create()
            saves = savefiles_normal
            break

        case 1:
            //if variable_instance_exists(id, "savefiles_completion")
                //ds_list_destroy(savefiles_completion)
            savefiles_completion = ds_list_create()
            saves = savefiles_completion
            break

        default:
            //if (variable_instance_exists(id, "savefiles"))
                //ds_list_destroy(savefiles)
            savefiles = ds_list_create()
            saves = savefiles
            break;
    }

    var min_saves = 6
    var max_i = 6
    var start_i = 0
    if (filter == 0)
    {
        min_saves = 3
        max_i = 3
    }
    if (filter == 1)
    {
        min_saves = 6
        max_i = 6
        start_i = 3
    }
    var ch = chapter < 0 ? global.chapter : chapter
    var folderexists = true
    var i = start_i
    var true_i = start_i
    var batch = 0

    if advanced
    {
        var debug_txt1 = "saves"
        if (filter == 0)
            debug_txt1 = "normal saves"
        if (filter == 1)
            debug_txt1 = "completion saves"
        scr_bettersaves_debug(string("Getting all {0} for chapter {1}", debug_txt1, ch));
    }
    
    while folderexists
    {
        var completion = false
        if (i >= max_i)
        {
            batch++
            i = start_i
        }
        if (i >= 3)
            completion = true

        if (batch > 0)
            folderexists = ossafe_directory_exists(game_save_id + scr_bettersaves_folder_name(batch))
        if (!folderexists)
            break;

        var file_struct = scr_bettersaves_file_struct(true_i, completion, ch)
        file_struct.exists = false

        var file = scr_bettersaves_file_name_from_struct(file_struct)
        if ossafe_file_exists(file)
            file_struct.exists = true
        scr_bettersaves_set_file_relations(file_struct)

        if file_struct.exists || true_i < min_saves
        {
            //if (file_struct.exists)
                //scr_bettersaves_debug("FILE AT: " + scr_bettersaves_file_name_from_struct(file_struct))
            if advanced
            {
                scr_bettersaves_get_file_meta(file_struct)
                scr_bettersaves_update_file_sprites(file_struct)
            }
            ds_list_add(saves, file_struct)
        }
        i++
        true_i++
    }

    var amt = ds_list_size(saves)
    if advanced
        scr_bettersaves_debug(string("Found {0} {1} for chapter {2}", amt, debug_txt1, ch));
}

// filter can be -1 for no filter, false/0 for only normal saves, true for only completion
// accept_basegame will allow nonexistent files in slot 0-2 to count as "existent"
function scr_bettersaves_file_amount(chapter = -1, filter = -1, accept_basegame = false)
{
    var max_i = 6
    var start_i = 0
    var min_saves = 3
    if (filter == 0)
        max_i = 3
    if (filter == 1)
    {
        max_i = 6
        start_i = 3
    }
    var ch = chapter < 0 ? global.chapter : chapter
    var folderexists = true
    var i = start_i
    var true_i = start_i
    var batch = 0
    var exist_count = 0
    while folderexists
    {
        var completion = false
        if (i >= max_i)
        {
            batch++
            i = start_i
        }
        if (i >= 3)
            completion = true
        if (batch > 0)
            folderexists = ossafe_directory_exists(game_save_id + scr_bettersaves_folder_name(batch))
        if (!folderexists)
            break;
        var file = scr_bettersaves_file_name(true_i, completion, ch)
        if ossafe_file_exists(file) || (accept_basegame && true_i < min_saves)
            exist_count++
        i++
        true_i++
    }

    return exist_count;
}

function scr_bettersaves_any_saves_simple(chapter = -1, filter = 0)
{
    return scr_bettersaves_file_amount(chapter, filter) > 0;
}

function scr_bettersaves_any_completion(savefile_list = -1)
{
    var list = scr_bettersaves_savelist(savefile_list)
    for (var i = 0; i < ds_list_size(list); i++)
    {
        var my = ds_list_find_value(list, i)
        if (my.exists && my.is_completion) || my.has_completion
            return true;
    }
    
    return false;
}

function scr_bettersaves_any_incomplete(savefile_list = -1)
{
    var list = scr_bettersaves_savelist(savefile_list)
    for (var i = 0; i < ds_list_size(list); i++)
    {
        var my = ds_list_find_value(list, i)
        if my.exists && !my.is_completion
            return true;
    }
    return false;
}

function scr_bettersaves_file_place(file_struct)
{
    var field = scr_bettersaves_ini_from_struct(file_struct)

    var room_id = ini_read_real(field, "Room", scr_get_id_by_room_index(room));
    
    // Function literally doesn't exist in chapter3&4
    if (room_id < 10000 && global.chapter <= 2)
    {
        var valid_room_index = scr_get_valid_room(global.chapter, room_id);
        room_id = scr_get_id_by_room_index(valid_room_index);
    }
    
    var room_index = scr_get_room_by_id(room_id);
    file_struct.place = scr_roomname(room_index);
}

function scr_bettersaves_get_file_meta(file_struct)
{
    if (global.chapter >= 2)
        file_struct.name = stringsetloc("[EMPTY]", "scr_84_load_ini_slash_scr_84_load_ini_gml_13_0");
    else
        file_struct.name = scr_84_get_lang_string("DEVICE_MENU_slash_Create_0_gml_97_0");
    file_struct.time = 0;
    file_struct.place = "------------";
    file_struct.level = 0;
    file_struct.time_string = global.bettersaves_default_time_string;
    file_struct.initlang = 0;

    if !file_struct.exists
        return;

    if !ossafe_file_exists("dr.ini")
        return;

    ossafe_ini_open("dr.ini");

    var field = scr_bettersaves_ini_from_struct(file_struct)

    scr_bettersaves_file_place(file_struct)
    file_struct.time = ini_read_real(field, "Time", 0);
    file_struct.name = ini_read_string(field, "Name", "------");
    file_struct.level = 1;
    file_struct.initlang = ini_read_real(field, "InitLang", 0);
    file_struct.time_seconds_total = floor(file_struct.time / 30);
    file_struct.time_minutes = floor(file_struct.time_seconds_total / 60);
    file_struct.time_seconds = file_struct.time_seconds_total - (file_struct.time_minutes * 60);
    file_struct.time_seconds_string = string(file_struct.time_seconds);
    
    if (file_struct.time_seconds == 0)
        file_struct.time_seconds_string = "00";
    
    if (file_struct.time_seconds < 10 && file_struct.time_seconds >= 1)
        file_struct.time_seconds_string = "0" + string(file_struct.time_seconds);
    
    file_struct.time_string = scr_timedisp(file_struct.time);
    
    ossafe_ini_close();
    ossafe_savedata_save();

}

function scr_bettersaves_calc_indexes(file_struct)
{
    var offset = file_struct.is_completion ? 3 : 0

    var batch_index = 0
    var temp_index = file_struct.true_file_index
    file_struct.is_first_three = false;

    while temp_index > (2 + offset)
    {
        temp_index -= 3
        batch_index++
    }

    file_struct.sub_index = temp_index
    file_struct.batch_index = batch_index

    if (batch_index <= 0)
        file_struct.is_first_three = true;
}

function scr_bettersaves_set_file_relations(file_struct)
{
    if !file_struct.is_completion
    {
        file_struct.has_completion = false
        if (scr_bettersaves_file_has_completion(file_struct))
            file_struct.has_completion = true
    }
}

function scr_bettersaves_change_file_index(file_struct, amount)
{
    file_struct.true_file_index += amount;
    scr_bettersaves_calc_indexes(file_struct)
    scr_bettersaves_set_file_relations(file_struct)
}

function scr_bettersaves_set_file_index(file_struct, index)
{
    file_struct.true_file_index = index;
    scr_bettersaves_calc_indexes(file_struct)
    scr_bettersaves_set_file_relations(file_struct)
}

function scr_bettersaves_get_all_ini_keys()
{
    // i did not mean to leave this here lmao
}

// NOTE: this function can lag if it has to shift *many* save files
function scr_bettersaves_file_delete(file_struct, savefile_list)
{
    var shift_list_index = ds_list_find_index(savefile_list, file_struct)

    if (shift_list_index == -1)
    {   
        // this is really fucking bad and sohuld never happen
        snd_play(snd_error)
        scr_bettersaves_debug("!!! shift_list_index was -1??? Erase failed.")
        return false;
    }

    if (global.is_console)
        throw("NOT IMPLEMENTED ON CONSOLES")

    scr_bettersaves_debug("Erasing file " + string(file_struct.true_file_index))

    file_struct.exists = false
    if (global.chapter >= 2)
        file_struct.name = stringsetloc("[EMPTY]", "scr_84_load_ini_slash_scr_84_load_ini_gml_13_0");
    else
        file_struct.name = scr_84_get_lang_string("DEVICE_MENU_slash_Step_0_gml_105_0")
    file_struct.time = 0
    file_struct.place = "------------"
    file_struct.level = 0
    file_struct.time_string = "--:--"

    ossafe_file_delete(scr_bettersaves_file_name_from_struct(file_struct))

    ossafe_ini_open("dr.ini");

    var field = scr_bettersaves_ini_from_struct(file_struct)

    scr_bettersaves_write_all_ini_tracked_default(field)

    for (var i = 0; i < ds_list_size(global.bettersaves_tracked_files); i++)
    {
        var tracked = ds_list_find_value(global.bettersaves_tracked_files, i)
        // except for config for some fucking reason (thanks toby)
        // edit: i think config was from survery program thats why
        if (tracked == global.bettersaves_config_struct)
            continue;
        fname = scr_bettersaves_get_track_filename(tracked, file_struct)
        ossafe_file_delete(fname)
    }

    if file_struct.is_first_three
    {
        ossafe_ini_close();
        ossafe_savedata_save();
        scr_bettersaves_update_file_sprites(file_struct)
        return false; 
    }

    // deleting new saves is a little more complicated...

    // we can kinda skip the whole process below if we deleted the last save in the list
    ds_list_delete(savefile_list, shift_list_index)
    if shift_list_index == ds_list_size(savefile_list)
    {
        scr_bettersaves_debug("No need to shift, erasing/deleting ini field: " + field)
        
        // delete/empty save file if needed
        // this was already emptied earlier so no need to do it here
        if !global.bettersaves_accuracy_dont_del_sections
            ini_section_delete(field)

        if !global.bettersaves_accuracy_dont_del_ura
            ini_key_delete("URA", scr_bettersaves_ura(file_struct))
        else
            ini_write_real("URA", scr_bettersaves_ura(file_struct), 0)

            scr_bettersaves_debug("File erase successful!")

        ossafe_savedata_save();
        ossafe_ini_close();
        return true;
    }

    scr_bettersaves_debug("SHIFTING all saves greater than " + string(file_struct.true_file_index))

    var last_struct = file_struct

    // mfw 2d array containing structs (who could knew saving could get so complicated)
    var stored_keys = []
    var uras = []
    
    for (var i = shift_list_index; i < ds_list_size(savefile_list); i++)
    {
        var my = ds_list_find_value(savefile_list, i)

        if (my.is_completion)
            continue;

        var arridx = (i - shift_list_index)

        // not dealin with that reopening file shit that scr_get_ura_value does
        field = scr_bettersaves_ura(my)
        uras[arridx] = ini_read_real("URA", field, 0)

        field = scr_bettersaves_ini_from_struct(my)

        stored_keys[arridx] = scr_bettersaves_store_all_ini_tracked(field)

        // if we're the last one we can try deleting stuff (empty if we cant)
        if (i == ds_list_size(savefile_list) - 1)
        {
            if !global.bettersaves_accuracy_dont_del_sections
                ini_section_delete(scr_bettersaves_ini_from_struct(my))
            else
                scr_bettersaves_write_all_ini_tracked_default(field)

            if !global.bettersaves_accuracy_dont_del_ura
                ini_key_delete("URA", scr_bettersaves_ura(my))
            else
                ini_write_real("URA", scr_bettersaves_ura(my), 0)
        }
        else
        {
            scr_bettersaves_write_all_ini_tracked_default(field)
            ini_write_real("URA", scr_bettersaves_ura(my), 0)
        }


        scr_bettersaves_write_all_ini_tracked_default(field)

        // move save files
        var old_name = scr_bettersaves_file_name_from_struct(my)
        var new_name = scr_bettersaves_file_name_from_struct(last_struct)
        ossafe_file_copy(old_name, new_name + ".TMP")
        ossafe_file_delete(old_name)

        for (var j = 0; j < ds_list_size(global.bettersaves_tracked_files); j++)
        {
            var tracked = ds_list_find_value(global.bettersaves_tracked_files, j)
            old_name = scr_bettersaves_get_track_filename(tracked, my)
            new_name = scr_bettersaves_get_track_filename(tracked, last_struct)
            scr_bettersaves_debug("Creating TMP of tracked file " + old_name + " to " + new_name + ".TMP")
            ossafe_file_copy(old_name, new_name + ".TMP")
            ossafe_file_delete(old_name)
        }

        last_struct = json_parse(json_stringify(my))

        // shift back save file
        my = scr_bettersaves_change_file_index(my, -1)
    }

    // do another loop to rename and delete files
    for (var i = shift_list_index; i < ds_list_size(savefile_list); i++)
    {
        var my = ds_list_find_value(savefiles, i)

        if (my.is_completion)
            continue;

        var arridx = (i - shift_list_index)

        var old_name = scr_bettersaves_file_name_from_struct(my)
        ossafe_file_delete(old_name)
        ossafe_file_rename(old_name + ".TMP", old_name)

        for (var j = 0; j < ds_list_size(global.bettersaves_tracked_files); j++)
        {
            var tracked = ds_list_find_value(global.bettersaves_tracked_files, j)
            old_name = scr_bettersaves_get_track_filename(tracked, my)
            ossafe_file_delete(old_name)
            scr_bettersaves_debug("Restoring TMP of tracked file " + old_name + ".TMP")
            ossafe_file_rename(old_name + ".TMP", old_name)
        }

        // restore ini stuff in new slots
        scr_bettersaves_write_all_ini_tracked(scr_bettersaves_ini_from_struct(my), stored_keys[arridx])
        ini_write_real("URA", scr_bettersaves_ura(my), uras[arridx])
    }

    ossafe_ini_close();
    ossafe_savedata_save();

    // one final loop to update the file sprites because we open an ini during this process
    scr_bettersaves_debug("Updating file sprites")
    for (var i = shift_list_index; i < ds_list_size(savefile_list); i++)
    {
        var my = ds_list_find_value(savefiles, i)

        if (my.is_completion)
            continue;

        scr_bettersaves_update_file_sprites(my)
    }

    scr_bettersaves_debug("File erase successful!")

    return true;
}

function scr_bettersaves_copy(file_to, file_from)
{
    scr_bettersaves_debug("Copying file " + string(file_from.true_file_index) + " to " + string(file_to.true_file_index))
    iniwrite = ossafe_ini_open("dr.ini");
    var field = scr_bettersaves_ini_from_struct(file_from)
    var stored = scr_bettersaves_store_all_ini_tracked(field)
    // for loop to fix room id in chapters1&2
    if global.chapter <= 2
    {
        for (var i = 0; i < array_length(stored); i++)
        {
            var my = stored[i]
            // kinda hacky but this should fix the room index
            if (my.track.key == "Room")
            {
                var room_id = my.val
                if (room_id < 10000)
                {
                    room_index = room_id;
                    var room_offset = room_index;
                    
                    if (room_index < 0)
                        room_offset = 0 + room_index;
                    
                    room_id = room_offset;
                    room_id += 10000 * file_to.chapter;

                    var room_index = scr_get_valid_room(file_to.chapter, room_id);
                    my.val = scr_get_id_by_room_index(room_index)
                }
                break;
            }
        }
    }

    field = scr_bettersaves_ini_from_struct(file_to)
    scr_bettersaves_write_all_ini_tracked(field, stored)
    ossafe_ini_close();

    var result = scr_get_ura_value(file_from.chapter, file_from);
    scr_store_ura_result(file_to.chapter, file_to, result);

    var new_file = json_parse(json_stringify(file_from))
    scr_bettersaves_set_file_index(new_file, file_to.true_file_index)

    if (!global.is_console)
    {
        ossafe_file_copy(scr_bettersaves_file_name_from_struct(file_from), scr_bettersaves_file_name_from_struct(file_to));

        for (var i = 0; i < ds_list_size(global.bettersaves_tracked_files); i++)
        {
            var tracked = ds_list_find_value(global.bettersaves_tracked_files, i)
            var tracked_from = scr_bettersaves_get_track_filename(tracked, file_from)
            var tracked_to = scr_bettersaves_get_track_filename(tracked, file_to)

            if ossafe_file_exists(tracked_from)
                ossafe_file_copy(tracked_from, tracked_to)
        }

        scr_bettersaves_update_file_sprites(new_file)
    }
    else
    {
        // uhh idunno
        throw ("COPYING NOT IMPLEMENTED ON CONSOLES")
        var file_to_copy = ds_map_find_value(global.savedata, "filech1_" + string(MENUCOORD[2]));
        var new_filename = "filech1_" + string(MENUCOORD[3]);
        var new_file = ossafe_file_text_open_write(new_filename);
        ds_map_set(new_file, "data", file_to_copy);
        ossafe_file_text_close(new_file);
        ossafe_savedata_save();
        
        if (ossafe_file_exists("keyconfig_" + string(MENUCOORD[2]) + ".ini"))
        {
            ossafe_ini_open("keyconfig_" + string(MENUCOORD[2]) + ".ini");
            var copy_border = ini_read_string("BORDER", "TYPE", global.screen_border_id);
            var copy_controls_list = [];
            var shoulder_reassign = obj_gamecontroller.gamepad_shoulderlb_reassign;
            
            for (var i = 0; i < 10; i += 1)
                copy_controls_list[i] = ini_read_real("GAMEPAD_CONTROLS", string(i), global.input_g[i]);
            
            shoulder_reassign = ini_read_real("SHOULDERLB_REASSIGN", "SHOULDERLB_REASSIGN", obj_gamecontroller.gamepad_shoulderlb_reassign);
            ossafe_ini_close();
            ossafe_ini_open("keyconfig_" + string(MENUCOORD[3]) + ".ini");
            ini_write_string("BORDER", "TYPE", copy_border);
            
            for (var i = 0; i < 10; i += 1)
                ini_write_real("GAMEPAD_CONTROLS", string(i), copy_controls_list[i]);
            
            ini_read_real("SHOULDERLB_REASSIGN", "SHOULDERLB_REASSIGN", shoulder_reassign);
            ossafe_ini_close();
        }
    }

    with (obj_event_manager)
        trigger_event(UnknownEnum.Value_0, UnknownEnum.Value_28);

    enum UnknownEnum
    {
        Value_0,
        Value_28 = 28
    }

    scr_bettersaves_debug("Copy complete.")

    return new_file;
}

function scr_bettersaves_savelist(list = -1)
{
    if (variable_instance_exists(id, "savefiles") && list == -1)
        return savefiles;
    if list == -1
    {
        scr_bettersaves_debug("!!! savefiles list nonexistent, and list == -1!")
        scr_bettersaves_debug("!!! this is really bad so uh, just kill the program.")
        throw ("MISSING savefile list")
    }

    return list;
}

function scr_bettersaves_local_funcs()
{
    get_key_file = function(file)
    {
        return scr_bettersaves_keyconfig_name(file, false);
    }

    get_config_file = function(file)
    {
        return scr_bettersaves_config_name(file, false)
    }

    get_dr_file = function(file)
    {
        return "dr.ini";
    }

    cur_file = function(file, completion = -1, savefile_list = -1)
    {
        var list = scr_bettersaves_savelist(savefile_list)
        return ds_list_find_value(list, file);
    }

    any_files = function(completion = false, savefile_list = -1)
    {
        var list = scr_bettersaves_savelist(savefile_list)
        for (var i = 0; i < ds_list_size(list); i++)
        {
            var f = cur_file(i, list)
            if f.exists && (f.is_completion == completion || completion == -1)
                return true;
        }

        return false;
    }

    get_file_amt = function(completion = false, savefile_list = -1)
    {
        var list = scr_bettersaves_savelist(savefile_list)
        return ds_list_size(list);
    }


    draw_with_darkness = function(sprite, index, x1, y1, brightness, scale = 1)
    {
        draw_sprite_ext(sprite, index, x1, y1, scale, scale, 0, c_white, draw_get_alpha())
        if (brightness >= 1)
            return;
        var fog = gpu_get_fog();
        var bm = gpu_get_blendmode();

        d3d_set_fog(true, c_black, 1, 1)
        gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha) 
        draw_sprite_ext(sprite, index, x1, y1, scale, scale, 0, c_white, 1 - brightness)

        gpu_set_blendmode(bm)
        // why is it even d3d_set_fog anyway
        gpu_set_fog(fog)
    }

    draw_with_outline = function(sprite, index, x1, y1, outline_col = c_black, corners = true, brightness = 1, scale = 1)
    {
        d3d_set_fog(true, outline_col, 1, 1)
        draw_with_darkness(sprite, index, x1 - scale, y1, brightness, scale)
        draw_with_darkness(sprite, index, x1 - scale, y1, brightness, scale)
        draw_with_darkness(sprite, index, x1 + scale, y1, brightness, scale)
        draw_with_darkness(sprite, index, x1, y1 - scale, brightness, scale)
        draw_with_darkness(sprite, index, x1, y1 + scale, brightness, scale)
        if (corners)
        {
            draw_with_darkness(sprite, index, x1 - scale, y1 + scale, brightness, scale)
            draw_with_darkness(sprite, index, x1 - scale, y1 -  scale, brightness, scale)
            draw_with_darkness(sprite, index, x1 + scale, y1 + scale, brightness, scale)
            draw_with_darkness(sprite, index, x1 + scale, y1 - scale, brightness, scale)
        }
        d3d_set_fog(false, c_black, 0, 0)
        draw_with_darkness(sprite, index, x1, y1, brightness, scale)
    }

    surf_scale = 2
    draw_text_shadow_scaled_surf = function(x1, y1, txt, shadow_spacing = surf_scale)
    {
        var col = draw_get_color()
        draw_set_color(c_black)
        draw_text_transformed(x1 + shadow_spacing, y1 + shadow_spacing, txt, surf_scale, surf_scale, 0)
        draw_set_color(col)
        draw_text_transformed(x1, y1, txt, surf_scale, surf_scale, 0)
    }

    draw_text_shadow_width_scaled_surf = function(x1, y1, txt, width, shadow_spacing = surf_scale)
    {
        var col = draw_get_color()
        var txt_width = string_width(txt)
        if txt_width >= width
            txt_width = width / txt_width
        else
            txt_width = 1
        draw_set_color(c_black)
        draw_text_transformed(x1 + shadow_spacing, y1 + shadow_spacing, txt, surf_scale * txt_width, surf_scale, 0)
        draw_set_color(col)
        draw_text_transformed(x1, y1, txt, surf_scale * txt_width, surf_scale, 0)
    }

    normalized = function(x)
    {
        return x * surf_scale;
    }
}

// yup whatever this is
function scr_bettersaves_lin_convert(_value, min_from, max_from, min_to, max_to) 
{
    return (((_value - min_from) / (max_from - min_from)) * (max_to - min_to)) + min_to;
}

function scr_bettersaves_file_has_completion(file_struct)
{
    var completion_ver = json_parse(json_stringify(file_struct))
    completion_ver.is_completion = true
    scr_bettersaves_change_file_index(completion_ver, 3)

    return ossafe_file_exists(scr_bettersaves_file_name_from_struct(completion_ver))
}

function scr_bettersaves_completion_has_file(file_struct)
{
    var og_ver = json_parse(json_stringify(file_struct))
    og_ver.is_completion = false
    scr_bettersaves_change_file_index(og_ver, -3)

    return ossafe_file_exists(scr_bettersaves_file_name_from_struct(og_ver))
}

// gives you ura ini key from file_struct
function scr_bettersaves_ura(file_struct, chapter = -1)
{
    var ch = chapter < 0 ? file_struct.chapter : chapter
    var file = string(ch) + "_" + string(file_struct.sub_index)
    return scr_bettersaves_anyfile_from_struct(file_struct, file, false)
}

function scr_bettersaves_update_file_sprites(file_struct)
{
    scr_bettersaves_get_star_sprite(file_struct)
    scr_bettersaves_get_crystal_sprite(file_struct)
}

function scr_bettersaves_get_crystal_sprite(file_struct)
{
    file_struct.crystal_img = 0
    if !variable_struct_exists(file_struct, "exists")
        return;

    //if !file_struct.exists
        //return;

    var ura = scr_get_ura_value(file_struct.chapter, file_struct)
    if (ura != 0)
    {
        // idk
        if (file_struct.chapter == 3 && ura == 2)
            return;
        file_struct.crystal_img = 1
    }
}

function scr_bettersaves_get_star_sprite(file_struct)
{
    file_struct.star_img = -1

    // Baddd
    if !variable_struct_exists(file_struct, "exists")
        return;

    if (file_struct.is_completion)
    {
        file_struct.star_img = 0
        // no save in the original slot, blanked star
        // but don't return, because 100% star overwrites the blank star
        if !scr_bettersaves_completion_has_file(file_struct)
            file_struct.star_img = 1
    }
    else
    {
        // no save in the slot, but it has completion data, blanked star
        if !file_struct.exists && file_struct.has_completion
        {
            file_struct.star_img = 1
            return;
        }
    }

    // dont check for completion data if u are a completion file
    // dumbass
    if !file_struct.is_completion
    {
        // has completion, star
        if file_struct.has_completion
            file_struct.star_img = 0
        else
            return;
    }

    if !global.bettersaves_100_percent_check_enabled
        return;

    var save_struct = file_struct
    var file_ch = file_struct.chapter

    // if we aren't a completion file, we have to set the file to load as the completion file
    if !file_struct.is_completion
    {
        var completion_ver = json_parse(json_stringify(file_struct))
        completion_ver.is_completion = true
        scr_bettersaves_change_file_index(completion_ver, 3)
        save_struct = completion_ver
    }

    // load the chapters save file, getting the flags array and inventory
    if !scr_bettersaves_flag_and_inv(save_struct)
    {
        // the loading can fail if the function doesn't exist yet or if the file doesn't exist, so just do normal star
        file_struct.star_img = 0
        return;
    }

    // special 100% star checks
    // mmm yes toby your save system is SOIGIUG GOOD!!!
    var jevil_flag = global.flag[241] == 6 || global.flag[241] == 7
    var got_egg = 
    [
        global.flag[911],
        global.flag[918],
        global.flag[930],
        global.flag[931],
    ]

    if (file_ch == 1)
    {
        var ch1_egg_check = scr_keyitemcheck(2);
        
        if (!ch1_egg_check)
        {
            if (global.flag[263] == 2)
                ch1_egg_check = true;
            else
            {
                scr_litemcheck(8);
                ch1_egg_check = haveit;
            }
        }
        got_egg[0] = ch1_egg_check
    }

    var placed_eggs = 
    [
        global.flag[263] == 2,
        global.flag[439],
        true,
        true,
    ]

    var egg_check = function(idx, file_struct, got_egg, placed_eggs)
    {
        if (!got_egg[idx] && global.bettersaves_100_percent_eggs)
            file_struct.star_img = 0

        if (!placed_eggs[idx] && global.bettersaves_100_percent_place_eggs)
            file_struct.star_img = 0
    }

    file_struct.star_img = 2

    // chapter 1 checks
    if (!jevil_flag && global.bettersaves_100_percent_secret_bosses)
        file_struct.star_img = 0

    egg_check(0, file_struct, got_egg, placed_eggs)

    if (file_ch < 2)
        return;

    var spamton_flag = global.flag[571] == 1 || global.flag[571] == 2

    if (!spamton_flag && global.bettersaves_100_percent_secret_bosses)
        file_struct.star_img = 0

    egg_check(1, file_struct, got_egg, placed_eggs)

    if (file_ch < 3)
        return;

    var knight_flag = global.flag[1047] == 1

    var john_flag = global.flag[1050]

    if (!knight_flag && global.bettersaves_100_percent_secret_bosses)
        file_struct.star_img = 0

    if (!john_flag && global.bettersaves_100_percent_john_mantle)
        file_struct.star_img = 0

    egg_check(2, file_struct, got_egg, placed_eggs)

    if (file_ch < 4)
        return;

    var gerson_flag = global.flag[1629]
    var mike_flag = global.flag[1696]

    if (!gerson_flag && global.bettersaves_100_percent_secret_bosses)
        file_struct.star_img = 0

    if (!mike_flag && global.bettersaves_100_percent_mike)
        file_struct.star_img = 0

    egg_check(3, file_struct, got_egg, placed_eggs)
}

function scr_bettersaves_menu_cleanup()
{
    if surface_exists(text_surf)
        surface_free(text_surf)
    if surface_exists(box_surf)
        surface_free(box_surf)
    if variable_instance_exists(id, "savefiles")
    {
        if ds_exists(ds_type_list, savefiles)
            ds_list_destroy(savefiles)
    }
    if variable_instance_exists(id, "savefiles_normal")
    {
        if ds_exists(ds_type_list, savefiles_normal)
            ds_list_destroy(savefiles_normal)
    }
    if variable_instance_exists(id, "savefiles_completion")
    {
        if ds_exists(ds_type_list, savefiles_completion)
            ds_list_destroy(savefiles_completion)
    }
}

function scr_bettersaves_get_saveprocess_file(filechoice, type, chapter = -1)
{
    var ch = chapter < 0 ? global.chapter : chapter
    switch (type)
    {
        case global.bettersaves_save_types.temp:
            return "filech" + string(ch) + "_" + string(filechoice);

        case global.bettersaves_save_types.completion:
            return scr_bettersaves_file_name(filechoice, true, ch);

        // normal save
        default:
            return scr_bettersaves_file_name(filechoice, false, ch);
    }
}

function scr_bettersaves_get_save_field(filechoice, type)
{
    var completion = false
    if (type == global.bettersaves_save_types.completion)
        completion = true
    var file_struct = scr_bettersaves_file_struct(filechoice, completion)

    var fields = 
    {
        ini_section: scr_bettersaves_ini_from_struct(file_struct),
        keyconfig: scr_bettersaves_keyconfig_from_struct(file_struct),
        file_struct: file_struct,
    }

    return fields;
}

function scr_bettersaves_copy_files_in_folder(folder_from, folder_to)
{
    var file = file_find_first(folder_from + "*", 0);

    while (file != "")
    {
        show_debug_message("Copying " + file + " to " + folder_to + file)
        ossafe_file_copy(folder_from + file, folder_to + file)
        file = file_find_next();
    }

    file_find_close();
}

function scr_bettersaves_get_completion_room_name(file_struct)
{
    if !file_struct.exists
        return stringsetloc("[Made on seeing credits.]", "DEVICE_MENU_slash_Draw_0_gml_195_0");

    switch file_struct.chapter
    {
        case 1:
            if global.lang == "en"
                return stringsetsub("Your Room [Chapter ~1 END]", file_struct.chapter) 
            else
                return stringsetsub("最終地点 [Ch~1 END]", file_struct.chapter) 
            break;
        default:
            return scr_get_completed_file_name(file_struct.chapter);
            break
    }
}

function scr_bettersaves_chapter_start()
{
    snd_free_all()
    switch global.chapter
    {
        case 1:
            room_goto(PLACE_CONTACT)
            break;
        case 2:
            room_goto(room_krisroom)
            break;
        case 3:
            room_goto(room_dw_couch_overworld_intro)
            break;
        case 4:
            room_goto(room_cc_fountain)
            break;
        default:
            throw(stringsetsub("!!! UNDEFINED START ROOM for chapter ~1", global.chapter))
            break;
    }
}

function scr_bettersaves_create_backup()
{
    scr_bettersaves_debug("Creating save folder backup...")

    var folder = game_save_id + global.bettersaves_backup_folder + "/" + scr_bettersaves_exact_second_timestamp() + "/"

    scr_bettersaves_copy_files_in_folder(game_save_id, folder)

    scr_bettersaves_debug("")
    scr_bettersaves_debug("Backed-up files, now backing up batch folders.")
    scr_bettersaves_debug("")

    var folderexists = true
    var i = 1
    while folderexists
    {
        var batch_folder = scr_bettersaves_folder_name(i)
        if (!ossafe_directory_exists(game_save_id + batch_folder))
        {
            folderexists = false
            continue;
        }
        scr_bettersaves_debug("Copying files in " + batch_folder)
        scr_bettersaves_debug("")
        scr_bettersaves_copy_files_in_folder(game_save_id + batch_folder + "/", folder + batch_folder + "/")
        scr_bettersaves_debug("")
        i++
    }

    scr_bettersaves_debug("Save folder backup complete.")
}

// extremely minor todo because i doubt anyones playing this on console: implement
// i added this anyway if i do decide to make it work tho
function ossafe_directory_exists(dir)
{
    if (!global.is_console)
        return directory_exists(dir)

    throw("NOT IMPLEMENTED ON CONSOLES")
    return "";
}
function ossafe_file_copy(file_from, file_to)
{
    if (!global.is_console)
        file_copy(file_from, file_to)
    else
        throw("NOT IMPLEMENTED ON CONSOLES")
}

function ossafe_file_rename(file_oldname, file_newname)
{
    if (!global.is_console)
        file_rename(file_oldname, file_newname)
    else
        throw("NOT IMPLEMENTED ON CONSOLES")
}

function scr_bettersaves_flag_and_inv(file_struct)
{
    switch file_struct.chapter
    {
        case 1:
            return scr_bettersaves_get_flags_and_inventory_ch1(file_struct);
            break;
        case 2:
            return scr_bettersaves_get_flags_and_inventory_ch2(file_struct);
            break;
        case 3:
            return scr_bettersaves_get_flags_and_inventory_ch3(file_struct);
            break;
        case 4:
            return scr_bettersaves_get_flags_and_inventory_ch4(file_struct);
            break;
        default:
            scr_bettersaves_debug("Can't load file data for chapter: " + string(file_struct.chapter))
            return false;
            break;
    }

    return true;
}

function scr_bettersaves_load_prev(savetype)
{
    switch global.chapter    
    {
        case 1:
            scr_bettersaves_debug("Tried to load previous chapter as chapter 1???")
            break;
        case 2:
            scr_load_chapter1(savetype)
            break;
        default:
            scr_load_prev_chapter_file(global.chapter - 1, savetype)
            break;
    }
}

// Actually does more than this but fuck u
function scr_bettersaves_update_save_place(force_default, savefile_list = -1)
{
    var list = scr_bettersaves_savelist(savefile_list)

    for (var i = 0; i < ds_list_size(list); i++)
    {
        var my = ds_list_find_value(list, i)
        
        if !my.exists
        {
            if (global.chapter >= 2)
                my.name = stringsetloc("[EMPTY]", "scr_84_load_ini_slash_scr_84_load_ini_gml_13_0");
            else
                my.name = scr_84_get_lang_string("DEVICE_MENU_slash_Create_0_gml_97_0");
        }

        scr_bettersaves_file_place(my)
    }
}

function scr_bettersaves_lang_change(in_menu = true)
{
    if !in_menu
        return;

    if !ossafe_file_exists("dr.ini")
    {
        scr_bettersaves_update_save_place(true)
        if global.chapter >= 2
        {
            if INCOMPLETE_LOAD
                scr_bettersaves_update_save_place(true, savefiles_prev)
            else
                scr_bettersaves_update_save_place(true, savefiles_completion_prev)
        }
        return;
    }

    ossafe_ini_open("dr.ini")

    scr_bettersaves_update_save_place(false)

    if global.chapter >= 2
    {
        if INCOMPLETE_LOAD
            scr_bettersaves_update_save_place(false, savefiles_prev)
        else
            scr_bettersaves_update_save_place(false, savefiles_completion_prev)
    }

    ossafe_ini_close()
}



// -- THE STUPID SECTION --
// this section of code sucks its just stripped down load code for the star images because toby's. save code. is. wonderful.
// i will kill tony fix.



// god i hate toby's stupid freaking save format DIE
function scr_bettersaves_get_flags_and_inventory_ch1(file_struct)
{
    var file = scr_bettersaves_file_name_from_struct(file_struct)

    if !ossafe_file_exists(file)
        return false;

    file = ossafe_file_text_open_read(file)
    
    scr_gamestart();
    var myfileid = file

    ossafe_file_text_readln(myfileid);
    
    if (global.is_console)
        ossafe_file_text_readln(myfileid);
    else
    {
        for (i = 0; i < 6; i += 1)
            ossafe_file_text_readln(myfileid);
    }

    repeat 9
        ossafe_file_text_readln(myfileid);
    
    if (global.is_console)
    {
        repeat 6
            ossafe_file_text_readln(myfileid);
        var charweapon_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(charweapon_list); i += 1)
            global.charweapon[i] = ds_list_find_value(charweapon_list, i);
        
        ds_list_destroy(charweapon_list);
        ossafe_file_text_readln(myfileid);
        var chararmor1_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(chararmor1_list); i += 1)
            global.chararmor1[i] = ds_list_find_value(chararmor1_list, i);
        
        ds_list_destroy(chararmor1_list);
        ossafe_file_text_readln(myfileid);
        var chararmor2_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(chararmor2_list); i += 1)
            global.chararmor2[i] = ds_list_find_value(chararmor2_list, i);
        
        ds_list_destroy(chararmor2_list);
        ossafe_file_text_readln(myfileid);
        ossafe_file_text_readln(myfileid);
    }
    
    for (i = 0; i < 4; i += 1)
    {
        if (!global.is_console)
        {
            repeat 6
                ossafe_file_text_readln(myfileid);
            global.charweapon[i] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
            global.chararmor1[i] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
            global.chararmor2[i] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
            ossafe_file_text_readln(myfileid);
        }
        
        for (q = 0; q < 4; q += 1)
        {
            repeat 8
                ossafe_file_text_readln(myfileid);
        }
        
        for (j = 0; j < 12; j += 1)
            ossafe_file_text_readln(myfileid);
    }
    
    ossafe_file_text_readln(myfileid);
    ossafe_file_text_readln(myfileid);
    ossafe_file_text_readln(myfileid);
    
    if (global.is_console)
    {
        var item_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(item_list); i += 1)
            global.item[i] = ds_list_find_value(item_list, i);
        
        ds_list_destroy(item_list);
        ossafe_file_text_readln(myfileid);
        var keyitem_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(keyitem_list); i += 1)
            global.keyitem[i] = ds_list_find_value(keyitem_list, i);
        
        ds_list_destroy(keyitem_list);
        ossafe_file_text_readln(myfileid);
        var weapon_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(weapon_list); i += 1)
            global.weapon[i] = ds_list_find_value(weapon_list, i);
        
        ds_list_destroy(weapon_list);
        ossafe_file_text_readln(myfileid);
        var armor_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(armor_list); i += 1)
            global.armor[i] = ds_list_find_value(armor_list, i);
        
        ds_list_destroy(armor_list);
        ossafe_file_text_readln(myfileid);
    }
    else
    {
        for (j = 0; j < 13; j += 1)
        {
            global.item[j] = file_text_read_real(myfileid);
            file_text_readln(myfileid);
            global.keyitem[j] = file_text_read_real(myfileid);
            file_text_readln(myfileid);
            global.weapon[j] = file_text_read_real(myfileid);
            file_text_readln(myfileid);
            global.armor[j] = file_text_read_real(myfileid);
            file_text_readln(myfileid);
        }
    }
    
    ossafe_file_text_readln(myfileid);
    ossafe_file_text_readln(myfileid);
    global.lweapon = ossafe_file_text_read_real(myfileid);
    ossafe_file_text_readln(myfileid);
    global.larmor = ossafe_file_text_read_real(myfileid);
    repeat 10
        ossafe_file_text_readln(myfileid);
    
    if (global.is_console)
    {
        var litem_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < (ds_list_size(litem_list) - 1); i += 1)
            global.litem[i] = ds_list_find_value(litem_list, i);
        
        ds_list_destroy(litem_list);
        ossafe_file_text_readln(myfileid);
        var phone_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < (ds_list_size(phone_list) - 1); i += 1)
            global.phone[i] = ds_list_find_value(phone_list, i);
        
        ds_list_destroy(phone_list);
        ossafe_file_text_readln(myfileid);
        var flag_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < (ds_list_size(flag_list) - 1); i += 1)
            global.flag[i] = ds_list_find_value(flag_list, i);
        
        ds_list_destroy(flag_list);
        ossafe_file_text_readln(myfileid);
    }
    else
    {
        for (i = 0; i < 8; i += 1)
        {
            global.litem[i] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
            global.phone[i] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
        }
        
        for (i = 0; i < 9999; i += 1)
        {
            global.flag[i] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
        }
    }
    
    ossafe_file_text_close(file)

    return true;
}

function scr_bettersaves_get_flags_and_inventory_ch2(file_struct)
{
    var file = scr_bettersaves_file_name_from_struct(file_struct)

    if !ossafe_file_exists(file)
        return false;

    file = ossafe_file_text_open_read(file)
    
    scr_gamestart();
    var myfileid = file
    ossafe_file_text_readln(myfileid);
    
    if (global.is_console)
        ossafe_file_text_readln(myfileid);
    else
    {
        for (i = 0; i < 6; i += 1)
            ossafe_file_text_readln(myfileid);
    }
    
    repeat 9
        ossafe_file_text_readln(myfileid);
    
    if (global.is_console)
    {
        repeat 6
            ossafe_file_text_readln(myfileid);
        var charweapon_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(charweapon_list); i += 1)
            global.charweapon[i] = ds_list_find_value(charweapon_list, i);
        
        ds_list_destroy(charweapon_list);
        ossafe_file_text_readln(myfileid);
        var chararmor1_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(chararmor1_list); i += 1)
            global.chararmor1[i] = ds_list_find_value(chararmor1_list, i);
        
        ds_list_destroy(chararmor1_list);
        ossafe_file_text_readln(myfileid);
        var chararmor2_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(chararmor2_list); i += 1)
            global.chararmor2[i] = ds_list_find_value(chararmor2_list, i);
        
        ds_list_destroy(chararmor2_list);
        ossafe_file_text_readln(myfileid);
    }
    
    for (i = 0; i < 5; i += 1)
    {
        if (!global.is_console)
        {
            repeat 6
                ossafe_file_text_readln(myfileid);
            global.charweapon[i] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
            global.chararmor1[i] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
            global.chararmor2[i] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
            ossafe_file_text_readln(myfileid);
        }
        
        for (q = 0; q < 4; q += 1)
        {
            repeat 10
                ossafe_file_text_readln(myfileid);
        }
        
        for (j = 0; j < 12; j += 1)
            ossafe_file_text_readln(myfileid);
    }
    
    ossafe_file_text_readln(myfileid);
    ossafe_file_text_readln(myfileid);
    ossafe_file_text_readln(myfileid);
    
    if (global.is_console)
    {
        var item_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(item_list); i += 1)
            global.item[i] = ds_list_find_value(item_list, i);
        
        ds_list_destroy(item_list);
        ossafe_file_text_readln(myfileid);
        var keyitem_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(keyitem_list); i += 1)
            global.keyitem[i] = ds_list_find_value(keyitem_list, i);
        
        ds_list_destroy(keyitem_list);
        ossafe_file_text_readln(myfileid);
        var weapon_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(weapon_list); i += 1)
            global.weapon[i] = ds_list_find_value(weapon_list, i);
        
        ds_list_destroy(weapon_list);
        ossafe_file_text_readln(myfileid);
        var armor_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(armor_list); i += 1)
            global.armor[i] = ds_list_find_value(armor_list, i);
        
        ds_list_destroy(armor_list);
        ossafe_file_text_readln(myfileid);
        var pocket_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(pocket_list); i += 1)
            global.pocketitem[i] = ds_list_find_value(pocket_list, i);
        
        ds_list_destroy(pocket_list);
        ossafe_file_text_readln(myfileid);
    }
    else
    {
        for (j = 0; j < 13; j += 1)
        {
            global.item[j] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
            global.keyitem[j] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
        }
        
        for (j = 0; j < 48; j += 1)
        {
            global.weapon[j] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
            global.armor[j] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
        }
        
        for (j = 0; j < 72; j += 1)
        {
            global.pocketitem[j] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
        }
    }
    
    ossafe_file_text_readln(myfileid);
    ossafe_file_text_readln(myfileid);
    global.lweapon = ossafe_file_text_read_real(myfileid);
    ossafe_file_text_readln(myfileid);
    global.larmor = ossafe_file_text_read_real(myfileid);
    repeat 10
        ossafe_file_text_readln(myfileid);
    
    if (global.is_console)
    {
        var litem_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < (ds_list_size(litem_list) - 1); i += 1)
            global.litem[i] = ds_list_find_value(litem_list, i);
        
        ds_list_destroy(litem_list);
        ossafe_file_text_readln(myfileid);
        var phone_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < (ds_list_size(phone_list) - 1); i += 1)
            global.phone[i] = ds_list_find_value(phone_list, i);
        
        ds_list_destroy(phone_list);
        ossafe_file_text_readln(myfileid);
        var flag_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < (ds_list_size(flag_list) - 1); i += 1)
            global.flag[i] = ds_list_find_value(flag_list, i);
        
        ds_list_destroy(flag_list);
        ossafe_file_text_readln(myfileid);
    }
    else
    {
        for (i = 0; i < 8; i += 1)
        {
            global.litem[i] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
            global.phone[i] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
        }
        
        for (i = 0; i < 2500; i += 1)
        {
            global.flag[i] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
        }
    }
    ossafe_file_text_close(file)

    return true;
}

function scr_bettersaves_get_flags_and_inventory_ch3(file_struct)
{
    var file = scr_bettersaves_file_name_from_struct(file_struct)

    if !ossafe_file_exists(file)
        return false;

    file = ossafe_file_text_open_read(file)
    scr_gamestart();
    var myfileid = file
    ossafe_file_text_readln(myfileid);
    
    if (global.is_console)
        ossafe_file_text_readln(myfileid);
    else
    {
        repeat 6
            ossafe_file_text_readln(myfileid);
    }
    
    repeat 9
        ossafe_file_text_readln(myfileid);
    
    if (global.is_console)
    {
        repeat 6
            ossafe_file_text_readln(myfileid);
        var charweapon_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(charweapon_list); i += 1)
            global.charweapon[i] = ds_list_find_value(charweapon_list, i);
        
        ds_list_destroy(charweapon_list);
        ossafe_file_text_readln(myfileid);
        var chararmor1_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(chararmor1_list); i += 1)
            global.chararmor1[i] = ds_list_find_value(chararmor1_list, i);
        
        ds_list_destroy(chararmor1_list);
        ossafe_file_text_readln(myfileid);
        var chararmor2_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(chararmor2_list); i += 1)
            global.chararmor2[i] = ds_list_find_value(chararmor2_list, i);
        
        ds_list_destroy(chararmor2_list);

        ossafe_file_text_readln(myfileid);
        ossafe_file_text_readln(myfileid);
    }
    
    for (i = 0; i < 5; i += 1)
    {
        if (!global.is_console)
        {
            repeat 6
                ossafe_file_text_readln(myfileid);
            global.charweapon[i] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
            global.chararmor1[i] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
            global.chararmor2[i] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
            ossafe_file_text_readln(myfileid);
        }

        repeat 4
        {
            repeat 10
                ossafe_file_text_readln(myfileid);
        }

        repeat 12
            ossafe_file_text_readln(myfileid);
    }
    
    ossafe_file_text_readln(myfileid);
    ossafe_file_text_readln(myfileid);
    ossafe_file_text_readln(myfileid);
    
    if (global.is_console)
    {
        var item_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(item_list); i += 1)
            global.item[i] = ds_list_find_value(item_list, i);
        
        ds_list_destroy(item_list);
        ossafe_file_text_readln(myfileid);
        var keyitem_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(keyitem_list); i += 1)
            global.keyitem[i] = ds_list_find_value(keyitem_list, i);
        
        ds_list_destroy(keyitem_list);
        ossafe_file_text_readln(myfileid);
        var weapon_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(weapon_list); i += 1)
            global.weapon[i] = ds_list_find_value(weapon_list, i);
        
        ds_list_destroy(weapon_list);
        ossafe_file_text_readln(myfileid);
        var armor_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(armor_list); i += 1)
            global.armor[i] = ds_list_find_value(armor_list, i);
        
        ds_list_destroy(armor_list);
        ossafe_file_text_readln(myfileid);
        var pocket_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(pocket_list); i += 1)
            global.pocketitem[i] = ds_list_find_value(pocket_list, i);
        
        ds_list_destroy(pocket_list);
        ossafe_file_text_readln(myfileid);
    }
    else
    {
        for (j = 0; j < 13; j += 1)
        {
            global.item[j] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
            global.keyitem[j] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
        }
        
        for (j = 0; j < 48; j += 1)
        {
            global.weapon[j] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
            global.armor[j] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
        }
        
        for (j = 0; j < 72; j += 1)
        {
            global.pocketitem[j] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
        }
    }
    
    ossafe_file_text_readln(myfileid);
    ossafe_file_text_readln(myfileid);
    global.lweapon = ossafe_file_text_read_real(myfileid);
    ossafe_file_text_readln(myfileid);
    global.larmor = ossafe_file_text_read_real(myfileid);

    repeat 10
        ossafe_file_text_readln(myfileid);
    
    if (global.is_console)
    {
        var litem_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < (ds_list_size(litem_list) - 1); i += 1)
            global.litem[i] = ds_list_find_value(litem_list, i);
        
        ds_list_destroy(litem_list);
        ossafe_file_text_readln(myfileid);
        var phone_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < (ds_list_size(phone_list) - 1); i += 1)
            global.phone[i] = ds_list_find_value(phone_list, i);
        
        ds_list_destroy(phone_list);
        ossafe_file_text_readln(myfileid);
        var flag_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < (ds_list_size(flag_list) - 1); i += 1)
            global.flag[i] = ds_list_find_value(flag_list, i);
        
        ds_list_destroy(flag_list);
        ossafe_file_text_readln(myfileid);
    }
    else
    {
        for (i = 0; i < 8; i += 1)
        {
            global.litem[i] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
            global.phone[i] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
        }
        
        for (i = 0; i < 2500; i += 1)
        {
            global.flag[i] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
        }
    }

    ossafe_file_text_close(myfileid);
    return true;
}

function scr_bettersaves_get_flags_and_inventory_ch4(file_struct)
{
    scr_gamestart();
    var file = scr_bettersaves_file_name_from_struct(file_struct)

    if !ossafe_file_exists(file)
        return false;

    file = ossafe_file_text_open_read(file)
    scr_gamestart();
    var myfileid = file
    ossafe_file_text_readln(myfileid);
    
    if (global.is_console)
        ossafe_file_text_readln(myfileid);
    else
    {
        repeat 6
            ossafe_file_text_readln(myfileid);
    }
    
    repeat 9
        ossafe_file_text_readln(myfileid);
    
    if (global.is_console)
    {
        repeat 6
            ossafe_file_text_readln(myfileid);
        var charweapon_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(charweapon_list); i += 1)
            global.charweapon[i] = ds_list_find_value(charweapon_list, i);
        
        ds_list_destroy(charweapon_list);
        ossafe_file_text_readln(myfileid);
        var chararmor1_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(chararmor1_list); i += 1)
            global.chararmor1[i] = ds_list_find_value(chararmor1_list, i);
        
        ds_list_destroy(chararmor1_list);
        ossafe_file_text_readln(myfileid);
        var chararmor2_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(chararmor2_list); i += 1)
            global.chararmor2[i] = ds_list_find_value(chararmor2_list, i);
        
        ds_list_destroy(chararmor2_list);
        ossafe_file_text_readln(myfileid);
        ossafe_file_text_readln(myfileid);
    }
    
    for (i = 0; i < 5; i += 1)
    {
        if (!global.is_console)
        {
            repeat 6
                ossafe_file_text_readln(myfileid);
            global.charweapon[i] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
            global.chararmor1[i] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
            global.chararmor2[i] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
            ossafe_file_text_readln(myfileid);
        }
        
        repeat 4
        {
            repeat 10
                ossafe_file_text_readln(myfileid);
        }
        
        repeat 12
            ossafe_file_text_readln(myfileid);
    }
    
    repeat 3
        ossafe_file_text_readln(myfileid);
    
    if (global.is_console)
    {
        var item_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(item_list); i += 1)
            global.item[i] = ds_list_find_value(item_list, i);
        
        ds_list_destroy(item_list);
        ossafe_file_text_readln(myfileid);
        var keyitem_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(keyitem_list); i += 1)
            global.keyitem[i] = ds_list_find_value(keyitem_list, i);
        
        ds_list_destroy(keyitem_list);
        ossafe_file_text_readln(myfileid);
        var weapon_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(weapon_list); i += 1)
            global.weapon[i] = ds_list_find_value(weapon_list, i);
        
        ds_list_destroy(weapon_list);
        ossafe_file_text_readln(myfileid);
        var armor_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(armor_list); i += 1)
            global.armor[i] = ds_list_find_value(armor_list, i);
        
        ds_list_destroy(armor_list);
        ossafe_file_text_readln(myfileid);
        var pocket_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(pocket_list); i += 1)
            global.pocketitem[i] = ds_list_find_value(pocket_list, i);
        
        ds_list_destroy(pocket_list);
        ossafe_file_text_readln(myfileid);
    }
    else
    {
        for (j = 0; j < 13; j += 1)
        {
            global.item[j] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
            global.keyitem[j] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
        }
        
        for (j = 0; j < 48; j += 1)
        {
            global.weapon[j] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
            global.armor[j] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
        }
        
        for (j = 0; j < 72; j += 1)
        {
            global.pocketitem[j] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
        }
    }
    
    ossafe_file_text_readln(myfileid);
    ossafe_file_text_readln(myfileid);
    global.lweapon = ossafe_file_text_read_real(myfileid);
    ossafe_file_text_readln(myfileid);
    global.larmor = ossafe_file_text_read_real(myfileid);

    repeat 10
        ossafe_file_text_readln(myfileid);
    
    if (global.is_console)
    {
        var litem_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < (ds_list_size(litem_list) - 1); i += 1)
            global.litem[i] = ds_list_find_value(litem_list, i);
        
        ds_list_destroy(litem_list);
        ossafe_file_text_readln(myfileid);
        var phone_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < (ds_list_size(phone_list) - 1); i += 1)
            global.phone[i] = ds_list_find_value(phone_list, i);
        
        ds_list_destroy(phone_list);
        ossafe_file_text_readln(myfileid);
        var flag_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < (ds_list_size(flag_list) - 1); i += 1)
            global.flag[i] = ds_list_find_value(flag_list, i);
        
        ds_list_destroy(flag_list);
        ossafe_file_text_readln(myfileid);
    }
    else
    {
        for (i = 0; i < 8; i += 1)
        {
            global.litem[i] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
            global.phone[i] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
        }
        
        for (i = 0; i < 2500; i += 1)
        {
            global.flag[i] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
        }
    }

    return true;
}
