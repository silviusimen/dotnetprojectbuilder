#!/bin/bash

function get_script_code()
{
cat << '__HERE_DOCUMENT_END'
#!/bin/bash

TEST_COVERAGE=$(cat coverage.xml  | grep '<coverage' | grep 'line-rate="1"' | grep 'branch-rate="1"' | wc -l )

if [ $TEST_COVERAGE = "1" ]; then
    echo "Test coverage check passed"
else
    echo "Test coverage is not sufficient, forcing the build to fail"
    exit 1
fi
__HERE_DOCUMENT_END
}

DEST_FILE="$1"
get_script_code > "${DEST_FILE}"
