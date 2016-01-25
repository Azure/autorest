// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using Microsoft.Rest.Generator.Logging;
using Xunit;
using Microsoft.Rest.Generator.Test.Resource;

namespace Microsoft.Rest.Generator.Test
{
    [Collection("AutoRest Tests")]
    public class AutoRestSettingsTests
    {
        [Fact]
        public void CreateWithoutArgumentsReturnsBlankSettings()
        {
            var settings = Settings.Create((string[]) null);
            Assert.NotNull(settings);
            settings = Settings.Create((IDictionary<string, string>) null);
            Assert.NotNull(settings);
            settings = Settings.Create(new string[0]);
            Assert.NotNull(settings);
            settings = Settings.Create(new Dictionary<string, string>());
            Assert.NotNull(settings);
        }

        [Fact]
        public void CreateWithMultipleEmptyKeysStoreInCustomDictonary()
        {
            var settings = Settings.Create(new[] {"-Help", " -Bar ", " -Foo"});
            Assert.Equal("", settings.CustomSettings["Help"]);
            Assert.Equal("", settings.CustomSettings["Foo"]);
            Assert.Equal("", settings.CustomSettings["Bar"]);
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
        public void CreateWithValidParametersWorks()
        {
            var settings = Settings.Create(new[]
            {
                "-Help", " -Input", "c:\\input",
                "-outputDirectory", " c:\\output", "-clientName", "MyClient"
            });
            Assert.Equal("", settings.CustomSettings["Help"]);
            Assert.Equal("c:\\input", settings.Input);
            Assert.Equal("c:\\output", settings.OutputDirectory);
            Assert.Equal("MyClient", settings.ClientName);
        }

        [Fact]
        public void CreateWithAliasedParametersWorks()
        {
            var settings = Settings.Create(new[]
            {
                "-h", " --i", "/c/input",
                "-output", " c:\\output", "-clientName", "MyClient"
            });
            Assert.True(settings.ShowHelp);
            Assert.Equal("/c/input", settings.Input);
            Assert.Equal("c:\\output", settings.OutputDirectory);
            Assert.Equal("MyClient", settings.ClientName);
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
                var codeGenerator = new SampleCodeGenerator(settings);
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