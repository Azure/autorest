using System.IO;
using System.Linq;
using AutoRest.Core;
using AutoRest.Core.Logging;
using Xunit;
using static AutoRest.Core.Utilities.DependencyInjection;
using System;
using AutoRest.Core.Legacy;
using AutoRest.Core.Utilities;
using AutoRest.Swagger;

namespace AutoRest.CompositeSwagger.Tests
{
    [Collection("AutoRest Tests")]
    public class SwaggerModelerTests
    {
        [Fact]
        public void CompositeSwaggerWithTwoModels()
        {
            using (NewContext)
            {
                var modeler = new SwaggerModeler();
                var clientModel = modeler.Build(new FileSystem(), CompositeServiceDefinition.GetInputFiles(new FileSystem(), Path.Combine("Swagger", "composite-swagger-good1.json")), true);
                Assert.Equal("2014-04-01-preview",
                    clientModel.Methods.FirstOrDefault(m => m.Name == "SimpleGet")
                        .Parameters.FirstOrDefault(p => p.SerializedName == "api-version")
                        .DefaultValue);
                Assert.Equal(true,
                    clientModel.Methods.FirstOrDefault(m => m.Name == "SimpleGet")
                        .Parameters.FirstOrDefault(p => p.SerializedName == "api-version")
                        .IsConstant);
                Assert.Equal(5, clientModel.Methods.Count);
                Assert.Equal(3, clientModel.ModelTypes.Count);
                Assert.Equal(2, clientModel.MethodGroupNames.Count());
            }
        }

        [Fact]
        public void CompositeSwaggerWithOneModel()
        {

            using (NewContext)
            {
                var modeler = new SwaggerModeler();
                var clientModel = modeler.Build(new FileSystem(), CompositeServiceDefinition.GetInputFiles(new FileSystem(), Path.Combine("Swagger", "composite-swagger-good2.json")));

                Assert.Equal(2, clientModel.Methods.Count);
                Assert.Equal(2, clientModel.ModelTypes.Count);
                Assert.Equal(1, clientModel.MethodGroupNames.Count());
            }
        }

        [Fact]
        public void CompositeSwaggerWithSameModels()
        {

            using (NewContext)
            {
                var modeler = new SwaggerModeler();
                var clientModel = modeler.Build(new FileSystem(), CompositeServiceDefinition.GetInputFiles(new FileSystem(), Path.Combine("Swagger", "composite-swagger-good3.json")));

                Assert.Equal(2, clientModel.Methods.Count);
                Assert.Equal(2, clientModel.ModelTypes.Count);
                Assert.Equal(1, clientModel.MethodGroupNames.Count());
            }
        }

        [Fact]
        public void CompositeModelWithConflictInGlobalParam()
        {
            using (NewContext)
            {
                var modeler = new SwaggerModeler();
                Assert.Throws<Exception>(() => modeler.Build(new FileSystem(), CompositeServiceDefinition.GetInputFiles(new FileSystem(), Path.Combine("Swagger", "composite-swagger-conflict-in-global-param.json"))));
            }
        }

        [Fact]
        public void CompositeModelWithConflictInModel()
        {
            using (NewContext)
            {
                var modeler = new SwaggerModeler();
                Assert.Throws<Exception>(() => modeler.Build(new FileSystem(), CompositeServiceDefinition.GetInputFiles(new FileSystem(), Path.Combine("Swagger", "composite-swagger-conflict-in-model.json"))));
            }
        }

        [Fact(Skip = "TEMP, see #1713")]
        public void CompositeModelWithConflictInSettings()
        {
            using (NewContext)
            {
                var modeler = new SwaggerModeler();
                Assert.Throws<Exception>(() => modeler.Build(new FileSystem(), CompositeServiceDefinition.GetInputFiles(new FileSystem(), Path.Combine("Swagger", "composite-swagger-conflict-in-settings.json"))));
            }
        }

        [Fact]
        public void CompositeModelWithEmptyDocuments()
        {
            using (NewContext)
            {
                var modeler = new SwaggerModeler();
                Assert.Throws<CodeGenerationException>(() => modeler.Build(new FileSystem(), CompositeServiceDefinition.GetInputFiles(new FileSystem(), Path.Combine("Swagger", "composite-swagger-empty.json"))));
            }
        }

        [Fact]
        public void CompositeModelWithEmptyInfo()
        {
            using (NewContext)
            {
                var modeler = new SwaggerModeler();
                Assert.Throws<NullReferenceException>(() => modeler.Build(new FileSystem(), CompositeServiceDefinition.GetInputFiles(new FileSystem(), Path.Combine("Swagger", "composite-swagger-empty2.json"))));
            }
        }
    }
}
