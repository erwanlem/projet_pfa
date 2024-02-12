open Component_defs
open System_defs
open Config


let cfg = Config.get_config ()

let player_control player keys =
  (* Déplacement vers la gauche *)
  if Hashtbl.mem keys cfg.key_left then
      (player # velocity # set (Vector.add (Vector.mult (-1.) Const.horz_vel)
      (Vector.{x=0.; y=(player#velocity#get).y}));
      player # direction # set (-1.) )

  (* Déplacement vers la droite *)
  else if Hashtbl.mem keys cfg.key_right then 
      (player # velocity # set (Vector.add (Const.horz_vel)(Vector.{x=0.; y=(player#velocity#get).y}));
      player # direction # set (1.) )
  else player#velocity#set ( Vector.{x=0.; y=(player#velocity#get).y} );

  (* Shoot *)
  if player#level#get > 1 && Hashtbl.mem keys cfg.key_space && Hashtbl.find keys cfg.key_space then
    (let x = (* position de l'élément en fonction de la direction (tirer vers la gauche ou vers la droite) *)
      if player#direction#get > 0. then (Vector.get_x player#pos#get)+.(float (Rect.get_width player#rect#get)) 
      else (Vector.get_x player#pos#get)-.15. in

    (ignore (Bullet.create "bullet" x 
    (Vector.get_y player#pos#get+.10.) 10 10 (Const.bullet_speed *. player#direction#get) 0. (Gfx.color 0 0 0 255)));
    Hashtbl.replace keys cfg.key_space false);

  (* Jump *)
  if Hashtbl.mem keys cfg.key_up && player#grounded#get 
    && Hashtbl.find keys cfg.key_up then
    (player # grounded # set false;
    player # sum_forces # set (Vector.add (player#sum_forces#get) (Const.jump));
    Hashtbl.replace keys cfg.key_up false)
    

let player_collision player collide pos =
  let vect_y_collision = (Vector.get_y pos) -. ((Vector.get_y player#pos#get) +. float (Rect.get_height player#rect#get)) in
  if (collide="ground" || collide="platform") && (Vector.get_y player#sum_forces#get) >= 0. 
    && (int_of_float vect_y_collision) >= 0 && not player#grounded#get then 
    player # grounded # set true;
  
  if collide = "death_box" then player#health#set 0.0;

  if collide = "arrow" then player#health#set (player#health#get -. Const.arch_stats.damage)



let create id x y w h color mass elas lvl =
  let player = new player in
  player # pos # set Vector.{ x = float x; y = float y };
  player # rect # set Rect.{width = w; height = h};
  player # color # set color;
  player # id # set id;
  player # mass # set mass;
  player # elasticity # set elas;
  player # health # set Const.player_health;
  player # control # set (player_control player);
  player # onCollideEvent # set (player_collision player);
  player # grounded # set false;
  player # direction # set 1.;
  player # level # set lvl;
  player # spawn_position # set Vector.{x = float x;y = float y};
  player # camera_position # set Vector.{ x = float x; y = float y };
  Force_system.register (player:>collidable);
  Draw_system.register (player :> drawable);
  Collision_system.register (player:>collidable);
  Move_system.register (player :> movable);
  Control_system.register (player :> controlable);
  View_system.register (player :> drawable);
  Health_system.register (player);
  player
  