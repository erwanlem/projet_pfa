open Component_defs
open System_defs

let bullet_collide bullet collide =
  (* Détruire *)
  Force_system.unregister (bullet :> collidable);
  Draw_system.unregister (bullet :> drawable);
  Collision_system.unregister (bullet :> collidable);
  Move_system.unregister (bullet :> movable);
  Vision_system.unregister (bullet :> drawable)


let create id x y w h dir_x dir_y color =
  let box = new box in
  box # pos # set Vector.{ x = float x; y = float y };
  box # rect # set Rect.{width = w; height = h};
  box # color # set color;
  box # id # set id;
  box # mass # set 1.;
  box # velocity # set Vector.{x=dir_x; y=dir_y};
  box # onCollideEvent # set (bullet_collide box);
  box # camera_position # set Vector.{ x = float x; y = float y };
  Force_system.register (box:>collidable);
  Draw_system.register (box :> drawable);
  Collision_system.register (box:>collidable);
  Move_system.register (box :> movable);
  Vision_system.register (box :> drawable);
  box