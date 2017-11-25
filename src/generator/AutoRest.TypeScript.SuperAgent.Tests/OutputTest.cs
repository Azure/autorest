using System;
using System.IO;
using AutoRest.Core;
using AutoRest.Core.Utilities;
using AutoRest.Swagger;
using NUnit.Framework;

namespace AutoRest.TypeScript.SuperAgent.Tests
{
   [TestFixture()]
    public class OutputTest
    {
        [Test]
        public void PassingTest()
        {
            var workingDir = Path.Combine(Directory.GetCurrentDirectory(), @"..\..\..\Resource");
            var inputFile = Path.Combine(workingDir, "test1.json");

            using (var context = new DependencyInjection.Context().Activate())
            {
                var settings = new Settings
                               {
                                   Input = inputFile,
                                   OutputDirectory = workingDir,
                                   CodeGenerator = "Test"
                               };

                var modeler = new SwaggerModeler();
                var codeModel = modeler.Build();
                var plugin = new PluginTs();

                using (plugin.Activate())
                {
                    codeModel = plugin.Serializer.Load(codeModel);
                    codeModel = plugin.Transformer.TransformCodeModel(codeModel);

                    //settings.CodeGenerator = "";

                    Core.AutoRestController.Generate();
                }
            }

        }

    }
}
