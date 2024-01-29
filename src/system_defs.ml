
open Ecs

module Control_system = System.Make(Control)
(* Use a functor to define the new system *)

let () = System.register (module Control_system)
(* Register the system globally *)

module Collision_system = System.Make(Collisions)
(* Use a functor to define the new system *)

let () = System.register (module Collision_system)
(* Register the system globally *)

module Force_system = System.Make(Force)
(* Use a functor to define the new system *)

let () = System.register (module Force_system)
(* Register the system globally *)

module Move_system = System.Make(Move)
(* Use a functor to define the new system *)

let () = System.register (module Move_system)
(* Register the system globally *)


module Draw_system = System.Make(Draw)
(* Use a functor to define the new system *)

let () = System.register (module Draw_system)
(* Register the system globally *)