// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core;
using AutoRest.Core.Extensibility;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Go.Model;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Go
{
  public sealed class PluginGo : Plugin<GeneratorSettingsGo, TransformerGo, CodeGeneratorGo, CodeNamerGo, CodeModelGo>
  {
    public PluginGo()
    {
      Context = new Context {
                  // inherit base settings
                  Context,

                  // set code model implementations our own implementations 
                  new Factory<CodeModel, CodeModelGo>(),
                  new Factory<Method, MethodGo>(),
                  new Factory<CompositeType, CompositeTypeGo>(),
                  new Factory<Property, PropertyGo>(),
                  new Factory<Parameter, ParameterGo>(),
                  new Factory<DictionaryType, DictionaryTypeGo>(),
                  new Factory<SequenceType, SequenceTypeGo>(),
                  new Factory<MethodGroup, MethodGroupGo>(),
                  new Factory<EnumType, EnumTypeGo>(),
                  new Factory<PrimaryType, PrimaryTypeGo>()
                };
    }
  }
}
