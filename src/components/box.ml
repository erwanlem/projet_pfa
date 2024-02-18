open Component_defs
open System_defs
open Const

let create id x y w h mass settings =
  let box = new box in
  box # pos # set Vector.{ x = float x; y = float y };
  box # rect # set Rect.{width = w; height = h};
  box # id # set id;
  box # mass # set mass;
  (match settings.texture with 
  None -> box # texture # set (Color settings.color)
  | Some t -> 
    let res = Gfx.get_resource (Hashtbl.find (Resources.get_textures ()) t) in
    let ctx = Gfx.get_context (Global.window ()) in
    
    if settings.animation > 0 then
      (
        let texture = Texture.anim_from_surface ctx res settings.animation 64 64 64 64 
                  20 (settings.t_y*64) in
        box # texture # set texture
      )
    else
      (
        let surface_tmp = Gfx.create_surface ctx w h in

        let rec loop i =
          if i <= (w/(settings.t_w*64)*settings.t_w) then
            (Gfx.blit_full ctx surface_tmp res (settings.t_x*64) (settings.t_y*64) (settings.t_w*64)
            (settings.t_h*64) (i*64) 0 (settings.t_w*64) (settings.t_h*64);
            loop (i+settings.t_w));
        in loop 0; 

        box # texture # set (Image surface_tmp)
      )
    
    );
  box # camera_position # set Vector.{ x = float x; y = float y };
  Force_system.register (box:>collidable);
  Draw_system.register (box :> drawable);
  Collision_system.register (box:>collidable);
  Move_system.register (box :> movable);
  View_system.register (box :> drawable);
  box