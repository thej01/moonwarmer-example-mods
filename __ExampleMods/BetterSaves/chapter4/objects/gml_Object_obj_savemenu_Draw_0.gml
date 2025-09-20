draw_set_alpha(1);
draw_set_color(c_white);
var xx = camerax();
var yy = cameray();
var scale = 1 + global.darkzone;

var numscale = function(arg0)
{
    var scale = 1 + global.darkzone;
    return round(arg0 / 2) * scale;
};

var menbox = function(arg0, arg1, arg2, arg3)
{
    var lightbox = function(arg0, arg1, arg2, arg3)
    {
        draw_sprite_ext(spr_pxwhite, 0, arg0 - 3, arg1 - 3, (arg2 + 6) - arg0, (arg3 + 6) - arg1, 0, c_white, 1);
        draw_sprite_ext(spr_pxwhite, 0, arg0, arg1, arg2 - arg0, arg3 - arg1, 0, c_black, 1);
    };
    
    if (global.darkzone == 1)
        scr_darkbox_black(arg0, arg1, arg2, arg3);
    else
        lightbox(arg0, arg1, arg2, arg3);
};

if (saved == 0)
    time_current = global.time;

scr_84_set_draw_font("main");

if (d == 2)
    scr_84_set_draw_font("mainbig");

