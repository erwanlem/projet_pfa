
open Ecs

module Collision_system = System.Make(Collisions)
(* Use a functor to define the new system *)

let () = System.register (module Collision_system)
(* Register the system globally *)

module Control_system = System.Make(Control)
(* Use a functor to define the new system *)

let () = System.register (module Control_system)
(* Register the system globally *)

module Alive_system = System.Make(Alive)
(* Use a functor to define the new system *)

let () = System.register (module Alive_system)
(* Register the system globally *)

module Ennemy_system = System.Make(Ennemy)
let () = System.register (module Ennemy_system)

module Force_system = System.Make(Force)
(* Use a functor to define the new system *)

let () = System.register (module Force_system)
(* Register the system globally *)

module Move_system = System.Make(Move)
(* Use a functor to define the new system *)

let () = System.register (module Move_system)
(* Register the system globally *)

module View_system = System.Make(View)
(* Use a functor to define the new system *)

let () = System.register (module View_system)
(* Register the system globally *)


module Draw_system = System.Make(Draw)
(* Use a functor to define the new system *)

let () = System.register (module Draw_system)
(* Register the system globally *)


let reset_systems () =
  System.remove_all ()