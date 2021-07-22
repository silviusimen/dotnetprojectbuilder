# dotnetprojectbuilder
Dot Net new project builder
# Dotnet setup
```
sudo ./install_dotnet_sdk.sh
```

# Project setup
```
export DOT_NET_PRJ_NAME="Ml.Prj.1"
mkdir -p ${DOT_NET_PRJ_NAME}/src
pushd ${DOT_NET_PRJ_NAME}/src
dotnet new classlib -f netcoreapp3.1 -n ${DOT_NET_PRJ_NAME}.Lib
popd
mkdir -p ${DOT_NET_PRJ_NAME}/test
pushd ${DOT_NET_PRJ_NAME}/test
dotnet new xunit -n ${DOT_NET_PRJ_NAME}.UnitTest
popd

dotnet add ${DOT_NET_PRJ_NAME}/test/${DOT_NET_PRJ_NAME}.UnitTest/${DOT_NET_PRJ_NAME}.UnitTest.csproj reference ${DOT_NET_PRJ_NAME}/src/${DOT_NET_PRJ_NAME}.Lib/${DOT_NET_PRJ_NAME}.Lib.csproj
pushd ${DOT_NET_PRJ_NAME}/test/${DOT_NET_PRJ_NAME}.UnitTest
dotnet add package coverlet.msbuild
dotnet add package Moq
dotnet add package FluentAssertions
popd

pushd ${DOT_NET_PRJ_NAME}
dotnet new sln -n ${DOT_NET_PRJ_NAME}
dotnet sln ${DOT_NET_PRJ_NAME}.sln add src/${DOT_NET_PRJ_NAME}.Lib/${DOT_NET_PRJ_NAME}.Lib.csproj
dotnet sln ${DOT_NET_PRJ_NAME}.sln add test/${DOT_NET_PRJ_NAME}.UnitTest/${DOT_NET_PRJ_NAME}.UnitTest.csproj

dotnet build
dotnet test --collect:"XPlat Code Coverage" -r TestResults

popd
```
# Coverga info
## Add to test/${DOT_NET_PRJ_NAME}.UnitTest/${DOT_NET_PRJ_NAME}.UnitTest.csproj
```
  <PropertyGroup>
    <CoverletOutputFormat>cobertura</CoverletOutputFormat>
    <CoverletOutput>../../coverage.xml</CoverletOutput>
    <CollectCoverage>true</CollectCoverage>
  </PropertyGroup>
```