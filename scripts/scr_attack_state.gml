///scr_attack_state();
image_speed = .4;
movement = ATTACK;

if(scr_animation_hit_frame(3)){
  var xx = 0;
  var yy = 0;
  switch(face){
    case DOWN:
      xx = x;
      yy = y+12;
      break;
      
    case UP:
      xx = x;
      yy = y-10;
      break;
      
    case RIGHT:
      xx = x+10;
      yy = y+2;
      break;
      
    case LEFT:
      xx = x-10;
      yy = y+2;
      break;
  } 
  audio_play_sound(snd_sword_attack, 8, false);
  with(instance_create(xx, yy, obj_damage)){
    creator = other.id;
    damage = obj_player_stats.attack;
  }
}
