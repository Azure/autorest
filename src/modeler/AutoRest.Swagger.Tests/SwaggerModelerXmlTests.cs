
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.IO;
using System.Linq;
using System.Net;
using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Core.Extensibility;
using AutoRest.Core.Utilities;
using Newtonsoft.Json.Linq;
using Xunit;
using static AutoRest.Core.Utilities.DependencyInjection;
using System.Globalization;

namespace AutoRest.Swagger.Tests
{
    public class SwaggerModelerXmlTests
    {
        [Fact]
        public void TestNameOverrideRules()
        {
            using (NewContext)
            {
                new Settings
                {
                    Namespace = "Test",
                    Input = Path.Combine("Resource","Swagger", "swagger-xml.yaml")
                };
                var modeler = new SwaggerModeler();
                var codeModel = modeler.Build(SwaggerParser.Parse(File.ReadAllText(Settings.Instance.Input)));
                foreach (var modelType in codeModel.ModelTypes)
                {
                    Assert.Equal(modelType.Documentation, modelType.XmlName);
                    foreach (var property in codeModel.Properties)
                    {
                        Assert.Equal(property.Documentation, property.XmlName);
                    }
                }
            }
        }

        [Fact]
        public void TestRealPathRegular()
        {
            using (NewContext)
            {
                new Settings
                {
                    Namespace = "Test",
                    Input = Path.Combine("Resource","Swagger", "swagger-xml.yaml")
                };
                var modeler = new SwaggerModeler();
                var codeModel = modeler.Build(SwaggerParser.Parse(File.ReadAllText(Settings.Instance.Input)));
                foreach (var property in codeModel.ModelTypes.SelectMany(m => m.Properties))
                {
                    Assert.Equal(property.Name, string.Join(".", property.RealPath));
                    Assert.Equal(property.XmlName, string.Join(".", property.RealXmlPath));
                }
            }
        }

        [Fact]
        public void TestRealPathIrregular()
        {
            using (NewContext)
            {
                new Settings
                {
                    Namespace = "Test",
                    Input = Path.Combine("Resource","Swagger", "swagger-xml-paths.yaml")
                };
                var modeler = new SwaggerModeler();
                var codeModel = modeler.Build(SwaggerParser.Parse(File.ReadAllText(Settings.Instance.Input)));
                foreach (var property in codeModel.ModelTypes.SelectMany(m => m.Properties))
                {
                    var expectedRealPath = property.Documentation.StartsWith("CUSTOM_")
                                         ? property.Documentation.Substring("CUSTOM_".Length)
                                         : null;
                    var expectedRealXmlPath = property.Summary;

                    if (expectedRealPath != null)
                    {
                        Assert.Equal(expectedRealPath, string.Join(".", property.RealPath));
                    }
                    if (expectedRealXmlPath != null)
                    {
                        Assert.Equal(expectedRealXmlPath, string.Join(".", property.RealXmlPath));
                    }
                }
            }
        }
    }
}
