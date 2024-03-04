open Component_defs
open System_defs
open Const



let create id master_obj =
  let box = new box in
  box # pos # set (master_obj#pos#get);
  box # rect # set (master_obj#hitbox_rect#get);
  box # id # set id;
  box # mass # set 50.;
  box # layer # set 20;
  box # texture # set (Texture.Color (Gfx.color 255 0 0 128));
  box # camera_position # set (master_obj#camera_position#get);
  Draw_system.register (box :> drawable);
  View_system.register (box :> drawable);
  box