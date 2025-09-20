function scr_example_shader_init()
{
    // SHADER REPLACE COLORS
    global.example_shader_colorreplace =
    [
        // -- Dark world Kris colors --

        // Hair color
        [
            11, 11, 59
        ],
        // Cape color
        [
            235, 0, 149
        ],
        // Skin color
        [
            117, 251, 237
        ],
        // Armor color
        [
            199, 227, 242
        ],
        // Shading color
        [
            106, 123, 196
        ],
        // Sword color
        [
            242, 161, 161
        ],
        // Sword outline color
        [
            72, 1, 46
        ],
        // Sword mantle (hehe) color
        [
            131, 21, 90
        ],
        // Sword highlight color
        [
            255, 215, 215
        ]
    ]

    // SHADER NEW COLORS

    global.example_shader_colornew =
    [
        // These are our NEW colors. (mantle kris!!!)
        // Hair color
        [
            80, 35, 211
        ],
        // Cape color
        [
            255, 95, 197
        ],
        // Skin color
        [
            141, 237, 254
        ],
        // Armor color
        [
            171, 215, 242
        ],
        // Shading color
        [
            97, 137, 165
        ],
        // Sword color
        [
            141, 237, 254
        ],
        // Sword outline color
        [
            80, 35, 211
        ],
        // Sword mantle (hehe) color
        [
            156, 150, 211
        ],
        // Sword highlight color
        [
            233, 233, 233
        ]
    ]

    scr_example_shader_init_sprite_list()
}

function scr_example_kris_sprite(sprite)
{
    var spr = sprite
    if (is_string(spr))
    {
        var spr = asset_get_index(spr)
        if (spr == -1)
            return;
    }

    if (ds_list_find_index(global.ex_kris_sprites, spr) == -1)
        ds_list_add(global.ex_kris_sprites, spr)
}

function scr_example_if_kris_sprite_use_shader(sprite = sprite_index)
{
    if ds_list_find_index(global.ex_kris_sprites, sprite) != -1
		scr_example_shader_on(global.example_shader_colorreplace, global.example_shader_colornew)
}

function scr_example_if_kris_sprite_disable_shader(sprite = sprite_index)
{
    if ds_list_find_index(global.ex_kris_sprites, sprite) != -1
        scr_example_shader_off()
}

function scr_example_shader_on(replaceColors, newColors)
{
	if (!variable_instance_exists(id, "example_shader_init"))
	{
		example_shader_init = true
		uni_replaceColor_r = shader_get_uniform(shd_colorreplace, "u_replaceColor_r");
		uni_replaceColor_g = shader_get_uniform(shd_colorreplace, "u_replaceColor_g");
		uni_replaceColor_b = shader_get_uniform(shd_colorreplace, "u_replaceColor_b");
		uni_colorCount = shader_get_uniform(shd_colorreplace, "u_colorCount")
		uni_newColor_r = shader_get_uniform(shd_colorreplace, "u_newColor_r");
		uni_newColor_g = shader_get_uniform(shd_colorreplace, "u_newColor_g");
		uni_newColor_b = shader_get_uniform(shd_colorreplace, "u_newColor_b");
	}

    var colors_replace = scr_color_array_to_decimal(replaceColors)
    var colors_new = scr_color_array_to_decimal(newColors)
	
	var new_r = []
	var new_g = []
	var new_b = []
	
	var newColor_r = []
	var newColor_g = []
	var newColor_b = []
	
	for (var i = 0; i < array_length(colors_replace); i++)
	{
		var cur_rgb = colors_replace[i]
		var cur_new_rgb = colors_new[i]
		
		new_r[i] = cur_rgb[0]
		new_g[i] = cur_rgb[1]
		new_b[i] = cur_rgb[2]
		
		newColor_r[i] = cur_new_rgb[0]
		newColor_g[i] = cur_new_rgb[1]
		newColor_b[i] = cur_new_rgb[2]
	}
	
	shader_set(shd_colorreplace)
	shader_set_uniform_f_array(uni_replaceColor_r, new_r)
	shader_set_uniform_f_array(uni_replaceColor_g, new_g)
	shader_set_uniform_f_array(uni_replaceColor_b, new_b)
	shader_set_uniform_f_array(uni_newColor_r, newColor_r)
	shader_set_uniform_f_array(uni_newColor_g, newColor_g)
	shader_set_uniform_f_array(uni_newColor_b, newColor_b)
	shader_set_uniform_i(uni_colorCount, array_length(colors_replace))
}

