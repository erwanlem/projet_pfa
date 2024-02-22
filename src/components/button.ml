open Component_defs
open System_defs
open Const

let cfg = Config.get_config ()

(* Pour l'instant on utilise la touche entrée pour cliquer *)
let onAction button link key =
  if Hashtbl.mem key cfg.key_return 
    then (reset_systems ();
          Global.set_level link;
          Hashtbl.remove key cfg.key_return)


let create id x y w h color settings =
  let btn = new button in
  btn # pos # set Vector.{ x = float x; y = float y };
  btn # rect # set Rect.{width = w; height = h};
  btn # id # set id;
  btn # texture # set (Color (Gfx.color 0 0 0 125));
  btn # control # set (onAction btn settings.link);
  btn # camera_position # set Vector.{ x = float x; y = float y };

  Draw_system.register (btn :> drawable);
  View_system.register (btn :> drawable);
  Control_system.register (btn :> controlable);

  if settings.text <> "" then
    ignore (Text.create x y w h settings);

  btn