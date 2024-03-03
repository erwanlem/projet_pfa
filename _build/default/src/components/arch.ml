open Component_defs
open System_defs

let arch_pattern arch dt =
  (*Permet de verifier que le joueur est toujours de le champs de vision*)
  arch#vs#get#seen#set (arch#vs#get#seen#get -1 ); 
  if arch#cld#get = 0 && arch#vs#get#seen#get > 0 then (
    arch#cld#set 60;
    ignore(
    Bullet.create "arrow" (Vector.get_x arch # pos # get -. 20.)
    ((Vector.get_y arch#pos#get) +.10.) 10 10 (Const.arrow_speed) 0.
  ))
  else if arch#cld#get > 0 then( arch#cld#set (arch#cld#get - 1))
  
      


let arch_collision arch collide pos =
  if collide = "ground" then arch # grounded # set true;
  if collide = "sword" then arch # take_dmg Const.sword_damage;
  if collide = "exclbr_mel" then arch # take_dmg Const.exclbr_mel_atk;
  if collide = "exclbr_rgd" then arch # take_dmg Const.exclbr_rgd_atk

let create id x y w h texture  =
  let arch = new arch in
  arch # pos # set Vector.{ x = float x; y = float y };
  arch # id # set id;
  arch # pattern # set (arch_pattern arch);
  arch # grounded # set false;
  arch # rect # set Rect.{width = w; height = h};
  arch # mass # set Const.arch_stats.mass;
  arch #vs# set (Vision.create "vs" (x-44) (y) 64 132);
  (match texture with 
  None -> arch # texture # set (Color (Gfx.color 255 0 255 255))
  | Some t -> arch # texture # set t);
  arch # elasticity # set Const.arch_stats.elas;
  arch # health # set Const.arch_stats.health;
  arch # damage # set Const.arch_stats.damage;
  arch # onCollideEvent # set (arch_collision arch);
  Force_system.register (arch:>collidable);
  Draw_system.register (arch :> drawable);
  Collision_system.register (arch:>collidable);
  Move_system.register (arch :> movable);
  Ennemy_system.register (arch :> mob);
  View_system.register (arch :> drawable);
  arch