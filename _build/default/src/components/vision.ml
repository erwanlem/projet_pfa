open Component_defs
open System_defs
open Const

let vision_collision vs collide pos=
  if collide = "player" then 
  vs#ppos#set Vector.{x = (Vector.get_x pos); y = (Vector.get_y pos)};
  vs#seen#set 30

let create id x y h w  = 
  let vs = new vision in
  vs#id#set id;
  vs#texture#set (Texture.color (Hashtbl.find colors "red"));
  vs#pos#set Vector.{x = float x; y = float y};
  vs#rect# set Rect.{width = w; height = h};
  vs#onCollideEvent#set (vision_collision vs);
  vs#isTransparent#set true;
  Collision_system.register (vs:>collidable);
  Draw_system.register (vs:>drawable);
  View_system.register (vs:> drawable);
  vs
