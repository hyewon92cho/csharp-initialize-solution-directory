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
dotnetVersion="$(dotnet --version)"
cat >$projectName.Solution/$projectName/$projectName.csproj <<EOL
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <TargetFramework>netcoreapp${dotnetVersion:0:5}</TargetFramework>
  </PropertyGroup>
</Project>
EOL
echo Initialize $projectName.Solution/$projectName/$projectName.csproj file...

# make project test csproj file
touch $projectName.Solution/$projectName.Tests/$projectName.Tests.csproj
cat >$projectName.Solution/$projectName.Tests/$projectName.Tests.csproj <<EOL
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <TargetFramework>netcoreapp${dotnetVersion:0:5}</TargetFramework>
  </PropertyGroup>
  <ItemGroup>
    <PackageReference Include="Microsoft.NET.Test.Sdk" Version="15.8.0" />
    <PackageReference Include="MSTest.TestAdapter" Version="1.3.2" />
    <PackageReference Include="MSTest.TestFramework" Version="1.3.2" />
  </ItemGroup>
  <ItemGroup>
    <ProjectReference Include="..\\${projectName}\\${projectName}.csproj" />
  </ItemGroup>
</Project>
EOL
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