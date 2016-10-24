// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Core;
using AutoRest.Core.Extensibility;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.NodeJS.Model;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.NodeJS
{
    public sealed class PluginJs :
        Plugin
        <GeneratorSettingsJs, ModelSerializer<CodeModelJs>, TransformerJs, CodeGeneratorJs, CodeNamerJs, CodeModelJs>
    {
        public PluginJs()
        {
            Context = new Context
            {
                // inherit base settings
                Context,

                // set code model implementations our own implementations 
                new Factory<CodeModel, CodeModelJs>(),
                new Factory<Method, MethodJs>(),
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