open Component_defs

type t = drawable

let init _ = ()


let update _dt el =
  let camera = Global.camera () in
  let camera_pos = camera#position in
  Seq.iter (fun m ->
    if Vector.get_x camera_pos > float (Const.window_width/3) then
      let Vector.{x; y} = m # pos # get in
      let x = x -. (Vector.get_x camera_pos) +. float (Const.window_width/3) in
      m#camera_position#set (Vector.add Vector.{x;y} m#hitbox_display#get)
    else
      let Vector.{x; y} = m # pos # get in
      m#camera_position#set (Vector.add Vector.{x;y} m#hitbox_display#get)
  ) el;