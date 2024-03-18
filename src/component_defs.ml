open Ecs

(* Some basic components *)
class position =
  object
    val mutable pos = Component.def Vector.zero
    method pos = pos
    method set_mutable_pos p = pos <- p
  end

class damage = 
object 
  val damage = Component.def 0.
  method damage = damage
end 


class anim_recover =
  object
    val anim_recover = Component.def (Texture.Color (Gfx.color 0 0 0 0))
    method anim_recover = anim_recover
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
    val onCollideEvent = Component.def (fun (a : string) (p : Vector.t) -> ())
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



class spawn_position =
  object
    val spawn_position = Component.def (Vector.zero)
    method spawn_position = spawn_position
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

class level =
  object
    val level = Component.def 0
    method level = level
  end

class texture =
  object
    val texture = Component.def (Texture.color (Gfx.color 0 0 0 0))
    method texture = texture
  end

class modifiable_texture =
  object
    val modifiable_texture = Component.def (Hashtbl.create 1 : (string, Texture.t) Hashtbl.t)
    method modifiable_texture = modifiable_texture
  end

class layer =
  object
    val layer = Component.def 0
    method layer = layer
  end

class hitbox =
  object
    val hitbox_position = Component.def Vector.zero
    method hitbox_position = hitbox_position
    val hitbox_rect = Component.def Rect.{width = 0; height = 0}
    method hitbox_rect = hitbox_rect
  end

class hitbox_display =
  object
    val hitbox_display = Component.def Vector.zero
    method hitbox_display = hitbox_display
  end

(* Some complex components *)

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
    val isTransparent = Component.def false
    method isTransparent = isTransparent
    inherit hitbox
  end

class drawable =
  object
    inherit position
    inherit rect
    inherit color
    inherit camera_position
    inherit texture
    inherit layer
    inherit hitbox_display
  end

class box =
  object
    inherit drawable
    inherit! collidable
    inherit! id
  end

class state_box =
  object
    inherit box
    val remove_box = Component.def (fun () -> ())
    method remove_box = remove_box
  end

class movable =
  object
    inherit position
    inherit velocity
  end

class controlable =
  object
    inherit box
    val control = Component.def (fun (h : (string, bool) Hashtbl.t) -> ())
    method control = control
  end

class state =
  object 
    inherit anim_recover
    val state = Component.def (State.create_state 0 (-1) (fun a b c -> Texture.Color (Gfx.color 0 0 0 0)))
    method state = state
    val state_box = Component.def (None : state_box option)
    method state_box = state_box
  end

class vision =
  object 
   inherit collidable 
   inherit !drawable
   val seen = Component.def 0
   method seen = seen
   val ppos = Component.def Vector.{x = -1.; y = -1.}
   method ppos = ppos
  end

class mob =
  object 
    inherit box
    inherit health
    inherit damage
    inherit direction 
    val vs =  Component.def (new vision)
    val pattern = Component.def (fun  (_:float)->())
    val cld = Component.def 0
    method cld = cld
    method vs = vs
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

class real_time =
  object
    val real_time_fun = Component.def (fun (():unit) -> (():unit))
    method real_time_fun = real_time_fun
  end



class player = 
  object
    inherit health
    inherit spawn_position
    inherit state
    inherit box
    inherit! controlable
    inherit real_time
    inherit direction
    inherit level
    inherit modifiable_texture
  end


class camera =
  object
    (* Objet suivi par la camera *)
    val focus = Component.def (new box)
    method focus = focus
    method position = focus#get#pos#get
  end

class text =
  object
    inherit drawable
    val text = Component.def ("")
    method text = text
    val font = Component.def ("")
    method font = font
  end

class button =
  object
    inherit id
    inherit drawable
    inherit! controlable
  end