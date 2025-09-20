if (global.chapter == 4)
{
    for (var i = 0; i < instance_number(obj_balthizard_enemy); i++)
    {
        turtle[i] = instance_find(obj_balthizard_enemy, i);
        
        if (turtle[i].gersonevent == true && turtle[i].gersonintro < 2)
            exit;
    }
    
    if (i_ex(obj_holywatercooler_enemy) && obj_holywatercooler_enemy.introcon > 0)
        exit;
    
    if (soundbattle == true)
    {
        if (global.myfight == 0 && global.bmenuno == 0 && !i_ex(obj_herokris) && i_ex(obj_sound_of_justice_enemy) && obj_sound_of_justice_enemy.phase == 1)
        {
            if (global.hp[2] <= (global.maxhp[2] * 0.5) && global.tension >= global.spellcost[2][1])
            {
                global.bmenuno = 0;
                global.bmenucoord[2][global.charturn] = 1;
                global.chartarget[global.charturn] = global.bmenucoord[global.bmenuno][global.charturn];
                scr_spellinfo(11);
                scr_spellconsumeb();
                exit;
            }
            else
            {
                scr_nexthero();
            }
        }
        
        if (global.hp[2] < 1)
            exit;
        
        if (i_ex(obj_sound_of_justice_enemy) && victory == 0)
        {
            if (selnoise == 1)
            {
                snd_play(snd_select);
                selnoise = 0;
            }
            
            if (obj_sound_of_justice_enemy.kris_phase2_try_attack_con > 0 || obj_sound_of_justice_enemy.susie_phase2_try_attack_con > 0 || obj_sound_of_justice_enemy.intermission1_con > 0 || obj_sound_of_justice_enemy.endingcon > 0 || obj_sound_of_justice_enemy.introcon > 0)
                exit;
        }
    }
    
    if (i_ex(obj_hammer_of_justice_enemy) && obj_hammer_of_justice_enemy.endcon == 5 && obj_hammer_of_justice_enemy.endtimer >= 105)
    {
    }
    else if (i_ex(obj_hammer_of_justice_enemy) && obj_hammer_of_justice_enemy.endcon > 0 && obj_hammer_of_justice_enemy.endtimer > 0 && obj_hammer_of_justice_enemy.end_cutscene_version == 1)
    {
        exit;
    }
    else if (i_ex(obj_hammer_of_justice_enemy) && obj_hammer_of_justice_enemy.endcon > 1 && obj_hammer_of_justice_enemy.end_cutscene_version == 1)
    {
        exit;
    }
    
    if (i_ex(obj_elnina_lanino_rematch_controller) && obj_elnina_lanino_rematch_controller.endcon > 0)
        exit;
    
    if (i_ex(obj_titan_enemy) && obj_titan_enemy.gerson.sprite_index == spr_gerson_item && global.mnfight != 2)
        exit;
}

if (victory == 1 && victoried == 0)
{
    global.faceaction[0] = 0;
    global.faceaction[1] = 0;
    global.faceaction[2] = 0;
    global.battleend = 1;
    global.mnfight = -1;
    global.myfight = 7;
    
    with (battlewriter)
        instance_destroy();
    
    with (obj_face)
        instance_destroy();
    
    with (obj_smallface)
        instance_destroy();
    
    for (var i = 0; i < 5; i += 1)
    {
        if (global.hp[i] < 1)
            global.hp[i] = round(global.maxhp[i] / 8);
    }
    
    lastbattlewriter = 32482473284732;
    
    if (skipvictory == 0)
    {
        global.monstergold[3] += floor(global.tension / 10) * global.chapter;
        
        if (global.charweapon[1] == 8)
            global.monstergold[3] += floor(global.monstergold[3] / 20);
        
        if (global.charweapon[1] == 53)
            global.monstergold[3] += floor(global.monstergold[3] / 20);
        
        global.monstergold[3] *= 1 + (scr_armorcheck_equipped_party(8) * 0.05);
        global.monstergold[3] *= 1 + (scr_armorcheck_equipped_party(21) * 0.3);
        global.monstergold[3] -= global.monstergold[3] * (scr_armorcheck_equipped_party(54) * 0.1);
        global.monstergold[3] = floor(global.monstergold[3]);
        
        if (global.flag[37] == 1)
            global.monstergold[3] = 0;
        
        global.gold += global.monstergold[3];
        global.xp += global.monsterexp[3];
        
        if (global.gold < 0)
            global.gold = 0;
        
        global.fc = 0;
        global.fe = 0;
        global.battlemsg[0] = stringsetsubloc("* You won^1!&* Got ~1 EXP and ~2 D$./%", string(global.monsterexp[3]), string(global.monstergold[3]), "obj_battlecontroller_slash_Step_0_gml_42_0");
        
        if (gersonend == true)
            global.battlemsg[0] = stringsetsubloc("* You won^1!&* Got ~1 EXP and ~2 D$.&* Susie's heal power increased!/%", string(global.monsterexp[3]), string(global.monstergold[3]), "obj_battlecontroller_slash_Step_0_gml_101_0");
        
        if (global.flag[37] == 1)
            global.battlemsg[0] = stringsetloc("* You won the battle!/%", "obj_battlecontroller_slash_Step_0_gml_43_0");
        
        if (global.flag[63] == 1)
        {
            global.battlemsg[0] = stringsetsubloc("* You won^1!&* Got ~1 D$^1.&* You became stronger./%", string(global.monstergold[3]), "obj_battlecontroller_slash_Step_0_gml_46_0");
            
            if (scr_havechar(4))
                global.battlemsg[0] = stringsetsubloc("* You won^1!&* Got ~1 D$^1.&* Noelle became stronger./%", string(global.monstergold[3]), "obj_battlecontroller_slash_Step_0_gml_69_0");
            
            var lvsnd = snd_play_pitch(snd_dtrans_lw, 2);
            snd_volume(lvsnd, 0.7, 0);
            scr_levelup();
        }
        
        global.msg[0] = global.battlemsg[0];
        global.typer = global.battletyper;
        lastbattlewriter = scr_battletext();
        
        if (global.flag[38] == 1)
        {
            with (lastbattlewriter)
                instance_destroy();
        }
        
        for (var i = 0; i < 3; i += 1)
        {
            with (global.charinstance[i])
            {
                state = 7;
                hurt = 0;
                hurttimer = 0;
            }
        }
    }
    
    victoried = 1;
    victortimer = 0;
    
    if (skipvictory == 1)
        victortimer = -20;
    
    with (obj_tensionbar)
    {
        alarm[5] = 15;
        hspeed = -10;
        friction = -0.4;
    }
}

