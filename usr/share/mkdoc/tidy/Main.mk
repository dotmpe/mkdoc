MK               += $(MK_SHARE)/tidy/Main.mk


tidy 			= tidy -q -wrap 0 -utf8 -i 
tidy-xml 		= $(tidy) -xml
tidy-xhtml 		= $(tidy) -asxhtml -access 1

