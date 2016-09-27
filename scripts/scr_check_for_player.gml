///scr_check_for_player()
if(instance_exists(obj_player_user_parent)){
  // Choose target
  target = instance_nearest(x, y, obj_player_user_parent);
  // Distance to target
  var dis = point_distance(x, y, target.x, target.y);
  // ... in range?
  if(dis < sight){
    state = scr_enemy_chase_state;
    var dir = point_direction(x, y, target.x, target.y);
    xaxis = lengthdir_x(1, dir);
    yaxis = lengthdir_y(1, dir);
  } else {
    scr_enemy_choose_next_state();
  }
} else {
  scr_enemy_choose_next_state();
}
