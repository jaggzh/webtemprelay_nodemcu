WEBDIR=/var/www/jaggyweb/pub/esp
SHELL=/bin/bash
baud=19200
baud=9600
baud=115200
delay=.3
delay=.02
LUATOOL_OPTS=--delay $(delay) -b $(baud)
AUX_FILES=start.lua ansi.lua f_*.lua fn_*.lua w_*.lua
ALL_FILES=$(AUX_FILES) init.lua

%: fn_%.lua
	luatool.py $(LUATOOL_OPTS) -f "$<" -t "$<"
%: f_%.lua
	luatool.py $(LUATOOL_OPTS) -f "$<" -t "$<"
%: w_%.lua
	luatool.py $(LUATOOL_OPTS) -f "$<" -t "$<"
%: %.lua
	luatool.py $(LUATOOL_OPTS) -f "$<" -t "$<"

all: cp start espcom
	@echo "luatool.py -f webled.lua -t init.lua -r"
	@echo "webled   -- uploads webled.lua"
	@echo "start  -- uploads start.lua"
	#@echo
	#@read -t 3 -p "Uploading in 3 seconds"
	#luatool.py -b $(baud) -f webled-dim.lua -t init.lua -r

start:
	luatool.py $(LUATOOL_OPTS) -f start.lua -t start.lua -r

#init: f_*.lua fn_*.lua
extras:
	luatool.py $(LUATOOL_OPTS) -f ../modules/ds18b20.lua -t ds18b20.lua
	sleep 1
	for i in $(ALL_FILES); do echo ">>>>>> $$i"; luatool.py $(LUATOOL_OPTS) -f "$$i" -t "$$i"; echo "Waiting to send next file"; sleep 1; done

espcom:
	espcom

cp:
	cp start.lua $(WEBDIR)

vi:
	vi Makefile init.lua start.lua fn_*.lua f_*.lua w_*.lua ansi.lua
