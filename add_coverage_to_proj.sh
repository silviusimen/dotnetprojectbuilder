#!/bin/bash

CS_PRJ_FILE="$1"

has_coverage=$(cat "${CS_PRJ_FILE}" | grep "<CoverletOutput>" | wc -l)

function coverage_xml()
{
cat << __COVERAGE_PROPERTY_GROUP
  <PropertyGroup>
    <CoverletOutputFormat>cobertura</CoverletOutputFormat>
    <CoverletOutput>../../coverage.xml</CoverletOutput>
    <CollectCoverage>true</CollectCoverage>
  </PropertyGroup>

</Project>
__COVERAGE_PROPERTY_GROUP
}

if [ $has_coverage == 1 ]; then
    echo "${CS_PRJ_FILE} already has coverage collection turned on, skipping"
    exit 0
else
    tempfile=$(mktemp)
    cat ${CS_PRJ_FILE} | sed 's:</Project>::' > $tempfile
    coverage_xml >> $tempfile
    mv -f $tempfile ${CS_PRJ_FILE}
    rm -f $tempfile
fi
