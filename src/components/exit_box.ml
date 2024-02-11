open Component_defs
open System_defs



let onCollide box dest collide pos =
  (* On reset tous les systèmes *)
  if collide = "player" then begin
  Force_system.remove_all ();
  Draw_system.remove_all ();
  Collision_system.remove_all ();
  Move_system.remove_all ();
  View_system.remove_all ();
  Global.set_level dest
  end
  


let create id x y w h dest =
  let box = new box in
  box # pos # set Vector.{ x = float x; y = float y };
  box # rect # set Rect.{width = w; height = h};
  box # id # set id;
  box # mass # set infinity;
  box # onCollideEvent # set (onCollide box dest);
  box # camera_position # set Vector.{ x = float x; y = float y };
  Collision_system.register (box:>collidable);
  box