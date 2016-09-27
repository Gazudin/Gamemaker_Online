///scr_move_state()
movement = MOVE;
old_x = phy_position_x;
old_y = phy_position_y;

if(Input.dash_key){
  var xdir = lengthdir_x(8, face*90);
  var ydir = lengthdir_y(8, face*90);
  var speaker = instance_place(x+xdir, y+ydir, obj_speaker);
  if(speaker != noone){
    // Talk to it
    with(speaker){
      if(!instance_exists(obj_dialog)){
        dialog = instance_create(x+xoffset, y+yoffset, obj_dialog);
        dialog.text = text;
      } else {
        dialog.text_page++;
        dialog.text_count = 0;
        if(dialog.text_page > array_length_1d(dialog.text)-1){
          with(dialog){
            instance_destroy();
          }
        } 
      }
    }
  } else if(obj_player_stats.stamina >= 5){
    state = scr_dash_state;
    alarm[0] = room_speed/6;
    obj_player_stats.stamina -= 5;
    obj_player_stats.alarm[0] = room_speed;
    // Send dash packet
    var packet = buffer_create(1, buffer_grow, 1);
    buffer_write(packet, buffer_string, "dash");
    scr_network_write(Network.TCP_socket, packet, "tcp");
  }
}


if(Input.attack_key){
  image_index = 0;
  movement = ATTACK;
  state = scr_attack_state;
  // Send attack packet
  var packet = buffer_create(1, buffer_grow, 1);
  buffer_write(packet, buffer_string, "attack");
  buffer_write(packet, buffer_u8, face); // Direction to attack
  scr_network_write(Network.TCP_socket, packet, "tcp");
}


if(Input.spell_key){
  var p = instance_create(x, y, obj_projectile);
  var xforce = lengthdir_x(15, face*90);
  var yforce = lengthdir_y(15, face*90);
  p.creator = id;
  with(p){
    physics_apply_impulse(x, y, xforce, yforce);
  }
}

// Get direction
dir = point_direction(0, 0, Input.xaxis, Input.yaxis);

// Get the length
if(Input.xaxis == 0 and Input.yaxis == 0){
  len = 0;
} else {
  len = spd;
  var tmpFace = face;
  scr_get_face(dir);
  // Send face packet if face changed
  if(face != tmpFace){
    var packet = buffer_create(1, buffer_grow, 1);
    buffer_write(packet, buffer_string, "face");
    buffer_write(packet, buffer_string, username);
    buffer_write(packet, buffer_u8, face);
    scr_network_write(Network.TCP_socket, packet, "tcp");
  }
}

// Get the hspd and vspd
hspd = lengthdir_x(len, dir);
vspd = lengthdir_y(len, dir);

// Move
phy_position_x += hspd;
phy_position_y += vspd;

// Check if moving
if(old_x == phy_position_x and old_y == phy_position_y){ // Not moving
  image_index = 0;
  image_speed = 0;
  
  // If not already in idle
  if(!idle){
    // Send idle packet
    var packet = buffer_create(1, buffer_grow, 1);
    buffer_write(packet, buffer_string, "idle");
    scr_network_write(Network.TCP_socket, packet, "tcp");
    idle = true;
  }
} else { // If moving, update position
  idle = false; // Not idle any more when moving
  image_speed = image_spd;
  // update old x/y
  old_x = phy_position_x;
  old_y = phy_position_y;

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
}



