c,r=...
loc=nil resp=nil

print("entered")

local function rec_get(name, value)
 _FORM[name]=value
 print("GET: " .. name .. ": " .. value)
end

--print(fgre.."Client connected to port 80"..rst)
--print(fred.."REQUEST: {{"..r.."}}"..rst);
local _, _, meth, path, vars

_, _, meth, path, vars=string.find(r, "([A-Z]+) (.+)%?(.*) HTTP");
if(meth==nil)then _, _, meth, path=string.find(r, "([A-Z]+) (.+) HTTP"); end

if(meth==nil)then
 print(fred.."Unknown query string {{"..r.."}}"..rst)
 _, _, meth, path=string.find(r, "([A-Z]+) (.-) HTTP");
end
--print("Method: "..meth)
print(fred.."GET "..path..rst)
if(meth=="GET")then
 --print("Entered GET")
 if(vars ~= nil)then
  --print("Vars: "..vars)
  local k,v
  for k, v in string.gmatch(vars, "([^=&]+)=([^=&]+)&*") do
   rec_get(k, v)
  end
 end
 if(path=="/ul")then print("fn_dl()") fn_dl()
 elseif(path=="/ls")then print("ls()") lf("f_ls.lua")()
 elseif(path=="/rm")then print("rm()") dofile("f_rm.lua")
 elseif(path=="/rst")then print("fn_rst()") fn_rst(c)
 elseif(path=="/cat")then print("cat()") lf("f_cat.lua")(c)
 elseif(path=="/tset")then print("tset()") dofile("f_tset.lua")
 elseif(path=="/on")then print("fan_on()") fn_fanon() loc="/" resp="Wait..."
 elseif(path=="/off")then print("fan_off()") fn_fanoff() loc="/" resp="Wait..."
 elseif(path=="/temp")then fn_temp()
 elseif(path=="/")then print("w_home()") lf("w_home.lua")(c)
 else
  print("Bad page"..path) c:send(http_404.."\r\nNot found")
 end
else
 print("!GET") resp="!GET"
end

if(loc~=nil)then
 if(resp==nil)then resp="" end
 resp=http_200.."\r\n<meta http-equiv=Refresh content='"..ref_delay..";url="..loc.."' />"..resp
end

if(resp~=nil)then
 --print("Sending response: {{"..resp.."}}")
 sendbig(c,resp)--closes too
end

collectgarbage();
-- vim:et:ts=1:sw=1
