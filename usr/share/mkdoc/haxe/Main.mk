$(info $(shell $(ll) file_target "haxe" "HaXe main" ))
MK               += $(DIR)/haxe/Main.mk

### Flags

#HX 	 			= -cp src/hx -cp text/hx

ifneq ($(VERBOSE), )
HX 				+= -v
endif
ifeq ($(DEBUG), )
HX 				+= --no-traces 
else
HX 				+= -D debug 
endif


