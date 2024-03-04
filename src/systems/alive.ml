open Component_defs
type t = alive

let init _ = ()

let update dt el =
  Seq.iter (fun m ->
      let att_time = m#attack_time#get in
      if att_time >= 0 then
        m#attack_time#set (att_time-1); 
      if m#health#get <= 0.0 then 
        (m#pos#set (m#spawn_position#get);
        m#health#set Const.player_health
      )
    ) el
