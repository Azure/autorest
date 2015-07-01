// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Microsoft.Rest.Generator.CSharp.Tests;
using System;
using System.Diagnostics;
using System.IO;
using Xunit;
using Xunit.Abstractions;

namespace Microsoft.Rest.Generator.Ruby.Tests
{
    [Collection("AutoRest Tests")]
    [TestCaseOrderer("Microsoft.Rest.Generator.CSharp.Tests.SwaggerBatTestOrderer",
        "AutoRest.Generator.CSharp.Tests")]
    public class AcceptanceTestsBase : IClassFixture<ServiceController>
    {
        private static string RspecFolder = @"RspecTests\";
        private static string SwaggerFolder = @"Swagger\";
        private static string Modeler = "Swagger";
        private static string Namespace = "MyNamespace";
        private static string RubyExecutable = "ruby";
        private static string ServerURIEnvironmentVariableName = "StubServerURI";
        private static int TestTimeout = 600000; // 10 minute

        protected readonly string CodeGenerator;
        protected readonly ITestOutputHelper Output;
        public ServiceController Fixture { get; set; }

        public AcceptanceTestsBase(ServiceController data, ITestOutputHelper output, string generatorType)
        {
            this.Fixture = data;
            this.Output = output;
            this.CodeGenerator = generatorType;
        }

        protected void GenerateClient(string swagger, string destFolder)
        {
            try 
            {
                Directory.Delete(destFolder, true);
            }
            catch (DirectoryNotFoundException) { }
            
            AutoRest.Generate(new Settings
            {
                Input = swagger,
                OutputDirectory = destFolder,
                CodeGenerator = CodeGenerator,
                Modeler = Modeler,
                Namespace = Namespace
            });

            Assert.True(Directory.Exists(destFolder), String.Format("Client generation for \"{0}\" failed", swagger));
        }

        protected void ExecuteRspecTest(string spec)
        {
            Assert.True(File.Exists(spec), String.Format("Test file \"{0}\" doesn't exists", spec));

            var processInfo = new ProcessStartInfo { FileName = RubyExecutable, Arguments = @"rspec " + spec };
            processInfo.EnvironmentVariables[ServerURIEnvironmentVariableName] = this.Fixture.Uri.AbsoluteUri;

            ProcessSync rspec = new ProcessSync(processInfo);
            rspec.Start();

            if (rspec.WaitForExit(TestTimeout))
            {
                Output.WriteLine(rspec.CombinedOutput);

                Assert.True(rspec.ExitCode == 0, String.Format("Tests \"{0}\" finished with errors.", spec));
            }
            else
            {
                Assert.True(false, String.Format("Tests \"{0}\" exceeded a {1} min. timeout.", spec, TestTimeout / 60000));
            }
        }
        
        protected void Test(string spec, string swaggerFile, string destFolder)
        {
            GenerateClient(Path.Combine(SwaggerFolder, swaggerFile), Path.Combine(RspecFolder, destFolder));
            ExecuteRspecTest(Path.Combine(RspecFolder, spec));
        }
    }
}
