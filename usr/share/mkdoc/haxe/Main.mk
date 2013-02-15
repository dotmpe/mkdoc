$(call log-module,HaXe,Main)
MK               += $(DIR)/haxe/Main.mk

$(if $(shell which haxe),,$(info $(shell \
	$(ll) "warning" haxe "HaXe is not available")))

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


