
--This is to prevent NodeMCU from getting into infinite loop
print("Loading in 15 seconds")
tmr.alarm(0,15000, 0,
  function()
    dofile("bootcheck.lua")
  end)

    