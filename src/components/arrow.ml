open Component_defs
open System_defs

let arrow_collide arrow collide pos =
  (* Détruire *)
  Gfx.debug "Destroy arrow with %s\n%!" collide;
  Force_system.unregister (arrow :> collidable);
  Draw_system.unregister (arrow :> drawable);
  Collision_system.unregister (arrow :> collidable);
  Move_system.unregister (arrow :> movable);
  View_system.unregister (arrow :> drawable)


let create id x y w h dir_x =
  let box = new box in
  box # pos # set Vector.{ x;y };
  box # rect # set Const.arrow_size;
  box # hitbox_rect # set Const.arrow_size;
  box # id # set id;
  box # mass # set 10.;
  box # velocity # set (Vector.mult dir_x Const.arrow_speed );
  box # onCollideEvent # set (arrow_collide box);
  box # camera_position # set Vector.{ x; y };
  box # layer # set 9;

  (*let res = Gfx.get_resource (Hashtbl.find (Resources.get_textures ()) "resources/images/flame.png") in
  let ctx = Gfx.get_context (Global.window ()) in

  let texture = 
    if dir_x > 0. then Texture.anim_from_surface ctx res 6 512 197 128 49 5 1
    else Texture.anim_from_surface ctx res 6 512 197 128 49 5 0 in
    *)
  box # texture # set (Texture.color (Gfx.color 0 0 0 255));

  Draw_system.register (box :> drawable);
  Collision_system.register (box:>collidable);
  Move_system.register (box :> movable);
  View_system.register (box :> drawable);
  box