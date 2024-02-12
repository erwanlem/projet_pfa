open Component_defs
open System_defs

let cfg = Config.get_config ()

(* Pour l'instant on utilise la touche entrée pour cliquer *)
let onAction button link key =
  if Hashtbl.mem key cfg.key_return 
    then (Global.set_level link;
          Force_system.remove_all ();
          Draw_system.remove_all ();
          Collision_system.remove_all ();
          Move_system.remove_all ();
          View_system.remove_all ();
          Hashtbl.remove key cfg.key_return)



let create id x y w h color link =
  let btn = new button in
  btn # pos # set Vector.{ x = float x; y = float y };
  btn # rect # set Rect.{width = w; height = h};
  btn # color # set color;
  btn # id # set id;
  btn # control # set (onAction btn link);
  btn # camera_position # set Vector.{ x = float x; y = float y };
  Draw_system.register (btn :> drawable);
  View_system.register (btn :> drawable);
  Control_system.register (btn :> controlable);
  btn