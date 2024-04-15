open Component_defs
open System_defs
open State


let update_sword_anim alexandre i frame maxframe dir =
  let res = Gfx.get_resource (try Hashtbl.find (Resources.get_textures ()) "resources/images/boss.png"
                              with Not_found -> failwith "In alexandre.ml : Resource not found" ) in
  let ctx = Gfx.get_context (Global.window ()) in
  if frame mod (maxframe/8) = 0 then
    i := !i+1;
  if dir = -1. then
    (
      Texture.image_from_surface ctx res (364*(!i)) (364*2) 364 364 (Rect.get_width alexandre#rect#get) (Rect.get_width alexandre#rect#get))
  else
    Texture.image_from_surface ctx res (364*(!i)) (3*364) 364 364 (Rect.get_width alexandre#rect#get) (Rect.get_width alexandre#rect#get)


let alexandre_pattern alexandre dt = 

  (* Case not alive : unregistered *)
  if not (alexandre # alive) then begin
    Real_time_system.unregister (alexandre:> real_time);
    Force_system.unregister (alexandre:>collidable);
    Draw_system.unregister (alexandre :> drawable);
    Collision_system.unregister (alexandre:>collidable);
    Move_system.unregister (alexandre :> movable);
    View_system.unregister (alexandre :> drawable)
  end

  else
    (* Case alive *)
    (* Get player position *)
    let playerpos = (Global.ply ()) # pos # get in

    (* get state *)
    let s = alexandre#state#get in

    (* if attacking *)
    if s.kind = 1 then begin
      if s.curframe > 0 then
        (alexandre#texture#set (s.update s.curframe s.maxframe (alexandre#direction#get)))
      else if s.curframe = 0 then
        (alexandre#texture#set (alexandre#anim_recover#get);
         (match alexandre#state_box#get with
          | Some b -> b#remove_box#get (); alexandre#state_box#set None
          | None -> ());
         s.kind <- 0);
      s.curframe <- s.curframe - 1
    end

    (* If not attacking *)
    else begin
      (* If close to the player : start attack *)
      if Vector.dist (Vector.addX playerpos 32.) (Vector.addX alexandre#pos#get 64.) < 110.0 then begin
        alexandre#anim_recover#set alexandre#texture#get;
        let i = ref (-1) in
        if alexandre#direction#get = 1. then
          (alexandre#state#set (create_state 1 32 (update_sword_anim alexandre i));
           alexandre#state_box#set (Some (Sword_box.create "ennemy_sword" alexandre (30.) 0. ~alex:true)))
        else
          (alexandre#state#set (create_state 1 32 (update_sword_anim alexandre i));
           alexandre#state_box#set (Some (Sword_box.create "ennemy_sword" alexandre (-22.) 0. ~alex:true)))
      end

      else

        let disttop = Vector.dist playerpos (alexandre#pos#get) in

        (* Can see the player *)
        if ( disttop < 750.0) then (
          let f x = 0.14*.x -. 25. in
          let randnum = Random.int 100 in
          let attack = f disttop < float randnum in


          (*Walk towards the player*)
          if (not attack || disttop < 250.)  && abs (int_of_float ((Vector.get_x playerpos) -. (Vector.get_x alexandre#pos#get))) > 10 
          then begin 

            (* Walk animation *)
            if Vector.get_x playerpos > (alexandre # pos # get ).x && alexandre#direction#get <> (1.) then begin
              alexandre # texture # set (Hashtbl.find (alexandre # modifiable_texture # get) "texture_left_walk");
              alexandre # direction # set 1.
            end
            else if Vector.get_x playerpos < (alexandre # pos # get ).x && alexandre#direction#get <> (-1.) then begin
              alexandre # texture # set (Hashtbl.find (alexandre # modifiable_texture # get) "texture_right_walk");
              alexandre # direction # set (-1.)
            end;

            Texture.pause_animation (alexandre#texture#get) false;
            alexandre # velocity # set (Vector.mult (alexandre # direction # get) !Const.alexandre_vel) 
          end

          else if attack && dt -. Hashtbl.find (alexandre#cooldown#get) "fireball" > 1000. then begin
            Hashtbl.replace (alexandre # cooldown # get) "fireball" dt;
            let x = (* position de l'élément en fonction de la direction (tirer vers la gauche ou vers la droite) *)
              if alexandre#direction#get > 0. then (Vector.get_x alexandre#pos#get)+.(float (Rect.get_width alexandre#rect#get)) 
              else (Vector.get_x alexandre#pos#get)-.128. in
            (ignore (Bullet.create "alexandre_fb" x 
                       (Vector.get_y alexandre#pos#get+.50.) 128 50 (Const.bullet_speed *. alexandre#direction#get) 0. ~color:2));
          end

        )
        (* Wait *)
        else begin
          Texture.pause_animation (alexandre#texture#get) true;
          alexandre#velocity#set ( Vector.{x=0.; y=(alexandre#velocity#get).y} ) 
        end
    end





let alexandre_collision alexandre collide pos =
  if collide = "ground" then alexandre # grounded # set true;
  if collide = "player_fb" then alexandre # take_dmg Const.fbdamage;
  if collide = "player" then alexandre#pushable#set false;
  if collide = "sword" then
    alexandre # take_dmg Const.sword_damage


let create id x y w h texture  =
  Random.self_init ();
  let alexandre = new alexandre in
  alexandre # pos # set Vector.{ x = float x; y = float y };
  alexandre # id # set id;
  alexandre # grounded # set false;
  alexandre # hitbox_rect # set Rect.{width = w - 56; height =  h-18} ;
  alexandre # hitbox_position # set Vector.{x=28.;y=14.};
  alexandre # rect # set Rect.{width = w; height = h};
  alexandre # mass # set Const.alexandre_stats.mass;
  (
    match texture with 
      None -> 
      let res = Gfx.get_resource (Hashtbl.find (Resources.get_textures ()) "resources/images/boss.png") in
      let ctx = Gfx.get_context (Global.window ()) in

      let texture1 = Texture.anim_from_surface ctx res 8 364 364 w w 3 1 in 
      let texture2 = Texture.anim_from_surface ctx res 8 364 364 w w 3 0 in 
      let h = Hashtbl.create 2 in
      Hashtbl.replace h "texture_left_walk" texture1;
      Hashtbl.replace h "texture_right_walk" texture2;
      alexandre # modifiable_texture # set h;
      alexandre # texture # set texture2
    | Some t -> alexandre # texture # set t);

    
  (* shows hitbox *)
  ignore (Hitbox.create "alexandre" alexandre);


  alexandre # cooldown # set (Hashtbl.create 2);
  Hashtbl.add (alexandre # cooldown # get) "fireball" 0.;


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
  View_system.register (alexandre :> drawable);
  Real_time_system.register(alexandre:> real_time);
  alexandre