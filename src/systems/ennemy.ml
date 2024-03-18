open Component_defs

type t = mob

let init _ = ()

let update dt el =
  Seq.iter (fun (e:t) -> 
    (e#pattern#get) dt 
    )
  el