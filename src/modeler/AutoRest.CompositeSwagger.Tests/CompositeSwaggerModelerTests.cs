using System.IO;
using System.Linq;
using AutoRest.Core;
using AutoRest.Core.Logging;
using Xunit;

namespace AutoRest.CompositeSwagger.Tests
{
    [Collection("AutoRest Tests")]
    public class CompositeSwaggerModelerTests
    {
        [Fact]
        public void CompositeSwaggerWithTwoModels()
        {

            Modeler modeler = new CompositeSwaggerModeler(new Settings
            {
                Namespace = "Test",
                Input = Path.Combine("Swagger", "composite-swagger-good1.json")
            });
            var clientModel = modeler.Build();
            Assert.Equal("2014-04-01-preview", clientModel.Methods.FirstOrDefault(m => m.Name == "SimpleGet").Parameters.FirstOrDefault(p => p.SerializedName == "api-version").DefaultValue);
            Assert.Equal(true, clientModel.Methods.FirstOrDefault(m => m.Name == "SimpleGet").Parameters.FirstOrDefault(p => p.SerializedName == "api-version").IsConstant);
            Assert.Equal(5, clientModel.Methods.Count);
            Assert.Equal(3, clientModel.ModelTypes.Count);
            Assert.Equal(2, clientModel.MethodGroups.Count());
        }

        [Fact]
        public void CompositeSwaggerWithOneModel()
        {

            Modeler modeler = new CompositeSwaggerModeler(new Settings
            {
                Namespace = "Test",
                Input = Path.Combine("Swagger", "composite-swagger-good2.json")
            });
            var clientModel = modeler.Build();

            Assert.Equal(2, clientModel.Methods.Count);
            Assert.Equal(2, clientModel.ModelTypes.Count);
            Assert.Equal(1, clientModel.MethodGroups.Count());
        }

        [Fact]
        public void CompositeSwaggerWithSameModels()
        {

            Modeler modeler = new CompositeSwaggerModeler(new Settings
            {
                Namespace = "Test",
                Input = Path.Combine("Swagger", "composite-swagger-good3.json")
            });
            var clientModel = modeler.Build();

            Assert.Equal(2, clientModel.Methods.Count);
            Assert.Equal(2, clientModel.ModelTypes.Count);
            Assert.Equal(1, clientModel.MethodGroups.Count());
        }

        [Fact]
        public void CompositeModelWithConflictInGlobalParam()
        {

            Modeler modeler = new CompositeSwaggerModeler(new Settings
            {
                Namespace = "Test",
                Input = Path.Combine("Swagger", "composite-swagger-conflict-in-global-param.json")
            });
            Assert.Throws<CodeGenerationException>(() => modeler.Build());
        }

        [Fact]
        public void CompositeModelWithConflictInModel()
        {

            Modeler modeler = new CompositeSwaggerModeler(new Settings
            {
                Namespace = "Test",
                Input = Path.Combine("Swagger", "composite-swagger-conflict-in-model.json")
            });
            Assert.Throws<CodeGenerationException>(() => modeler.Build());
        }

        [Fact]
        public void CompositeModelWithConflictInSettings()
        {

            Modeler modeler = new CompositeSwaggerModeler(new Settings
            {
                Namespace = "Test",
                Input = Path.Combine("Swagger", "composite-swagger-conflict-in-settings.json")
            });
            Assert.Throws<CodeGenerationException>(() => modeler.Build());
        }

        [Fact]
        public void CompositeModelWithEmptyDocuments()
        {

            Modeler modeler = new CompositeSwaggerModeler(new Settings
            {
                Namespace = "Test",
                Input = Path.Combine("Swagger", "composite-swagger-empty.json")
            });
            Assert.Throws<CodeGenerationException>(() => modeler.Build());
        }

        [Fact]
        public void CompositeModelWithEmptyInfo()
        {

            Modeler modeler = new CompositeSwaggerModeler(new Settings
            {
                Namespace = "Test",
                Input = Path.Combine("Swagger", "composite-swagger-empty2.json")
            });
            Assert.Throws<CodeGenerationException>(() => modeler.Build());
        }
    }
}
