open Component_defs
open System_defs

let create focus_object max_x =
  let cam = new camera in
  cam # focus # set focus_object;
  cam # max_x # set max_x;
  cam