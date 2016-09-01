//argument:0 data buffer
var command = buffer_read(argument0, buffer_string)
show_debug_message("Networking Event: " + string(command))

switch(command){

    case "HELLO":
        Network.server_status = "online"
        Network.timer_start = get_timer()/1000 // got response, reset timeout timer
        server_time = buffer_read(argument0, buffer_string)
        show_debug_message("Server welcomes you @ " + server_time)
        break
    
    case "PING":
        // update ping
        Network.ping_sent = false;
        _timer = get_timer()/1000 // get timer once
        Network.ping = _timer - Network.ping_start
        Network.ping_start = _timer
        Network.timer_start = _timer
        break;
      
    case "LOGIN":
        status = buffer_read(argument0, buffer_string)
        switch(status){
            // log in user
            case "TRUE":
                target_room = buffer_read(argument0, buffer_string)
                target_x = buffer_read(argument0, buffer_u16)
                target_y = buffer_read(argument0, buffer_u16)
                username = buffer_read(argument0, buffer_string)
                game_role = buffer_read(argument0, buffer_string)
                 
                goto_room = asset_get_index(target_room);
                room_goto(goto_room);
                // Initiate a player object on this room
                with(instance_create(target_x, target_y, obj_Player)){
                    visible = false
                    username = other.username
                    game_role = other.game_role
                }
                break; 
            // deny login
            case "FALSE":
                show_message("Login Failed: User doesn't exist or password incorrect");
                break;
            // user already logged in
            case "INGAME":
                show_message("Login Failed: User is already logged in!")
                break;
        }
        break;
      
    // currently not used
    /*case "REGISTER":
        status = buffer_read(argument0, buffer_string)
        if(status == "TRUE"){
            show_message("Register Success: Please Login.")
        }else{
            show_message("Registe Failed: Username Taken.")
        }
        break;*/
    
    // a user enters the current room
    case "ENTER ROOM":
        username = buffer_read(argument0, buffer_string)
        pos_x = buffer_read(argument0, buffer_u16)
        pos_y = buffer_read(argument0, buffer_u16)
        
        // is user already in room
        foundUser = -1
        with(obj_User){
            if(username == other.username){
                foundUser = id
                break
            }
        }
        
        // didn't find the user, create it
        if(foundUser == -1){
            with(instance_create(pos_x, pos_y, obj_User)){
                username = other.username
                x = other.pos_x
                y = other.pos_y
            }
        }
        break;
    
    // other user logged out
    case "LOGOUT":
        username = buffer_read(argument0, buffer_string)
        with(obj_User){
            if(username == other.username){
                instance_destroy()
                break
            }
        }
        
        break
        
    // other user updates position
    case "POS":
        username = buffer_read(argument0, buffer_string)
        pos_x = buffer_read(argument0, buffer_u16)
        pos_y = buffer_read(argument0, buffer_u16)
        
        foundPlayer = -1
        
        // check if that user is already created
        with(obj_User){
            if(username == other.username){
                other.foundPlayer = id
                break
            }
        }
        // did we find that user
        if(foundPlayer != -1){
            // then move user
            with(foundPlayer){
                x = other.pos_x
                y = other.pos_y
            }
        // if not, create the user
        } else {
            with(instance_create(pos_x, pos_y, obj_User)){
                username = other.username
            }
        }
        break
    
    case "PUSSY":
        username = buffer_read(argument0, buffer_string)
        xx = buffer_read(argument0, buffer_u16)
        yy = buffer_read(argument0, buffer_u16)
        
        System.pussytext = string(username) + " just rekt that pussy! Now go find another one."
        
        if(instance_exists(obj_pussy)){
            with(obj_pussy){
                instance_destroy()
            }
        }
        if(!instance_exists(obj_pussy)){
            instance_create(xx, yy, obj_pussy)
        }
        
        break

        
}
