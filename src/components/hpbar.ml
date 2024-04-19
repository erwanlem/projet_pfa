open Component_defs
open System_defs

let real_time_f bar (dt : float) =
  let ctx = Gfx.get_context (Global.window ()) in 
  let h = Rect.get_height bar#rect#get in

  let percentage = bar # master_hp  /. bar#max_health#get in
  let w = int_of_float ((float bar # totw # get) *. percentage) in

  if bar#player#get then begin
    let margin = 10 in (* margin between heart and bar *)
    bar#max_health#set Const.player_health;
    let heart = Gfx.get_resource (Hashtbl.find (Resources.get_textures ()) "resources/images/green_heart.png") in
    let surface = Gfx.create_surface ctx (h*3 + margin + (bar # totw # get)) (h*3) in

    (* Bar *)
    Gfx.set_color ctx (Gfx.color 0 255 0 255);
    if bar # master_hp > 0. then
      Gfx.fill_rect ctx surface (h*3+margin) h w h;

    Gfx.blit_full ctx surface heart 0 0 32 32 0 0 (h*2) (h*3);
    bar # texture # set (Texture.Image surface)
  end
  else begin
    let margin = 20 in (* margin between heart and bar *)
    bar#max_health#set Const.alexandre_stats.health;
    let heart = Gfx.get_resource (Hashtbl.find (Resources.get_textures ()) "resources/images/red_heart_64.png") in
    let surface = Gfx.create_surface ctx (h*3 + margin + (bar # totw # get)) (h*3) in
    
    (* Bar *)
    Gfx.set_color ctx (Gfx.color 255 0 0 255);
    if bar # master_hp > 0. then begin
      Gfx.fill_rect ctx surface (h*3+margin) h w h;
      Gfx.blit_full ctx surface heart 0 0 64 64 0 0 (h*2) (h*3)
    end;
    bar # texture # set (Image surface)
  end


let create ?(margin = "top") id x y w h master player =
  let hpbar = new hpbar in
  hpbar # id # set id;
  hpbar # master # set (Some master);
  hpbar # totw # set w;
  hpbar # player # set player;
  if margin = "top" then begin
    hpbar # pos # set Vector.{x = float x ; y= 50.} ;
    hpbar # camera_position # set Vector.{x = float x ; y= 50.}
  end else begin
    hpbar # pos # set Vector.{x = float x ; y=float y} ;
    hpbar # camera_position # set Vector.{x = float x ; y=float y}
  end;
  hpbar # rect # set Rect.{width = w; height = h*3};

  let ctx = Gfx.get_context (Global.window ()) in 
  if player then begin
    let margin = 10 in (* margin between heart and bar *)
    hpbar#max_health#set Const.player_health;
    let heart = Gfx.get_resource (Hashtbl.find (Resources.get_textures ()) "resources/images/green_heart.png") in
    let surface = Gfx.create_surface ctx (h*3 + margin + w) (h*3) in

    (* Bar *)
    Gfx.set_color ctx (Gfx.color 0 255 0 255);
    Gfx.fill_rect ctx surface (h*3+margin) h w h;

    Gfx.blit_full ctx surface heart 0 0 32 32 0 0 (h*3) (h*3);
    hpbar # texture # set (Image surface)
  end
  else begin
    let margin = 20 in (* margin between heart and bar *)
    hpbar#max_health#set Const.alexandre_stats.health;
    let heart = Gfx.get_resource (Hashtbl.find (Resources.get_textures ()) "resources/images/red_heart_64.png") in
    let surface = Gfx.create_surface ctx (h*3 + margin + w) (h*3) in
    
    (* Bar *)
    Gfx.set_color ctx (Gfx.color 255 0 0 255);
    Gfx.fill_rect ctx surface (h*3+margin) h w h;

    Gfx.blit_full ctx surface heart 0 0 64 64 0 0 (h*3) (h*3);
    hpbar # texture # set (Image surface)
  end;

  
  hpbar # layer # set 20;
  hpbar # real_time_fun # set  (real_time_f hpbar);

  Real_time_system.register (hpbar :> real_time);
  Draw_system.register (hpbar :> drawable);

  hpbar