open Component_defs
open System_defs


let onCollide box collide pos =
  let vect_y_collision = (Vector.get_y pos) -. ((Vector.get_y box#pos#get) +. float (Rect.get_height box#rect#get)) in
  if(int_of_float vect_y_collision) >= 0 then 
    box # elasticity # set 0.
  else box # elasticity # set 2.


let create id x y w h color mass =
  let box = new box in
  box # pos # set Vector.{ x = float x; y = float y };
  box # rect # set Rect.{width = w; height = h};
  box # color # set color;
  box # id # set id;
  box # mass # set mass;
  box # elasticity # set 1.;
  box # camera_position # set Vector.{ x = float x; y = float y };
  box # onCollideEvent # set (onCollide box);
  Force_system.register (box:>collidable);
  Draw_system.register (box :> drawable);
  Collision_system.register (box:>collidable);
  Move_system.register (box :> movable);
  Vision_system.register (box :> drawable);
  box