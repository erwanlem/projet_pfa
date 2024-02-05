(* A module to initialize and retrieve global objects *)

val window : unit -> Gfx.window
(** Returns the main window *)


val init : string -> unit

val scoring : unit -> int
val set_scoring : int -> unit

val init_camera : Component_defs.camera -> unit
val camera : unit -> Component_defs.camera

