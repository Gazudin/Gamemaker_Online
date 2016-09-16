///scr_enemy_wander_state()
scr_check_for_player();
if(point_distance(x, y, targetX, targetY) >= spd){
  var dir = point_direction(x, y, targetX, targetY);
  var hspd = lengthdir_x(spd, dir);
  var vspd = lengthdir_y(spd, dir);
  if(hspd != 0){
    image_xscale = sign(hspd);
  }
  phy_position_x += hspd;
  phy_position_y += vspd;
}
