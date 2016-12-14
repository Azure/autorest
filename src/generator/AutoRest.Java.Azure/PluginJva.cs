// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Core;
using AutoRest.Core.Extensibility;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Java.Azure.Model;
using AutoRest.Java.Model;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Java.Azure
{
    public sealed class PluginJva : Plugin<GeneratorSettingsJva, ModelSerializer<CodeModelJva>, TransformerJva, CodeGeneratorJva, CodeNamerJva, CodeModelJva>
    {
        public PluginJva()
        {
            Context = new Context
            {
                // inherit base settings
                Context,

                // set code model implementations our own implementations 
                new Factory<CodeModel, CodeModelJv>(),
                new Factory<Method, MethodJv>(),
                new Factory<CompositeType, CompositeTypeJv>(),
                new Factory<Property, PropertyJv>(),
                new Factory<Parameter, ParameterJv>(),
                new Factory<DictionaryType, DictionaryTypeJv>(),
                new Factory<SequenceType, SequenceTypeJv>(),
                new Factory<MethodGroup, MethodGroupJv>(),
                new Factory<EnumType, EnumTypeJv>(),
                new Factory<PrimaryType, PrimaryTypeJv>(),
                new Factory<Response, ResponseJv>()
            };
        }
    }
}