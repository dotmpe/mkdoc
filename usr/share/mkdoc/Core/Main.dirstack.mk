#      ------------ -- 
SP                  := $(SP).x
D_$(SP)             := $d
d                   := $(DIR)
/                   := $d/
B                   := $(BUILD)$/
#      ------------ -- 
$(info $(shell $(ll) file_target "$/" "Loading makefile.." ))
#             ------------ -- 