if (menuno == 0)
{
    if (d == 1)
    {
        menbox(xx + 53, yy + 52, xx + 267, yy + 155);
    }
    else
    {
        scr_darkbox(((54 * d) + xx) - 16, (49 * d) + yy, (265 * d) + xx + 16, (135 * d) + yy + (type * 45));
        draw_set_color(c_black);
        ossafe_fill_rectangle(((64 * d) + xx) - 16, (59 * d) + yy, (255 * d) + xx + 16, (125 * d) + yy + (type * 45), false);
    }
    
    draw_set_color(c_white);
    
    if (xcoord == 2)
        draw_set_color(c_yellow);
    
    draw_set_font(scr_84_get_font("main"));
    
    if (global.darkzone == 1)
        draw_set_font(scr_84_get_font("mainbig"));
    
    draw_set_halign(fa_left);
    
    if (!scr_kana_check(name_current))
    {
        draw_text((60 * d) + xx, (60 * d) + yy, string_hash_to_newline(name_current));
    }
    else
    {
        var memfont = draw_get_font();
        draw_set_font(fnt_ja_mainbig);
        
        if (global.darkzone == 0)
            draw_set_font(fnt_ja_main);
        
        draw_text((60 * d) + xx, (60 * d) + yy, string_hash_to_newline(name_current));
        draw_set_font(memfont);
    }
    
    draw_set_halign(fa_right);
    draw_text((200 * d) + xx, (60 * d) + yy, string_hash_to_newline(stringsetsubloc("LV ~1", global.chapter, "obj_savemenu_slash_Draw_0_gml_34_0")));
    draw_text((261 * d) + xx, (60 * d) + yy, scr_timedisp(time_current));
    draw_set_halign(fa_center);
    draw_text_width((160 * d) + xx, (85 * d) + yy, string_hash_to_newline(scr_roomname(room)), 360);
    draw_set_halign(fa_left);
    var myoff = 0;
    
    if (global.darkzone == 0 && ycoord == 1)
        myoff = -21;
    
    if (xcoord < 2)
        draw_sprite(heartsprite, 0, xx + (71 * d) + (xcoord * 90 * d), yy + (114 * d) + (ycoord * 42) + myoff);
    
    if (xcoord < 2)
    {
        draw_text(xx + (85 * d), yy + (110 * d), string_hash_to_newline(stringsetloc("Save", "obj_savemenu_slash_Draw_0_gml_47_0")));
        draw_text(xx + (175 * d), yy + (110 * d), string_hash_to_newline(stringsetloc("Return", "obj_savemenu_slash_Draw_0_gml_48_0")));
        
        if (type == 1)
        {
            if (global.darkzone == 1)
            {
                draw_text(xx + (85 * d), yy + (130 * d), stringsetloc("Storage", "obj_savemenu_slash_Draw_0_gml_52_0_b"));
                
                if (!haverecruited)
                    draw_set_color(c_gray);
                
                draw_text(xx + (175 * d), yy + (130 * d), stringsetloc("Recruits", "obj_savemenu_slash_Draw_0_gml_54_0"));
            }
            
            if (global.darkzone == 0)
            {
                var xoff = 0;
                
                if (global.lang == "ja")
                    xoff = 0;
                
                var title = stringsetloc("Return to Title", "obj_darkcontroller_slash_Draw_0_gml_95_0");
                draw_text(xx + 85 + xoff, yy + 130, title);
            }
        }
    }
    else
    {
        draw_text(xx + (85 * d), yy + (110 * d), string_hash_to_newline(stringsetloc("File saved.", "obj_savemenu_slash_Draw_0_gml_52_0")));
    }
}
else if menuno == 1 || menuno == 2
{

    if (overwrite == 0 || menuno == 2)
    {
        draw_set_color(c_black);
        draw_set_alpha(0.8);
        ossafe_fill_rectangle(xx - 10, yy - 10, xx + 640 + 10, yy + 480 + 10, 0);
        draw_set_alpha(1);
    }

    scr_84_set_draw_font("main")
    if d == 2
        scr_84_set_draw_font("mainbig")
    
    var yoff = numscale(0);
    var wmod = numscale(28);
    var mwidth = numscale(520);
    var mheight = numscale(105);
    var mx = numscale(60);
    var my = numscale(12) + yoff;
    menbox(xx + mx, yy + my, xx + mx + mwidth, yy + my + mheight);
    mwidth = numscale(520);
    var scroll_pos = mpos
    var scroll_y = 0
    if (scroll_pos > save_count - 2)
        scroll_pos = save_count - 2
    if (scroll_pos > 1 && save_count > 3)
        scroll_y = scroll_pos - 1;
    var ext_box = numscale(38)
    var upy = numscale(-24)
    mheight = numscale(316) + ext_box;
    if global.darkzone == 0
        mheight -= 6
    mx = numscale(60);
    my = numscale(144) + upy + yoff;
    menbox(xx + mx, yy + my, xx + mx + mwidth, yy + my + mheight);
    
    if (global.darkzone == 1)
    {
        draw_sprite_ext(spr_textbox_top, 0, xx + mx + numscale(14), yy + my + ext_box, mwidth * 0.948, 2, 0, c_white, 1);
        for (var i = 0; i < 3; i++)
            draw_sprite_ext(spr_textbox_top, 0, xx + mx + 14, yy + 208 + ext_box + (84 * i) + yoff, mwidth * 0.948, 2, 0, c_white, 1);
    }
    else
    {
        draw_sprite_ext(spr_pxwhite, 0, xx + mx, yy + my + ext_box, mwidth, 3, 0, c_white, 1);
        for (var i = 0; i < 3; i++)
            draw_sprite_ext(spr_pxwhite, 0, xx + mx, yy + 104 + (42 * i) + ext_box + yoff + 4, mwidth, 3, 0, c_white, 1);
    }
    
    if menuno == 2
        draw_set_color(c_yellow);
    else
        draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_text(xx + numscale(320), yy + numscale(32) + yoff, global.truename);
    draw_set_halign(fa_left);
    draw_text(xx + mx + numscale(40), yy + numscale(32) + yoff, string_hash_to_newline(stringsetsubloc("LV ~1", global.chapter, "obj_savemenu_slash_Draw_0_gml_34_0")));
    draw_set_halign(fa_right);
    draw_text(xx + mx + numscale(483), yy + numscale(32) + yoff, scr_timedisp(time_current));
    draw_set_halign(fa_center);
    draw_text(xx + numscale(320), yy + numscale(64) + yoff, room_current);
    draw_set_halign(fa_left);
    draw_set_color(c_white);
    newfile = stringsetloc("New File", "obj_savemenu_slash_Draw_0_gml_115_0");
    var mspace = numscale(84);

    my += ext_box
    var preview_top_y = yy + my - (ext_box / 2) - numscale(5)
    my -= mspace * scroll_y

    var add_file_txt = "+ " + newfile + "..."
    var next_file_x = (xx + numscale(320)) - string_width(add_file_txt)

    var bo = numscale(4)
    if global.darkzone == 0
    {
        bo -= 6
        preview_top_y -= 6
    }
    for (var i = 0; i < (save_count + 1); i++)
    {
        var screen_i = i - scroll_y
        if screen_i < -1 || screen_i > 3
            continue;

        var preview_type = 0 
        if screen_i == -1
            preview_type = -1
        if screen_i == 3
            preview_type = 1

        if menuno == 2
            draw_set_color(#444444)
        else
            draw_set_color(c_white);
        
        if (mpos == i)
            draw_set_color(c_yellow);

        var preview_bottom_y = yy + my + numscale(16) + (i * mspace)

        if i == save_count
        {
            draw_set_halign(fa_center);
            if menuno == 2 && mpos == i
            {
                draw_set_color(c_yellow)
                draw_text(xx + numscale(320), preview_bottom_y, stringsetloc("File Saved", "obj_savemenu_slash_Draw_0_gml_371_0"));
            }
            else
                draw_text(xx + numscale(320), preview_bottom_y, add_file_txt);
            draw_set_halign(fa_left);
            draw_set_color(c_white);
            continue;
        }

        var base_y = yy + my + numscale(20) + (i * mspace)
        var base_x = xx + mx + numscale(40) + numscale(24)
        if preview_type != 0
        {
            if menuno == 2
                draw_set_color(merge_color(c_gray, c_black, 0.74))
            else
                draw_set_color(c_gray)
        }
        if preview_type == -1
            base_y = preview_top_y 
        if preview_type == 1
            base_y = preview_bottom_y
        if menuno != 2 || (menuno == 2 && mpos != i)
        {
            if (level_file[i] != 0)
            {
                draw_set_halign(fa_left);
                draw_text(base_x, base_y, string_hash_to_newline(stringsetsubloc("LV ~1", global.chapter, "obj_savemenu_slash_Draw_0_gml_34_0")));
                draw_set_halign(fa_right);
                draw_text(xx + mx + numscale(483), base_y, scr_timedisp(time_file[i]));
                draw_set_halign(fa_center);
                if preview_type == 0
                    draw_text(xx + numscale(320), base_y + numscale(32), scr_roomname(roome_file[i]));
                if (!scr_kana_check(name_file[i]))
                    draw_text(xx + numscale(320), base_y, name_file[i]);
                else
                {
                    var memfont = draw_get_font()
                    draw_set_font(fnt_ja_mainbig);
                    if global.darkzone == 0
                        draw_set_font(fnt_ja_main);
                    draw_text(xx + numscale(320), base_y - numscale(20), name_file[i]);
                    draw_set_font(memfont)
                }
                
                draw_set_halign(fa_left);
                draw_set_color(c_white);
            }
            else
            {
                if preview_type != 0
                    base_y -= numscale(16)
                draw_set_halign(fa_center);
                draw_text(xx + numscale(320), base_y + numscale(16), newfile);
                draw_set_halign(fa_left);
                draw_set_color(c_white);
            }
        }
        else
        {
            draw_set_color(c_yellow)
            draw_set_halign(fa_center);
            draw_text(xx + numscale(320), base_y + numscale(16), stringsetloc("File Saved", "obj_savemenu_slash_Draw_0_gml_371_0"));
            draw_set_halign(fa_left);
            draw_set_color(c_white);
        }
    }
    
    if scroll_y <= 0
    {
        draw_set_halign(fa_center);
        
        if (mpos == -1)
            draw_set_color(c_yellow);

        if menuno == 2
            draw_set_color(#444444)
        
        returntxt = stringsetloc("Return", "obj_savemenu_slash_Draw_0_gml_48_0");
        draw_text(xx + numscale(320), preview_top_y, string_hash_to_newline(returntxt));
        draw_set_halign(fa_left);
        draw_set_color(c_white);
    }
    
    if (overwrite == 0 && menuno != 2)
    {
        if (mpos != -1)
        {
            if mpos == save_count
            {
                var hyoff = numscale(60)
                if (global.darkzone == 1)
                    hyoff += 1
                draw_sprite(heartsprite, 0, (xx + numscale(320)) - (string_width(add_file_txt) / 2) - numscale(32), (yy + my + (mspace * mpos) + hyoff) - numscale(40) + numscale(3));
            }
            else
            {
                if (level_file[mpos] != 0)
                    draw_sprite(heartsprite, 0, xx + mx + numscale(32), (yy + my + (mspace * mpos) + numscale(62)) - numscale(34));
                else
                    draw_sprite(heartsprite, 0, (xx + numscale(320)) - (string_width(newfile) / 2) - numscale(32), yy + my + numscale(36) + (mpos * mspace) + (string_height(newfile) / 4));
            }
        }
        else
        {
            draw_sprite(heartsprite, 0, (xx + numscale(320)) - string_width(returntxt), yy + (my + bo) - (ext_box / 2));
        }
    }
    
    if (overwrite == 1)
    {
        draw_sprite_ext(spr_pxwhite, 0, xx - 10, yy - 10, 650, 490, 0, c_black, 0.8);
        saved = 2;
        menbox(xx + numscale(10), yy + numscale(100), xx + numscale(630), yy + numscale(380));
        overwritetext = stringsetsubloc("Overwrite Slot ~1?", mpos + 1, "obj_savemenu_slash_Draw_0_gml_215_0");
        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_text(xx + numscale(320), yy + numscale(123), string_hash_to_newline(overwritetext));
        draw_set_color(c_yellow);
        var currentSpace = numscale(70);
        var horzspace = numscale(80);
        draw_set_halign(fa_left);
        draw_text(xx + horzspace, yy + numscale(165) + currentSpace, string_hash_to_newline(stringsetsubloc("LV ~1", global.chapter, "obj_savemenu_slash_Draw_0_gml_34_0")));
        draw_set_halign(fa_right);
        draw_text((xx + numscale(640)) - horzspace, yy + numscale(165) + currentSpace, scr_timedisp(time_current));
        draw_set_halign(fa_center);
        draw_text(xx + numscale(320), yy + numscale(195) + currentSpace, room_current);
        var memfont = draw_get_font();
        
        if (scr_kana_check(name_current))
        {
            draw_set_font(fnt_ja_mainbig);
            
            if (global.darkzone == 0)
                draw_set_font(fnt_ja_main);
        }
        
        draw_text(xx + numscale(320), yy + numscale(165) + currentSpace, name_current);
        draw_set_font(memfont);
        draw_set_halign(fa_left);
        draw_set_color(c_white);
        draw_set_color(c_white);
        draw_set_halign(fa_left);
        draw_text(xx + horzspace, yy + numscale(165), string_hash_to_newline(stringsetsubloc("LV ~1", global.chapter, "obj_savemenu_slash_Draw_0_gml_34_0")));
        draw_set_halign(fa_right);
        draw_text((xx + numscale(640)) - horzspace, yy + numscale(165), scr_timedisp(time_file[mpos]));
        draw_set_halign(fa_center);
        draw_text(xx + numscale(320), yy + numscale(195), scr_roomname(roome_file[mpos]));
        memfont = draw_get_font();
        
        if (scr_kana_check(name_file[mpos]))
        {
            draw_set_font(fnt_ja_mainbig);
            
            if (global.darkzone == 0)
                draw_set_font(fnt_ja_main);
        }
        
        draw_text(xx + numscale(320), yy + numscale(165), name_file[mpos]);
        draw_set_font(memfont);
        draw_set_halign(fa_left);
        draw_set_color(c_white);
        savetxt = stringsetloc("Save", "obj_savemenu_slash_Draw_0_gml_47_0");
        returntxt = stringsetloc("Return", "obj_savemenu_slash_Draw_0_gml_48_0");
        
        if (left_p() || right_p())
            overcoord = 1 - overcoord;
        
        if (overcoord == 0)
            draw_set_color(c_yellow);
        else
            draw_set_color(c_white);
        
        draw_text(xx + numscale(170), yy + numscale(324), string_hash_to_newline(savetxt));
        
        if (overcoord == 1)
            draw_set_color(c_yellow);
        else
            draw_set_color(c_white);
        
        draw_text(xx + numscale(350), yy + numscale(324), string_hash_to_newline(returntxt));
        
        if (overcoord == 0)
            draw_sprite(heartsprite, 0, xx + numscale(142), yy + numscale(324) + (string_height(savetxt) / 4));
        else
            draw_sprite(heartsprite, 0, xx + numscale(322), yy + numscale(324) + (string_height(returntxt) / 4));
    }
}
/*else if (menuno == 1)
{
    scr_84_set_draw_font("main");
    
    if (d == 2)
        scr_84_set_draw_font("mainbig");
    
    if (overwrite == 0)
    {
        draw_set_color(c_black);
        draw_set_alpha(0.8);
        ossafe_fill_rectangle(xx - 10, yy - 10, xx + 640 + 10, yy + 480 + 10, 0);
        draw_set_alpha(1);
    }
    
    var yoff = 0;
    var wmod = numscale(28);
    var mwidth = numscale(520);
    var mheight = numscale(105);
    var mx = xx + numscale(60);
    var my = yy + 12 + numscale(yoff);
    menbox(mx, my, mx + mwidth, my + mheight);
    mwidth = numscale(520);
    mheight = numscale(321);
    mx = numscale(60);
    my = numscale(124) + yoff;
    menbox(xx + mx, yy + my, xx + mx + mwidth, yy + my + mheight);
    
    if (global.darkzone == 1)
    {
        for (var i = 0; i < 3; i++)
            draw_sprite_ext(spr_textbox_top, 0, xx + mx + 14, yy + 208 + (84 * i) + yoff, mwidth * 0.948, 2, 0, c_white, 1);
    }
    else
    {
        for (var i = 0; i < 3; i++)
            draw_sprite_ext(spr_pxwhite, 0, xx + mx, yy + 104 + (42 * i) + yoff + 4, mwidth, 3, 0, c_white, 1);
    }
    
    var ybo = numscale(32);
    var yline = yy + ybo + yoff;
    var xline = [xx + numscale(320), xx + mx + numscale(40), xx + mx + numscale(483), xx + numscale(320)];
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_text(xline[0], yline, global.truename);
    draw_set_halign(fa_left);
    draw_text(xline[1], yline, string_hash_to_newline(stringsetsubloc("LV ~1", global.chapter, "obj_savemenu_slash_Draw_0_gml_34_0")));
    draw_set_halign(fa_right);
    draw_text(xline[2], yline, scr_timedisp(time_current));
    draw_set_halign(fa_center);
    draw_text(xline[3], yline + ybo, room_current);
    draw_set_halign(fa_left);
    newfile = stringsetloc("New File", "obj_savemenu_slash_Draw_0_gml_115_0");
    var mspace = numscale(84);
    
    for (var i = 0; i < 3; i++)
    {
        draw_set_color(c_white);
        
        if (mpos == i)
            draw_set_color(c_yellow);
        
        if (level_file[i] != 0)
        {
            var xl = [xx + mx + numscale(64), xx + mx + numscale(483), xx + numscale(320)];
            draw_set_halign(fa_left);
            draw_text(xl[0], yy + my + numscale(20) + (i * mspace), string_hash_to_newline(stringsetsubloc("LV ~1", global.chapter, "obj_savemenu_slash_Draw_0_gml_34_0")));
            draw_set_halign(fa_right);
            draw_text(xl[1], yy + my + numscale(20) + (i * mspace), scr_timedisp(time_file[i]));
            draw_set_halign(fa_center);
            draw_text(xl[2], yy + my + numscale(52) + (i * mspace), scr_roomname(roome_file[i]));
            
            if (!scr_kana_check(name_file[i]))
            {
                var xpo = xx + numscale(320);
                var thisyoff = numscale(20);
                draw_text(xpo, yy + my + thisyoff + (i * mspace), name_file[i]);
            }
            else
            {
                var memfont = draw_get_font();
                draw_set_font(fnt_ja_mainbig);
                
                if (global.darkzone == 0)
                    draw_set_font(fnt_ja_main);
                
                draw_text(xx + (160 * scale), yy + my + (10 * scale) + (i * mspace), name_file[i]);
                draw_set_font(memfont);
            }
            
            draw_set_halign(fa_left);
            draw_set_color(c_white);
        }
        else
        {
            draw_set_halign(fa_center);
            draw_text(xx + (160 * scale), yy + my + (18 * scale) + (i * mspace), newfile);
            draw_set_halign(fa_left);
            draw_set_color(c_white);
        }
    }
    
    draw_set_halign(fa_center);
    
    if (mpos == 3)
        draw_set_color(c_yellow);
    
    returntxt = stringsetloc("Return", "obj_savemenu_slash_Draw_0_gml_48_0");
    var bo = 0;
    
    if (global.darkzone == 0)
        bo = 3;
    
    draw_text(xx + (160 * scale), yy + my + (135 * scale) + bo, string_hash_to_newline(returntxt));
    draw_set_halign(fa_left);
    draw_set_color(c_white);
    
    if (overwrite == 0)
    {
        if (mpos < 3)
        {
            if (level_file[mpos] != 0)
                draw_sprite(heartsprite, 0, xx + mx + (16 * scale), yy + my + (mspace * mpos) + (14 * scale));
            else
                draw_sprite(heartsprite, 0, (xx + (160 * scale)) - (string_width(newfile) / 2) - (16 * scale), yy + my + (18 * scale) + (mpos * mspace) + (string_height(newfile) / 4));
        }
        else
        {
            bo = 0;
            
            if (global.darkzone == 0)
                bo = 3;
            
            draw_sprite(heartsprite, 0, (xx + (160 * scale)) - string_width(returntxt), yy + my + (135 * scale) + (string_height(returntxt) / 4) + bo);
        }
    }
    
    if (overwrite == 0)
    {
        if (down_p())
            mpos++;
        
        if (up_p())
            mpos--;
        
        mpos = clamp(mpos, 0, 3);
        
        if (button1_p() && buffer < 0)
        {
            if (mpos == 3)
            {
                menuno = 0;
                buffer = 3;
                mpos = global.filechoice;
                snd_play(snd_select);
            }
            else if (level_file[mpos] != 0 && mpos != global.filechoice)
            {
                overwrite = 0.5;
                buffer = 3;
                overcoord = 0;
            }
            else
            {
                menuno = 2;
                global.filechoice = mpos;
                snd_play(snd_save);
                scr_save();
                saved = 1;
                xcoord = 2;
                buffer = 3;
                
                if (d == 2)
                {
                    name = global.truename;
                    love = global.llv;
                }
                
                scr_roomname(room);
                level = global.lv;
                time = global.time;
                minutes = floor(time / 1800);
                seconds = round(((time / 1800) - minutes) * 60);
                
                if (seconds == 60)
                    seconds = 59;
                
                if (seconds < 10)
                    seconds = "0" + string(seconds);
            }
        }
        
        if (button2_p() && buffer < 0)
        {
            menuno = 0;
            buffer = 3;
            mpos = global.filechoice;
            snd_play(snd_select);
        }
    }
    
    if (overwrite == 1)
    {
        draw_sprite_ext(spr_pxwhite, 0, xx - 10, yy - 10, 650, 490, 0, c_black, 0.8);
        saved = 2;
        menbox(xx + numscale(10), yy + numscale(100), xx + numscale(630), yy + numscale(380));
        overwritetext = stringsetsubloc("Overwrite Slot ~1?", mpos + 1, "obj_savemenu_slash_Draw_0_gml_215_0");
        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_text(xx + numscale(320), yy + numscale(123), string_hash_to_newline(overwritetext));
        draw_set_color(c_yellow);
        var currentSpace = numscale(70);
        var horzspace = numscale(80);
        draw_set_halign(fa_left);
        draw_text(xx + horzspace, yy + numscale(165) + currentSpace, string_hash_to_newline(stringsetsubloc("LV ~1", global.chapter, "obj_savemenu_slash_Draw_0_gml_34_0")));
        draw_set_halign(fa_right);
        draw_text((xx + numscale(640)) - horzspace, yy + numscale(165) + currentSpace, scr_timedisp(time_current));
        draw_set_halign(fa_center);
        draw_text(xx + numscale(320), yy + numscale(195) + currentSpace, room_current);
        var memfont = draw_get_font();
        
        if (scr_kana_check(name_current))
        {
            draw_set_font(fnt_ja_mainbig);
            
            if (global.darkzone == 0)
                draw_set_font(fnt_ja_main);
        }
        
        draw_text(xx + numscale(320), yy + numscale(165) + currentSpace, name_current);
        draw_set_font(memfont);
        draw_set_halign(fa_left);
        draw_set_color(c_white);
        draw_set_color(c_white);
        draw_set_halign(fa_left);
        draw_text(xx + horzspace, yy + numscale(165), string_hash_to_newline(stringsetsubloc("LV ~1", global.chapter, "obj_savemenu_slash_Draw_0_gml_34_0")));
        draw_set_halign(fa_right);
        draw_text((xx + numscale(640)) - horzspace, yy + numscale(165), scr_timedisp(time_file[mpos]));
        draw_set_halign(fa_center);
        draw_text(xx + numscale(320), yy + numscale(195), scr_roomname(roome_file[mpos]));
        memfont = draw_get_font();
        
        if (scr_kana_check(name_file[mpos]))
        {
            draw_set_font(fnt_ja_mainbig);
            
            if (global.darkzone == 0)
                draw_set_font(fnt_ja_main);
        }
        
        draw_text(xx + numscale(320), yy + numscale(165), name_file[mpos]);
        draw_set_font(memfont);
        draw_set_halign(fa_left);
        draw_set_color(c_white);
        savetxt = stringsetloc("Save", "obj_savemenu_slash_Draw_0_gml_47_0");
        returntxt = stringsetloc("Return", "obj_savemenu_slash_Draw_0_gml_48_0");
        
        if (left_p() || right_p())
            overcoord = 1 - overcoord;
        
        if (overcoord == 0)
            draw_set_color(c_yellow);
        else
            draw_set_color(c_white);
        
        draw_text(xx + numscale(170), yy + numscale(324), string_hash_to_newline(savetxt));
        
        if (overcoord == 1)
            draw_set_color(c_yellow);
        else
            draw_set_color(c_white);
        
        draw_text(xx + numscale(350), yy + numscale(324), string_hash_to_newline(returntxt));
        
        if (overcoord == 0)
            draw_sprite(heartsprite, 0, xx + numscale(142), yy + numscale(324) + (string_height(savetxt) / 4));
        else
            draw_sprite(heartsprite, 0, xx + numscale(322), yy + numscale(324) + (string_height(returntxt) / 4));
        
        if (button1_p() && buffer < 0)
        {
            if (overcoord == 0)
            {
                menuno = 2;
                global.filechoice = mpos;
                snd_play(snd_save);
                script_execute(scr_save);
                saved = 1;
                xcoord = 2;
                buffer = 3;
                
                if (d == 2)
                {
                    name = global.truename;
                    love = global.llv;
                }
                
                scr_roomname(room);
                level = global.lv;
                time = global.time;
                minutes = floor(time / 1800);
                seconds = round(((time / 1800) - minutes) * 60);
                
                if (seconds == 60)
                    seconds = 59;
                
                if (seconds < 10)
                    seconds = "0" + string(seconds);
            }
            else
            {
                overwrite = 0;
                buffer = 3;
                saved = 0;
            }
        }
        
        if (button2_p() && buffer < 0)
        {
            overwrite = 0;
            buffer = 3;
            saved = 0;
        }
    }
    
    if (overwrite == 0.5)
        overwrite = 1;
}
/*else if (menuno == 2)
{
    draw_sprite_ext(spr_pxwhite, 0, xx - 10, yy - 10, 650, 490, 0, c_black, 0.8);
    var yoff = 0;
    var ybo = 0;
    var ybo2 = 0;
    
    if (global.darkzone == 0)
    {
        ybo = 6;
        ybo2 = 1;
    }
    
    var wmod = numscale(28);
    var mwidth = numscale(520);
    var mheight = numscale(105);
    var mx = numscale(60);
    var my = numscale(12) + yoff;
    menbox(xx + mx, yy + my + ybo, xx + mx + mwidth, yy + my + mheight + ybo2);
    mwidth = numscale(520);
    mheight = numscale(273);
    mx = numscale(60);
    my = numscale(124) + yoff;
    menbox(xx + mx, yy + my, xx + mx + mwidth, (yy + my + mheight) - ybo);
    
    if (global.darkzone == 1)
    {
        for (var i = 0; i < 2; i++)
            draw_sprite_ext(spr_textbox_top, 0, xx + mx + 14, yy + 208 + (84 * i) + yoff, mwidth * 0.948, 2, 0, c_white, 1);
    }
    else
    {
        for (var i = 0; i < 2; i++)
            draw_sprite_ext(spr_pxwhite, 0, xx + mx, yy + numscale(208) + (numscale(84) * i) + yoff + 4, mwidth, 3, 0, c_white, 1);
    }
    
    draw_set_color(c_yellow);
    draw_set_halign(fa_center);
    draw_text(xx + numscale(320), yy + numscale(32) + yoff, global.truename);
    draw_set_halign(fa_left);
    draw_text(xx + mx + numscale(40), yy + numscale(32) + yoff, string_hash_to_newline(stringsetsubloc("LV ~1", global.chapter, "obj_savemenu_slash_Draw_0_gml_34_0")));
    draw_set_halign(fa_right);
    draw_text(xx + mx + numscale(483), yy + numscale(32) + yoff, scr_timedisp(time_current));
    draw_set_halign(fa_center);
    draw_text(xx + numscale(320), yy + numscale(64) + yoff, room_current);
    draw_set_halign(fa_left);
    draw_set_color(c_white);
    newfile = stringsetloc("New File", "obj_savemenu_slash_Draw_0_gml_115_0");
    var mspace = numscale(84);
    
    for (var i = 0; i < 3; i++)
    {
        draw_set_color(c_white);
        
        if (mpos == i)
            draw_set_color(c_yellow);
        
        if (mpos != i)
        {
            draw_set_color(#444444);
            
            if (level_file[i] != 0)
            {
                draw_set_halign(fa_left);
                draw_text(xx + mx + numscale(64), yy + my + numscale(20) + (i * mspace), string_hash_to_newline(stringsetsubloc("LV ~1", global.chapter, "obj_savemenu_slash_Draw_0_gml_34_0")));
                draw_set_halign(fa_right);
                draw_text(xx + mx + numscale(483), yy + my + numscale(20) + (i * mspace), scr_timedisp(time_file[i]));
                draw_set_halign(fa_center);
                draw_text(xx + numscale(320), yy + my + numscale(52) + (i * mspace), scr_roomname(roome_file[i]));
                var memfont = draw_get_font();
                
                if (scr_kana_check(name_file[i]))
                {
                    draw_set_font(fnt_ja_mainbig);
                    
                    if (global.darkzone == 0)
                        draw_set_font(fnt_ja_main);
                }
                
                draw_text(xx + numscale(320), yy + my + numscale(20) + (i * mspace), name_file[i]);
                draw_set_font(memfont);
                draw_set_halign(fa_left);
                draw_set_color(c_white);
            }
            else
            {
                draw_set_halign(fa_center);
                draw_text(xx + numscale(320), yy + my + numscale(36) + (i * mspace), newfile);
                draw_set_halign(fa_left);
                draw_set_color(c_white);
            }
        }
        else
        {
            filesaved = stringsetloc("File Saved", "obj_savemenu_slash_Draw_0_gml_371_0");
            draw_set_halign(fa_center);
            draw_text(xx + numscale(320), yy + my + numscale(36) + (i * mspace), filesaved);
            draw_set_halign(fa_left);
            draw_set_color(c_white);
        }
    }
    
    draw_set_halign(fa_center);
    draw_set_halign(fa_left);
    draw_set_color(c_white);
    
    if (button1_p() || button2_p())
    {
        if (buffer < 0)
        {
            global.interact = 0;
            
            with (obj_mainchara)
                onebuffer = 3;
            
            instance_destroy();
        }
    }
}*/
else if (menuno == 10 || menuno == 11)
{
    menbox(xx + 53, yy + 52, xx + 267, yy + 155);
    yes = stringsetloc("Yes", "obj_savemenu_slash_Draw_0_gml_518_0");
    no = stringsetloc("No", "obj_savemenu_slash_Draw_0_gml_519_0");
    var prompt = stringsetloc("Really return to title?", "obj_savemenu_slash_Draw_0_gml_520_0");
    draw_text(xx + 85, yy + 64, prompt);
    draw_text(xx + 85, yy + 130, yes);
    draw_text(xx + 175, yy + 130, no);
    
    if (menuno == 10)
        draw_sprite_ext(heartsprite, 0, xx + 71 + (90 * quitxcoord), yy + 135, 1, 1, 0, c_white, 1);
}