--whatif mqtt restarts
local module = {}

module.isConnected = false
m = nil
subscriptions = {}

function module.subscribe(topic, callback)
  if module.isConnected then
    m:subscribe(topic,0,
      function(conn)
        print("Successfully subscribed to mosquitto topic - " .. topic)
        subscriptions[topic] = callback
      end)
    return true
  else
    return false
  end
end

function module.publish(topic,payload)
  if topic~= nil and payload ~=nil and module.isConnected then
    m:publish(topic,payload,2,0)
    print(topic .. " - " .. payload)
  end
end

local function mqtt_start()

  m = mqtt.Client(config.MQTT_ID, 120)

  -- register message callback beforehand
  m:on("message", function(conn, topic, data)
    if data ~= nil then
      print("MSG RECVD " .. topic .. ": " .. data)
      _G[subscriptions[topic]](data)
    end
  end)

  -- Connect to broker
  m:connect(config.MQTT_Host, config.MQTT_Port, 0,
    function(con)
      print("Successfully connected to mosquitto")
      module.isConnected=true
    end)

end

function module.start()
  module.isConnected=false
  mqtt_start()
end



return module
