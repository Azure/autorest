using AutoRest.Core;
using AutoRest.Core.Extensibility;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.TypeScript.SuperAgent.Model;

namespace AutoRest.TypeScript.SuperAgent
{
    public sealed class PluginTs : Plugin<GeneratorSettingsTs, ModelSerializer<CodeModelTs>, TransformerTs, CodeGeneratorTs, CodeNamerTs, CodeModelTs>
    {
        public PluginTs()
        {
            Context = new DependencyInjection.Context
            {
                // inherit base settings
                Context,

                // set code model implementations our own implementations 
                new Factory<CodeModel, CodeModelTs>(),
                new Factory<CompositeType, CompositeTypeTs>(),
                new Factory<DictionaryType, DictionaryTypeTs>(),
                new Factory<EnumType, EnumTypeTs>(),
                new Factory<Method, MethodTs>(),
                new Factory<MethodGroup, MethodGroupTs>(),
                new Factory<Parameter, ParameterTs>(),
                new Factory<PrimaryType, PrimaryTypeTs>(),
                new Factory<Property, PropertyTs>(),
                new Factory<SequenceType, SequenceTypeTs>(),

                // we have a specific constructor for when a literal type is necessary.
                //new Factory<ILiteralType> {(string name) => new CompositeTypeCsa {Name = {FixedValue = name}}},
            };
        }
    }
}
