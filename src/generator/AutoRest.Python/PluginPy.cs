// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Core;
using AutoRest.Core.Extensibility;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Python.Model;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Python
{
    public sealed class PluginPy : Plugin<GeneratorSettingsPy, TransformerPy, CodeGeneratorPy, CodeNamerPy, CodeModelPy>
    {
        public PluginPy()
        {
            Context = new Context
            {
                // inherit base settings
                Context,

                // set code model implementations our own implementations 
                new Factory<CodeModel, CodeModelPy>(),
                new Factory<Method, MethodPy>(),
                new Factory<CompositeType, CompositeTypePy>(),
                new Factory<Property, PropertyPy>(),
                new Factory<Parameter, ParameterPy>(),
                new Factory<DictionaryType, DictionaryTypePy>(),
                new Factory<SequenceType, SequenceTypePy>(),
                new Factory<MethodGroup, MethodGroupPy>(),
                new Factory<EnumType, EnumTypePy>(),
                new Factory<PrimaryType, PrimaryTypePy>()
            };
        }
    }
}