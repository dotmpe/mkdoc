#      ------------ -- 
SP                  := $(SP).x
D_$(SP)             := $d
d                   := $(DIR)
/                   := $d/
#      ------------ -- 
$(info $(shell $(ll) file_target "$/" "Loading makefile.." ))
#             ------------ -- 

