
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
using AutoRest.CSharp;
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
                    Input = Path.Combine("Swagger", "swagger-xml.yaml")
                };
                Modeler modeler = new SwaggerModeler();
                var codeModel = modeler.Build();
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
    }
}
