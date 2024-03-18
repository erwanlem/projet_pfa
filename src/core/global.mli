(* A module to initialize and retrieve global objects *)

val window : unit -> Gfx.window
(** Returns the main window *)


val init : string -> unit

val scoring : unit -> int
val set_scoring : int -> unit

val init_camera : Component_defs.camera -> unit
val camera : unit -> Component_defs.camera

val init_player : Component_defs.player -> unit
val ply : unit -> Component_defs.player

val level_switch : unit -> bool
val get_level : unit -> string
val set_level : string -> unit

