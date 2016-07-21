local k,v
resp="<html>"
for k,v in pairs(file.list()) do
    resp=resp..k.." ("..v.." bytes) <a href='rm?f="..k.."'>rm</a> <a href='cat?f="..k.."'>cat</a><br />"
end
resp=resp.."</html>"
