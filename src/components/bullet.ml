open Component_defs
open System_defs

let bullet_collide bullet collide pos =
  (* Détruire *)
  if not (collide = "vs" || collide = "appear_box") then begin
    (*Gfx.debug "Destroy bullet with %s\n%!" collide;*)
    Force_system.unregister (bullet :> collidable);
    Draw_system.unregister (bullet :> drawable);
    Collision_system.unregister (bullet :> collidable);
    Move_system.unregister (bullet :> movable);
    View_system.unregister (bullet :> drawable)
  end


let create ?(color=1) id x y w h dir_x dir_y =
  let box = new box in
  box # pos # set Vector.{ x;y };
  box # rect # set Rect.{width = w; height = h};
  box # hitbox_rect # set Rect.{width = w; height = h};
  box # id # set id;
  box # mass # set 10.;
  box # velocity # set Vector.{x=dir_x; y=dir_y};
  box # onCollideEvent # set (bullet_collide box);
  box # camera_position # set Vector.{ x; y };
  box # layer # set 9;

  let res =
  if color = 1 then
    Gfx.get_resource (Hashtbl.find (Resources.get_textures ()) "resources/images/flame.png")
  else
    Gfx.get_resource (Hashtbl.find (Resources.get_textures ()) "resources/images/flame2.png") in
  let ctx = Gfx.get_context (Global.window ()) in

  let texture = 
    if dir_x > 0. then Texture.anim_from_surface ctx res 6 128 50 128 49 5 1
    else Texture.anim_from_surface ctx res 6 128 50 128 49 4 0 in
  box # texture # set texture;

  Draw_system.register (box :> drawable);
  Collision_system.register (box:>collidable);
  Move_system.register (box :> movable);
  View_system.register (box :> drawable);
  box