
using Microsoft.Rest.Generator;
using Microsoft.Rest.Generator.CSharp.Tests;
using System;
using System.Collections.Concurrent;
using System.Diagnostics;
using System.IO;
using System.Text;
using System.Threading;
using Xunit;
using Xunit.Abstractions;

namespace Ruby.Tests
{
    [Collection("AutoRest Tests")]
    [TestCaseOrderer("Microsoft.Rest.Generator.CSharp.Tests.SwaggerBatTestOrderer",
        "AutoRest.Generator.CSharp.Tests")]
    internal class AcceptanceTests : IClassFixture<ServiceController>
    {
        private static string RspecFolder = @"RspecTests\";
        private static string SwaggerFolder = @"..\..\..\..\AcceptanceTests\swagger\";
        private static string CodeGenerator = "Ruby";
        private static string Modeler = "Swagger";
        private static string Namespace = "MyNamespace";
        private static string RubyExecutable = "ruby";
        private static string ServerURIEnvironmentVariableName = "StubServerURI";
        private static int TestTimeout = 600000; // 10 minute

        private readonly ITestOutputHelper output;
        public ServiceController Fixture { get; set; }

        public AcceptanceTests(ServiceController data, ITestOutputHelper output)
        {
            this.Fixture = data;
            this.output = output;
        }

        private void GenerateClient(string swagger, string destFolder)
        {
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

        private void ExecuteRspecTest(string spec)
        {
            Assert.True(File.Exists(spec), String.Format("Test file \"{0}\" doesn't exists", spec));

            Process rspec = new Process
            {
                StartInfo = new ProcessStartInfo
                {
                    FileName = RubyExecutable,
                    Arguments = @"rspec " + spec,
                    UseShellExecute = false,
                    RedirectStandardOutput = true,
                    RedirectStandardError = true,
                }
            };
            rspec.StartInfo.EnvironmentVariables[ServerURIEnvironmentVariableName] = this.Fixture.Uri.AbsoluteUri;

            StringBuilder outputBuilder = new StringBuilder();
            StringBuilder error = new StringBuilder();

            using (AutoResetEvent outputWaitHandle = new AutoResetEvent(false))
            {
                using (AutoResetEvent errorWaitHandle = new AutoResetEvent(false))
                {
                    rspec.OutputDataReceived += (sender, e) =>
                    {
                        if (e.Data == null)
                        {
                            outputWaitHandle.Set();
                        }
                        else
                        {
                            outputBuilder.AppendLine(e.Data);
                        }
                    };
                    rspec.ErrorDataReceived += (sender, e) =>
                    {
                        if (e.Data == null)
                        {
                            errorWaitHandle.Set();
                        }
                        else
                        {
                            error.AppendLine(e.Data);
                        }
                    };

                    rspec.Start();

                    rspec.BeginOutputReadLine();
                    rspec.BeginErrorReadLine();

                    if (rspec.WaitForExit(TestTimeout) &&
                        outputWaitHandle.WaitOne(TestTimeout) &&
                        errorWaitHandle.WaitOne(TestTimeout))
                    {
                        var result = outputBuilder.ToString() + error.ToString();

                        output.WriteLine(result);

                        Assert.True(rspec.ExitCode == 0, String.Format("Tests \"{0}\" finished with errors.", spec));
                    }
                    else
                    {
                        Assert.True(false, String.Format("Tests \"{0}\" exceeded a {1} min. timeout.", spec, TestTimeout / 60000));
                    }
                }
            }
        }

        private void Test(string spec, string swaggerFile, string destFolder)
        {
            GenerateClient(Path.Combine(SwaggerFolder, swaggerFile), Path.Combine(RspecFolder, destFolder));
            ExecuteRspecTest(Path.Combine(RspecFolder, spec));
        }

        [Fact]
        public void BoolTests()
        {
            Test("bool_spec.rb", "body-boolean.json", "Boolean");
        }

        [Fact(Skip = "not completely implemented yet")]
        public void DictionaryTests()
        {
            Test("dictionary_spec.rb", "body-dictionary.json", "Dictionary");
        }

        [Fact(Skip = "not completely implemented yet")]
        public void ComplexTests()
        {
            Test("complex_spec.rb", "body-complex.json", "Complex");
        }

        [Fact]
        public void IntegerTests()
        {
            Test("integer_spec.rb", "body-integer.json", "Integer");
        }

        [Fact]
        public void NumberTests()
        {
            Test("number_spec.rb", "body-number.json", "Number");
        }

        [Fact]
        public void StringTests()
        {
            Test("string_spec.rb", "body-string.json", "String");
        }

        [Fact]
        public void ByteTests()
        {
            Test("byte_spec.rb", "body-byte.json", "Byte");
        }

        [Fact(Skip = "not completely implemented yet")]
        public void UrlPathTests()
        {
            Test("path_spec.rb", "url.json", "Url");
        }

        [Fact(Skip = "not completely implemented yet")]
        public void UrlQeruiesTests()
        {
            Test("query_spec.rb", "url.json", "UrlQuery");
        }

        [Fact(Skip = "not completely implemented yet")]
        public void UrlItemsTests()
        {
            Test("path_items_spec.rb", "url.json", "UrlItems");
        }

        [Fact(Skip = "not completely implemented yet")]
        public void DateTimeTests()
        {
            Test("datetime_spec.rb", "body-datetime.json", "DateTime");
        }

        [Fact]
        public void DateTests()
        {
            Test("date_spec.rb", "body-date.json", "Date");
        }

        [Fact]
        public void ArrayTests()
        {
            Test("array_spec.rb", "body-array.json", "Array");
        }

        [Fact(Skip = "not completely implemented yet")]
        public void HeaderTests()
        {
            Test("header_spec.rb", "header.json", "Header");
        }

        [Fact(Skip = "not completely implemented yet")]
        public void HttpInfrastructureTests()
        {
            Test("header_spec.rb", "httpInfrastructure.json", "HttpInfrastructure");
        }

        [Fact(Skip = "not completely implemented yet")]
        public void RequiredOptionalTests()
        {
            Test("header_spec.rb", "required-optional.json", "RequiredOptional");
        }

        [Trait("Report", "true")]
        [Fact(Skip = "not all tests are ready so test coverage is too low")]
        public void EnsureTestCoverage()
        {
            Test("report_spec.rb", "report.json", "Report");
        }
    }
}
