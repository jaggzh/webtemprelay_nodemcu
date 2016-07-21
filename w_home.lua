local re_st=gpio.read(relay_pin)

resp=[[<html><head><style>
button { display:inline-block; width:48%; text-decoration:none; padding:0; font-size:200%; }
h1,p {font-size:100%}
.box {display:block; border:1px solid black; padding:.5em;}
h1,div,em {padding:0; margin:0}
sm {display:block; font-size:80%;}
iframe {display:block; height:1em; width:100%}
</style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.0.0/jquery.min.js"></script>
<script>
//$('#temp').load("/temp"); // not working
function updt() { setTimeout(function() { $('#temp').load("/temp", updt); }, 5000); }
updt();
</script>
<link rel="shortcut icon" href="data:image/x-icon;," type="image/x-icon"></head><body>
<h1>ESP8266 Fan Controller</h1>]]
resp=resp.."<sm>Free mem: "..node.heap().." [ <a href=/ls>ls</a> | <a href=/rst>restart</a> ]</sm>"

resp=resp.."<style>"
if(re_st==1)then resp=resp.."#butoff {background: green}"
else resp=resp.."#buton {background: green}"
end
resp=resp..[[</style>
<div id=temp></div>
<div class=box>Fan:<br />
<a href="/on"><button id=buton>ON</button></a><a href="/off"><button id=butoff>OFF</button></a></p>
<form class=box method=GET action=tset>Fan on at:
<input type=number min=40 max=120 step=.5 name=t value=']]..on_temp..
[['>F <input type=submit></form></div>

<form class=box method=GET action=ul>Get script<br />
<input type=text size=15 name=host value=192.168.1.9 placeholder=IP>:<input type=number name=port value=80>
Path /<input type=text size=20 name=path value=esp>/<br />
Src: <input type=text size=20 name=sfn value=webtemp.lua><br />
Dst: <input type=text size=20 name=dfn value=init.lua><br />
<input type=submit></form></div>]]
