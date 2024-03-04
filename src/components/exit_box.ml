open Component_defs
open System_defs
open Const



let onCollide box dest collide pos =
  (* On reset tous les systèmes *)
  if collide = "player" then begin
  reset_systems ();
  Global.set_level dest
  end


let create id x y w h settings =
  let box = new box in
  box # pos # set Vector.{ x = float x; y = float y };
  box # rect # set Rect.{width = w; height = h};
  box # hitbox_rect # set Rect.{width = w; height = h};
  box # id # set id;
  box # mass # set infinity;
  box # onCollideEvent # set (onCollide box settings.link);

  Collision_system.register (box:>collidable);
  box