open Component_defs
open System_defs
open State

let update_sword_anim alexandre i frame maxframe dir =
  Texture.Color(Gfx.color 0 0 0 0)
  (*
  let res = Gfx.get_resource (try Hashtbl.find (Resources.get_textures ()) "resources/images/alexandre_attack.png"
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

let alexandre_pattern alexandre (dt : float) = 
  let playerpos = (Global.ply()) # pos # get in
  if Vector.dist playerpos (alexandre#pos#get) < 50.0 (*&& alexandre # cooldown # get = 0*) then
    ( if (State.get_state alexandre#state#get) = 0 then
        (let i = ref (-1) in
        (*alexandre # cooldown # set 20;*)
         if alexandre#direction#get = 1. then
           (alexandre#state#set (State.create_state 1 6 (update_sword_anim alexandre i));
            alexandre#state_box#set (Some (Sword_box.create "sword" alexandre (30.) 0.)))
         else
           (alexandre#state#set (State.create_state 1 6 (update_sword_anim alexandre i));
            alexandre#state_box#set (Some (Sword_box.create "sword" alexandre (-22.) 0.))))
    )
  else
  if (Vector.dist playerpos (alexandre#pos#get) < 350.0) && (State.get_state alexandre#state#get) = 0 (*Avancer vers le joueur*)
  then alexandre # velocity # set (Vector.mult (alexandre # direction # get) !Const.knight_vel) 
  else alexandre # velocity # set (Vector.zero) ;
  ()


let alexandre_call alexandre () : unit =
  if not (alexandre # alive) then  
    (
      Real_time_system.unregister (alexandre:> real_time);
      Force_system.unregister (alexandre:>collidable);
      Draw_system.unregister (alexandre :> drawable);
      Collision_system.unregister (alexandre:>collidable);
      Move_system.unregister (alexandre :> movable);
      Ennemy_system.unregister (alexandre: Component_defs.alexandre :> mob);
      View_system.unregister (alexandre :> drawable)
    )
  else
    begin
    let s = alexandre#state#get in
      if s.kind = 1 then
        (if s.curframe > 0 then
          (alexandre#texture#set (s.update s.curframe s.maxframe (alexandre#direction#get)))
        else if s.curframe = 0 then
          (alexandre#texture#set (alexandre#anim_recover#get);
          (match alexandre#state_box#get with
          | Some b -> b#remove_box#get (); alexandre#state_box#set None
          | None -> ());
          s.kind <- 0);
        s.curframe <- s.curframe - 1;
        );
 
    (*if alexandre # cooldown # get > 0 then alexandre # cooldown # set (alexandre # cooldown # get -1);*)
    let playerpos = (Global.ply())#pos#get in
    Gfx.debug "Player pos : %f;%f \n %!" (playerpos.x) (playerpos.y);
    if playerpos.x > (alexandre # pos#get ).x then
      alexandre #direction # set 1.
    else  
      alexandre #direction #set (-1.)
  end
  




let alexandre_collision alexandre collide pos =
  if collide = "ground" then alexandre # grounded # set true;
  if collide = "sword_left" || collide = "sword_right" then 
    (alexandre # take_dmg Const.sword_damage);
  if collide = "exclbr_mel" then alexandre # take_dmg Const.exclbr_mel_atk;
  if collide = "alexandre_fb" then alexandre # take_dmg Const.fbdamage;
  if collide = "exclbr_rgd" then alexandre # take_dmg Const.exclbr_rgd_atk


let create id x y w h texture  =
  let alexandre = new alexandre in
  alexandre # pos # set Vector.{ x = float x; y = float y };
  alexandre # id # set id;
  (*alexandre # pattern # set (alexandre_pattern alexandre);*)
  alexandre # grounded # set false;
  alexandre # hitbox_rect # set Rect.{width = w - 36; height =  h-18} ;
  alexandre # hitbox_position # set Vector.{x=18.;y=14.};
  alexandre # rect # set Rect.{width = w; height = h};
  alexandre # mass # set Const.alexandre_stats.mass;
  (
    match texture with 
      None -> (*
    let res =Gfx.get_resource (Hashtbl.find (Resources.get_textures ()) "resources/images/alexandre.png" ) in
    let ctx = Gfx.get_context (Global.window () )in

    let reposG = Texture.anim_from_surface ctx res 1 64 64 64 64 60 1 in
    let reposD = Texture.anim_from_surface ctx res 1 64 64 64 64 60 3 in
    let attackG = Texture.anim_from_surface ctx res 12 64 64 64 64 60 1 in
    let attackD = Texture.anim_from_surface ctx res 12 64 64 64 64 60 1 in
    let h = Hashtbl.create 4 in
    Hashtbl.replace h "textReposG" reposG;
    Hashtbl.replace h "textReposD" reposD;
    Hashtbl.replace h "textAttackG" attackG;
    Hashtbl.replace h "textAttackD" attackD;
    alexandre # modifiable_texture # set h;
    alexandre # texture # set reposG
    *)
      alexandre # texture # set (Texture.color (Gfx.color 255 255 0 255))
    | Some t -> alexandre # texture # set t
  );

  (* show hitbox *)
  (*
  ignore (Hitbox.create "alexandre" alexandre);
  *)
  alexandre # elasticity # set Const.alexandre_stats.elas;
  alexandre # health # set Const.alexandre_stats.health;
  alexandre # damage # set Const.alexandre_stats.damage;
  alexandre # layer # set 9;
  alexandre # direction # set (-1.);
  alexandre # real_time_fun # set (alexandre_pattern alexandre);
  alexandre # onCollideEvent # set (alexandre_collision alexandre);
  Force_system.register (alexandre:>collidable);
  Draw_system.register (alexandre :> drawable);
  Collision_system.register (alexandre:>collidable);
  Move_system.register (alexandre :> movable);
  Ennemy_system.register (alexandre :> mob);
  View_system.register (alexandre :> drawable);
  Real_time_system.register(alexandre:> real_time);
  alexandre