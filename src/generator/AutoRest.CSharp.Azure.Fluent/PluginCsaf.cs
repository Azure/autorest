// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Core;
using AutoRest.Core.Extensibility;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.CSharp.Azure.Fluent.Model;
using AutoRest.CSharp.Azure.Model;
using AutoRest.CSharp.Model;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.CSharp.Azure.Fluent
{
    public sealed class PluginCsaf :
        Plugin
        <GeneratorSettingsCsaf, ModelSerializer<CodeModelCsaf>, TransformerCsaf, CodeGeneratorCsaf, CodeNamerCs,
            CodeModelCsaf>
    {
        public PluginCsaf()
        {
            Context = new Context
            {
                // inherit base settings
                Context,

                // set code model implementations our own implementations 
                new Factory<CodeModel, CodeModelCsaf>(),
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
                new Factory<ILiteralType> {(string name) => new CompositeTypeCsa {Name = {FixedValue = name}}}
            };
        }
    }
}