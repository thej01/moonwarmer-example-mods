if (sprite_palette != -1)
{
    pal_swap_set(sprite_palette, current_pal, false);
    draw_sprite_ext(sprite_index, image_index, x + sinerx + shakex, y + sinery + shakey, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
    pal_swap_reset();
}
else
{
    scr_example_if_kris_sprite_use_shader()
    draw_sprite_ext(sprite_index, image_index, x + sinerx + shakex, y + sinery + shakey, image_xscale, image_yscale, image_angle, color_blend, image_alpha);
    scr_example_if_kris_sprite_disable_shader()
}
