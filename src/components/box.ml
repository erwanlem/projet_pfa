open Component_defs
open System_defs

let create id x y w h mass texture =
  let box = new box in
  box # pos # set Vector.{ x = float x; y = float y };
  box # rect # set Rect.{width = w; height = h};
  box # id # set id;
  box # mass # set mass;
  (match texture with 
  None -> box # texture # set (Color (Gfx.color 0 255 128 255))
  | Some t -> box # texture # set t);
  box # camera_position # set Vector.{ x = float x; y = float y };
  Force_system.register (box:>collidable);
  Draw_system.register (box :> drawable);
  Collision_system.register (box:>collidable);
  Move_system.register (box :> movable);
  View_system.register (box :> drawable);
  box