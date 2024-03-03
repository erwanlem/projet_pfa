open Component_defs
open System_defs
open Const

let cfg = Config.get_config ()

let create x y w h settings =
  let txt = new text in
  txt # pos # set Vector.{ x = float x; y = float y };
  txt # camera_position # set Vector.{ x = float x; y = float y };
  txt # rect # set Rect.{width=w; height=h};

  let res = Hashtbl.find (Resources.get_fonts ()) settings.font in
  let ctx = Gfx.get_context (Global.window ()) in
  Gfx.set_color ctx (Gfx.color 255 0 0 255);
  let surf_font = Gfx.render_text ctx settings.text res in

  let fw, fh = Gfx.surface_size surf_font in
  Gfx.debug "Font size = %d, %d\n%!" fw fh;

  txt # texture # set (Image surf_font);
  txt # layer # set 10;

  Draw_system.register (txt :> drawable);
  View_system.register (txt :> drawable);
  txt