local module = {}

inpin = 6

start= tmr.time()
tmrNbr = 0

function motionStart()
  start=tmr.time()
  print('Motion Started!')
  
  sendData("1")
  tmr.stop(tmrNbr)
  tmr.alarm(tmrNbr,1000, 1, 
    function()
      sendData("1")
    end)
    
  gpio.trig(inpin, "down", motionStop)
end

function motionStop()
  tmr.stop(tmrNbr)
  sendData("0")
  duration = tmr.time() - start
  print('Motion ended after '..duration..' seconds.')
  gpio.trig(inpin, "up", motionStart)
end



function sendData(msg)  
    mosquitto.publish(config.MQTT_SensorTopic .. "motion/state",msg)
end


function module.start(tmrNumber, tmrInterval)  
  print("hcsr start")
  tmrNbr = tmrNumber
  gpio.mode(inpin, gpio.INT)
  gpio.trig(inpin, "up", motionStart)

end

return module