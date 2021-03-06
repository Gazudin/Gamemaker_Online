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
         
        goto_room = asset_get_index(target_room);
        room_goto(goto_room);
        audio_stop_sound(System.bgm);
        System.bgm = bgm_wild_arms_overworld;
        audio_play_sound(System.bgm, 5, true);
        audio_sound_gain(System.bgm, System.bgm_volume, 0);
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
    hp = buffer_read(argument0, buffer_u16);
    maxhp = buffer_read(argument0, buffer_u16);
    
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
        hp = other.hp;
        maxhp = other.maxhp;
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
    
    // Check if that user is already created
    with(obj_user){
      if(username == other.username){
        other.foundPlayer = id;
        break;
      }
    }
    // Did we find that user
    if(foundPlayer != -1){
      // then move user
      with(foundPlayer){
        target_x = other.target_x;
        target_y = other.target_y;
        if(movement != attacking){
          movement = MOVE;
          image_speed = image_spd
        }
      }
    }
    break;
      
  // Player changed face direction
  case "FACE":
    username = buffer_read(argument0, buffer_string);
    face = buffer_read(argument0, buffer_u8);
    if(instance_exists(obj_user)){
      with(obj_user){
        if(username == other.username){
          face = other.face;
        }
      }
    }
    break; 
    
  // Enemy updates position
  case "ENEMY POS":
    ID = buffer_read(argument0, buffer_string);
    target_x = buffer_read(argument0, buffer_u16);
    target_y = buffer_read(argument0, buffer_u16);
    
    foundEnemy = -1;
    
    // Check if that enemy is already created
    with(obj_enemy_parent){
      if(ID == other.ID){
        other.foundEnemy = id;
        break;
      }
    }
    // Did we find that enemy
    if(foundEnemy != -1){
      // Then move enemy
      with(foundEnemy){
        movement = MOVE;
        target_x = other.target_x;
        target_y = other.target_y;
      }
    }
    break;
      
  // Enemy changed direction
  case "ENEMY FACE":
    ID = buffer_read(argument0, buffer_string);
    face = buffer_read(argument0, buffer_u8);
    if(instance_exists(obj_enemy_parent)){
      with(obj_enemy_parent){
        if(ID == other.ID){
          face = other.face;
        }
      }
    }
    break;
    
  case "SPAWN ENEMY":
    ID = buffer_read(argument0, buffer_string);
    asset = buffer_read(argument0, buffer_string);
    spawn_x = buffer_read(argument0, buffer_u16);
    spawn_y = buffer_read(argument0, buffer_u16);
    hp = buffer_read(argument0, buffer_u16);
    maxhp = buffer_read(argument0, buffer_u16);
    expr = buffer_read(argument0, buffer_u16);
    
    // Create the enemy
    with(instance_create(spawn_x, spawn_y, asset_get_index(asset))){
      ID = other.ID;
      hp = other.hp;
      maxhp = other.maxhp;
      expr = other.expr;
    };
    break;
      
  // User stopped moving
  case "IDLE":
    username = buffer_read(argument0, buffer_string);
    with(obj_user){
      if(username == other.username){
        movement = IDLE;
        image_speed = 0;
        image_index = 0;
      }
    }
    break;
      
  // Enemy stopped moving
  case "ENEMY IDLE":
    ID = buffer_read(argument0, buffer_string);
    if(instance_exists(obj_enemy_parent)){
      with(obj_enemy_parent){
        if(ID == other.ID){
          movement = IDLE;
          image_speed = image_spd;
        }
      }
    }
    break;
    
  case "CHAT":
    message = buffer_read(argument0, buffer_string);
    if(instance_exists(Chat)){
      ds_list_add(Chat.chat_log, message);
    }
    break;
  
  case "SPRITE":
    username = buffer_read(argument0, buffer_string);
    sprite = buffer_read(argument0, buffer_string);
    with(obj_user){
      if(username == other.username){
        sprite_index = asset_get_index(other.sprite);
      }
    }
    break;
  
  case "DASH":
    username = buffer_read(argument0, buffer_string);
    with(obj_user){
      if(username == other.username){
        dashing = true;
        alarm[0] = room_speed/7;
      }
    }
    break;
      
  case "ATTACK":
    username = buffer_read(argument0, buffer_string);
    face = buffer_read(argument0, buffer_u8);
    with(obj_user){
      if(username == other.username){
        image_index = 0;
        image_speed = .4;
        face = other.face;
        movement = ATTACK;
        attacking = true;
      }
    }
    break;
    
    
  case "DAMAGE ENEMY":
    ID = buffer_read(argument0, buffer_string);
    damage = buffer_read(argument0, buffer_u16);
    xforce = buffer_read(argument0, buffer_s16)/1000;
    yforce = buffer_read(argument0, buffer_s16)/1000;
    
    foundEnemy = -1;
    
    // Check if that enemy exists
    with(obj_enemy_parent){
      if(ID == other.ID){
        other.foundEnemy = id;
        break;
      }
    }
    // did we find that enemy
    if(foundEnemy != -1){
      // then damage enemy
      with(foundEnemy){
        hp -= other.damage;
        physics_apply_impulse(x, y, other.xforce, other.yforce);
      }
    }
    break;  
    
  case "KILL ENEMY":
    ID = buffer_read(argument0, buffer_string);
    
    foundEnemy = -1;
    
    // Check if that enemy exists
    with(obj_enemy_parent){
      if(ID == other.ID){
        other.foundEnemy = id;
        break;
      }
    }
    // did we find that enemy
    if(foundEnemy != -1){
      // then kill enemy
      with(foundEnemy){
        instance_destroy();
      }
    }
    break;
    
          
  case "DAMAGE USER":
    username = buffer_read(argument0, buffer_string);
    damage = buffer_read(argument0, buffer_u16);
    xforce = buffer_read(argument0, buffer_s16)/1000;
    yforce = buffer_read(argument0, buffer_s16)/1000;
    
    foundUser = -1;
    
    if(instance_exists(obj_player_user_parent)){
      // Check if that user exists
      with(obj_player_user_parent){
        if(username == other.username){
          other.foundUser = id;
          break;
        }
      }
      // Did we find that user
      if(foundUser != -1){
        // Then damage user
        with(foundUser){
          if(username == obj_player.username){
            obj_player_stats.hp -= other.damage;
          } else {
            hp -= other.damage;
          }
          image_speed = 0;
          image_index = 0;
          movement = KNOCKBACK;
          physics_apply_impulse(x, y, other.xforce, other.yforce);
        }
      }
    }
    break;

    
  case "AI HOST":
    username = buffer_read(argument0, buffer_string);
    
    if(instance_exists(obj_player)){
      with(obj_player){
        if (username == other.username){
          AI_host = true;
        } else {
          AI_host = false;
        }
      }
    }
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
