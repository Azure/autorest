using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AutoRest.Core;
using AutoRest.Core.Extensibility;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.CSharp.Azure.Model;
using AutoRest.CSharp.Model;

namespace AutoRest.CSharp.Azure
{
    public sealed class PluginCsa : Plugin<GeneratorSettingsCsa, ModelSerializer<CodeModelCsa>, TransformerCsa, CodeGeneratorCsa, CodeNamerCs, CodeModelCsa>
    {
        public PluginCsa()
        {
            Context = new DependencyInjection.Context
            {
                // inherit base settings
                Context,

                // set code model implementations our own implementations 
                new Factory<CodeModel, CodeModelCsa>(),
                new Factory<CompositeType, CompositeTypeCsa>(),
                new Factory<DictionaryType, DictionaryTypeCs>(),
                new Factory<EnumType, EnumTypeCs>(),
                new Factory<Method, MethodCsa>(),
                new Factory<MethodGroup, MethodGroupCsa>(),
                new Factory<Parameter, ParameterCsa>(),
                new Factory<PrimaryType, PrimaryTypeCsa>(),
                new Factory<Property, PropertyCs>(),
                new Factory<SequenceType, SequenceTypeCs>(),

                // we have a specific constructor for when a literal type is necessary.
                new Factory<ILiteralType> {(string name) => new CompositeTypeCsa {Name = {FixedValue = name}}},
            };
        }
    }
}
