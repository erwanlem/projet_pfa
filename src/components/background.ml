open Component_defs
open System_defs
open Const

let create id settings =
  let box = new box in
  box # pos # set Vector.{ x = 0.; y = 0. };
  box # rect # set Rect.{width = Const.window_width; height = Const.window_height};
  box # id # set id;
  box # mass # set infinity;
  box # layer # set 0;
  (match settings.texture with 
  None -> box # texture # set (Color (Gfx.color 255 255 255 255))
  | Some t -> 
    let res = Gfx.get_resource (Hashtbl.find (Resources.get_textures ()) t) in
    let ctx = Gfx.get_context (Global.window ()) in

    let w, h = Gfx.surface_size res in
    Gfx.debug "%d, %d\n%!" w h;

    let texture = Texture.image_from_surface ctx res 0 0 
          w h Const.window_width Const.window_height in    
    
    box # texture # set texture);
  Draw_system.register (box :> drawable);
  box