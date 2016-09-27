///scr_enemy_idle_state()

// Send idle packet if not idle already
if(movement != IDLE){
  var packet = buffer_create(1, buffer_grow, 1);
  buffer_write(packet, buffer_string, "enemy idle");
  buffer_write(packet, buffer_string, ID);
  scr_network_write(Network.TCP_socket, packet, "tcp");
  idle = true;
}
movement = IDLE;
scr_check_for_player();

