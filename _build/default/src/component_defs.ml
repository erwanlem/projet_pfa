open Ecs

(* Some basic components *)
class position =
  object
    val pos = Component.def Vector.zero
    method pos = pos
  end

class damage = 
object 
  val damage = Component.def 0.
  method damage = damage
end 

class rect =
  object
    val rect = Component.def Rect.{width = 0; height = 0}
    method rect = rect
  end

class velocity =
  object
    val velocity = Component.def Vector.zero
    method velocity = velocity
  end

class grounded =
  object
    val grounded = Component.def false
    method grounded = grounded
  end

class onCollideEvent =
  object
    val onCollideEvent = Component.def (fun (a : string) -> ())
    method onCollideEvent = onCollideEvent
  end

class color =
  object
    val color = Component.def (Gfx.color 0 0 0 0)
    method color = color
  end

class mass =
  object
    val mass = Component.def (0.0)
    method mass = mass
  end

class elasticity =
  object
    val elasticity = Component.def (0.0)
    method elasticity = elasticity
  end

class sum_forces =
  object
    val sum_forces = Component.def (Vector.zero)
    method sum_forces = sum_forces
  end

class id =
  object
    val id = Component.def ("")
    method id = id
  end

class camera_position =
  object
    val camera_position = Component.def (Vector.zero)
    method camera_position = camera_position
  end

class health =
  object
    val health = Component.def 50.
    method health = health
  end

class direction =
  object
    val direction = Component.def 0.
    method direction = direction
  end
  
(* Some complex components *)

class movable =
  object
    inherit position
    inherit velocity
  end

class collidable =
  object
    inherit id
    inherit position
    inherit velocity
    inherit sum_forces
    inherit mass
    inherit rect
    inherit elasticity
    inherit grounded
    inherit onCollideEvent
  end

class drawable =
  object
    inherit position
    inherit rect
    inherit color
    inherit camera_position
  end

class box =
  object
    inherit drawable
    inherit! collidable
    inherit! id
  end

class controlable =
  object
    inherit box
    val control = Component.def (fun (h : (string, unit) Hashtbl.t) -> ())
    method control = control
  end

class mob =
  object 
    inherit box
    inherit health
    inherit damage
    val pattern = Component.def (fun (_:float)->())
    method pattern = pattern
    method alive = (health#get) <0. 
    method take_dmg dmg = health#set ((health#get)-.dmg)
  end 

class knight=
  object 
    inherit mob
  end

class arch=
  object
    inherit mob
  end

class icespirit=
  object
    inherit mob
  end

class player = 
  object
    inherit box
    inherit! controlable
    inherit health
    inherit direction
    val heat = Component.def 100.
    method heat = heat
    method cold = if heat # get > 0. then heat # set (heat # get -. 1.)
                  else heat # set 0. 
    method heater = if heat #get < 101. then heat #set(heat # get +. 1. )
                    else heat # set 100.
  end

class camera =
  object
    (* Objet suivi par la camera *)
    val focus = Component.def (new box)
    method focus = focus
    method position = focus#get#pos#get
  end