// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Core;
using AutoRest.Core.Extensibility;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Java.Azure.Fluent;
using AutoRest.Java.Azure.Fluent.Model;
using AutoRest.Java.Azure.Model;
using AutoRest.Java.Model;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Java.Azure
{
    public sealed class PluginJvaf : Plugin<GeneratorSettingsJvaf, ModelSerializer<CodeModelJvaf>, TransformerJvaf, CodeGeneratorJvaf, CodeNamerJvaf, CodeModelJvaf>
    {
        public PluginJvaf()
        {
            Context = new Context
            {
                // inherit base settings
                Context,

                // set code model implementations our own implementations 
                new Factory<CodeModel, CodeModelJvaf>(),
                new Factory<Method, MethodJvaf>(),
                new Factory<CompositeType, CompositeTypeJvaf>(),
                new Factory<Property, PropertyJvaf>(),
                new Factory<Parameter, ParameterJv>(),
                new Factory<DictionaryType, DictionaryTypeJv>(),
                new Factory<SequenceType, SequenceTypeJva>(),
                new Factory<MethodGroup, MethodGroupJvaf>(),
                new Factory<EnumType, EnumTypeJvaf>(),
                new Factory<PrimaryType, PrimaryTypeJv>(),
                new Factory<Response, ResponseJva>()
            };
        }
    }
}