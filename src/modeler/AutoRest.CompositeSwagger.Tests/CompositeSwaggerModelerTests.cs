using System.IO;
using System.Linq;
using AutoRest.Core;
using AutoRest.Core.Logging;
using Xunit;
using static AutoRest.Core.Utilities.DependencyInjection;
namespace AutoRest.CompositeSwagger.Tests
{
    [Collection("AutoRest Tests")]
    public class CompositeSwaggerModelerTests
    {
        [Fact]
        public void CompositeSwaggerWithTwoModels()
        {
            using (NewContext)
            {
                new Settings
                {
                    Namespace = "Test",
                    Input = Path.Combine("Swagger", "composite-swagger-good1.json")
                };
                Modeler modeler = new CompositeSwaggerModeler();
                var clientModel = modeler.Build();
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
                new Settings
                {
                    Namespace = "Test",
                    Input = Path.Combine("Swagger", "composite-swagger-good2.json")
                };
                Modeler modeler = new CompositeSwaggerModeler();
                var clientModel = modeler.Build();

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
                new Settings
                {
                    Namespace = "Test",
                    Input = Path.Combine("Swagger", "composite-swagger-good3.json")
                };
                Modeler modeler = new CompositeSwaggerModeler();
                var clientModel = modeler.Build();

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
                new Settings
                {
                    Namespace = "Test",
                    Input = Path.Combine("Swagger", "composite-swagger-conflict-in-global-param.json")
                };
                Modeler modeler = new CompositeSwaggerModeler();
                Assert.Throws<CodeGenerationException>(() => modeler.Build());
            }
        }

        [Fact]
        public void CompositeModelWithConflictInModel()
        {
            using (NewContext)
            {
                new Settings
                {
                    Namespace = "Test",
                    Input = Path.Combine("Swagger", "composite-swagger-conflict-in-model.json")
                };
                Modeler modeler = new CompositeSwaggerModeler();
                Assert.Throws<CodeGenerationException>(() => modeler.Build());
            }
        }

        [Fact]
        public void CompositeModelWithConflictInSettings()
        {
            using (NewContext)
            {
                new Settings
                {
                    Namespace = "Test",
                    Input = Path.Combine("Swagger", "composite-swagger-conflict-in-settings.json")
                };
                Modeler modeler = new CompositeSwaggerModeler();
                Assert.Throws<CodeGenerationException>(() => modeler.Build());
            }
        }

        [Fact]
        public void CompositeModelWithEmptyDocuments()
        {
            using (NewContext)
            {
                new Settings
                {
                    Namespace = "Test",
                    Input = Path.Combine("Swagger", "composite-swagger-empty.json")
                };
                Modeler modeler = new CompositeSwaggerModeler();
                Assert.Throws<CodeGenerationException>(() => modeler.Build());
            }
        }

        [Fact]
        public void CompositeModelWithEmptyInfo()
        {
            using (NewContext)
            {
                new Settings
                {
                    Namespace = "Test",
                    Input = Path.Combine("Swagger", "composite-swagger-empty2.json")
                };
                Modeler modeler = new CompositeSwaggerModeler();
                Assert.Throws<CodeGenerationException>(() => modeler.Build());
            }
        }
    }
}
