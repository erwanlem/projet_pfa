open Component_defs
open System_defs


let cfg = Config.get_config ()

let player_control player keys =
  if Hashtbl.mem keys cfg.key_left then 
      player # velocity # set (Vector.add (Vector.mult (-1.) Const.horz_vel)(Vector.{x=0.; y=(player#velocity#get).y}))
  else if Hashtbl.mem keys cfg.key_right then 
      player # velocity # set (Vector.add (Const.horz_vel)(Vector.{x=0.; y=(player#velocity#get).y}))
  else player#velocity#set ( Vector.{x=0.; y=(player#velocity#get).y} );

  if Hashtbl.mem keys cfg.key_up && player#grounded#get then 
    (player # grounded # set false;
    player # sum_forces # set (Vector.add (player#sum_forces#get) (Const.jump)))


let player_ground_collision player collide =
  if collide = "ground" then player # grounded # set true
  else if collide = "platform" then player # grounded # set true


let create id x y w h color mass elas =
  let char = new character in
  char # pos # set Vector.{ x = float x; y = float y };
  char # rect # set Rect.{width = w; height = h};
  char # color # set color;
  char # id # set id;
  char # mass # set mass;
  char # elasticity # set elas;
  char # control # set (player_control char);
  char # ground_collision # set (player_ground_collision char);
  char # grounded # set false;
  char # camera_position # set Vector.{ x = float x; y = float y };
  Force_system.register (char:>collidable);
  Draw_system.register (char :> drawable);
  Collision_system.register (char:>collidable);
  Move_system.register (char :> movable);
  Control_system.register (char :> controlable);
  Vision_system.register (char :> drawable);
  char
  