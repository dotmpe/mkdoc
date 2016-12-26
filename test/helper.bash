
init()
{
  test -n "$base" || {
    case "$ENV" in
      dev* ) 
        base="make -f ${MK_DIR}/Mkdoc-full.mk" ;;
      * )
        base=make ;;
    esac
  }
  export base
}

### Misc. helper functions

trueish()
{
  test -n "$1" || return 1
  case "$1" in
		[Oo]n|[Tt]rue|[Yyj]|[Yy]es|1 )
      return 0;;
    * )
      return 1;;
  esac
}

noop()
{
  set --
}

fnmatch()
{
  case "$2" in $1 ) return 0 ;; *) return 1 ;; esac
}


common_test()
{
  test ${status} -eq 0
}

common_test_conclusion()
{
  trueish "$DEBUG" && {
    diag "Lines (${#lines[@]}): ${lines[*]}"
  }
  common_test || {
    trueish "$DEBUG" || diag "Lines (${#lines[@]}): ${lines[*]}"
    fail "$BATS_TEST_DESCRIPTION ($base $1)"
  }
}
