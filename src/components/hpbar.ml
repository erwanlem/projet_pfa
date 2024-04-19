open Component_defs
open System_defs

let real_time_f bar (dt : float) =
  if bar # master_hp > 0. then
    let percentage = bar # master_hp  /. Const.alexandre_stats.health in
    let w = int_of_float ((float bar # totw # get) *. percentage) in
    bar # updatew w
  else
    bar # updatew 0


let create ?(margin = "top") id x y w h master =
  let hpbar = new hpbar in
  hpbar # id # set id;
  hpbar # master # set (Some master);
  hpbar # totw # set w;
  if margin = "top" then begin
    hpbar # pos # set Vector.{x = float x ; y= 50.} ;
    hpbar # camera_position # set Vector.{x = float x ; y= 50.}
  end else begin
    hpbar # pos # set Vector.{x = float x ; y=float y} ;
    hpbar # camera_position # set Vector.{x = float x ; y=float y}
  end;
  hpbar # rect # set Rect.{width = w; height = h};
  hpbar # texture # set (Texture.Color( Gfx.color 255 0 0 255));
  hpbar # layer # set 20;
  hpbar # real_time_fun # set  (real_time_f hpbar);

  Real_time_system.register (hpbar :> real_time);
  Draw_system.register (hpbar :> drawable);

  hpbar