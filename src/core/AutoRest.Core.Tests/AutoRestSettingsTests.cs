// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using AutoRest.Core.Logging;
using Newtonsoft.Json.Linq;
using Xunit;

namespace AutoRest.Core.Tests
{
    [Collection("AutoRest Tests")]
    public class AutoRestSettingsTests
    {
        [Fact]
        public void CreateWithoutArgumentsReturnsBlankSettings()
        {
            var settings = Settings.Create((string[]) null);
            Assert.NotNull(settings);
            settings = Settings.Create((IDictionary<string, object>) null);
            Assert.NotNull(settings);
            settings = Settings.Create(new string[0]);
            Assert.NotNull(settings);
            settings = Settings.Create(new Dictionary<string, object>());
            Assert.NotNull(settings);
        }

        [Fact]
        public void CreateWithMultipleEmptyKeysStoreInCustomDictonary()
        {
            var settings = Settings.Create(new[] {"-Help", " -Bar ", " -Foo"});
            Assert.True(settings.ShowHelp);
            Assert.Equal("", settings.CustomSettings["Foo"]);
            Assert.Equal("", settings.CustomSettings["Bar"]);
        }

        [Fact]
        public void LoadCodeGenSettingsFromJsonFile()
        {
            var codeBaseUrl = new Uri(Assembly.GetExecutingAssembly().CodeBase);
            var codeBasePath = Uri.UnescapeDataString(codeBaseUrl.AbsolutePath);
            var dirPath = Path.GetDirectoryName(codeBasePath);
            var settingsFile = Path.Combine(dirPath, "Resource\\SampleSettings.json");
            var settings = Settings.Create(new[] {"-cgs", settingsFile});
            Assert.False((bool) settings.CustomSettings["sampleSwitchFalse"]);
            Assert.True((bool) settings.CustomSettings["sampleSwitchTrue"]);
            Assert.Equal("Foo", settings.CustomSettings["sampleString"]);
            Assert.Equal(typeof (JArray), settings.CustomSettings["filePathArray"].GetType());
            Assert.Equal(2, ((JArray) settings.CustomSettings["filePathArray"]).Count);
            Assert.Equal(typeof (JArray), settings.CustomSettings["intArray"].GetType());
            Assert.Equal(typeof (long), settings.CustomSettings["intFoo"].GetType());
        }

        [Fact]
        public void EmptyCredentialsSettingIsSetToTrueIfPassed()
        {
            var settings = Settings.Create(new[] {"-AddCredentials"});
            Assert.True(settings.AddCredentials);
        }

        [Fact]
        public void NonEmptyCredentialsSettingIsSetToValueIfPassed()
        {
            var settings = Settings.Create(new[] {"-AddCredentials false"});
            Assert.False(settings.AddCredentials);
        }

        [Fact]
        public void NonEmptyPackageVersionIsSet()
        {
            var settings = Settings.Create(new[] {"-pv", "1.2.1"});
            Assert.Equal("1.2.1", settings.PackageVersion);
        }

        [Fact]
        public void NonEmptyPackageNameIsSet()
        {
            var settings = Settings.Create(new[] {"-pn", "HelloWorld"});
            Assert.Equal("HelloWorld", settings.PackageName);
        }

        [Fact]
        public void CreateWithValidParametersWorks()
        {
            var settings = Settings.Create(new[]
            {
                "-Help", " -Input", "c:\\input",
                "-outputDirectory", " c:\\output", "-clientName", "MyClient",
                "-ModelsName", "MyModels"
            });
            Assert.True(settings.ShowHelp);
            Assert.Equal("c:\\input", settings.Input);
            Assert.Equal("c:\\output", settings.OutputDirectory);
            Assert.Equal("MyClient", settings.ClientName);
            Assert.Equal("MyModels", settings.ModelsName);
        }

        [Fact]
        public void CreateWithAliasedParametersWorks()
        {
            var settings = Settings.Create(new[]
            {
                "-h", " --i", "/c/input",
                "-output", " c:\\output", "-clientName", "MyClient",
                "-mname", "MyModels"
            });
            Assert.True(settings.ShowHelp);
            Assert.Equal("/c/input", settings.Input);
            Assert.Equal("c:\\output", settings.OutputDirectory);
            Assert.Equal("MyClient", settings.ClientName);
            Assert.Equal("MyModels", settings.ModelsName);
        }

        [Fact]
        public void IntegerParameterWorks()
        {
            var settings = Settings.Create(new[]
            {
                "-ft", "3", "-PayloadFlatteningThreshold", "4"
            });
            Assert.Equal(4, settings.PayloadFlatteningThreshold);
        }

        [Fact]
        public void MissingParameterThrowsException()
        {
            var settings = Settings.Create(new[] {"-Modeler", "foo"});
            try
            {
                settings.Validate();
                Assert.True(false);
            }
            catch (CodeGenerationException e)
            {
                Assert.NotNull(e.InnerExceptions);
                Assert.Equal(1, e.InnerExceptions.Count);
                Assert.True(e.InnerExceptions.Any(i =>
                    i.Message.Equals(string.Format("Parameter '{0}' is required.", "Input"))));
            }
        }
    }
}
