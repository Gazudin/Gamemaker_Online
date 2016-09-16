///scr_move_state()
old_x = phy_position_x;
old_y = phy_position_y;

// Get input
scr_get_input();

if(dash_key and obj_player_stats.stamina >= 5){
  state = scr_dash_state;
  alarm[0] = room_speed/6;
  obj_player_stats.stamina -= 5;
  obj_player_stats.alarm[0] = room_speed;
}

if(attack_key){
  image_index = 0;
  state = scr_attack_state;
}

// Get direction
dir = point_direction(0, 0, xaxis, yaxis);

// Get the length
if(xaxis == 0 and yaxis == 0){
  len = 0;
} else {
  len = spd;
  scr_get_face();
}

// Get the hspd and vspd
hspd = lengthdir_x(len, dir);
vspd = lengthdir_y(len, dir);

// Move
phy_position_x += hspd;
phy_position_y += vspd;

// Control the sprite
image_speed = .1;
if(len == 0){
  image_speed = 0;
  image_index = 0;
}

// Control the sprite
var new_sprite = sprite_index;
switch(face){
  case RIGHT:
    new_sprite = spr_player_right;
    break;
    
  case UP:
    new_sprite = spr_player_up;
    break;
    
  case LEFT:
    new_sprite = spr_player_left;
    break;
    
  case DOWN:
    new_sprite = spr_player_down;
    break;
}
// When changing sprite
if(new_sprite != sprite_index){
  sprite_index = new_sprite;
  // Send sprite packet
  var packet = buffer_create(1, buffer_grow, 1);
  buffer_write(packet, buffer_string, "sprite");
  buffer_write(packet, buffer_string, sprite_get_name(new_sprite));
  scr_network_write(Network.TCP_socket, packet, "tcp");
}


// if moved, update position
if(old_x != phy_position_x || old_y != phy_position_y){  

   /*var packet = buffer_create(1, buffer_grow, 1);
    buffer_write(packet, buffer_string, "pos");
    buffer_write(packet, buffer_string, room_get_name(room));
    buffer_write(packet, buffer_u32, x);
    buffer_write(packet, buffer_u32, y);
    pos_id += 1
    
    scr_network_write(Network.UDP_socket, packet, "udp");
    */
    
    var packet = buffer_create(1, buffer_grow, 1);
    buffer_write(packet, buffer_string, "pos");
    buffer_write(packet, buffer_u32, x);
    buffer_write(packet, buffer_u32, y);
    scr_network_write(Network.TCP_socket, packet, "tcp");
} else {
  image_speed = 0;
  image_index = 0;
  
  // Send idle packet
  var packet = buffer_create(1, buffer_grow, 1);
  buffer_write(packet, buffer_string, "idle");
  scr_network_write(Network.TCP_socket, packet, "tcp");
}
