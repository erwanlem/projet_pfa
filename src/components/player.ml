open Component_defs
open System_defs
open Config
open State


let cfg = Config.get_config ()


let update_sword_anim player i frame maxframe dir =
  let res = Gfx.get_resource (try Hashtbl.find (Resources.get_textures ()) "resources/images/player_attack.png"
                                    with Not_found -> failwith "In alive.ml : Resource not found" ) in
  let ctx = Gfx.get_context (Global.window ()) in
  if frame mod (maxframe/6) = 0 then
    i := !i+1;
  if dir = -1. then
    (
      Texture.image_from_surface ctx res (64*(!i)) 64 64 64 (Rect.get_width player#rect#get) (Rect.get_height player#rect#get))
  else
      Texture.image_from_surface ctx res (64*(!i)) (3*64) 64 64 (Rect.get_width player#rect#get) (Rect.get_height player#rect#get)


let player_framed_call player _ : unit =
  player # cooldown_decr (player # cooldown # get); 
  if Hashtbl.find (player#cooldown#get) "teleport" > 190. then begin
    if (player # direction # get) = (1.) then
      player#sum_forces#set (Vector.add player#sum_forces#get Vector.{x=5.; y=0.})
    else
      player#sum_forces#set (Vector.add player#sum_forces#get Vector.{x=(-5.); y=0.})
  end;


  let s = player#state#get in
    if s.kind = 1 then
      (if s.curframe > 0 then
        (player#texture#set (s.update s.curframe s.maxframe (player#direction#get)))
      else if s.curframe = 0 then
        (player#texture#set (player#anim_recover#get);
        (match player#state_box#get with
        | Some b -> b#remove_box#get (); player#state_box#set None
        | None -> ());
        s.kind <- 0);
      s.curframe <- s.curframe - 1;
      );
      
    if player#health#get <= 0.0 then begin
      Fall_box.reset_fall_box_position ();
      Hide_box.reset_hide_box ();
      player#pos#set (player#spawn_position#get);
      player#health#set Const.player_health
    end



let player_control player keys =

  (* Déplacement vers la gauche *)
  if Hashtbl.mem keys cfg.key_left then
    (if (player # direction # get) <> (-1.) then
      (player # texture # set (Hashtbl.find (player # modifiable_texture # get) "texture_right_walk");
      player # direction # set (-1.));
      Texture.pause_animation (player#texture#get) false;
      player # velocity # set (Vector.add (Vector.mult (-1.) !Const.horz_vel)
      (Vector.{x=0.; y=(player#velocity#get).y}));
    )

  (* Déplacement vers la droite *)
  else if Hashtbl.mem keys cfg.key_right then 
    (if (player # direction # get) <> (1.) then
      (player # texture # set (Hashtbl.find (player # modifiable_texture # get) "texture_left_walk");
      player # direction # set (1.)
      );
      Texture.pause_animation (player#texture#get) false;
      player # velocity # set (Vector.add (!Const.horz_vel)(Vector.{x=0.; y=(player#velocity#get).y}));
    )
  else
    (Texture.pause_animation (player#texture#get) true;
    player#velocity#set ( Vector.{x=0.; y=(player#velocity#get).y} ));

  (* Teleport *)
  if Hashtbl.mem keys cfg.key_teleport && 
    Hashtbl.find (player#cooldown#get) "teleport" < 1. then begin
    Hashtbl.replace (player # cooldown # get) "teleport" 200.;
    if (player # direction # get) = (1.) then begin
      player#sum_forces#set (Vector.add player#sum_forces#get Vector.{x=2.; y=0.});
    end
    else
      player#sum_forces#set (Vector.add player#sum_forces#get Vector.{x=(-2.); y=0.})
    end;


  (* Shoot *)
  if player#level#get > 1 && Hashtbl.mem keys cfg.key_space && Hashtbl.find keys cfg.key_space && 
    Hashtbl.find (player#cooldown#get) "fireball" < 1. then begin
      Hashtbl.replace (player # cooldown # get) "fireball" 100.;
    let x = (* position de l'élément en fonction de la direction (tirer vers la gauche ou vers la droite) *)
      if player#direction#get > 0. then (Vector.get_x player#pos#get)+.(float (Rect.get_width player#rect#get)) 
      else (Vector.get_x player#pos#get)-.64. in

    (ignore (Bullet.create "player_fb" x 
    (Vector.get_y player#pos#get+.25.) 64 25 (Const.bullet_speed *. player#direction#get) 0.));
    Hashtbl.replace keys cfg.key_space false;
  end;


  (* Jump *)
  if Hashtbl.mem keys cfg.key_up && player#grounded#get 
    && Hashtbl.find keys cfg.key_up then
    (player # grounded # set false;
    player # sum_forces # set (Vector.add (player#sum_forces#get) (Const.jump));
    Hashtbl.replace keys cfg.key_up false);

  (* sword *)
  if Hashtbl.mem keys cfg.key_return && (State.get_state player#state#get) = 0 then begin
    (player#anim_recover#set player#texture#get;
    let i = ref (-1) in
    if player#direction#get = 1. then
      (player#state#set (State.create_state 1 24 (update_sword_anim player i));
      player#state_box#set (Some (Sword_box.create "sword" player (30.) 0.)))
    else
      (player#state#set (State.create_state 1 24 (update_sword_anim player i));
      player#state_box#set (Some (Sword_box.create "sword" player (-22.) 0.))))
    end
    





(* Player collision *)
let player_collision player collide pos =
  (*Gfx.debug "%a - %a\n%!" Vector.pp player#pos#get Vector.pp player#camera_position#get;*)
  let vect_y_collision = 
    (Vector.get_y pos) -. ((Vector.get_y (Vector.add player#pos#get player#hitbox_position#get))
     +. float (Rect.get_height player#hitbox_rect#get)) in
  if (collide="ground" || collide="platform") && (Vector.get_y player#sum_forces#get) >= 0. 
    && (int_of_float vect_y_collision) >= 0 && not player#grounded#get then 
    player # grounded # set true;
  
  if collide = "death_box" then player#health#set 0.0;

  if collide = "medkit" then player # health # set (min (player # health # get +. 10.) (Const.player_health));

  if collide = "arrow" || collide = "ennemy_sword" then 
    player#health#set (player#health#get -. Const.knight_stats.damage)







(* Create player *)
let create id x y w h mass elas lvl texture =
  let player = new player in
  (* position joueur *)
  player # pos # set Vector.{ x = float x; y = float y };
  player # rect # set Rect.{width = w; height = h};
  (* Position hitbox relative *)
  player # hitbox_rect # set Rect.{width = w-36; height = h-14};
  player # hitbox_position # set Vector.{x=18.;y=10.};
  (* Chargement des textures *)
  (match texture with 
  None -> 
    let res = Gfx.get_resource (Hashtbl.find (Resources.get_textures ()) "resources/images/arthur.png") in
    let res2 = Gfx.get_resource (Hashtbl.find (Resources.get_textures ()) "resources/images/player_attack.png") in
    let ctx = Gfx.get_context (Global.window ()) in

    let texture1 = Texture.anim_from_surface ctx res 9 64 64 w h 3 3 in 
    let texture2 = Texture.anim_from_surface ctx res 9 64 64 w h 3 1 in 
    let texture3 = Texture.anim_from_surface ctx res2 9 64 64 w h 3 3 in 
    let texture4 = Texture.anim_from_surface ctx res2 9 64 64 w h 3 1 in 
    let h = Hashtbl.create 2 in
    Hashtbl.replace h "texture_left_walk" texture1;
    Hashtbl.replace h "texture_right_walk" texture2;
    Hashtbl.replace h "texture_left_attack" texture3;
    Hashtbl.replace h "texture_right_attack" texture4;
    player # modifiable_texture # set h;
    player # texture # set texture1;
    Texture.pause_animation (player#texture#get) true

  | Some t -> player # texture # set t);

  (* Hitbox *)
  ignore (Hitbox.create "player" player);

  Hashtbl.replace player#cooldown#get "attack1" 0.;
  Hashtbl.replace player#cooldown#get "attack2" 0.;
  Hashtbl.replace player#cooldown#get "teleport" 0.;

  player # id # set id;
  player # mass # set mass;
  player # elasticity # set elas;
  player # health # set Const.player_health;

  player # control # set (player_control player);
  player # onCollideEvent # set (player_collision player);
  player # real_time_fun # set (player_framed_call player);

  player # grounded # set false;
  player # direction # set 1.;
  player # layer # set 10;
  player # level # set lvl;
  player # spawn_position # set Vector.{x = float x;y = float y};
  player # camera_position # set Vector.{ x = float x; y = float y };

  Hashtbl.replace (player # cooldown # get) "fireball" 0.; 

  (* Enregistrement dans les systèmes *)
  Force_system.register (player:>collidable);
  Draw_system.register (player :> drawable);
  Collision_system.register (player:>collidable);
  Move_system.register (player :> movable);
  Control_system.register (player :> controlable);
  View_system.register (player :> drawable);
  Real_time_system.register (player:>real_time);
  player
  