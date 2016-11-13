using AutoRest.Core;
using AutoRest.Core.Extensibility;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.NodeJS.Azure.Model;
using AutoRest.NodeJS.Model;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.NodeJS.Azure
{
    public class GeneratorSettingsJsa : GeneratorSettingsJs
    {
        public override string Name => "Azure.NodeJS";

        public override string Description => "Azure specific NodeJS code generator.";
    }

    public sealed class PluginJsa : Plugin<GeneratorSettingsJsa, ModelSerializer<CodeModelJsa>, TransformerJsa, CodeGeneratorJsa, CodeNamerJs, CodeModelJsa>
    {
        public PluginJsa()
        {
            Context = new Context
            {
                // inherit base settings
                Context,

                // set code model implementations our own implementations 
                new Factory<CodeModel, CodeModelJsa>(),
                new Factory<Method, MethodJsa>(),
                new Factory<CompositeType, CompositeTypeJs>(),
                new Factory<Property, PropertyJs>(),
                new Factory<Parameter, ParameterJs>(),
                new Factory<DictionaryType, DictionaryTypeJs>(),
                new Factory<SequenceType, SequenceTypeJs>(),
                new Factory<MethodGroup, MethodGroupJs>(),
                new Factory<EnumType, EnumType>(),
                new Factory<PrimaryType, PrimaryTypeJs>()
            };
        }
    }
}