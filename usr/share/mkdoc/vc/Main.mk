## 
MK_$d               := $(MK_SHARE)/mkdoc/vc/Main.mk
include                $(MK_SHARE)Core/Main.makefiles.mk
#
#      ------------ -- 

#$(call log-module,vc,Version Control)

clean-checkout = \
	d=$$(readlink -f $(DIR));\
		for f in $(GIT_$(DIR));\
		do\
			$(ll) header "$@" "Updating GIT" $$(dirname $$f);\
			cd $$(dirname $$f);\
			git pull;\
			git repack;\
			cd $$d;\
		done;\
		for f in $(HG_$(DIR));\
		do\
			$(ll) header "$@" "Updating Mercurial" $$(dirname $$f);\
			cd $$(dirname $$f);\
			hg pull; \
			hg update;\
			cd $$d;\
		done;\
		for f in $(BZR_$(DIR));\
		do\
			$(ll) header "$@" "Updating Bazaar" $$(dirname $$f);\
			cd $$(dirname $$f);\
			bzr pull;\
			cd $$d;\
		done

