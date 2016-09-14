///scr_enemy_chase_state()
scr_check_for_player();
phy_position_x += sign(targetX - x)*spd;
phy_position_y += sign(targetY - y)*spd;
