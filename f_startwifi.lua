wifi.setmode(wifi.STATION)
wifi.sta.setip({ip=n_ip,netmask=n_nm,gateway=n_gw})
print('MAC: ',wifi.sta.getmac(),'\nheap: ',node.heap())
print('SSID: '..n_ssid)

--register callback
--wifi.sta.eventMonReg(wifi.STA_IDLE, function() print("STATION_IDLE") end)
--wifi.sta.eventMonReg(wifi.STA_CONNECTING, function() print("STATION_CONNECTING") end)
--wifi.sta.eventMonReg(wifi.STA_WRONGPWD, function() print("STATION_WRONG_PASSWORD") end)
--wifi.sta.eventMonReg(wifi.STA_APNOTFOUND, function() print("STATION_NO_AP_FOUND") end)
--wifi.sta.eventMonReg(wifi.STA_FAIL, function() print("STATION_CONNECT_FAIL") end)
--wifi.sta.eventMonReg(wifi.STA_GOTIP, function() print("STATION_GOT_IP") end)
--wifi.sta.eventMonStart()

--wifi.sta.config(n_ssid,n_sspw)
print(wifi.sta.getip())
