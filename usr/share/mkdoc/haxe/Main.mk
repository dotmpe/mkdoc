$(eval $(call module-header,haxe,$(MK_SHARE)haxe/Main.mk,"HaXe cross-platform compiler"))
#
#      ------------ -- 


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


