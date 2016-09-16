//argument:0 data buffer
var command = buffer_read(argument0, buffer_string);
if(command != "PING"){
  show_debug_message("Networking Event: " + string(command));
}

switch(command){

  case "HELLO":
    Network.server_status = "online";
    server_time = buffer_read(argument0, buffer_string);
    show_debug_message("Server welcomes you @ " + server_time);
    break;
        
    
  case "PING":
    // update ping
    Network.ping_sent = false;
    var _timer = get_timer()/1000; // get timer once
    Network.ping = _timer - Network.ping_start;
    Network.ping_start = _timer;
    break;
        
      
  case "LOGIN":
    status = buffer_read(argument0, buffer_string);
    switch(status){
      // log in user
      case "TRUE":
        target_room = buffer_read(argument0, buffer_string);
        target_x = buffer_read(argument0, buffer_u16);
        target_y = buffer_read(argument0, buffer_u16);
        username = buffer_read(argument0, buffer_string);
        game_role = buffer_read(argument0, buffer_string);
            
        // Stats
        level = buffer_read(argument0, buffer_u16);
        expr = buffer_read(argument0, buffer_u16);
        maxexpr = buffer_read(argument0, buffer_u16);
        hp = buffer_read(argument0, buffer_u16);
        maxhp = buffer_read(argument0, buffer_u16);
        stamina = buffer_read(argument0, buffer_u16);
        maxstamina = buffer_read(argument0, buffer_u16);
        attack = buffer_read(argument0, buffer_u16);
        
        show_debug_message('Got level: '+string(level));
        show_debug_message('Got expr: '+string(expr));
        show_debug_message('Got maxexpr: '+string(maxexpr));
        show_debug_message('Got hp: '+string(hp));
        show_debug_message('Got maxhp: '+string(maxhp));
        show_debug_message('Got stamina: '+string(stamina));
        show_debug_message('Got maxstamina: '+string(maxstamina));
        show_debug_message('Got attack: '+string(attack));
         
        goto_room = asset_get_index(target_room);
        room_goto(goto_room);
        audio_stop_sound(System.bgm);
        System.bgm = bgm_wild_arms_overworld;
        audio_play_sound(System.bgm, 5, true);
        // Initiate a player object on this room
        with(instance_create(target_x, target_y, obj_player)){
            username = other.username;
            game_role = other.game_role;
        }
        
        // Create player stats
        with(instance_create(0, 0, obj_player_stats)){
          level = other.level;
          expr = other.expr;
          maxexpr = other.maxexpr;
          hp = other.hp;
          maxhp = other.maxhp;
          stamina = other.stamina;
          maxstamina = other.maxstamina;
          attack = other.attack;
        }
        if(!instance_exists(Chat)){
            instance_create(0,0,Chat);
        }
        break;
        // deny login
        case "FALSE":
          show_message("Login Failed: User doesn't exist or password incorrect");
          break;
            
        // user already logged in
        case "INGAME":
          show_message("Login Failed: User is already logged in!");
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
    username = buffer_read(argument0, buffer_string);
    pos_x = buffer_read(argument0, buffer_u16);
    pos_y = buffer_read(argument0, buffer_u16);
    // is user already in room
    foundUser = -1;
    with(obj_user){
        if(username == other.username){
            foundUser = id;
            break;
        }
    }
    // didn't find the user, create it
    if(foundUser == -1){
      with(instance_create(pos_x, pos_y, obj_user)){
        username = other.username;
        x = other.pos_x;
        y = other.pos_y;
      }
    }
    break;
  
  // other user logged out
  case "LOGOUT":
    username = buffer_read(argument0, buffer_string);
    with(obj_user){
      if(username == other.username){
        instance_destroy();
        break;
      }
    }
    break;
    
  // other user leaves the room
  case "LEAVE ROOM":
    username = buffer_read(argument0, buffer_string)
    with(obj_user){
      if(username == other.username){
        instance_destroy();
        break;
      }
    }
    break;
      
  // other user updates position
  case "POS":
    username = buffer_read(argument0, buffer_string);
    target_x = buffer_read(argument0, buffer_u16);
    target_y = buffer_read(argument0, buffer_u16);
    
    foundPlayer = -1;
    
    // check if that user is already created
    with(obj_user){
      if(username == other.username){
        other.foundPlayer = id;
        break;
      }
    }
    // did we find that user
    if(foundPlayer != -1){
      // then move user
      with(foundPlayer){
        target_x = other.target_x;
        target_y = other.target_y;
      }
    // if not, create the user
    } else {
      with(instance_create(target_x, target_y, obj_user)){
        username = other.username;
      }
    }
    break
      
  // User stopped moving
  case "IDLE":
    username = buffer_read(argument0, buffer_string);
    with(obj_user){
      if(username == other.username){
        image_speed = 0;
        image_index = 0;
      }
    }
    break;
    
  case "CHAT":
    message = buffer_read(argument0, buffer_string);
    if(instance_exists(Chat)){
      show_message("receivec message");
      ds_list_add(Chat.chat_log, message);
    }
    break;
  
  case "SPRITE":
    username = buffer_read(argument0, buffer_string);
    sprite = buffer_read(argument0, buffer_string);
    with(obj_user){
      if(username == other.username){
        show_debug_message('Found user: '+username);
        sprite_index = asset_get_index(other.sprite);
      }
    }
    break;
      
  case "DASH":
  
    break;
      
  case "ATTACK":
    break;
      
  case "PUSSY":
    username = buffer_read(argument0, buffer_string);
    xx = buffer_read(argument0, buffer_u16);
    yy = buffer_read(argument0, buffer_u16);     
    System.pussytext = string(username) + " just rekt that pussy! Now go find another one."
    if(instance_exists(obj_pussy)){
        with(obj_pussy){
            instance_destroy();
        }
    }
    instance_create(xx, yy, obj_pussy);
    break;
        
}
