--tmr.alarm(0,30000,0,function() dofile('init.lua') end)

print("Connecting to Wi-Fi ")
wifi.setmode(wifi.STATION)
wifi.sta.config("WAP_ID","PASSWORD")
wifi.sta.connect()
tmr.alarm(1,1000,1,function() if wifi.sta.getip() == nil then
	print("IP not received. Wait for it...") else
	tmr.stop(1)
	print("Config complete, IP is "..wifi.sta.getip())
	--dofile("dht11.lua")
	end
	end)

--tmr.alarm(0, 6000, 1, function()  dofile("tempwebserver.lua") end )
--tmr.alarm(0, 6000, 1, function()  dofile("IOT_TH.lua") end )
print('dofile("IOT_TH.lua")')
dofile("IOT_TH.lua")
