using AutoRest.Core;
using AutoRest.Core.Utilities;
using AutoRest.Swagger;
using NUnit.Framework;

namespace AutoRest.TypeScript.SuperAgent.Tests
{
   [TestFixture()]
    public class Class1
    {
        [Test]
        public void PassingTest()
        {
            using (var context = new DependencyInjection.Context().Activate())
            {
                var settings = new Settings
                               {
                                   Input = "C:\\Users\\jlaszlo\\Desktop\\a.json",
                                   OutputDirectory = "D:\\IT-Hotel\\YCS\\Ycs Web\\Agoda.WebSite.ClientSide\\scripts\\services",
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
