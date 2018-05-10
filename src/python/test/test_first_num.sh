#! /bin/bash -x

set -e

test_expected () {
    BASH_DIR=$(dirname_ $BASH_SOURCE)
    PARENT=$(dirname_ $BASH_DIR)
    if [[ $(python $PARENT/first_num.py "$@") == $EXPECTED ]]; then
        echo pass
        return 0
    fi
    echo fail
    echo -n "Expected: ${EXPECTED}, Args: $* "
    echo Actual: $(python $PARENT/first_num.py "$@")
    return 1
}


EXPECTED=3
test_expected 3
test_expected 3 4
test_expected 3 hhh lll
test_expected hhh 3 lll
test_expected hhh lll 3

EXPECTED="hhh lll"
test_expected 3 hhh lll --Invert
test_expected hhh 3 lll --Invert
test_expected hhh lll 3 --Invert
test_expected --Invert 3 hhh lll
test_expected --Invert hhh 3 lll
test_expected --Invert hhh lll 3
test_expected 3 hhh --Invert lll
test_expected hhh 3 --Invert lll
test_expected hhh --Invert lll 3

EXPECTED=""
test_expected hhh lll

EXPECTED="hhh lll"
test_expected hhh lll --Invert
test_expected hhh 3 lll --Invert
