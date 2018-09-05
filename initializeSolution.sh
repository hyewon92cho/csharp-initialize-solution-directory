#!/usr/bin/env bash

# get a project name
read -p 'Project name: ' projectName
echo 'Project name is "'$projectName'"'

# if there is no directory named $projectName
if [ -d ${projectName}.Solution ]; then
  echo Directory already exists...
else
  # make solution directory
  mkdir $projectName.Solution
  echo Make a new directory named $projectName.Solution... 
fi

# make project directory and test directory
mkdir $projectName.Solution/$projectName $projectName.Solution/$projectName.Tests
echo Make new directorys named $projectName and $projectName.Tests \in $projectName.Solution directory...

# make README.md file and git initialization
touch $projectName.Solution/README.md
echo Make $projectName.Solution/README.md file...
git init $projectName.Solution/
echo Initialize git...

# make project csproj file
touch $projectName.Solution/$projectName/$projectName.csproj
echo Make  new csproj file at $projectName.Solution/$projectName directory...
echo '<Project Sdk="Microsoft.NET.Sdk">' >> $projectName.Solution/$projectName/$projectName.csproj
echo '  <PropertyGroup>' >> $projectName.Solution/$projectName/$projectName.csproj
dotnetVersion="$(dotnet --version)"
echo '    <TargetFramework>netcoreapp'${dotnetVersion:0:3}'</TargetFramework>' >> $projectName.Solution/$projectName/$projectName.csproj
echo '  </PropertyGroup>' >> $projectName.Solution/$projectName/$projectName.csproj
echo '</Project>' >> $projectName.Solution/$projectName/$projectName.csproj
echo Initialize $projectName.Solution/$projectName/$projectName.csproj file...

# make project test csproj file
touch $projectName.Solution/$projectName.Tests/$projectName.Tests.csproj
echo '<Project Sdk="Microsoft.NET.Sdk">' >> $projectName.Solution/$projectName.Tests/$projectName.Tests.csproj
echo '  <PropertyGroup>' >> $projectName.Solution/$projectName.Tests/$projectName.Tests.csproj
echo '    <TargetFramework>netcoreapp'${dotnetVersion:0:3}'</TargetFramework>' >> $projectName.Solution/$projectName.Tests/$projectName.Tests.csproj
echo '  </PropertyGroup>' >> $projectName.Solution/$projectName.Tests/$projectName.Tests.csproj
echo '  <ItemGroup>' >> $projectName.Solution/$projectName.Tests/$projectName.Tests.csproj
echo '    <PackageReference Include="Microsoft.NET.Test.Sdk" Version="15.8.0" />' >> $projectName.Solution/$projectName.Tests/$projectName.Tests.csproj
echo '    <PackageReference Include="MSTest.TestAdapter" Version="1.3.2" />' >> $projectName.Solution/$projectName.Tests/$projectName.Tests.csproj
echo '    <PackageReference Include="MSTest.TestFramework" Version="1.3.2" />' >> $projectName.Solution/$projectName.Tests/$projectName.Tests.csproj
echo '  </ItemGroup>' >> $projectName.Solution/$projectName.Tests/$projectName.Tests.csproj
echo '  <ItemGroup>' >> $projectName.Solution/$projectName.Tests/$projectName.Tests.csproj
echo '    <ProjectReference Include="..\'$projectName'\'$projectName'.csproj" />' >> $projectName.Solution/$projectName.Tests/$projectName.Tests.csproj
echo '  </ItemGroup>' >> $projectName.Solution/$projectName.Tests/$projectName.Tests.csproj
echo '</Project>' >> $projectName.Solution/$projectName.Tests/$projectName.Tests.csproj
echo Initialize $projectName.Solution/$projectName.Tests/$projectName.Tests.csproj file...

# implement dotnet restore at test directory
dotnet restore $projectName.Solution/$projectName.Tests
echo implement dotnet restore at \test directory...

# make models directory
mkdir $projectName.Solution/$projectName/Models
echo Make $projectName.Solution/$projectName/Models directory...

# make models.test directory
mkdir $projectName.Solution/$projectName.Tests/ModelTests
echo Make $projectName.Solution/$projectName.Tests/ModelTests directory...