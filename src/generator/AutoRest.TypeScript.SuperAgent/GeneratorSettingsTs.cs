using AutoRest.Core.Extensibility;

namespace AutoRest.TypeScript.SuperAgent
{
    public class GeneratorSettingsTs : IGeneratorSettings
    {
        public virtual string Name => "TypeScript.SuperAgent";
        public virtual string Description => "SuperAgent TypeScript code generator.";
    }
}
