let debug = Gfx.open_formatter "console" let () = Gfx.set_debug_formatter debug
let () = Game.run
    Game.{ key_left = "ArrowLeft"; 
           key_right = "ArrowRight"; 
           key_up = "ArrowUp";
           key_down = "ArrowDown"}