///scr_enemy_chase_state()
scr_check_for_player();
var dir = point_direction(x, y, targetX, targetY);
var hspd = lengthdir_x(spd, dir);
var vspd = lengthdir_y(spd, dir);
if(sign(hspd) != 0){
  image_xscale = sign(hspd);
}
phy_position_x += hspd;
phy_position_y += vspd;
