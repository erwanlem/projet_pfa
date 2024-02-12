open Component_defs
open System_defs

let create focus_object =
  let cam = new camera in
  cam # focus # set focus_object;
  cam