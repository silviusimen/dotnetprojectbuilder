#!/bin/bash

DOT_NET_PRJ_NAME="$1"

if [ -z "$DOT_NET_PRJ_NAME" ]; then
  echo "Project identifier is a required parameter"
  exit 1
fi

SELFDIRREL=$(dirname $0)
SELFDIR=$(readlink -f ${SELFDIRREL}/)

SRC_DIR=src
TESTS_DIR=tests

UT_SUFFIX=.UnitTests
LIB_SUFFIX=.Lib
CLI_SUFFIX=.Cli


UT_PRJ=${DOT_NET_PRJ_NAME}${UT_SUFFIX}
LIB_PRJ=${DOT_NET_PRJ_NAME}${LIB_SUFFIX}
CLI_PRJ=${DOT_NET_PRJ_NAME}${CLI_SUFFIX}

UT_PRJ_FILE=${TESTS_DIR}/${UT_PRJ}/${UT_PRJ}.csproj
LIB_PRJ_FILE=${SRC_DIR}/${LIB_PRJ}/${LIB_PRJ}.csproj
CLI_PRJ_FILE=${SRC_DIR}/${CLI_PRJ}/${CLI_PRJ}.csproj

function create_class_lib_proj()
{
  mkdir -p ${SRC_DIR}
  pushd ${SRC_DIR}
    dotnet new classlib -f netcoreapp3.1 -n ${LIB_PRJ}
  popd
}

function create_cli_proj()
{
  mkdir -p ${SRC_DIR}
  pushd ${SRC_DIR}
    dotnet new console -f netcoreapp3.1 -n ${CLI_PRJ}
  popd
}

function add_cli_project_references()
{
  dotnet add ${CLI_PRJ_FILE} reference ${LIB_PRJ_FILE}
}

function create_ut_proj()
{
  mkdir -p ${TESTS_DIR}
  pushd ${TESTS_DIR}
    dotnet new xunit -n ${UT_PRJ}
  popd
}

function add_ut_project_references()
{
  dotnet add ${UT_PRJ_FILE} reference ${LIB_PRJ_FILE}
}

function add_ut_project_packages()
{
  pushd ${TESTS_DIR}/${UT_PRJ}
    dotnet add package coverlet.msbuild
    dotnet add package Moq
    dotnet add package FluentAssertions
  popd
}

function create_solution_file()
{
  dotnet new sln -n ${DOT_NET_PRJ_NAME}
  dotnet sln ${DOT_NET_PRJ_NAME}.sln add ${LIB_PRJ_FILE}
  dotnet sln ${DOT_NET_PRJ_NAME}.sln add ${CLI_PRJ_FILE}
  dotnet sln ${DOT_NET_PRJ_NAME}.sln add ${UT_PRJ_FILE}
}

function add_code_coverage_to_ut_project()
{
  ${SELFDIR}/add_coverage_to_project.sh "${UT_PRJ_FILE}"
}

function create_coverage_check_script()
{
  mkdir -p scripts
  ${SELFDIR}/create_coverage_check_script.sh scripts/ut_coverage_check.sh
}

function create_makefile()
{
  ${SELFDIR}/create_makefile.sh ${DOT_NET_PRJ_NAME} Makefile
}

function build_project()
{
  make clean
  make build-dev
  make unit-test
}

function create_git_ignore_entries()
{
  echo ".gitignore"
  echo ".vscode/" 
  echo "coverage.xml" 
  echo "${SRC_DIR}/${CLI_PRJ}/bin/"
  echo "${SRC_DIR}/${CLI_PRJ}/obj/"
  echo "${SRC_DIR}/${LIB_PRJ}/bin/"
  echo "${SRC_DIR}/${LIB_PRJ}/obj/"
  echo "${TESTS_DIR}/${UT_PRJ}/bin/"
  echo "${TESTS_DIR}/${UT_PRJ}/obj/"
}

function create_git_repo()
{
  rm -rf .git/
  git init .
  create_git_ignore_entries > .gitignore
  git add Makefile scripts/ ${DOT_NET_PRJ_NAME}.sln ${LIB_PRJ_FILE} ${CLI_PRJ_FILE} ${UT_PRJ_FILE}
  git add ${SRC_DIR} ${TESTS_DIR}
  git status
}

function run_workflow_from_prj_dir()
{
  create_class_lib_proj
  create_cli_proj
  add_cli_project_references
  create_ut_proj
  add_ut_project_references
  add_ut_project_packages
  create_solution_file
  add_code_coverage_to_ut_project
  create_coverage_check_script
  create_makefile 
  build_project
  create_git_repo
}

function run_workflow()
{
  mkdir -p ${DOT_NET_PRJ_NAME}
  pushd ${DOT_NET_PRJ_NAME}
    run_workflow_from_prj_dir
  popd
}

run_workflow