if (victoried == 1)
{
    victortimer += 1;
    
    if (i_ex(lastbattlewriter) == false && victortimer >= 10)
    {
        intro = 2;
        
        if (bp <= 0)
            scr_endcombat();
    }
}

if (global.myfight == 0)
{
    if (global.bmenuno == 0)
    {
        if (!i_ex(battlewriter) || (global.chapter == 2 && !i_ex(battlewriter)))
        {
            global.msg[0] = global.battlemsg[0];
            global.typer = global.battletyper;
            
            if (global.chapter == 4 && facevar == 1)
            {
                scr_speaker("susie");
                global.fe = 17;
                facevar = 0;
            }
            
            if (global.chapter == 4 && facevar == 2)
            {
                scr_speaker("susie");
                global.fe = 5;
                facevar = 0;
            }
            
            scr_battletext();
        }
        
        if (left_p() == 1 && lbuffer < 0)
        {
            if (global.bmenucoord[0][global.charturn] == 0)
                global.bmenucoord[0][global.charturn] = 4;
            else
                global.bmenucoord[0][global.charturn] -= 1;
            
            movenoise = 1;
            rbuffer = 1;
            
            if (disableitembutton == 1 && global.bmenucoord[0][global.charturn] == 2)
                global.bmenucoord[0][global.charturn] = 1;
            
            if (disablesusieattack == 1 && global.charturn == 1 && global.bmenucoord[0][global.charturn] == 0)
                global.bmenucoord[0][global.charturn] = 4;
        }
        
        if (right_p() == 1 && rbuffer < 0)
        {
            if (global.bmenucoord[0][global.charturn] == 4)
                global.bmenucoord[0][global.charturn] = 0;
            else
                global.bmenucoord[0][global.charturn] += 1;
            
            movenoise = 1;
            lbuffer = 1;
            
            if (disableitembutton == 1 && global.bmenucoord[0][global.charturn] == 2)
                global.bmenucoord[0][global.charturn] = 3;
            
            if (disablesusieattack == 1 && global.charturn == 1 && global.bmenucoord[0][global.charturn] == 0)
                global.bmenucoord[0][global.charturn] = 1;
        }
        
        if (button1_p() == 1 && twobuffer < 0)
        {
            onebuffer = 1;
            selnoise = 1;
            
            if (global.bmenucoord[0][global.charturn] == 0)
                global.bmenuno = 1;
            
            if (global.bmenucoord[0][global.charturn] == 1 && global.char[global.charturn] != 1)
            {
                onebuffer = 1;
                global.bmenuno = 2;
            }
            else if (global.bmenucoord[0][global.charturn] == 1)
            {
                onebuffer = 1;
                global.bmenuno = 11;
            }
            
            if (global.bmenucoord[0][global.charturn] == 2 && tempitem[0][global.charturn] != 0)
            {
                onebuffer = 1;
                global.bmenuno = 4;
                scr_iteminfo_temp(global.charturn);
                
                for (var i = 0; i < 12; i += 1)
                {
                    if (tempitem[global.bmenucoord[4][global.charturn]][global.charturn] == 0 && global.bmenucoord[4][global.charturn] > 0)
                        global.bmenucoord[4][global.charturn] -= 1;
                }
            }
            
            if (global.bmenucoord[0][global.charturn] == 3)
            {
                onebuffer = 1;
                global.bmenuno = 12;
            }
            
            if (global.bmenucoord[0][global.charturn] == 4)
            {
                if (global.chapter == 4 && (i_ex(obj_titan_spawn_enemy) || i_ex(obj_titan_enemy) || i_ex(obj_jackenstein_enemy) || i_ex(obj_sound_of_justice_enemy)))
                    scr_tensionheal(5);
                else
                    scr_tensionheal(40);
                
                global.faceaction[global.charturn] = 4;
                global.charaction[global.charturn] = 10;
                scr_nexthero();
            }
        }
        
        if (button2_p() == 1 && onebuffer < 0 && global.charturn > 0)
        {
            twobuffer = 1;
            movenoise = 1;
            scr_prevhero();
        }
        
        with (battlewriter)
            depth = 3;
        
        with (obj_face_parent)
            depth = 3;
        
        with (obj_smallface)
            depth = 3;
    }
    
    if (global.bmenuno == 2 && global.flag[34] == 1)
    {
        with (battlewriter)
            skipme = 1;
        
        with (battlewriter)
            depth = 10;
        
        with (obj_face_parent)
            depth = 10;
        
        with (obj_smallface)
            depth = 10;
        
        thischar = global.char[global.charturn];
        
        if (right_p() || left_p())
        {
            cango = 1;
            spellcoord = global.bmenucoord[2][global.charturn];
            
            if (spellcoord < 11)
            {
                if (global.spell[thischar][global.bmenucoord[2][global.charturn] + 1] == 0)
                {
                    cango = 0;
                    
                    if ((spellcoord % 2) == 1 && spellcoord > 0)
                        global.bmenucoord[2][global.charturn] -= 1;
                }
            }
            else
            {
                global.bmenucoord[2][global.charturn] -= 1;
                cango = 0;
            }
            
            if (cango == 1)
            {
                if ((spellcoord % 2) == 0)
                    global.bmenucoord[2][global.charturn] += 1;
                else
                    global.bmenucoord[2][global.charturn] -= 1;
            }
        }
        
        if (down_p())
        {
            spellcoord = global.bmenucoord[2][global.charturn];
            cango = 1;
            
            if (spellcoord >= 10)
            {
                cango = 0;
            }
            else
            {
                if (global.spell[thischar][spellcoord + 2] == 0)
                    cango = 0;
                
                if (spellcoord == 5 && global.spell[thischar][6] != 0 && global.spell[thischar][7] == 0)
                    cango = 2;
            }
            
            if (cango != 0)
            {
                if (cango == 1)
                    global.bmenucoord[2][global.charturn] += 2;
                
                if (cango == 2)
                    global.bmenucoord[2][global.charturn] = 6;
            }
        }
        
        if (up_p())
        {
            spellcoord = global.bmenucoord[2][global.charturn];
            cango = 1;
            
            if (spellcoord <= 1)
                cango = 0;
            
            if (cango == 1)
                global.bmenucoord[2][global.charturn] -= 2;
        }
        
        global.tensionselect = global.spellcost[thischar][global.bmenucoord[2][global.charturn]];
        
        if (button1_p() && global.spell[thischar][global.bmenucoord[2][global.charturn]] != 0 && onebuffer < 0)
        {
            if (global.spellcost[thischar][global.bmenucoord[2][global.charturn]] <= global.tension)
            {
                onebuffer = 2;
                global.bmenuno = 0;
                selnoise = 1;
                scr_spellinfo(global.spell[thischar][global.bmenucoord[2][global.charturn]]);
                
                if (spelltarget == 0)
                    scr_spellconsumeb();
                
                if (spelltarget == 1)
                    global.bmenuno = 8;
                
                if (spelltarget == 2)
                    global.bmenuno = 3;
            }
        }
        
        if (button2_p() && onebuffer < 0)
        {
            global.tensionselect = 0;
            twobuffer = 1;
            global.bmenuno = 0;
            movenoise = 1;
        }
    }
    
    if (global.bmenuno == 2 && global.flag[34] == 0)
    {
        with (battlewriter)
            skipme = 1;
        
        with (battlewriter)
            depth = 10;
        
        with (obj_face_parent)
            depth = 10;
        
        with (obj_smallface)
            depth = 10;
        
        thischar = global.charturn;
        
        if (right_p() || left_p())
        {
            cango = 1;
            spellcoord = global.bmenucoord[2][global.charturn];
            
            if (spellcoord < 11)
            {
                if (global.battlespell[thischar][global.bmenucoord[2][global.charturn] + 1] == 0)
                {
                    cango = 0;
                    
                    if ((spellcoord % 2) == 1 && spellcoord > 0)
                        global.bmenucoord[2][global.charturn] -= 1;
                }
            }
            else
            {
                global.bmenucoord[2][global.charturn] -= 1;
                cango = 0;
            }
            
            if (cango == 1)
            {
                if ((spellcoord % 2) == 0)
                    global.bmenucoord[2][global.charturn] += 1;
                else
                    global.bmenucoord[2][global.charturn] -= 1;
            }
        }
        
        if (down_p())
        {
            spellcoord = global.bmenucoord[2][global.charturn];
            cango = 1;
            
            if (spellcoord >= 10)
            {
                cango = 0;
            }
            else
            {
                if (global.battlespell[thischar][spellcoord + 2] == 0)
                    cango = 0;
                
                if (spellcoord == 5 && global.battlespell[thischar][6] != 0 && global.battlespell[thischar][7] == 0)
                    cango = 2;
            }
            
            if (cango != 0)
            {
                if (cango == 1)
                    global.bmenucoord[2][global.charturn] += 2;
                
                if (cango == 2)
                    global.bmenucoord[2][global.charturn] = 6;
            }
        }
        
        if (up_p())
        {
            spellcoord = global.bmenucoord[2][global.charturn];
            cango = 1;
            
            if (spellcoord <= 1)
                cango = 0;
            
            if (cango == 1)
                global.bmenucoord[2][global.charturn] -= 2;
        }
        
        global.tensionselect = global.battlespellcost[thischar][global.bmenucoord[2][global.charturn]];
        
        if (button1_p() && global.battlespell[thischar][global.bmenucoord[2][global.charturn]] != 0 && onebuffer < 0)
        {
            if (global.battlespellcost[thischar][global.bmenucoord[2][global.charturn]] <= global.tension)
            {
                if (global.chapter == 4 && (i_ex(obj_titan_spawn_enemy) || i_ex(obj_titan_enemy) || i_ex(obj_sound_of_justice_enemy)))
                {
                    if (global.charturn > 0 && global.bmenucoord[2][global.charturn] == 0)
                        skipmonsterselection = 1;
                }
                
                onebuffer = 2;
                global.bmenuno = 0;
                selnoise = 1;
                
                if (i_ex(obj_sound_of_justice_enemy))
                {
                    if (global.bmenucoord[2][global.charturn] == 0)
                        obj_sound_of_justice_enemy.susie_phase2_try_attack_con = 1;
                    
                    if (global.bmenucoord[2][global.charturn] == 1)
                        obj_sound_of_justice_enemy.endingcon = 1;
                    
                    scr_nexthero();
                    exit;
                }
                
                if (global.battlespell[thischar][global.bmenucoord[2][global.charturn]] != -1)
                {
                    scr_spellinfo(global.battlespell[thischar][global.bmenucoord[2][global.charturn]]);
                    
                    if (spelltarget == 0)
                        scr_spellconsumeb();
                    
                    if (spelltarget == 1)
                        global.bmenuno = 8;
                    
                    if (spelltarget == 2)
                        global.bmenuno = 3;
                    
                    if (spelltarget == 3)
                        global.bmenuno = 99;
                }
                else
                {
                    global.bmenuno = 13;
                }
            }
        }
        
        if (button2_p() && onebuffer < 0)
        {
            global.tensionselect = 0;
            twobuffer = 1;
            global.bmenuno = 0;
            movenoise = 1;
        }
    }
    
    if (global.bmenuno == 4)
    {
        with (battlewriter)
            skipme = 1;
        
        with (battlewriter)
            depth = 10;
        
        with (obj_face_parent)
            depth = 10;
        
        with (obj_smallface)
            depth = 10;
        
        if (tempitem[global.bmenucoord[4][global.charturn]][global.charturn] == 0)
            global.bmenucoord[4][global.charturn] -= 1;
        
        if (right_p())
        {
            cango = 1;
            itemcoord = global.bmenucoord[4][global.charturn];
            
            if (itemcoord < 11)
            {
                if (tempitem[global.bmenucoord[4][global.charturn] + 1][global.charturn] == 0)
                {
                    cango = 0;
                    
                    if ((itemcoord % 2) == 1 && itemcoord > 0)
                        global.bmenucoord[4][global.charturn] -= 1;
                }
            }
            else
            {
                global.bmenucoord[4][global.charturn] -= 1;
                cango = 0;
            }
            
            if (cango == 1)
            {
                if ((itemcoord % 2) == 0)
                    global.bmenucoord[4][global.charturn] += 1;
                else
                    global.bmenucoord[4][global.charturn] -= 1;
            }
        }
        
        if (left_p())
        {
            cango = 1;
            itemcoord = global.bmenucoord[4][global.charturn];
            
            if (tempitem[1][global.charturn] != 0)
            {
                if ((itemcoord % 2) == 0)
                    global.bmenucoord[4][global.charturn] += 1;
                else
                    global.bmenucoord[4][global.charturn] -= 1;
            }
        }
        
        if (down_p())
        {
            itemcoord = global.bmenucoord[4][global.charturn];
            cango = 1;
            
            if (itemcoord >= 10)
            {
                cango = 0;
            }
            else
            {
                if (tempitem[itemcoord + 2][global.charturn] == 0)
                    cango = 0;
                
                if (itemcoord == 5 && tempitem[6][global.charturn] != 0 && tempitem[7][global.charturn] == 0)
                    cango = 2;
            }
            
            if (cango != 0)
            {
                if (cango == 1)
                    global.bmenucoord[4][global.charturn] += 2;
                
                if (cango == 2)
                    global.bmenucoord[4][global.charturn] = 6;
            }
        }
        
        if (up_p())
        {
            itemcoord = global.bmenucoord[4][global.charturn];
            cango = 1;
            
            if (itemcoord <= 1)
                cango = 0;
            
            if (cango == 1)
                global.bmenucoord[4][global.charturn] -= 2;
        }
        
        if (tempitem[global.bmenucoord[4][global.charturn]][global.charturn] == 0)
            global.bmenucoord[4][global.charturn] -= 1;
        
        if (button1_p() && tempitem[global.bmenucoord[4][global.charturn]][global.charturn] != 0 && onebuffer < 0)
        {
            onebuffer = 2;
            global.bmenuno = 0;
            selnoise = 1;
            scr_iteminfo(tempitem[global.bmenucoord[4][global.charturn]][global.charturn]);
            
            if (itemtarget == 0 || itemtarget == 2)
            {
                var _tensionhealed = 0;
                var allowtensionheal = true;
                
                if (global.chapter == 4)
                {
                    if (instance_exists(obj_hammer_of_justice_enemy))
                        allowtensionheal = false;
                }
                
                if (allowtensionheal)
                {
                    var item_use = false;
                    
                    if (tempitem[global.bmenucoord[4][global.charturn]][global.charturn] == 27)
                    {
                        scr_tensionheal(80);
                        _tensionhealed = 1;
                        item_use = true;
                    }
                    
                    if (tempitem[global.bmenucoord[4][global.charturn]][global.charturn] == 28)
                    {
                        scr_tensionheal(ceil(global.maxtension / 2));
                        _tensionhealed = 1;
                        item_use = true;
                    }
                    
                    if (tempitem[global.bmenucoord[4][global.charturn]][global.charturn] == 29)
                    {
                        scr_tensionheal(ceil(global.maxtension));
                        _tensionhealed = 1;
                        item_use = true;
                    }
                    
                    if (item_use == true)
                    {
                        with (obj_event_manager)
                            trigger_event(UnknownEnum.Value_0, get_consumer_trophy());
                    }
                }
                
                if (_tensionhealed)
                {
                    var _drivenoise = snd_play(snd_cardrive);
                    snd_pitch(_drivenoise, 1.4);
                    snd_volume(_drivenoise, 0.8, 0);
                    
                    with (global.charinstance[global.charturn])
                    {
                        ha = instance_create(x, y, obj_healanim);
                        ha.target = id;
                        ha.particlecolor = c_orange;
                    }
                    
                    scr_itemshift_temp(global.bmenucoord[4][global.charturn], global.charturn);
                    scr_nexthero();
                }
                
                if (!_tensionhealed)
                    scr_itemconsumeb();
            }
            
            if (itemtarget == 1)
                global.bmenuno = 7;
        }
        
        if (button2_p() && onebuffer < 0)
        {
            twobuffer = 1;
            global.bmenuno = 0;
            movenoise = 1;
        }
    }
    
    if (global.bmenuno == 9)
    {
        thisenemy = global.bmenucoord[11][global.charturn];
        scr_actinfo_temp(thisenemy);
        
        if (right_p())
        {
            cango = 1;
            actcoord = global.bmenucoord[9][global.charturn];
            
            if (actcoord < 5)
            {
                if (canact[global.bmenucoord[9][global.charturn] + 1] == 0)
                {
                    cango = 0;
                    
                    if ((actcoord % 2) == 1 && actcoord > 0)
                        global.bmenucoord[9][global.charturn] -= 1;
                }
            }
            else
            {
                global.bmenucoord[9][global.charturn] -= 1;
                cango = 0;
            }
            
            if (cango == 1)
            {
                if ((actcoord % 2) == 0)
                    global.bmenucoord[9][global.charturn] += 1;
                else
                    global.bmenucoord[9][global.charturn] -= 1;
            }
        }
        
        if (left_p())
        {
            cango = 1;
            actcoord = global.bmenucoord[9][global.charturn];
            
            if ((actcoord % 2) == 0)
            {
                if (canact[actcoord + 1] != 0)
                    global.bmenucoord[9][global.charturn] += 1;
            }
            else
            {
                global.bmenucoord[9][global.charturn] -= 1;
            }
        }
        
        if (down_p())
        {
            actcoord = global.bmenucoord[9][global.charturn];
            cango = 1;
            
            if (actcoord >= 4)
                cango = 0;
            else if (canact[actcoord + 2] == 0)
                cango = 0;
            
            if (cango != 0)
            {
                if (cango == 1)
                    global.bmenucoord[9][global.charturn] += 2;
            }
        }
        
        if (up_p())
        {
            actcoord = global.bmenucoord[9][global.charturn];
            cango = 1;
            
            if (actcoord <= 1)
                cango = 0;
            
            if (cango == 1)
                global.bmenucoord[9][global.charturn] -= 2;
        }
        
        global.tensionselect = acttpcost[global.bmenucoord[9][global.charturn]];
        canpress = 1;
        
        if (global.char[global.charturn] == 1)
        {
            if (global.actactor[global.bmenucoord[11][global.charturn]][global.bmenucoord[9][global.charturn]] == 2 || global.actactor[global.bmenucoord[11][global.charturn]][global.bmenucoord[9][global.charturn]] == 4)
            {
                if (havechar[1] == 0 || global.hp[2] <= 0)
                    canpress = 0;
            }
            
            if (global.actactor[global.bmenucoord[11][global.charturn]][global.bmenucoord[9][global.charturn]] == 3 || global.actactor[global.bmenucoord[11][global.charturn]][global.bmenucoord[9][global.charturn]] == 4)
            {
                if (havechar[2] == 0 || global.hp[3] <= 0)
                    canpress = 0;
            }
            
            if (global.actactor[global.bmenucoord[11][global.charturn]][global.bmenucoord[9][global.charturn]] == 5)
            {
                if (havechar[3] == 0 || global.hp[4] <= 0)
                    canpress = 0;
            }
        }
        
        if (canpress == 1)
        {
            if (button1_p() && global.canact[thisenemy][global.bmenucoord[9][global.charturn]] == 1 && global.tension >= global.tensionselect && onebuffer < 0)
            {
                onebuffer = 2;
                global.bmenuno = 0;
                selnoise = 1;
                global.actingchoice[global.charturn] = global.bmenucoord[9][global.charturn];
                global.tension -= acttpcost[global.bmenucoord[9][global.charturn]];
                global.tensionselect = 0;
                scr_actselect(thisenemy, global.bmenucoord[9][global.charturn]);
                global.bmenucoord[9][global.charturn] = 0;
                scr_nexthero();
            }
        }
        
        if (button2_p() && onebuffer < 0)
        {
            global.bmenucoord[9][global.charturn] = 0;
            global.tensionselect = 0;
            twobuffer = 1;
            global.bmenuno = 11;
            movenoise = 1;
        }
    }
    
    if (global.bmenuno == 7 || global.bmenuno == 1 || global.bmenuno == 8 || global.bmenuno == 3 || global.bmenuno == 11 || global.bmenuno == 12 || global.bmenuno == 13)
    {
        with (battlewriter)
            skipme = 1;
        
        with (battlewriter)
            depth = 10;
        
        with (obj_face_parent)
            depth = 10;
        
        with (obj_smallface)
            depth = 10;
        
        if (button2_p() && onebuffer < 0)
        {
            twobuffer = 1;
            
            if (global.bmenuno == 1 || global.bmenuno == 11 || global.bmenuno == 12)
                global.bmenuno = 0;
            
            if (global.bmenuno == 7)
                global.bmenuno = 4;
            
            if (global.bmenuno == 8 || global.bmenuno == 3 || global.bmenuno == 13)
                global.bmenuno = 2;
            
            movenoise = 1;
        }
        
        if (global.bmenuno == 7 || global.bmenuno == 1 || global.bmenuno == 8 || global.bmenuno == 3 || global.bmenuno == 11 || global.bmenuno == 12 || global.bmenuno == 13)
        {
            if (global.bmenuno == 7 || global.bmenuno == 8)
            {
                for (var i = 0; i < 3; i += 1)
                {
                    ht[i] = 0;
                    
                    if (global.char[i] > 0)
                        ht[i] = 1;
                }
            }
            
            if (global.bmenuno == 1 || global.bmenuno == 3 || global.bmenuno == 11 || global.bmenuno == 12 || global.bmenuno == 13)
            {
                for (var i = 0; i < 3; i += 1)
                    ht[i] = global.monster[i];
            }
            
            if (global.bmenucoord[global.bmenuno][global.charturn] == 2 && ht[2] == 0)
                global.bmenucoord[global.bmenuno][global.charturn] = 0;
            
            if (global.bmenucoord[global.bmenuno][global.charturn] == 0 && ht[0] == 0)
                global.bmenucoord[global.bmenuno][global.charturn] = 1;
            
            if (global.bmenucoord[global.bmenuno][global.charturn] == 1 && ht[1] == 0)
                global.bmenucoord[global.bmenuno][global.charturn] = 0;
            
            if (global.bmenucoord[global.bmenuno][global.charturn] == 0 && ht[0] == 0)
                global.bmenucoord[global.bmenuno][global.charturn] = 2;
            
            if (down_p() == 1)
            {
                if (global.bmenucoord[global.bmenuno][global.charturn] == 0)
                {
                    if (ht[1] == 1)
                    {
                        movenoise = 1;
                        global.bmenucoord[global.bmenuno][global.charturn] = 1;
                    }
                    else if (ht[2] == 1)
                    {
                        movenoise = 1;
                        global.bmenucoord[global.bmenuno][global.charturn] = 2;
                    }
                }
                else if (global.bmenucoord[global.bmenuno][global.charturn] == 1)
                {
                    if (ht[2] == 1)
                    {
                        movenoise = 1;
                        global.bmenucoord[global.bmenuno][global.charturn] = 2;
                    }
                    else if (ht[0] == 1)
                    {
                        movenoise = 1;
                        global.bmenucoord[global.bmenuno][global.charturn] = 0;
                    }
                }
                else if (global.bmenucoord[global.bmenuno][global.charturn] == 2)
                {
                    if (ht[0] == 1)
                    {
                        movenoise = 1;
                        global.bmenucoord[global.bmenuno][global.charturn] = 0;
                    }
                    else if (ht[1] == 1)
                    {
                        movenoise = 1;
                        global.bmenucoord[global.bmenuno][global.charturn] = 1;
                    }
                }
            }
            
            if (up_p() == 1)
            {
                if (global.bmenucoord[global.bmenuno][global.charturn] == 0)
                {
                    if (ht[2] == 1)
                    {
                        movenoise = 1;
                        global.bmenucoord[global.bmenuno][global.charturn] = 2;
                    }
                    else if (ht[1] == 1)
                    {
                        movenoise = 1;
                        global.bmenucoord[global.bmenuno][global.charturn] = 1;
                    }
                }
                else if (global.bmenucoord[global.bmenuno][global.charturn] == 1)
                {
                    if (ht[0] == 1)
                    {
                        movenoise = 1;
                        global.bmenucoord[global.bmenuno][global.charturn] = 0;
                    }
                    else if (ht[2] == 1)
                    {
                        movenoise = 1;
                        global.bmenucoord[global.bmenuno][global.charturn] = 2;
                    }
                }
                else if (global.bmenucoord[global.bmenuno][global.charturn] == 2)
                {
                    if (ht[1] == 1)
                    {
                        movenoise = 1;
                        global.bmenucoord[global.bmenuno][global.charturn] = 1;
                    }
                    else if (ht[0] == 1)
                    {
                        movenoise = 1;
                        global.bmenucoord[global.bmenuno][global.charturn] = 0;
                    }
                }
            }
            
            if ((button1_p() && onebuffer < 0) || skipmonsterselection)
            {
                onebuffer = 1;
                selnoise = 1;
                skipmonsterselection = 0;
                
                if (global.bmenuno == 1)
                {
                    global.chartarget[global.charturn] = global.bmenucoord[global.bmenuno][global.charturn];
                    global.faceaction[global.charturn] = 1;
                    global.charaction[global.charturn] = 1;
                    scr_nexthero();
                }
                
                if (global.bmenuno == 7)
                {
                    var balthizardskip = false;
                    
                    for (var i = 0; i < instance_number(obj_balthizard_enemy); i++)
                    {
                        turtle[i] = instance_find(obj_balthizard_enemy, i);
                        
                        if (turtle[i].acting == 5 && global.charturn == 1)
                            balthizardskip = true;
                    }
                    
                    var gueiskip = false;
                    
                    for (var i = 0; i < instance_number(obj_guei_enemy); i++)
                    {
                        guei[i] = instance_find(obj_guei_enemy, i);
                        
                        if (guei[i].acting == 4 && obj_guei_enemy.gersonactcount == 1)
                            gueiskip = true;
                    }
                    
                    global.chartarget[global.charturn] = global.bmenucoord[global.bmenuno][global.charturn];
                    
                    if (i_ex(obj_titan_enemy) && obj_titan_enemy.acting == 1)
                        scr_nexthero();
                    else if (balthizardskip && global.plot == 141)
                        scr_nexthero();
                    else if (gueiskip)
                        scr_nexthero();
                    else
                        scr_itemconsumeb();
                }
                
                if (global.bmenuno == 8 || global.bmenuno == 3)
                {
                    global.chartarget[global.charturn] = global.bmenucoord[global.bmenuno][global.charturn];
                    scr_spellconsumeb();
                }
                
                if (global.bmenuno == 11)
                {
                    global.bmenuno = 9;
                    actcoord = global.bmenucoord[9][global.charturn];
                    thisenemy = global.bmenucoord[11][global.charturn];
                    
                    if (global.char[global.charturn] == 1)
                    {
                        for (var i = 0; i < 6; i += 1)
                        {
                            if (global.canact[thisenemy][actcoord] == 0)
                            {
                                if (actcoord > 0)
                                    global.bmenucoord[9][global.charturn] -= 1;
                            }
                        }
                    }
                    
                    if (global.char[global.charturn] == 2)
                    {
                        for (var i = 0; i < 6; i += 1)
                        {
                            if (global.canactsus[thisenemy][actcoord] == 0)
                            {
                                if (actcoord > 0)
                                    global.bmenucoord[9][global.charturn] -= 1;
                            }
                        }
                    }
                    
                    if (global.char[global.charturn] == 3)
                    {
                        for (var i = 0; i < 6; i += 1)
                        {
                            if (global.canactral[thisenemy][actcoord] == 0)
                            {
                                if (actcoord > 0)
                                    global.bmenucoord[9][global.charturn] -= 1;
                            }
                        }
                    }
                    
                    if (global.char[global.charturn] == 4)
                    {
                        for (var i = 0; i < 6; i += 1)
                        {
                            if (global.canactnoe[thisenemy][actcoord] == 0)
                            {
                                if (actcoord > 0)
                                    global.bmenucoord[9][global.charturn] -= 1;
                            }
                        }
                    }
                    
                    onebuffer = 1;
                }
                
                if (global.bmenuno == 12)
                {
                    global.faceaction[global.charturn] = 10;
                    global.chartarget[global.charturn] = global.bmenucoord[global.bmenuno][global.charturn];
                    global.charaction[global.charturn] = 2;
                    global.charspecial[global.charturn] = 100;
                    scr_nexthero();
                }
                
                if (global.bmenuno == 13)
                {
                    onebuffer = 2;
                    global.bmenuno = 0;
                    selnoise = 1;
                    global.actingchoice[global.charturn] = global.bmenucoord[2][global.charturn];
                    global.tension -= global.battlespellcost[thischar][global.bmenucoord[2][global.charturn]];
                    global.tensionselect = 0;
                    scr_actinfo_temp(global.bmenucoord[13][global.charturn]);
                    scr_actselect(global.bmenucoord[13][global.charturn], global.bmenucoord[2][global.charturn]);
                    scr_nexthero();
                }
            }
        }
    }
}

