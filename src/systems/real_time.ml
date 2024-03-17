open Component_defs
open State
open Const
type t = real_time

let init _ = ()

let update dt el =
  Seq.iter (fun m ->
      m#real_time_fun#get ()
    ) el
