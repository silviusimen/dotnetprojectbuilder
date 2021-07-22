#!/bin/bash

function get_script_code()
{
cat << '__HERE_DOCUMENT_END'
#!/bin/bash

PROJECT=PROJECT_NAME_PLACEHOLDER
APPVERSION=1.0.0
TESTS_DIR=tests
UNIT_TESTS_DIR=${PROJECT}.UnitTests

clean:
	dotnet clean -c Debug ${PROJECT}.sln
	dotnet clean -c Release ${PROJECT}.sln

restore:
	dotnet restore $(PROJECT).sln

build-dev:
	dotnet build -c Debug $(PROJECT).sln

build-release:
	dotnet build -c Release $(PROJECT).sln

test: build-dev
	dotnet test $(PROJECT).sln

unit-test:
	dotnet test $(TESTS_DIR)/$(UNIT_TESTS_DIR)
	./scripts/ut_coverage_check.sh

.PHONY: doc

__HERE_DOCUMENT_END
}

DOT_NET_PRJ_NAME="$1"
DEST_FILE="$2"
get_script_code | sed "s/PROJECT_NAME_PLACEHOLDER/${DOT_NET_PRJ_NAME}/" > "${DEST_FILE}"
