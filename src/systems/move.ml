open Component_defs
type t = movable

let init _ = ()

let delta = 1000. /. 60.
let d = ref 0.

let update dt el =
  Seq.iter (fun m ->
      let npos = Vector.add (Vector.mult delta (m#velocity#get)) (m#pos#get) in
      m # pos # set npos
    ) el
