using AutoRest.Core;
using AutoRest.Core.Utilities;
using AutoRest.TypeScript.SuperAgent.Model;
using NUnit.Framework;

namespace AutoRest.TypeScript.SuperAgent.Tests
{
    [TestFixture]
    public class Class1
    {
        [Test]
        public void PassingTest()
        {

            var generator = new CodeGeneratorTs();

            var model = new CodeModelTs();

            var settings = Settings.Instance;

            settings.Input = "";
            settings.OutputDirectory = "";

            settings.CodeGenerator = "";

            Core.AutoRestController.Generate();


            generator.Generate(model);

        }

    }
}
