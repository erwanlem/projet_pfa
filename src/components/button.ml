open Component_defs
open System_defs

let create id x y w h color =
  let btn = new button in
  btn # pos # set Vector.{ x = float x; y = float y };
  btn # rect # set Rect.{width = w; height = h};
  btn # color # set color;
  btn # id # set id;
  btn # camera_position # set Vector.{ x = float x; y = float y };
  Draw_system.register (btn :> drawable);
  View_system.register (btn :> drawable);
  btn