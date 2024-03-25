open Component_defs
open System_defs
open State

let arch_pattern arch dt = 
  if arch # cld # get = -1 then 
    begin
      (let x = (* position de l'élément en fonction de la direction (tirer vers la gauche ou vers la droite) *)
      if arch#direction#get > 0. then (Vector.get_x arch#pos#get)+.(float (Rect.get_width arch#rect#get)) 
      else (Vector.get_x arch#pos#get)-.4. in

      ignore (Arrow.create "arrow" x 
      (Vector.get_y arch#pos#get+.25.) 64 25 (Const.bullet_speed *. arch#direction#get)));
      arch # cld # set 60
(*
      ignore(Arrow.create "arrow" (Vector.get_x arch # hitbox_position # get +. (arch # direction # get *. 20.) )
    ((Vector.get_y arch#hitbox_position#get) +.20.) 10 10 (arch # direction # get )) ;
    arch#cld#set (arch#cld#get - 1);*)
    end;
  ()
  (*Permet de verifier que le joueur est toujours de le champs de vision*)(*
  if arch#vs#get#seen#get > 0 then arch#vs#get#seen#set (arch#vs#get#seen#get -1 ); 
  (* tire si le joueur a été vu récement et si l'archer n'as pas tirer depuis un moment *)
  if arch#cld#get = 0 && arch#vs#get#seen#get > 0 then (
    arch#cld#set 60;
    ignore(
    Arrow.create "arrow" (Vector.get_x arch # pos # get +. (arch # direction # get *. 20.) +. 32.)
    ((Vector.get_y arch#pos#get) +.10.) 10 10 (arch # direction # get ) 
  ))
  else if arch#cld#get > 0 then( arch#cld#set (arch#cld#get - 1))
    *)
  
let archer_call arch () : unit =
  if not (arch # alive) then  
    (
      Real_time_system.unregister (arch:> real_time);
      Force_system.unregister (arch:>collidable);
      Draw_system.unregister (arch :> drawable);
      Collision_system.unregister (arch:>collidable);
      Move_system.unregister (arch :> movable);
      Ennemy_system.unregister (arch: Component_defs.arch :> mob);
      View_system.unregister (arch :> drawable)
    )
  else begin
    let playerpos = (Global.ply())#pos#get in
    if arch # cld # get = 0 && ((Vector.dist playerpos (arch#pos#get))  < 350.0) && (abs_float (playerpos.y -. (arch # pos # get).y) < 5.) then
      begin
      Gfx.debug "Test \n %!";
      arch # cld # set (-1);
      end
    else if arch # cld # get > 0 then
      arch # cld # set (arch # cld # get - 1);
    

    if playerpos.x > (arch # pos#get ).x then(
      arch #direction # set 1.;
      arch # texture # set (Hashtbl.find (arch # modifiable_texture # get) "textReposD"))
    else  
      (arch #direction #set (-1.);
      arch # texture # set (Hashtbl.find (arch # modifiable_texture # get) "textReposG"))
    end
  


    
let arch_collision arch collide pos =
  if collide = "ground" then arch # grounded # set true;
  if collide = "sword_left" || collide = "sword_right" then 
    (arch # take_dmg Const.sword_damage; Gfx.debug "COLLIDE SWORD\n%!");
  if collide = "exclbr_mel" then arch # take_dmg Const.exclbr_mel_atk;
  if collide = "player_fb" then arch # take_dmg Const.fbdamage;
  if collide = "exclbr_rgd" then arch # take_dmg Const.exclbr_rgd_atk


let create id x y w h texture  =
  let arch = new arch in
  arch # pos # set Vector.{ x = float x; y = float y };
  arch # id # set id;
  arch # pattern # set (arch_pattern arch);
  arch # grounded # set false;
  arch # hitbox_rect # set Rect.{width = w - 36; height =  h-18} ;
  arch # hitbox_position # set Vector.{x=18.;y=14.};
  arch # rect # set Rect.{width = w; height = h};
  arch # mass # set Const.arch_stats.mass;
  (
    match texture with 
  None -> 
    let res =Gfx.get_resource (Hashtbl.find (Resources.get_textures ()) "resources/images/archer.png" ) in
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
    arch # modifiable_texture # set h;
    arch # texture # set reposG
  | Some t -> arch # texture # set t
  );

  (* show hitbox *)
  ignore (Hitbox.create "archer" arch);

  arch # elasticity # set Const.arch_stats.elas;
  arch # health # set Const.arch_stats.health;
  arch # damage # set Const.arch_stats.damage;
  arch # layer # set 9;
  arch # direction # set (-1.);
  arch # real_time_fun # set (archer_call arch);
  arch # onCollideEvent # set (arch_collision arch);
  Force_system.register (arch:>collidable);
  Draw_system.register (arch :> drawable);
  Collision_system.register (arch:>collidable);
  Move_system.register (arch :> movable);
  Ennemy_system.register (arch :> mob);
  View_system.register (arch :> drawable);
  Real_time_system.register(arch:> real_time);
  arch