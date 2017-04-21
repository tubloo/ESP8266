local module = {}

SDA_PIN = 1 -- sda pin, GPIO04
SCL_PIN = 2 -- scl pin, GPIO05

--I2C slave address of GY-30
local GY_30_address = 0x23
-- i2c interface ID
local id = 0
--CMD
local CMD = 0x10
--Make it more faster
local i2c = i2c

local function read_data(ADDR, commands, length)
  --print("read data - start")
  i2c.start(id)
  i2c.address(id, ADDR, i2c.TRANSMITTER)
  i2c.write(id, commands)
  i2c.stop(id)
  i2c.start(id)
  i2c.address(id, ADDR,i2c.RECEIVER)
  tmr.delay(200000)
  c = i2c.read(id, length)
  i2c.stop(id)
  --print("read data - end")

  return c
end

local function sendData(topic)

  dataT = read_data(GY_30_address, CMD, 2)
  --Make it more faster
  UT = dataT:byte(1) * 256 + dataT:byte(2)
  l = (UT*1000/12)
  --print("lux: "..(l / 100).."."..(l % 100).." lx")

  mult = 10^(2 or 0)
  l = math.floor(l * mult + 0.5) / mult

  print(l)

  if l == 0 then
    print("bh1750 initializing")
  elseif l == 5461250 then
    print("bh1750 not found")
  else
    
      mosquitto.publish(config.MQTT_SensorTopic .. "lux",l)
    
  end
end

local function init()
  i2c.setup(id, SDA_PIN, SCL_PIN, i2c.SLOW)
  print("i2c ok..")
end

function module.start(tmrNumber, tmrInterval)  

  init()

  tmr.stop(tmrNumber)
  tmr.alarm(tmrNumber,tmrInterval, 1, 
    function()
      sendData()
    end)
end

return module

--GND - purple
--ADD - Blue
--SDA - Green
--SCL - Yellow
--VCC - Orange
