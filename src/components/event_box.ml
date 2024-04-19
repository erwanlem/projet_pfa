open Component_defs
open System_defs
open Const



let create id x y w h settings =
  let box = new box in
  box # pos # set Vector.{ x = float x; y = float y };
  box # rect # set Rect.{width = w; height = h};
  box # hitbox_rect # set Rect.{width = w; height = h};
  box # id # set id;
  box # mass # set infinity;
  box # isTransparent # set true;

  Collision_system.register (box:>collidable);
  box