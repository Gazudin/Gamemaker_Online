///scr_dash_state()
if(len == 0){
  dir = face*90;
}
len = spd*4;

// Get the hspd and vspd
hspd = lengthdir_x(len, dir);
vspd = lengthdir_y(len, dir);

// Move
phy_position_x += hspd;
phy_position_y += vspd;

// Create the dash effect
with(instance_create(x, y, obj_dash_effect)){
  sprite_index = other.sprite_index;
  image_index = other.image_index;
}
 

/*
var packet = buffer_create(1, buffer_grow, 1);
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

