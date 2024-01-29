open Component_defs
open System_defs

let create id x y w h color mass =
  let box = new box in
  box # pos # set Vector.{ x = float x; y = float y };
  box # rect # set Rect.{width = w; height = h};
  box # color # set color;
  box # id # set id;
  box # mass # set mass;
  Force_system.register (box :> collidable);
  Move_system.register (box :> movable);
  Draw_system.register (box :> drawable);
  Collision_system.register (box :> collidable);
  box