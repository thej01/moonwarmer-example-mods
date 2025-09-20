function scr_chapter_save_file_exists(chapter)
{
    return scr_bettersaves_any_saves_simple(chapter, 0);
}

function scr_chapter_save_file_exists_in_slot(chapter, slot)
{
    return ossafe_file_exists(scr_bettersaves_file_name(slot, false, chapter));
}

function scr_completed_chapter_any_slot(chapter)
{
    return scr_bettersaves_any_saves_simple(chapter, 1);
}

function scr_completed_chapter_in_slot(chapter, slot)
{
    return ossafe_file_exists(scr_bettersaves_file_name(slot + 3, true, chapter));
}

function scr_get_ini_value(chapter, slot, key, completion = false)
{
    var _ini_file = ossafe_ini_open("dr.ini");
    var _ini_value = ini_read_real(scr_bettersaves_ini_name(slot, chapter, completion), key, 0);
    ossafe_ini_close();
    return _ini_value;
}

// gonna be honest, do not know how to rework this one
// I don't really care though idk when this is even used
function scr_get_ini_value_all_slots(chapter, key)
{
    var _ini_file = ossafe_ini_open("dr.ini");
    var _list = [];
    
    for (var i = 0; i < 6; i++)
    {
        var _slot = i;
        var _value = ini_read_real(scr_ini_chapter(chapter, _slot), key, 0);
        _list[i][0] = _slot;
        _list[i][1] = _value;
    }
    
    ossafe_ini_close();
    return _list;
}

function scr_get_ura_value(chapter, file_struct)
{
    var _ini_file = ossafe_ini_open("dr.ini");
    var _ini_value = ini_read_real("URA", scr_bettersaves_ura(file_struct, chapter), 0);
    ossafe_ini_close();
    return _ini_value;
}

function scr_set_ura_value(chapter, file_struct, result)
{
    var _ini_file = ossafe_ini_open("dr.ini");
    var _ini_value = ini_write_real("URA", scr_bettersaves_ura(file_struct, chapter), result);
    ossafe_ini_close();
    return _ini_value;
}

function scr_store_ura_result(chapter, file_struct, arg2)
{
    if (arg2 == 0)
        exit;
    
    var current_result = scr_get_ura_value(chapter, file_struct);
    var new_result = arg2;
    
    if ((arg2 + current_result) == 3)
        new_result = 3;
    
    scr_set_ura_value(chapter, file_struct, new_result);
}
