open Component_defs
open System_defs
open Const



let create id master_obj x y =
  let box = new box in
  box # set_mutable_pos master_obj#pos;
  box # hitbox_position # set Vector.{x;y};
  box # hitbox_rect # set Rect.{width=10;height=10};
  box # rect # set Rect.{width=10;height=10};
  box # id # set id;
  box # hitbox_display # set (master_obj#hitbox_position # get);
  box # mass # set 0.;
  box # layer # set 20;
  box # texture # set (Texture.Color (Gfx.color 0 0 0 128));
  box # camera_position # set (master_obj#camera_position#get);
  Draw_system.register (box :> drawable);
  Collision_system.register (box :> collidable);
  View_system.register (box :> drawable);
  box