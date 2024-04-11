open Component_defs
open System_defs
open State

let update_sword_anim knight i frame maxframe dir =
  Texture.Color(Gfx.color 0 0 0 0)
  (*
  let res = Gfx.get_resource (try Hashtbl.find (Resources.get_textures ()) "resources/images/knight_attack.png"
                                    with Not_found -> failwith "In alive.ml : Resource not found" ) in
  let ctx = Gfx.get_context (Global.window ()) in
  if frame mod (maxframe/6) = 0 then
    i := !i+1;
  if dir = -1. then
    (
      Texture.image_from_surface ctx res (64*(!i)) 64 64 64 64 64)
  else
    Texture.image_from_surface ctx res (64*(!i)) (3*64) 64 64 64 64
*)

let knight_pattern knight _ = 
  let playerpos = (Global.ply()) # pos # get in
  if Vector.dist playerpos (knight#pos#get) < 50.0 && knight # cooldown # get = 0 then
    ( if (State.get_state knight#state#get) = 0 then
        (let i = ref (-1) in
        knight # cooldown # set 20;
         if knight#direction#get = 1. then
           (knight#state#set (State.create_state 1 6 (update_sword_anim knight i));
            knight#state_box#set (Some (Sword_box.create "sword" knight (30.) 0.)))
         else
           (knight#state#set (State.create_state 1 6 (update_sword_anim knight i));
            knight#state_box#set (Some (Sword_box.create "sword" knight (-22.) 0.))))
    )
  else
  (*Avancer vers le joueur*)
  if (Vector.dist playerpos (knight#pos#get) < 350.0) 
    && abs (int_of_float ((Vector.get_x playerpos) -. (Vector.get_x knight#pos#get))) > 10 
    && (State.get_state knight#state#get) = 0
  then begin 
    Texture.pause_animation (knight#texture#get) false;
    knight # velocity # set (Vector.mult (knight # direction # get) !Const.knight_vel) 
  end
  (* Attendre *)
  else begin
    Texture.pause_animation (knight#texture#get) true;
    knight#velocity#set ( Vector.{x=0.; y=(knight#velocity#get).y} ) 
  end;
  ()


let knight_call knight () : unit =
  if not (knight # alive) then  
    (
      Real_time_system.unregister (knight:> real_time);
      Force_system.unregister (knight:>collidable);
      Draw_system.unregister (knight :> drawable);
      Collision_system.unregister (knight:>collidable);
      Move_system.unregister (knight :> movable);
      Ennemy_system.unregister (knight: Component_defs.knight :> mob);
      View_system.unregister (knight :> drawable)
    )
  else
    begin
    let s = knight#state#get in
      if s.kind = 1 then
        (if s.curframe > 0 then
          (knight#texture#set (s.update s.curframe s.maxframe (knight#direction#get)))
        else if s.curframe = 0 then
          (knight#texture#set (knight#anim_recover#get);
          (match knight#state_box#get with
          | Some b -> b#remove_box#get (); knight#state_box#set None
          | None -> ());
          s.kind <- 0);
        s.curframe <- s.curframe - 1;
        );
 
    if knight # cooldown # get > 0 then knight # cooldown # set (knight # cooldown # get -1);
    let playerpos = (Global.ply())#pos#get in
    (*Gfx.debug "Player pos : %f;%f \n %!" (playerpos.x) (playerpos.y);*)
    if playerpos.x > (knight # pos#get ).x then begin
      knight # texture # set (Hashtbl.find (knight # modifiable_texture # get) "texture_left_walk");
      knight #direction # set 1.
    end
    else begin
      knight # texture # set (Hashtbl.find (knight # modifiable_texture # get) "texture_right_walk");
      knight #direction #set (-1.)
    end
  end
  




let knight_collision knight collide pos =
  if collide = "ground" then knight # grounded # set true;
  if collide = "sword_left" || collide = "sword_right" then 
    (knight # take_dmg Const.sword_damage);
  if collide = "exclbr_mel" then knight # take_dmg Const.exclbr_mel_atk;
  if collide = "knight_fb" then knight # take_dmg Const.fbdamage;
  if collide = "exclbr_rgd" then knight # take_dmg Const.exclbr_rgd_atk


let create id x y w h texture  =
  let knight = new knight in
  knight # pos # set Vector.{ x = float x; y = float y };
  knight # id # set id;
  knight # pattern # set (knight_pattern knight);
  knight # grounded # set false;
  knight # hitbox_rect # set Rect.{width = w - 36; height =  h-18} ;
  knight # hitbox_position # set Vector.{x=18.;y=14.};
  knight # rect # set Rect.{width = w; height = h};
  knight # mass # set Const.knight_stats.mass;
  (
    match texture with 
    None -> 
      let res = Gfx.get_resource (Hashtbl.find (Resources.get_textures ()) "resources/images/knight_walk.png") in
      let res2 = Gfx.get_resource (Hashtbl.find (Resources.get_textures ()) "resources/images/knight_attack.png") in
      let ctx = Gfx.get_context (Global.window ()) in
  
      let texture1 = Texture.anim_from_surface ctx res 9 64 64 64 64 3 3 in 
      let texture2 = Texture.anim_from_surface ctx res 9 64 64 64 64 3 1 in 
      let texture3 = Texture.anim_from_surface ctx res2 9 64 64 64 64 3 3 in 
      let texture4 = Texture.anim_from_surface ctx res2 9 64 64 64 64 3 1 in 
      let h = Hashtbl.create 2 in
      Hashtbl.replace h "texture_left_walk" texture1;
      Hashtbl.replace h "texture_right_walk" texture2;
      Hashtbl.replace h "texture_left_attack" texture3;
      Hashtbl.replace h "texture_right_attack" texture4;
      knight # modifiable_texture # set h;
      knight # texture # set texture1
  
    | Some t -> knight # texture # set t);

  (* shows hitbox *)
  ignore (Hitbox.create "knight" knight);

  knight # elasticity # set Const.knight_stats.elas;
  knight # health # set Const.knight_stats.health;
  knight # damage # set Const.knight_stats.damage;
  knight # layer # set 9;
  knight # direction # set (-1.);
  knight # real_time_fun # set (knight_call knight);
  knight # onCollideEvent # set (knight_collision knight);
  Force_system.register (knight:>collidable);
  Draw_system.register (knight :> drawable);
  Collision_system.register (knight:>collidable);
  Move_system.register (knight :> movable);
  Ennemy_system.register (knight :> mob);
  View_system.register (knight :> drawable);
  Real_time_system.register(knight:> real_time);
  knight