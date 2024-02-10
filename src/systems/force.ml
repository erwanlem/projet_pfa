open Component_defs

type t = collidable

let init _ = ()

let gravity = Const.gravity
let delta = 1000. /. 60.
let update dt el =
  Seq.iter (fun (m : t) ->
    let mass = m # mass # get in
    if Float.is_finite mass then begin
      let f = m # sum_forces # get in
      let f = Vector.add f gravity in
      m # sum_forces # set Vector.zero;
      let a = Vector.mult (1.0 /. m # mass # get) f in
      let delta_v = Vector.mult delta a in
      m # velocity # set (Vector.add delta_v m # velocity # get);
    end
    ) el
