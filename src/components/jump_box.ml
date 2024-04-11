open Component_defs
open System_defs
open Const


let onCollide box collide pos =
  let vect_y_collision = (Vector.get_y pos) -. (Vector.get_y box#pos#get) in
  if (int_of_float vect_y_collision) > 0 then 
    (box # elasticity # set 0.)
  else (box # elasticity # set 4.)


let create id x y w h mass settings =
  let box = new box in
  box # pos # set Vector.{ x = float x; y = float y };
  box # rect # set Rect.{width = w; height = h};
  box # hitbox_rect # set Rect.{width = w; height = h};

  (match settings.texture with 
  None -> box # texture # set (Color (Gfx.color 0 255 128 255))
  | Some t -> 
    let res = Gfx.get_resource (Hashtbl.find (Resources.get_textures ()) t) in
    let ctx = Gfx.get_context (Global.window ()) in
    
    let surface_tmp = Gfx.create_surface ctx w h in
    for i = 0 to (w/(settings.t_w*block_size))-1 do
      Gfx.blit_full ctx surface_tmp res (settings.t_x*64) (settings.t_y*64) (settings.t_w*64)
                   (settings.t_h*64) (i*block_size) 0 (settings.t_w*block_size) (settings.t_h*block_size);
    done;
    box # texture # set (Image surface_tmp)
    );
  box # id # set id;
  box # layer # set 8;
  box # mass # set mass;
  box # elasticity # set 0.;
  box # camera_position # set Vector.{ x = float x; y = float y };
  box # onCollideEvent # set (onCollide box);
  Force_system.register (box:>collidable);
  Draw_system.register (box :> drawable);
  Collision_system.register (box:>collidable);
  Move_system.register (box :> movable);
  View_system.register (box :> drawable);
  box