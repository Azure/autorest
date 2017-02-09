using AutoRest.Core;
using AutoRest.Core.Utilities;
using AutoRest.TypeScript.SuperAgent.Model;
using Xunit;

namespace AutoRest.TypeScript.SuperAgent.Tests
{
   
    public class Class1
    {
        [Fact]
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
