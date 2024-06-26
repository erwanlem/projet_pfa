open Component_defs
open System_defs
open Const



let create ?(layer =20) ?(col = Gfx.color 30 30 30 50) id master_obj =
  let box = new box in
  box # set_mutable_pos master_obj#pos;
  box # rect # set (master_obj#hitbox_rect#get);
  box # id # set id;
  box # hitbox_display # set (master_obj#hitbox_position # get);
  box # mass # set 50.;
  box # layer # set layer;
  box # texture # set (Texture.Color col);
  box # camera_position # set (master_obj#camera_position#get);
  Draw_system.register (box :> drawable);
  View_system.register (box :> drawable);
  box