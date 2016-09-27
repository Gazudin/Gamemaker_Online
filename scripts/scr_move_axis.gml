///scr_move_axis();
movement = MOVE;

var dir = point_direction(0, 0, xaxis, yaxis);
var hspd = lengthdir_x(spd, dir);
var vspd = lengthdir_y(spd, dir);
if(hspd != 0){
  image_xscale = sign(hspd);
}
scr_get_face(dir);

phy_position_x += hspd;
phy_position_y += vspd;

// Send position update if we're host
if(instance_exists(obj_player)){
  if(obj_player.AI_host){
    var packet = buffer_create(1, buffer_grow, 1);
    buffer_write(packet, buffer_string, "enemy pos");
    buffer_write(packet, buffer_string, ID);
    buffer_write(packet, buffer_u32, x);
    buffer_write(packet, buffer_u32, y);
    scr_network_write(Network.TCP_socket, packet, "tcp");
  }
}
