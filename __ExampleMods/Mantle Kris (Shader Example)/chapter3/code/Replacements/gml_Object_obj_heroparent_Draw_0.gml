var scale = 2;

if (global.chapter == 3 && i_ex(obj_susiezilla_gamecontroller))
    exit;

if (global.chapter == 3 && normalsprite == spr_gameshow_drowningRalsei_ralsei_origin_edit)
    scale = 1;

if (hurt == 1 && state != 8 && global.hp[global.char[myself]] > 0)
{
    if (global.faceaction[myself] != 4)
    {
        specdraw = 1;
        scr_example_if_kris_sprite_use_shader(hurtsprite)
        draw_sprite_ext(hurtsprite, hurtindex, (x - 20) + (hurtindex * 10), y, scale, scale, 0, image_blend, image_alpha);
        scr_example_if_kris_sprite_disable_shader(hurtsprite)
    }
    else
    {
        specdraw = 1;
        thissprite = defendsprite;
        index = defendtimer;
        scr_example_if_kris_sprite_use_shader(defendsprite)
        draw_sprite_ext(defendsprite, defendtimer, (x - 20) + (hurtindex * 10), y, scale, scale, 0, image_blend, image_alpha);
        scr_example_if_kris_sprite_disable_shader(defendsprite)
    }
}

if (specdraw == 0 && state != 8)
{
    sprite_index = thissprite;
    image_index = index;
    image_blend = c_white;
    image_blend = c_white;
    scr_example_if_kris_sprite_use_shader(thissprite)
    draw_sprite_ext(thissprite, index, x, y, scale, scale, 0, image_blend, image_alpha);
    scr_example_if_kris_sprite_disable_shader(thissprite)
    
    if (flash == 1)
    {
        fsiner += 1;
        d3d_set_fog(true, c_white, 0, 1);
        scr_example_if_kris_sprite_use_shader(thissprite)
        draw_sprite_ext(thissprite, index, x, y, scale, scale, 0, image_blend, (-cos(fsiner / 5) * 0.4) + 0.6);
        scr_example_if_kris_sprite_disable_shader(thissprite)
        d3d_set_fog(false, c_black, 0, 0);
    }
}

if (state == 8)
{
    scr_example_if_kris_sprite_use_shader()
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
    scr_example_if_kris_sprite_disable_shader()
}

specdraw = 0;

if (becomeflash == 0)
    flash = 0;

becomeflash = 0;

if (global.targeted[myself] == 1 && global.mnfight == 1 && global.chapter == 1)
    draw_sprite_ext(spr_chartarget, siner / 10, x, y, 2, 2, 0, c_white, 1);