if (movenoise == 1)
{
    snd_play(snd_menumove);
    movenoise = 0;
}

if (grazenoise == 1)
{
    snd_play(snd_graze);
    grazenoise = 0;
}

if (selnoise == 1)
{
    snd_play(snd_select);
    selnoise = 0;
}

if (damagenoise == 1)
{
    if (i_ex(obj_titan_enemy) && (obj_titan_enemy.drawstate == "defense" || obj_titan_enemy.drawstate == "defense end"))
    {
        snd_play(snd_bump);
    }
    else if (i_ex(obj_titan_enemy) && ((obj_titan_enemy.drawstate == "idle" && obj_titan_enemy.starshootcon > 0) || obj_titan_enemy.drawstate == "crack"))
    {
        with (obj_titan_enemy)
            redflashtimer = 10;
        
        snd_play(snd_damage);
        snd_play(snd_queen_punched_lower_heavy);
        scr_shakescreen();
        
        with (obj_shake)
        {
            shakex = 4;
            shakey = 4;
        }
    }
    else if (i_ex(obj_titan_enemy) && (obj_titan_enemy.drawstate == "idle" || obj_titan_enemy.drawstate == "crack2") && obj_titan_enemy.starshootcon == 0)
    {
        snd_play_x(snd_metal_hit_reverb, 1, 0.5);
        
        with (obj_titan_enemy)
            playmeatsoundcon = 1;
    }
    else
    {
        snd_play(snd_squeak);
    }
    
    damagenoise = 0;
}

