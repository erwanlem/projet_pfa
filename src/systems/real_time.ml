open Component_defs
open State
open Const
type t = real_time

let init _ = ()

(* Indique la fréquence rafraichissement
   - une fréquence trop élevée va réduire les performances du jeu
   - une fréquence trop faible va créer une latence dans les actions temps réel *)


let update dt el =
  Seq.iter (fun m ->
      m#real_time_fun#get dt
    ) el
