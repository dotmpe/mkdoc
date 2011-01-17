$(call log-module,"tidy","Tidy (X)HTML validator and formatter")
MK               += $(MK_SHARE)/tidy/Main.mk


tidy 			= tidy -m -q -wrap 0 -utf8 -i 
tidy-xml 		= $(tidy) -xml
tidy-xhtml 		= $(tidy) -asxhtml -access 1
tidy-check 		= tidy -utf8 -asxhtml -quiet -errors

