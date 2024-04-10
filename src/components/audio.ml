open Component_defs
open System_defs
open Const


let create track =
  let audio = new audible in
  audio#track#set track;
  audio#index#set 0;
  Music_system.register audio;
  audio