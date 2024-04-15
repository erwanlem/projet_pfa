open Component_defs
open System_defs

let medkit_collide medkit collide _ =
  if collide = "player" then (
  Draw_system.unregister (medkit :> drawable);
  Collision_system.unregister (medkit :> collidable);
  View_system.unregister (medkit :> drawable))
else ()


let create id x y  =
  let box = new box in
  box # pos # set Vector.{ x = float x ; y =float y };
  box # rect # set Const.medkit_size;
  box # hitbox_rect # set Const.medkit_size;
  box # id # set id;
  box # onCollideEvent # set (medkit_collide box);
  box # layer # set 9;

  let res = Gfx.get_resource (Hashtbl.find (Resources.get_textures ()) "resources/images/food.png") in
  let ctx = Gfx.get_context (Global.window ()) in
  let texture1 = Texture.image_from_surface ctx res 32 (6*16) 16 16 16 16 in
  box#texture#set texture1;

  (*let res = Gfx.get_resource (Hashtbl.find (Resources.get_textures ()) "resources/images/flame.png") in
  let ctx = Gfx.get_context (Global.window ()) in

  let texture = 
    if dir_x > 0. then Texture.anim_from_surface ctx res 6 512 197 128 49 5 1
    else Texture.anim_from_surface ctx res 6 512 197 128 49 5 0 in
    *)

  Draw_system.register (box :> drawable);
  Collision_system.register (box:>collidable);
  View_system.register (box :> drawable);
  box