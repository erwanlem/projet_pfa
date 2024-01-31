type t = { x : float; y : float }

let add a b = { x = a.x +. b.x; y = a.y +. b.y }
let sub a b = { x = a.x -. b.x; y = a.y -. b.y }

let mult k a = { x = k*. a.x; y = k*. a.y }

let dot a b = a.x *. b.x +. a.y *. b.y
let norm a = sqrt (dot a a)
let normalize a = mult (1.0 /. norm a) a
let pp fmt a = Format.fprintf fmt "(%f, %f)" a.x a.y

let get_x vect = vect.x
let get_y vect = vect.y

let clamp a c =
  let {x;y} = a in
  let x = if x > c then c else x in
  let y = if y > c then c else y in
  {x; y}

let zero = { x = 0.0; y = 0.0 }
let is_zero v = v.x = 0.0 && v.y = 0.0