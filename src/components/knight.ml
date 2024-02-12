open Component_defs
open System_defs


let knight_collision knight collide pos =
  if collide = "ground" then knight # grounded # set true;
  if collide = "ply_sword" then knight # take_dmg Const.sword_damage;
  if collide = "exclbr_mel" then knight # take_dmg Const.exclbr_mel_atk;
  if collide = "exclbr_rgd" then knight # take_dmg Const.exclbr_rgd_atk

let create id x y w h =
  let knight = new knight in
  knight # pos # set Vector.{ x = float x; y = float y };
  knight # id # set id;
  knight # grounded # set false;
  knight # rect # set Rect.{width = w; height = h};
  knight # mass # set Const.knight_stats.mass;
  knight # color# set (Gfx.color 0 0 0 255);
  knight # elasticity # set Const.knight_stats.elas;
  knight # health # set Const.knight_stats.health;
  knight # damage # set Const.knight_stats.damage;
  knight # onCollideEvent # set (knight_collision knight);
  Force_system.register (knight:>collidable);
  Draw_system.register (knight :> drawable);
  Collision_system.register (knight:>collidable);
  Move_system.register (knight :> movable);
  knight