if (laznoise == 1)
{
    snd_play(snd_laz_c);
    laznoise = 0;
}

onebuffer -= 1;
twobuffer -= 1;
lbuffer -= 1;
rbuffer -= 1;

if (global.mnfight == 2 && timeron == 1)
{
    global.turntimer -= 1;
    
    if (global.turntimer <= 0 && reset == 0)
    {
        with (obj_bulletparent)
            instance_destroy();
        
        with (obj_bulletgenparent)
            instance_destroy();
        
        with (obj_darkener)
            darken = 0;
        
        with (obj_heart)
        {
            instance_create(x, y, obj_returnheart);
            instance_destroy();
        }
        
        reset = 1;
        
        if (noreturn == 0)
            alarm[2] = 15;
    }
}

if (global.myfight == 3)
{
    if (scr_monsterpop() == 0 && !instance_exists(obj_writer))
    {
        scr_wincombat();
        
        if (global.myfight == 3)
            scr_endturn();
    }
}

if (global.myfight == 5)
{
    myfightreturntimer--;
    
    if (myfightreturntimer <= 0)
    {
        scr_mnendturn();
        global.spelldelay = 10;
        
        with (obj_heroparent)
        {
            attacktimer = 0;
            image_index = 0;
            index = 0;
            itemed = 0;
            acttimer = 0;
            defendtimer = 0;
            state = 0;
            flash = 0;
            siner = 0;
            fsiner = 0;
            alarm[4] = -1;
        }
        
        with (obj_spellphase)
        {
            with (spellwriter)
                instance_destroy();
            
            instance_destroy();
        }
    }
}

