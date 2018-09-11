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
touch $projectName.Solution/.gitignore
cat >$projectName.Solution/.gitignore <<EOL
obj/

bin/

EOL
echo Initialize git...

# make project csproj file
touch $projectName.Solution/$projectName/$projectName.csproj
dotnetVersion="$(dotnet --version)"
cat >$projectName.Solution/$projectName/$projectName.csproj <<EOL
<Project Sdk="Microsoft.NET.Sdk.Web">
  <PropertyGroup>
    <TargetFramework>netcoreapp${dotnetVersion}</TargetFramework>
  </PropertyGroup>
  <ItemGroup>
    <PackageReference Include="Microsoft.AspNetCore" Version="1.1.2" />
    <PackageReference Include="Microsoft.AspNetCore.Http" Version="1.1.2" />
    <PackageReference Include="Microsoft.AspNetCore.Mvc" Version="1.1.3" />
  </ItemGroup>
</Project>
EOL
echo Initialize $projectName.Solution/$projectName/$projectName.csproj file...

# make Startup.cs
touch $projectName.Solution/$projectName/Startup.cs
cat >$projectName.Solution/$projectName/Startup.cs <<EOL
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace ${projectName}
{
    public class Startup
    {
        public Startup(IHostingEnvironment env)
        {
            var builder = new ConfigurationBuilder()
                .SetBasePath(env.ContentRootPath)
                .AddEnvironmentVariables();
            Configuration = builder.Build();
        }

        public IConfigurationRoot Configuration { get; }

        public void ConfigureServices(IServiceCollection services)
        {
            services.AddMvc();
        }

        public void Configure(IApplicationBuilder app)
        {
            app.UseMvc(routes =>
            {
                routes.MapRoute(
                    name: "default",
                    template: "{controller=Home}/{action=Index}/{id?}");
            });
            app.Run(async (context) =>
            {
                await context.Response.WriteAsync("Hello World!");
            });
        }
    }
}
EOL
echo making Startup.cs...

# make Program.cs
touch $projectName.Solution/$projectName/Program.cs
cat >$projectName.Solution/$projectName/Program.cs <<EOL
using System.IO;
using Microsoft.AspNetCore.Hosting;

namespace ${projectName}
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var host = new WebHostBuilder()
                .UseKestrel()
                .UseContentRoot(Directory.GetCurrentDirectory())
                .UseIISIntegration()
                .UseStartup<Startup>()
                .Build();

            host.Run();
        }
    }
}
EOL
echo making Program.cs...

# make models directory
mkdir $projectName.Solution/$projectName/Models
mkdir $projectName.Solution/$projectName/Views
mkdir $projectName.Solution/$projectName/Views/Home
mkdir $projectName.Solution/$projectName/Controllers
touch $projectName.Solution/$projectName/Controllers/HomeController.cs
cat >$projectName.Solution/$projectName/Controllers/HomeController.cs <<EOL
using Microsoft.AspNetCore.Mvc;
using ${projectName}.Models;
namespace ${projectName}.Controllers
{
    public class HomeController : Controller
    {

    }
}
EOL
echo Make and initialize directories and files...

# dotnet restore in main directory
dotnet restore $projectName.Solution/$projectName

# make project test csproj file
touch $projectName.Solution/$projectName.Tests/$projectName.Tests.csproj
cat >$projectName.Solution/$projectName.Tests/$projectName.Tests.csproj <<EOL
<Project Sdk="Microsoft.NET.Sdk.Web">
  <PropertyGroup>
    <TargetFramework>netcoreapp${dotnetVersion}</TargetFramework>
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

# make models.test directory
mkdir $projectName.Solution/$projectName.Tests/ModelTests
mkdir $projectName.Solution/$projectName.Tests/ControllerTests
touch $projectName.Solution/$projectName.Tests/ControllerTests/HomeControllerTest.cs
cat >$projectName.Solution/$projectName.Tests/ControllerTests/HomeControllerTest.cs <<EOL
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using ${projectName}.Controllers;
using ${projectName}.Models;

namespace ${projectName}.Tests
{
    [TestClass]
    public class HomeControllerTest
    {
    }
}
EOL
mkdir $projectName.Solution/$projectName.Tests/ViewTests
echo Make $projectName.Solution/$projectName.Tests/ModelTests directory...

# implement dotnet restore at test directory
dotnet restore $projectName.Solution/$projectName.Tests
echo implement dotnet restore at \test directory...