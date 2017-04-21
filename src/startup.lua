config = require("config")
mosquitto = require("mosquitto")
setup = require("setup")

print("Starting ..")
  
--Load config params from "device.config"
if file.open("device.config","r") then

  print("Reading config parameters ..")
  
  local sF = file.read()
  local s = {}
  print("setting: "..sF)
  file.close()
  for k, v in string.gmatch(sF, "([%w.]+)=([%S ]+)") do
    s[k] = v
    print(k .. ": " .. v)
    config.params[k] = v
  end
  
  print("WiFi SSID " .. config.params["wifissid"])
  print("WiFi Password " .. config.params["wifipwd"] )
  
  config.SSID[config.params["wifissid"]] = config.params["wifipwd"] 
  config.MQTT_Host = config.params["mqtthost"]
  config.MQTT_Port = config.params["mqttport"]
  config.MQTT_NodeTopic = config.params["nodetopic"]
  
end

setup.start()
