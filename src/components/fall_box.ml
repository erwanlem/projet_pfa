open Component_defs
open System_defs
open Const


(* Saves states of fall_box instances *)
let save_box = Hashtbl.create 2

let remove_fall_box () =
  Gfx.debug "REMOVE\n%!";
  Hashtbl.clear save_box

let reset_fall_box_position () =
  Gfx.debug "RESET\n%!";
  Hashtbl.iter (
    fun k (x, y) -> 
      k#pos#set Vector.{x;y};
      k#mass#set infinity;
      k#velocity#set Vector.zero
      ) save_box


let onCollide box collide pos =
  if collide = "player" then begin
    box#pushable#set false;
    box#mass#set 1000.
  end




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

  (* Save to reset origin state *)
  Hashtbl.replace save_box box (float x, float y);

  Force_system.register (box:>collidable);
  Draw_system.register (box :> drawable);
  Collision_system.register (box:>collidable);
  Move_system.register (box :> movable);
  View_system.register (box :> drawable);
  box