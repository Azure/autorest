using System;
using System.IO;
using AutoRest.Core;
using AutoRest.Core.Utilities;
using AutoRest.Swagger;
using NUnit.Framework;

namespace AutoRest.CSharp.LoadBalanced.Tests
{
   [TestFixture]
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
                    path = "C:\\projects\\autorest\\src\\generator\\AutoRest.CSharp.LoadBalanced.Tests";
                }

                var settings = new Settings
                               {
                                   Input = "http://petstore.swagger.io/v2/swagger.json",
                                   OutputDirectory = "D:\\projects\\gen2",
                                   CodeGenerator = "Test",
                                   Namespace = "Agoda.SAPI.Client"
                               };

                var modeler = new SwaggerModeler();
                var codeModel = modeler.Build();
                var plugin = new LoadBalancedPluginCs();

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
