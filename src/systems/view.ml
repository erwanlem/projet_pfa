open Component_defs

type t = drawable

let init _ = ()

let update _dt el =
  let camera = Global.camera () in
  let camera_pos = camera#position in
  Seq.iter (fun m ->
    if Vector.get_x camera_pos > float (Const.window_width/3) then
      let Vector.{x; y} = m # pos # get in
      let new_x = (x -. (Vector.get_x camera_pos) +. float (Const.window_width/3)) *. m#parallax#get in

      (* Seulement pour affichage hitbox, sinon retirer *)
      let cam_position = Vector.add Vector.{x=new_x;y=y} m#hitbox_display#get in

      (*let cam_position =Vector.{x=new_x;y=y} in*)
      let position_gap = (x -. Vector.get_x cam_position) in
      if position_gap >= Const.max_gap *. m#parallax#get then
        m#camera_position#set Vector.{x=x-.Const.max_gap*.m#parallax#get; y=y}
      else
        m#camera_position#set cam_position
    else
      let Vector.{x; y} = m # pos # get in
      m#camera_position#set (Vector.add Vector.{x;y} m#hitbox_display#get)
  ) el