#
#      ------------ -- 


###    Python
#      ------------ -- 


# default python version
PY_FULL_VERSION     := $(shell python -V 2>&1 | sed 's/^Python\ \([0-9\.]\+\)+\?$$/\1/g')
PY_MM_VERSION       := $(shell echo $(PY_FULL_VERSION) | sed 's/^\([0-9]\+\)\.\([0-9]\+\).*$$/\1.\2/')
PY_MMID_VERSION      := $(shell echo $(PY_MM_VERSION) | sed 's/\.//g')
$(info PY_FULL_VERSION=$(PY_FULL_VERSION))
$(info PY_MMID_VERSION=$(PY_MMID_VERSION))
$(info PY_MM_VERSION=$(PY_MM_VERSION))

# add BIN python{version} keys
$(foreach PY,2.4 2.5 2.6 2.7, \
	$(if $(shell which python$(PY)),\
		$(eval BIN += python$(shell echo $(PY)|sed 's/\.//g')=$(shell which python$(PY)))))

$(info 4 $(BIN))

ifneq ($(shell which python),)
ifeq ($(shell which python$(PY_FULL_VERSION)),)
BIN                 += python$(PY_MMID_VERSION)=$(shell which python$(PY_FULL_VERSION))
else
BIN                 += python$(PY_MMID_VERSION)=$(shell which python)
endif
$(info 3 $(BIN))
BIN                 += python=python$(PY_MMID_VERSION)
endif
$(eval $(if $(call get-bin,python),,$(info no Python available)))


###    Mercurial (hg)
#      ------------ -- 

ifneq ($(shell which hg),)
BIN                 += hg=$(shell which hg)
endif

$(if $(shell $(call get-bin,hg)),,$(info no Mercurial (hg) available))


###    Subversion (svn)
#      ------------ -- 

ifneq ($(shell which svn),)
BIN                 += svn=$(shell which svn)
endif

$(if $(shell $(call get-bin,svn)),,$(info no Subversion (svn) available))


###    GIT
#      ------------ -- 

ifneq ($(shell which git),)
BIN                 += git=$(shell which git)
endif

$(if $(shell $(call get-bin,git)),,$(info no GIT available))


#      ------------ -- 
#
