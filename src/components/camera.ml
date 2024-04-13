open Component_defs
open System_defs

let create focus =
  let cam = new camera in

  
  cam#focus#set focus;
  (*cam # focus # set focus_object;*)
  cam