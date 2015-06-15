
check-file-versions::
	git-versioning check

STRGT += do-release
do-release:: min := 
do-release:: maj := 
do-release::
do-release:: M=Release
do-release:: check-file-versions
	[ -n "$(VERSION)" ] || exit 1
	git ci -m "$(M) $(VERSION)"
	git tag $(VERSION)
	git push origin
	git push --tags
	git-versioning increment $(min) $(maj)
	BRANCH=$$(git status|grep On.branch|awk '{print $$3}'); \
	git-versioning pre-release $$BRANCH
	@git add $$(echo $$(cat .versioned-files.list))

