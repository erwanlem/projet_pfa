open Component_defs
open System_defs
open Const



let remove_sword sword () =
  Draw_system.unregister (sword :> drawable);
  Collision_system.unregister (sword :> collidable);
  View_system.unregister (sword :> drawable)


let collision_function sword collide pos =
  Gfx.debug "Sword collide %s\n%!" collide



let create id master_obj x y =
  let box = new state_box in
  box # set_mutable_pos master_obj#pos;
  box # hitbox_position # set (Vector.add master_obj#hitbox_position#get Vector.{x;y});
  box # hitbox_rect # set Rect.{width=18;height=40};
  box # rect # set Rect.{width=18;height=40};
  box # id # set id;
  box # hitbox_display # set (Vector.add (master_obj#hitbox_position # get) Vector.{x;y});
  box # mass # set 1.;
  box # layer # set 20;
  box # isTransparent # set true;
  box # onCollideEvent # set (collision_function box);
  box # remove_box # set (remove_sword box); 
  box # texture # set (Texture.Color (Gfx.color 0 0 0 128));
  box # camera_position # set (master_obj#camera_position#get);
  Draw_system.register (box :> drawable);
  Collision_system.register (box :> collidable);
  View_system.register (box :> drawable);
  box