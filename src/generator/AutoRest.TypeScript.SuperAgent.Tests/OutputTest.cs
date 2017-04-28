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
            Func<string, string> parent = path => Directory.GetParent(path).FullName;
            var currentPath = Directory.GetCurrentDirectory();

            using (var context = new DependencyInjection.Context().Activate())
            {
                var path = "";

                try
                {
                    parent(parent(parent(currentPath)));
                }
                catch (NullReferenceException)
                {
                    path = "C:\\projects\\autorest\\src\\generator\\AutoRest.TypeScript.SuperAgent.Tests\\Resource";
                }

                var settings = new Settings
                               {
                                   Input = Path.Combine(path, "Resource\\test3.json"),
                                   OutputDirectory = Path.Combine(currentPath, "test3.json"),
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