function scr_example_shader_off()
{
    if shader_current() == shd_colorreplace
        shader_reset();
}

function scr_color_array_to_decimal(arr)
{
    var new_arr = []
    for (var i = 0; i < array_length(arr); i++)
    {
        for (var j = 0; j < array_length(arr[i]); j++)
            new_arr[i][j] = arr[i][j] / 255
    }
    return new_arr;
}

function scr_example_shader_init_sprite_list()
{
    // every single kris sprite in the game :fire:
	if (variable_global_exists("ex_kris_sprites"))
        return;

    global.ex_kris_sprites = ds_list_create()

    scr_example_kris_sprite("spr_kris_hug")
    scr_example_kris_sprite("spr_krisb_pirouette")
    scr_example_kris_sprite("spr_krisb_bow")
    scr_example_kris_sprite("spr_krisb_victory")
    scr_example_kris_sprite("spr_krisb_defeat")
    scr_example_kris_sprite("spr_krisb_attackready")
    scr_example_kris_sprite("spr_krisb_act")
    scr_example_kris_sprite("spr_krisb_actready")
    scr_example_kris_sprite("spr_krisb_itemready")
    scr_example_kris_sprite("spr_krisb_item")
    scr_example_kris_sprite("spr_krisb_attack")
    scr_example_kris_sprite("spr_krisb_attack_old")
    scr_example_kris_sprite("spr_krisb_hurt")
    scr_example_kris_sprite("spr_krisb_intro")
    scr_example_kris_sprite("spr_krisb_idle")
    scr_example_kris_sprite("spr_krisb_defend")
    scr_example_kris_sprite("spr_kris_drop")
    scr_example_kris_sprite("spr_kris_fell")
    scr_example_kris_sprite("spr_krisr_kneel")
    scr_example_kris_sprite("spr_krisd_dark")
    scr_example_kris_sprite("spr_krisr_dark")
    scr_example_kris_sprite("spr_krisu_dark")
    scr_example_kris_sprite("spr_krisl_dark")
    scr_example_kris_sprite("spr_kris_fallen_dark")
    scr_example_kris_sprite("spr_krisd_slide")
    scr_example_kris_sprite("spr_king_liftkris")

    scr_example_kris_sprite("spr_cutscene_10_kris_blush")
    scr_example_kris_sprite("spr_cutscene_10_kris_blush_walk")
    scr_example_kris_sprite("spr_cutscene_10_kris_t_pose")
    scr_example_kris_sprite("spr_cutscene_10_susie_kris_t_pose_back")
    scr_example_kris_sprite("spr_cutscene_10_susie_kris_t_pose_back_punch_left")
    scr_example_kris_sprite("spr_cutscene_10_susie_kris_t_pose_back_punch_right")
    scr_example_kris_sprite("spr_cutscene_10_susie_kris_t_pose_back_dodge_right")
    scr_example_kris_sprite("spr_cutscene_10_susie_kris_t_pose_back_dodge_left")
    scr_example_kris_sprite("spr_cutscene_10_susie_kris_t_pose_front")
    scr_example_kris_sprite("spr_cutscene_10_kris_reach")
    scr_example_kris_sprite("spr_cutscene_27_kris")
    scr_example_kris_sprite("spr_kris_fall_d_dw")
    scr_example_kris_sprite("spr_kris_fall_smear")
    scr_example_kris_sprite("spr_kris_dw_landed")
    scr_example_kris_sprite("spr_kris_fall_ball")
    scr_example_kris_sprite("spr_kris_jump_ball")
    scr_example_kris_sprite("spr_kris_dw_land_example_dark")
    scr_example_kris_sprite("spr_kris_fall_example_dark")
    scr_example_kris_sprite("spr_kris_pose")
    scr_example_kris_sprite("spr_kris_dance")
    scr_example_kris_sprite("spr_kris_sword_jump")
    scr_example_kris_sprite("spr_kris_sword_jump_down")
    scr_example_kris_sprite("spr_kris_sword_jump_settle")
    scr_example_kris_sprite("spr_kris_sword_jump_up")
    scr_example_kris_sprite("spr_kris_coaster")
    scr_example_kris_sprite("spr_kris_hug_left")
    scr_example_kris_sprite("spr_kris_peace")
    scr_example_kris_sprite("spr_kris_rude_gesture")
    scr_example_kris_sprite("spr_krisb_virokun")
    scr_example_kris_sprite("spr_krisb_virokun_doctor")
    scr_example_kris_sprite("spr_krisb_virokun_nurse")
    scr_example_kris_sprite("spr_krisb_wan")
    scr_example_kris_sprite("spr_krisb_wan_tail")
    scr_example_kris_sprite("spr_krisb_wiggle")
    scr_example_kris_sprite("spr_krisb_ready_throw_torso")
    scr_example_kris_sprite("spr_krisb_ready_throw_full")
    scr_example_kris_sprite("spr_krisb_ready_throw")
    scr_example_kris_sprite("spr_susieb_throwkrisready")
    scr_example_kris_sprite("spr_teacup_kris")
    scr_example_kris_sprite("spr_cutscene_13_queen_hand_down")
    scr_example_kris_sprite("spr_cutscene_13_queen_hand_down")
    scr_example_kris_sprite("spr_cutscene_13_queen_hand")
    scr_example_kris_sprite("spr_cutscene_13_queen_hand_2")
    scr_example_kris_sprite("spr_cutscene_13_queen_hand_3")
    scr_example_kris_sprite("spr_kris_susie_faceaway")
    
    scr_example_kris_sprite("spr_krisd_dark_stealth_old")
    scr_example_kris_sprite("spr_kris_zoosuit")
    scr_example_kris_sprite("spr_kris_ride_jump_shoot")
    scr_example_kris_sprite("spr_krisu_dark_cool")
    scr_example_kris_sprite("spr_kris_ride_jump_idle")
    scr_example_kris_sprite("spr_susiezilla_krisandralsei_tug")
    scr_example_kris_sprite("spr_kris_grabandpull_susie")
    scr_example_kris_sprite("spr_kris_guitar_ready", "rock")
    scr_example_kris_sprite("spr_kris_guitar_isolate", "rock")
    scr_example_kris_sprite("spr_kris_grabandpull_susie_pt2")
    scr_example_kris_sprite("spr_kris_quiz_down")
    scr_example_kris_sprite("spr_kris_grabandpull_susie_pt4")
    scr_example_kris_sprite("spr_kris_grabandpull_susie_pt3")
    scr_example_kris_sprite("spr_kris_halt_serious_right")
    scr_example_kris_sprite("spr_kris_chef1")
    scr_example_kris_sprite("spr_kris_ride_jump_1")
    scr_example_kris_sprite("spr_kris_quiz_cough")
    scr_example_kris_sprite("spr_krisr_dark_holdingcontroller")
    scr_example_kris_sprite("spr_kris_chef_pose_1")
    scr_example_kris_sprite("spr_kris_chef_default")
    scr_example_kris_sprite("spr_kris_rock_1", "rock")
    scr_example_kris_sprite("spr_kris_ride_2")
    scr_example_kris_sprite("spr_kris_jump_2")
    scr_example_kris_sprite("spr_kris_racing_play")
    scr_example_kris_sprite("spr_chefs_kris_stun")
    scr_example_kris_sprite("spr_kris_grabandpull_susie_pt1")
    scr_example_kris_sprite("spr_kris_ride_1")
    scr_example_kris_sprite("spr_kris_clap")
    scr_example_kris_sprite("spr_kris_chef")
    scr_example_kris_sprite("spr_kris_chef_jump")
    scr_example_kris_sprite("spr_kris_lightemup2")
    scr_example_kris_sprite("spr_krisu_dark_head1pxdown")
    scr_example_kris_sprite("spr_kris_lightemup4")
    scr_example_kris_sprite("spr_krisu_holdcontroller_cool")
    scr_example_kris_sprite("spr_kris_guitar_high_hold", "rock")
    scr_example_kris_sprite("spr_kris_t_pose")
    scr_example_kris_sprite("spr_chefs_kris_throw")
    scr_example_kris_sprite("spr_krisd_dark_stealth_left")
    scr_example_kris_sprite("spr_krisu_holdcontroller_slightright")
    scr_example_kris_sprite("spr_kris_susie_faceaway_flipped")
    scr_example_kris_sprite("spr_kris_chef_pose_2")
    scr_example_kris_sprite("spr_kris_chef_walk")
    scr_example_kris_sprite("spr_krisu_dark_slightright")
    scr_example_kris_sprite("spr_susiezilla_krisandralsei")
    scr_example_kris_sprite("spr_kris_cowboy_sidewalk")
    scr_example_kris_sprite("spr_kris_zoosuit_card")
    scr_example_kris_sprite("spr_kris_button_press")
    scr_example_kris_sprite("spr_krisd_feet")
    scr_example_kris_sprite("spr_krisb_pirouette_plate")
    scr_example_kris_sprite("spr_kris_chef_squat")
    scr_example_kris_sprite("spr_kris_chef3")
    scr_example_kris_sprite("spr_kris_grab_temp")
    scr_example_kris_sprite("spr_krisd_dark_stealth")
    scr_example_kris_sprite("spr_kris_chef2")
    scr_example_kris_sprite("spr_kris_climb")
    scr_example_kris_sprite("spr_krisu_goldcontroller_hurt")
    scr_example_kris_sprite("spr_kris_guitar", "rock")
    scr_example_kris_sprite("spr_kris_lightemup3")
    scr_example_kris_sprite("spr_krisu_dark_slightright_down")
    scr_example_kris_sprite("spr_kris_guitar_high", "rock")
    scr_example_kris_sprite("spr_susiezilla_kris_tug")
    scr_example_kris_sprite("spr_krisr_dark_lookdown")
    scr_example_kris_sprite("spr_krisu_holdcontroller")
    scr_example_kris_sprite("spr_kris_u_dark_lookright")
    scr_example_kris_sprite("spr_couch_kris_knock_over")
    scr_example_kris_sprite("spr_kris_zoosuit_cup")
    scr_example_kris_sprite("spr_kris_ride_shoot")
    scr_example_kris_sprite("spr_kris_racing_walk")
    scr_example_kris_sprite("spr_kris_grabandpull_susieedit_strip7")
    scr_example_kris_sprite("spr_krisb_throwplate")
    scr_example_kris_sprite("spr_kris_run_serious_right")
    scr_example_kris_sprite("spr_kris_jump_ball_fixed")
    scr_example_kris_sprite("spr_roaring_knight_kris_knighting")
    scr_example_kris_sprite("spr_kris_rock_2", "rock")
    scr_example_kris_sprite("spr_shootout_kris_popout")
    scr_example_kris_sprite("spr_kris_lightemup1")
    scr_example_kris_sprite("spr_krisu_holdcontroller_lookright")
    scr_example_kris_sprite("spr_kris_cowboy_walk_up")
    scr_example_kris_sprite("spr_couch_susie_awake")
    scr_example_kris_sprite("spr_couch_susie_blinking")
    scr_example_kris_sprite("spr_couch_susie_sleeping_pop")
    scr_example_kris_sprite("spr_couch_susie_kicking")
    scr_example_kris_sprite("spr_couch_susie_sleeping")
    scr_example_kris_sprite("spr_couch_susie_kicking_ready")
    scr_example_kris_sprite("spr_couch_susie_looking")
    scr_example_kris_sprite("spr_susie_funnyface")
    scr_example_kris_sprite("spr_shadowman_shakehand")
    scr_example_kris_sprite("spr_dw_ch3_SM03_grab_3_breathing")
    scr_example_kris_sprite("spr_dw_ch3_SM03_grab_2")
    scr_example_kris_sprite("spr_dw_ch3_SM03_grab_3")
    scr_example_kris_sprite("spr_dw_ch3_SM03_grab_4")
    scr_example_kris_sprite("spr_dw_ch3_SM03_together")
    scr_example_kris_sprite("spr_dw_ch3_SM03_grab_1")

    scr_example_kris_sprite("spr_kris_injured")
    scr_example_kris_sprite("spr_kris_block_up_wind_inbetween2")
    scr_example_kris_sprite("spr_krisu_kneel")
    scr_example_kris_sprite("spr_kris_fall_dw_hurt_old")
    scr_example_kris_sprite("spr_kris_pianopuppet_body")
    scr_example_kris_sprite("spr_susiekris_walking")
    scr_example_kris_sprite("spr_kris_climb_new_jump_right")
    scr_example_kris_sprite("spr_kris_piano_transition_2_3")
    scr_example_kris_sprite("spr_krisd_dark_extendedhitboxB")
    scr_example_kris_sprite("spr_kris_splat")
    scr_example_kris_sprite("spr_kris_kneel_stand_head")
    scr_example_kris_sprite("spr_kris_climb_new_charge")
    scr_example_kris_sprite("spr_kris_block_up_wind")
    scr_example_kris_sprite("spr_kris_stand_form_kneel_up")
    scr_example_kris_sprite("spr_kris_defending_dark")
    scr_example_kris_sprite("spr_susieb_throwkrisready5163")
    scr_example_kris_sprite("spr_kris_defending")
    scr_example_kris_sprite("spr_kris_piano_loop_1")
    scr_example_kris_sprite("spr_kris_pianopuppet_larm")
    scr_example_kris_sprite("spr_kris_climb_new")
    scr_example_kris_sprite("spr_kris_kneel_stand")
    scr_example_kris_sprite("spr_kris_climb_new_jump_right_alt2")
    scr_example_kris_sprite("spr_dw_church_piano_w_kris")
    scr_example_kris_sprite("spr_kris_climb_new_charge_right")
    scr_example_kris_sprite("spr_kris_piano_full", "kris_piano_full")
    scr_example_kris_sprite("spr_krisd_dark_extendidhitbox")
    scr_example_kris_sprite("spr_susiekris_Jump")
    scr_example_kris_sprite("spr_kris_climb_new_charge_left")
    scr_example_kris_sprite("spr_kris_climb_new_jump_left")
    scr_example_kris_sprite("spr_kris_climb_new_slip_left")
    scr_example_kris_sprite("spr_kris_fall_dw_hurt")
    scr_example_kris_sprite("spr_kris_climb_new_slip_left4325")
    scr_example_kris_sprite("spr_kris_climb_new_slip_right_4326")
    scr_example_kris_sprite("spr_kris_piano_loop_3")
    scr_example_kris_sprite("spr_kris_run_down")
    scr_example_kris_sprite("spr_kris_climb_new_slip_fall")
    scr_example_kris_sprite("spr_kris_jump_up")
    scr_example_kris_sprite("spr_kris_kneel_hand_raise")
    scr_example_kris_sprite("spr_kris_dw_plummet")
    scr_example_kris_sprite("spr_kris_block_up_wind_inbetween")
    scr_example_kris_sprite("spr_krisu_kneel_b")
    scr_example_kris_sprite("spr_kris_kneel_hand_down")
    scr_example_kris_sprite("spr_kris_old_man_clash")
    scr_example_kris_sprite("spr_kris_kneel_head")
    scr_example_kris_sprite("spr_kris_walk_up_windy_hair")
    scr_example_kris_sprite("spr_kris_piano_transition_end")
    scr_example_kris_sprite("spr_kris_walk_up_windy")
    scr_example_kris_sprite("spr_susiekris_running")
    scr_example_kris_sprite("spr_kris_fall_dw_hurt_wind")
    scr_example_kris_sprite("spr_kris_piano_sit_old")
    scr_example_kris_sprite("spr_kris_sword_run")
    scr_example_kris_sprite("spr_kris_climb_new_slip_right")
    scr_example_kris_sprite("spr_kris_run_right")
    scr_example_kris_sprite("spr_kris_defending_parry")
    scr_example_kris_sprite("spr_kris_piano_sit_old_2")
    scr_example_kris_sprite("spr_kris_climb_new_jump_right_alt1")
    scr_example_kris_sprite("spr_kris_climb_new_land_left")
    scr_example_kris_sprite("spr_susiekris_Jump_ready")
    scr_example_kris_sprite("spr_kris_piano_loop_2")
    scr_example_kris_sprite("spr_kris_jump_up_ready")
    scr_example_kris_sprite("spr_kris_climb_new_jump_up")
    scr_example_kris_sprite("spr_kris_piano_sit", "kris_piano_sit")
    scr_example_kris_sprite("spr_kris_climb_new_land_right")
    scr_example_kris_sprite("spr_kris_defending_parry_dark")
    scr_example_kris_sprite("spr_kris_old_man_clash_black")
    scr_example_kris_sprite("spr_kris_pianopuppet_rarm")
    scr_example_kris_sprite("spr_krisu_dark_1frame")
    scr_example_kris_sprite("spr_kris_piano_transition_3_4")
    scr_example_kris_sprite("spr_ralsei_group_hug")
    scr_example_kris_sprite("spr_ralsei_group_hug_nuzzle")
    scr_example_kris_sprite("spr_ralsei_group_hug_nuzzle_alt")
    scr_example_kris_sprite("spr_susie_kneel_heal")
    scr_example_kris_sprite("spr_jackenstein_catch")
    scr_example_kris_sprite("spr_jackenstein_party_hug")
    scr_example_kris_sprite("spr_jackenstein_party_nuzzle")
    scr_example_kris_sprite("spr_jackenstein_party_put_down")
    scr_example_kris_sprite("spr_npc_jackenstein_climb_party")
    scr_example_kris_sprite("spr_susie_climb_throw_catch")
    scr_example_kris_sprite("spr_susie_climb_throw")
    scr_example_kris_sprite("spr_kris_kneel_start")
}