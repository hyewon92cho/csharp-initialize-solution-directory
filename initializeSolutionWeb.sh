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
    <PackageReference Include="Microsoft.AspNetCore.StaticFiles" Version="1.1.3" />
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
            app.UseDeveloperExceptionPage();
            app.UseStaticFiles();
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
EOL

# Choose DB Connection
echo 'Do you want to connect DB? [y/n]'
read -p 'Connect DB: ' connectDB

# get a database name
if [$connectDB = "y"] || [$connectDB = "Y"] then
  read -p 'DB name: ' dbName
  echo 'DB name is "'$dbName'"'
  echo 'Initialize solution directory with DB...'
else
  echo 'Initialize solution directory without DB...'
fi

    public static class DBConfiguration
    {
        public static string ConnectionString = "server=localhost;user id=root;password=root;port=8889;database=${dbName};";
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
mkdir $projectName.Solution/$projectName/Properties
mkdir $projectName.Solution/$projectName/wwwroot
mkdir $projectName.Solution/$projectName/wwwroot/css
mkdir $projectName.Solution/$projectName/wwwroot/js
mkdir $projectName.Solution/$projectName/wwwroot/img
mkdir $projectName.Solution/$projectName/Models
touch $projectName.Solution/$projectName/Models/Database.cs
cat >$projectName.Solution/$projectName/Models/Database.cs <<EOL
using System;
using MySql.Data.MySqlClient;
using ${projectName};

namespace ${projectName}.Models
{
    public class DB
    {
        public static MySqlConnection Connection()
        {
            MySqlConnection conn = new MySqlConnection(DBConfiguration.ConnectionString);
            return conn;
        }
    }
}
EOL
mkdir $projectName.Solution/$projectName/Views
mkdir $projectName.Solution/$projectName/Views/Home
touch $projectName.Solution/$projectName/Views/Home/Index.cshtml
cat >$projectName.Solution/$projectName/Views/Home/Index.cshtml <<EOL
@{
  Layout = "_Layout";
}
EOL
mkdir $projectName.Solution/$projectName/Views/Shared
touch $projectName.Solution/$projectName/Views/Shared/_Layout.cshtml
cat >$projectName.Solution/$projectName/Views/Shared/_Layout.cshtml <<EOL
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title>${projectName}</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
        <link rel="stylesheet" href="/css/styles.css">
    </head>
    <body>
        <!-- @Html.Partial("Header") -->
        @RenderBody()
        <!-- @Html.Partial("Footer") -->
    </body>
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
</html>
EOL
touch $projectName.Solution/$projectName/Views/Shared/Header.cshtml
touch $projectName.Solution/$projectName/Views/Shared/Footer.cshtml

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

# database connection
dotnet add package MySqlConnector

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
