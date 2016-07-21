n_ip="192.168.1.11"
n_nm="255.255.255.0"
n_gw="192.168.1.1"
n_ssid="x"
n_sspw="x"

resp=""
HTML_MAX=1460/5 -- reserve room for escaping
led_pin=4  -- D2?(not connected to board pin) GPIO2
therm_pin=5 -- D5 GPIO14
relay_pin=6 -- D6 GPIO6
def_ontemp=75
tset_file="degf"
loc=""
degc=nil
degf=nil
ref_delay=2
fan_state=0
tmrdelay=5
tm={}
tm.sec,tm.min,tm.hour,tm.day,tm.mon,tm.year=0,0,0,0,0,0

function http200()
 return("HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n")
end
function http404()
 return("HTTP/1.1 404 Not Found\r\nContent-Type: text/html\r\n")
end
function lf(f)
 print("Loading: "..f)
 fr=assert(loadfile(f))
 return(fr)
end
function fn_fanon()
 print(fcya.."FAN ON"..rst)
 gpio.write(relay_pin, gpio.LOW);
 gpio.write(led_pin, gpio.LOW);
 fan_state=1
end
function fn_fanoff()
 print(fcya.."FAN OFF"..rst)
 gpio.write(relay_pin, gpio.HIGH);
 gpio.write(led_pin, gpio.HIGH);
 fan_state=0
end
function unrequire(m)
 package.loaded[m]=nil
 _G[m]=nil
end
function gettemp()
 degc=therm.read()
 degf=therm.read(nil,therm.F)
end
function checktemp()
 gettemp()
 if(tonumber(degf)>=tonumber(on_temp))then
  --print("1: degf="..degf.." on_temp="..on_temp)
  if(fan_state==0)then fn_fanon() end
 else
  --print("2: degf="..degf.." on_temp="..on_temp)
  if(fan_state==1)then fn_fanoff() end
 end
end
function timefmt(t)
 return t.year.."-"..t.mon.."-"..t.day.." "..t.hour..":"..t.min..":"..t.sec
end


on_temp=lf("f_val_r.lua")(tset_file)
if(on_temp==nil)then
 on_temp=def_ontemp
 lf("f_val_w.lua")(tset_file,on_temp)
end

lf("f_startwifi.lua")()

therm=require("ds18b20")
lf("ansi.lua")()

gpio.mode(led_pin, gpio.OUTPUT)
gpio.mode(therm_pin, gpio.INPUT, gpio.PULLUP)
gpio.mode(relay_pin, gpio.OUTPUT)

therm.setup(therm_pin)
addrs=therm.addrs()
therm_exists=0
if(addrs==nil)then print("No DS18B20 temp sensors")
else
 print("Total DS18B20 sensors: "..table.getn(addrs).."")
 if(table.getn(addrs) > 0)then
  therm_exists=1
  print("Temp: "..therm.read().."'C ("..therm.read(nil,therm.F).."'F)")
 end
end

_FORM={}

function sendbig(c,s)
 --print("sendbig()")
 assert(loadfile("fn_sendbig.lua"))(c,s)
end

gettemp()

socks=0

srv=net.createServer(net.TCP)
srv:listen(80,function(c)
 c:on("receive", function(c,req)
  --lf("fn_sck_receive.lua")(c,req)
  c:send(http200().."\r\nNot enabled")
  c:close()
 end)
end)

function gettime(t)
 if(t~=nil)then
  tm=t
  print("Time received: "..timefmt(tm))
 end
end

function timer()
 tm.sec=tm.sec+tmrdelay
 if(tm.sec>=60)then tm.sec=0 tm.min=tm.min+1 end
 if(tm.min>=60)then tm.min=0 tm.hour=tm.hour+1 end
 if(tm.hour>=24)then tm.hour=0 tm.day=tm.day+1 end
 if(((tm.sec)%5)==0)then
  print("Time: "..timefmt(tm).." Temp:"..degf.." on_temp="..on_temp.." Heap: "..node.heap())
 end
 if((tm.year==0 and tm.min==0 and tm.sec==0) or ((tm.hour%6)==0 and tm.sec==0))then
  print(" Calling datetime")
  lf("fn_timenist.lua")(gettime)
 end
 --checktemp()
 collectgarbage();
end

print(fred.."Registering timer"..rst)
tmr.register(0,tmrdelay*1000,tmr.ALARM_AUTO,timer)
tmr.start(0)
--tmr.stop(0)

-- vim:et:ts=1:sw=1
