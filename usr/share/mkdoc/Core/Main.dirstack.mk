#      ------------ -- 
SP                  := $(SP).x
D_$(SP)             := $d
d                   := $(DIR)
/                   := $d/
B                   := $(/:./%=$(BUILD)%)
#      ------------ -- 
$(call chat,info,"$/",Loading makefile)
$(call chat,debug,"$/","\'BUILD=$B\'")
#             ------------ -- 

