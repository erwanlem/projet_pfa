open Component_defs
type t = player

let init _ = ()

let delta = 1000. /. 60.
let update dt el =
  Seq.iter (fun m ->
      if m#health#get <= 0.0 then 
        (m#pos#set (m#spawn_position#get);
        m#health#set Const.player_health
      )
    ) el
