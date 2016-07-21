--Queries NIST DayTime server for a date time string
--adapted from http://www.esp8266.com/viewtopic.php?p=8733
--from httpget.lua example from LuaLoader Quick Start guide

--Call like:
-- function gettime(tm) something_with_tm end
-- assert(loadfile("fn_datetime.lua"))(gettime)

--JJJJJ YR-MO-DA HH:MM:SS TT L H msADV UTC(NIST) OTM. 
--Ex: 57577 16-07-08 04:22:46 50 0 0 609.8 UTC(NIST) * 
--JJJJJ - the modified Julian Date (JD-2400000.5)
--YR-MO-DA
--HH:MM:SS
--TT - USA is on Standard Time (ST) or (DST) : 00 (ST)
--L - Leap second at the end of the month (0: no, 1: +1, 2: -1)
--H - Health of the server (0: healthy, >0: errors)
--msADV - time code advanced in ms for network delays
--UTC(NIST) - the originator of this time code
--OTM - on-time marker : * (time correct on arival)

local cb=...
local t={}
local syear,smon,sday,shour,smin,ssec
local c

local function timeconn()
 print("Conn. to time server:")
 c:connect(13,'128.138.141.172')--'utcnist2.colorado.edu') 
end

c=net.createConnection(net.TCP,0) 
c:on("receive", function(c, pl) 
 print('received date: '..fred..pl..rst)
 syear=string.sub(pl,8,9)
 smon=string.sub(pl,11,12)
 sday=string.sub(pl,14,15)
 shour=string.sub(pl,17,18)
 smin=string.sub(pl,20,21)
 ssec=string.sub(pl,23,24)
 if(syear~=nil or smon~=nil or sday~=nil or
  shour~=nil or smin~=nil or ssec~=nil)then
   t.year=2000+tonumber(syear)
   t.mon=tonumber(smon)
   t.day=tonumber(sday)
   t.hour=tonumber(shour)
   t.min=tonumber(smin)
   t.sec=tonumber(ssec)
   if(t.year~=nil or t.mon~=nil or t.day~=nil or
    t.hour~=nil or t.min~=nil or t.sec~=nil)then
     cb(t) -- pass it on
   else
    print("num date fail")
   end
 else
  print("str date fail")
 end
 c:close()
end) 
c:on("disconnection", function(c, pl)
 print('Disc. from Time')
 if(syear==nil)then
  print("Failed to receive time (syear==nil)")
  timeconn()
 end
end)
timeconn()
-- vim:et:ts=1:sw=1
