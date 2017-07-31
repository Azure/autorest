// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Core;
using AutoRest.Core.Extensibility;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Python.Azure.Model;
using AutoRest.Python.Model;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Python.Azure
{
    public sealed class PluginPya : Plugin<GeneratorSettingsPya, TransformerPya, CodeGeneratorPya, CodeNamerPy,CodeModelPya>
    {
        public PluginPya()
        {
            Context = new Context
            {
                // inherit base settings
                Context,

                // set code model implementations our own implementations 
                new Factory<CodeModel, CodeModelPya>(),
                new Factory<Method, MethodPya>(),
                new Factory<CompositeType, CompositeTypePy>(),
                new Factory<Property, PropertyPya>(),
                new Factory<Parameter, ParameterPy>(),
                new Factory<DictionaryType, DictionaryTypePy>(),
                new Factory<SequenceType, SequenceTypePy>(),
                new Factory<MethodGroup, MethodGroupPya>(),
                new Factory<EnumType, EnumTypePy>(),
                new Factory<PrimaryType, PrimaryTypePy>()
            };
        }
    }
}