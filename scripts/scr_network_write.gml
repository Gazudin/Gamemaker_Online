///scr_network_write(socket, buffer, protocol)

// Initialize
var packetSize = buffer_tell(argument1);
var bufPacket = buffer_create(1, buffer_grow, 1);

// Write the size and the packet into new buffer
buffer_write(bufPacket, buffer_u8, packetSize + 1);
buffer_copy(argument1, 0, packetSize, bufPacket, 1);
buffer_seek(bufPacket, 0, packetSize + 1);

// Send the packet
switch(argument2){

    case "tcp":
        network_send_raw(argument0, bufPacket, buffer_tell(bufPacket))
        break;
        
    case "udp":
        show_debug_message("udp send size: "+
        string(network_send_udp_raw(network_create_socket(network_socket_udp), "95.143.172.196", 
            61027, bufPacket, buffer_tell(bufPacket))))
        break;
}

// Destroy the buffers
buffer_delete(argument1);
buffer_delete(bufPacket);
