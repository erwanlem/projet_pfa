open Component_defs
open System_defs

let create id x y w h event =
  let box_ev = new event_box in
  box_ev # id # set id;
  box_ev # rect # set Rect.{ width=w; height=h };
  box_ev # color # set (Gfx.color 0 0 0 0);
  box_ev # pos # set Vector.{ x; y };
  box_ev # event # set event;
  Draw_system.register (box_ev :> drawable)
