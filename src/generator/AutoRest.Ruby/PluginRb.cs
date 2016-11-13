// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Core;
using AutoRest.Core.Extensibility;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Ruby.Model;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Ruby
{
    public sealed class PluginRb :Plugin <GeneratorSettingsRb, ModelSerializer<CodeModelRb>, TransformerRb, CodeGeneratorRb, CodeNamerRb, CodeModelRb>
    {
        public PluginRb()
        {
            Context = new Context
            {
                // inherit base settings
                Context,

                // set code model implementations our own implementations 
                new Factory<CodeModel, CodeModelRb>(),
                new Factory<Method, MethodRb>(),
                new Factory<CompositeType, CompositeTypeRb>(),
                new Factory<Property, PropertyRb>(),
                new Factory<Parameter, ParameterRb>(),
                new Factory<DictionaryType, DictionaryTypeRb>(),
                new Factory<SequenceType, SequenceTypeRb>(),
                new Factory<MethodGroup, MethodGroupRb>(),
                new Factory<EnumType, EnumTypeRb>(),
                new Factory<PrimaryType, PrimaryTypeRb>()
            };
        }
    }
}