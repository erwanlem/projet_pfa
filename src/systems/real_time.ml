open Component_defs
open State
open Const
type t = real_time

let init _ = ()

(* Indique la fréquence rafraichissement
   - une fréquence trop élevée va réduire les performances du jeu
   - une fréquence trop faible va créer une latence dans les actions temps réel *)
let reference_timer = 2

let timer = ref reference_timer

let update dt el =
  timer := !timer - 1;
  if !timer = 0 then begin
    timer := reference_timer;
    Seq.iter (fun m ->
        m#real_time_fun#get ()
      ) el
    end
