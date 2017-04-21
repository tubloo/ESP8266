local module = {}

node_topic = config.MQTT_NodeTopic .. node.chipid()
isSubscribed = false

function startStatus()

  send_status()
  tmr.stop(2)
  tmr.alarm(2,config.Node_Interval, 1, 
    function()
      send_status()
      collectgarbage()
    end)
end


function send_status()  

    utility=require("utility")
    statustext=utility.jsonStatus() 
    utility=nil
    print(statustext)
    mosquitto.publish(node_topic .. "/status", statustext)


    --subscriptions are put here. only invoke once, once mosquitto is connected
    if isSubscribed == false then
      isSubscribed = mosquitto.subscribe(node_topic .. "/command", "nodeCommand")
    end
end 

function nodeCommand(data)
  print ("command recvd - " .. data)
  if data == "RESTART" then
    node.restart()
  end
end

startStatus()

return module