if (global.charweapon[4] == 13)
{
    if ((t_siner % 6) == 0)
    {
        if (global.hp[4] > round(global.maxhp[4] / 3))
            global.hp[4]--;
    }
}

t_siner++;

if (scr_debug())
{
    scr_turn_skip();
    
    if (scr_debug_keycheck(vk_f2))
        scr_debug_fullheal();
    
    if (scr_debug_keycheck(vk_f3))
        scr_raise_party();
    
    if (scr_debug_keycheck(vk_f5))
        scr_wincombat();
    
    if (scr_debug_keycheck(vk_f6))
        scr_weaken_enemies();
    
    if (scr_debug_keycheck(vk_f8))
        scr_weaken_party(true);
    
    if (scr_debug_keycheck(vk_f9))
    {
        global.tension = 0;
        scr_debug_print("TP set to 0%");
    }
    
    if (scr_debug_keycheck(vk_f10))
    {
        global.tension = 250;
        scr_debug_print("TP maxed out!!");
    }
    
    if (scr_debug_keycheck(ord("M")))
    {
        if (audio_is_playing(global.batmusic[1]))
        {
            if (!audio_is_paused(global.batmusic[1]))
                audio_pause_sound(global.batmusic[1]);
            else
                audio_resume_sound(global.batmusic[1]);
        }
    }
}

enum UnknownEnum
{
    Value_0
}
