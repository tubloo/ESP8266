local utility={}

function utility.jsonStatus()

  json=nil

  bytesRemain,bytesUsed,totalMemory=file.fsinfo() 
  majorVer, minorVer, devVer, chipid, flashid, flashsize, flashmode, flashspeed = node.info();

  json = '\
  {\
    "NodeMCU": {\
      "IP": "' .. wifi.sta.getip() .. '",\
      "MAC": "' .. wifi.sta.getmac() ..'",\
      "SDK": "' .. majorVer..'.'..minorVer..'.'..devVer ..'",\
      "FlashSize": "' .. flashsize .. '",\
      "ChipID": "' .. chipid .. '",\
      "FlashID": "' .. flashid ..'",\
      "FlashMode": "' .. flashmode ..'",\
      "FlashSpeed": "' .. flashspeed ..'",\
      "Heap": "' .. node.heap() ..'",\
      "NodeTopic": "' .. config.MQTT_NodeTopic ..'",\
      "SensorTopic": "' .. config.MQTT_SensorTopic ..'",\
      "TotalMemory": "' .. totalMemory .. '",\
      "bytesUsed": "' .. bytesUsed .. '",\
      "bytesRemain": "' .. bytesRemain .. '", \
      "Files": [  '
      
      --unable to send entire payload in one go
      --  l = file.list();
      --  for k,v in pairs(l) do
      --    json=json .. '\
      --    {\
      --      "Name": "' .. k .. '",\
      --      "Size": "' .. v .. '"\
      --      },'
      --end

      json=json:sub(1, -2) .. ']}}'

      return json
end

return utility
