function ts()tmr.stop(0)end
function nr()node.restart(0)end

tmr.alarm(0,6000,0,function()dofile("start.lua")end)
