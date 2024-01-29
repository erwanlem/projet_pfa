open Ecs

(* Some basic components *)
class position =
  object
    val pos = Component.def Vector.zero
    method pos = pos
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

class sum_forces =
  object
    val sum_forces = Component.def (Vector.zero)
    method sum_forces = sum_forces
  end

class event =
  object
    val event = Component.def (fun (a : string) -> ())
    method event = event
  end

class id =
  object
    val id = Component.def ("")
    method id = id
  end
(* Some complex components *)

class movable =
  object
    inherit position
    inherit velocity
  end

class collidable =
  object
    inherit position
    inherit velocity
    inherit sum_forces
    inherit mass
    inherit rect
  end


class drawable =
  object
    inherit position
    inherit rect
    inherit color
  end

class box =
  object
    inherit drawable
    inherit! collidable
    inherit id
  end

class event_box =
  object
    inherit drawable
    inherit event
    inherit id
  end