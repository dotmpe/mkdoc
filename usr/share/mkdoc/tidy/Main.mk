$(eval $(call module-header,tidy,$(MK_SHARE)tidy/Main.mk,Tidy (X)HTML validator and formatter))
#
#      ------------ -- 


$(if $(shell which gxl2gv),,$(info $(shell \
	$(ll) "warning" tidy "X(HT)ML formatter not available")))

tidy 			= tidy -m -q -wrap 0 -utf8 -i 
tidy-xml 		= $(tidy) -xml
tidy-xhtml 		= $(tidy) -asxhtml -access 1
tidy-check 		= tidy -utf8 -asxhtml -quiet -errors

