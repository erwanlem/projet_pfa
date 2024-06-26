open Component_defs
open System_defs
open State


let update_arc_anim knight i frame maxframe dir =
  let res = Gfx.get_resource (try Hashtbl.find (Resources.get_textures ()) "resources/images/ennemies/archer.png"
                              with Not_found -> failwith "In arch.ml : Resource not found" ) in
  let ctx = Gfx.get_context (Global.window ()) in
  if frame mod (maxframe/13) = 0 then
    i := !i+1;
  if dir = -1. then
    (
      Texture.image_from_surface ctx res (64*(!i)) 64 64 64 64 64)
  else
    Texture.image_from_surface ctx res (64*(!i)) (3*64) 64 64 64 64


let arch_pattern arch dt = 

  (* Case not alive : unregistered *)
  if not (arch # alive) then  
    (
      Real_time_system.unregister (arch:> real_time);
      Force_system.unregister (arch:>collidable);
      Draw_system.unregister (arch :> drawable);
      Collision_system.unregister (arch:>collidable);
      Move_system.unregister (arch :> movable);
      View_system.unregister (arch :> drawable)
    )

  else

    (* Get player position *)
    let playerpos = (Global.ply ()) # pos # get in

    (* get state *)
    let s = arch#state#get in

    (* if attacking *)
    if s.kind = 1 then begin
      if s.curframe > 0 then
        (arch#texture#set (s.update s.curframe s.maxframe (arch#direction#get)))
      else if s.curframe = 0 then 
        (ignore(Arrow.create "arrow" ((arch # pos # get).x +. 32. +. (arch # direction # get) *. 40.)
                  ((arch # pos # get).y +. 40.)
                  (arch # direction # get )
               );
         arch#texture#set (arch#anim_recover#get);

         (match arch#state_box#get with
          | Some b -> b#remove_box#get (); arch#state_box#set None
          | None -> ());
         s.kind <- 0);
      s.curframe <- s.curframe - 1

    end

    (* If not attacking *)
    else begin
      (* If player visible *)

      (* If close to the player : start attack *)
      if Vector.dist playerpos (arch#pos#get) < 800.0 
      && dt -. Hashtbl.find (arch#cooldown#get) "attack" > 1000. && (Float.abs (playerpos.y -. (arch#pos# get).y)) < 10. then begin
        Hashtbl.replace arch#cooldown#get "attack" dt;
        arch#anim_recover#set arch#texture#get;
        let i = ref (-1) in
        if arch#direction#get = 1. then
          arch#state#set (State.create_state 1 39 (update_arc_anim arch i))
        else
          arch#state#set (State.create_state 1 39 (update_arc_anim arch i))
      end;

      if playerpos.x > (arch # pos#get ).x then begin
        arch #direction # set 1.;
        arch # texture # set (Hashtbl.find (arch # modifiable_texture # get) "textReposD")
      end
      else  begin
        arch #direction #set (-1.);
        arch # texture # set (Hashtbl.find (arch # modifiable_texture # get) "textReposG")
      end

    end


let arch_collision arch collide pos =
  if collide = "ground" then arch # grounded # set true;
  if collide = "player" || collide = "arrow" then arch # pushable # set false;
  if collide = "sword" then 
    arch # take_dmg Const.sword_damage;
  if collide = "player_fb" then arch # take_dmg Const.fbdamage


let create id x y w h texture =
  let arch = new arch in
  arch # pos # set Vector.{ x = float x; y = float y };
  arch # id # set id;
  arch # grounded # set false;
  arch # hitbox_rect # set Rect.{width = w - 36; height =  h-18} ;
  arch # hitbox_position # set Vector.{x=18.;y=14.};
  arch # rect # set Rect.{width = w; height = h};
  arch # mass # set Const.arch_stats.mass;
  (
    match texture with 
      None -> 
      let res = Gfx.get_resource (Hashtbl.find (Resources.get_textures ()) "resources/images/ennemies/archer.png" ) in
      let ctx = Gfx.get_context (Global.window () )in

      let reposG = Texture.anim_from_surface ctx res 1 64 64 64 64 60 1 in
      let reposD = Texture.anim_from_surface ctx res 1 64 64 64 64 60 3 in
      let attackG = Texture.anim_from_surface ctx res 13 64 64 64 64 60 1 in
      let attackD = Texture.anim_from_surface ctx res 13 64 64 64 64 60 1 in
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
  (*ignore (Hitbox.create "archer" arch);*)

  Hashtbl.replace (arch#cooldown#get) "attack" 0.;

  arch # elasticity # set Const.arch_stats.elas;
  arch # health # set Const.arch_stats.health;
  arch # damage # set Const.arch_stats.damage;
  arch # layer # set 9;
  arch # direction # set (-1.);
  arch # real_time_fun # set (arch_pattern arch);
  arch # onCollideEvent # set (arch_collision arch);
  Force_system.register (arch:>collidable);
  Draw_system.register (arch :> drawable);
  Collision_system.register (arch:>collidable);
  Move_system.register (arch :> movable);
  View_system.register (arch :> drawable);
  Real_time_system.register(arch:> real_time);
  arch