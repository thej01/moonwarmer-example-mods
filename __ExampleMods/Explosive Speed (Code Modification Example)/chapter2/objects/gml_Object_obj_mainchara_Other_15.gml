if (active == 1)
{
    scr_damage_all_overworld();
    snd_play(snd_badexplosion);
    snd_volume(snd_badexplosion, 0.5, 0);
    anim = instance_create(x, y, obj_animation);
    anim.sprite_index = spr_realisticexplosion;
    anim.image_xscale = 2;
    anim.image_yscale = 2;
    
    with (obj_darkcontroller)
        charcon = 1;
    
    global.interact = 1;
    
    with (obj_mainchara)
        alarm[1] = 7;
    
    hit = 1;
}
