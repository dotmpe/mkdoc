
DU_GEN           := $(DU_GEN) --no-datestamp

TRGT_$d += main,du.xml .build/main.du.xhtml main,du.pxml

TRGT += $(TRGT_$d)
CLN += $(TRGT_$d)

KWDS_$d := $/KEYWORDS

$(info KWDS=$(shell $(kwds-file)))

test-du-result:
	md5sum -c check.md5 
	
update-du-result:
	pwd -P
	ls -la
	md5sum main,du.pxml > check.md5 

STRGT += test-du-result
TEST += test-du-result
