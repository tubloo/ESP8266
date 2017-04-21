
files = file.list()

if files["device.config"] then
  print("This node has been configured.")
  dofile("startup.lua")
else
  print("Fresh Node.. Getting ready for configuring..")
  dofile("firstrun.lua")
end
