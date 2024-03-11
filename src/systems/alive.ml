open Component_defs
open State
open Const
type t = player

let init _ = ()

let update dt el =
  Seq.iter (fun m ->
      let s = m#state#get in
      if s.kind = 1 then
        (if s.curframe > 0 then
          ((*m#texture#set (s.update s.curframe s.maxframe (m#direction#get))*))
        else if s.curframe = 0 then
          (m#texture#set (m#anim_recover#get);
          s.kind <- 0);
        s.curframe <- s.curframe - 1;
        );
        
        

      if m#health#get <= 0.0 then 
        (m#pos#set (m#spawn_position#get);
        m#health#set Const.player_health
      )
    ) el
