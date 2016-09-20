///scr_move_axis();

var dir = point_direction(0, 0, xaxis, yaxis);
var hspd = lengthdir_x(spd, dir);
var vspd = lengthdir_y(spd, dir);
if(hspd != 0){
  image_xscale = sign(hspd);
}
var tmpFace = face;
scr_get_face(dir);
// Send face packet if face changed
if(face != tmpFace){
  var packet = buffer_create(1, buffer_grow, 1);
  buffer_write(packet, buffer_string, "enemy face");
  buffer_write(packet, buffer_string, ID);
  buffer_write(packet, buffer_u8, face);
  scr_network_write(Network.TCP_socket, packet, "tcp");
}

movement = MOVE;
phy_position_x += hspd;
phy_position_y += vspd;

// Send position update
var packet = buffer_create(1, buffer_grow, 1);
buffer_write(packet, buffer_string, "enemy pos");
buffer_write(packet, buffer_string, ID);
buffer_write(packet, buffer_u32, x);
buffer_write(packet, buffer_u32, y);
scr_network_write(Network.TCP_socket, packet, "tcp");
