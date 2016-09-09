///scr_network_write(socket, buffer, protocol)

// Initialize
var socket = argument0
var buffer = argument1
var protocol = argument2

var packetSize = buffer_tell(buffer);
var bufPacket = buffer_create(1, buffer_grow, 1);

// Write the size and the packet into new buffer
buffer_write(bufPacket, buffer_u8, packetSize + 1);
buffer_copy(buffer, 0, packetSize, bufPacket, 1);
buffer_seek(bufPacket, 0, packetSize + 1);

// Send the packet
switch(protocol){

    case "tcp":
        network_send_raw(socket, bufPacket, buffer_tell(bufPacket))
        break;
        
    case "udp":
        show_debug_message("udp send size: "+
        string(network_send_udp_raw(socket, Network.ip, 
            Network.udp_port, bufPacket, buffer_tell(bufPacket))))
        break;
}

// Destroy the buffers
buffer_delete(argument1);
buffer_delete(bufPacket);
