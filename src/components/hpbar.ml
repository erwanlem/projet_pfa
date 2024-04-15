open Component_defs
open System_defs

let real_time_f bar (dt : float) =
  let percentage = bar # master_hp  /. Const.alexandre_stats.health in
  let w = int_of_float ((float bar # totw # get) *. percentage) in
  bar # updatew w


let create id x y w h alex=
  let hpbar = new hpbar in
  hpbar # id # set id;
  hpbar # master # set (Some(alex));
  hpbar # totw # set w;
  hpbar # pos # set Vector.{x = float x ; y= 50.} ;
  hpbar # camera_position # set Vector.{x = float x ; y= 50.};
  hpbar # rect # set Rect.{width = w; height = h};
  hpbar # hitbox_position # set Vector.{x = float x; y= float y};
  hpbar # hitbox_rect # set Rect.{width = w; height = h};
  hpbar # texture # set (Texture.Color( Gfx.color 255 0 0 255));
  hpbar # layer # set 9;
  hpbar # real_time_fun # set  (real_time_f hpbar);
  (*ignore(Hitbox.create ~layer: 20 "hpbar" hpbar);*)
  Real_time_system.register (hpbar :> real_time);
  Draw_system.register (hpbar :> drawable);
  (*View_system.register (hpbar :> drawable);*)
  hpbar