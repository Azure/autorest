// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Core;
using AutoRest.Core.Extensibility;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.CSharp.LoadBalanced.Legacy.Model;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.CSharp.LoadBalanced.Legacy
{
    public sealed class LoadBalancedPluginCs :Plugin<GeneratorSettingsCs, ModelSerializer<CodeModelCs>, TransformerCs, LoadBalancedCodeGeneratorCs, CodeNamerCs, CodeModelCs>
    {
        public LoadBalancedPluginCs()
        {
            Context = new Context
            {
                // inherit base settings
                Context,

                // set code model implementations our own implementations 
                new Factory<CodeModel, CodeModelCs>(),
                new Factory<Method, MethodCs>(),
                new Factory<CompositeType, CompositeTypeCs>(),
                new Factory<Property, PropertyCs>(),
                new Factory<Parameter, ParameterCs>(),
                new Factory<DictionaryType, DictionaryTypeCs>(),
                new Factory<SequenceType, SequenceTypeCs>(),
                new Factory<MethodGroup, MethodGroupCs>(),
                new Factory<EnumType, EnumTypeCs>(),
                new Factory<PrimaryType, PrimaryTypeCs>()
            };
        }
    }
}