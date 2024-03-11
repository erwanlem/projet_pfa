type t =
  { mutable curframe : int; mutable maxframe : int; mutable kind : int; update : int -> int -> float -> Texture.t }

(*
  state 0 -> default state, no action
  state 1 -> attack state   
*)
let create_state stateid frames update =
  { curframe = frames; maxframe = frames; kind = stateid; update = update }


(* Returns state id *)
let get_state state = state.kind