using System;
using System.IO;
using AutoRest.Core;
using AutoRest.Core.Utilities;
using AutoRest.Swagger;
using NUnit.Framework;

namespace AutoRest.CSharp.LoadBalanced.Legacy.Tests
{
   [TestFixture]
    public class OutputTest
    {
        //[Test, Ignore("local test ")]
        [Test]
        public void PassingTest()
        {
            Func<string, string> parent = path => Directory.GetParent(path).FullName;
            var currentPath = Directory.GetCurrentDirectory();

            Console.WriteLine("Starting PassingTest");

            using (var context = new DependencyInjection.Context().Activate())
            {
                var path = "";

                try
                {
                    parent(parent(parent(currentPath)));
                }
                catch (NullReferenceException)
                {
                    path = "C:\\DevWorkspace\\git\\autorest\\src\\generator\\AutoRest.CSharp.LoadBalanced.Tests";
                }

                var settings = new Settings
                               {
                                   Input = "C:\\swagger\\temp\\temp.json.txt",
                                   OutputDirectory = "C:\\swagger\\output\\_test",
                                   CodeGenerator = "Test",
                                   Namespace = "Agoda.SupplyApi.Client"
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
