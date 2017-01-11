// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Core.Extensibility;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Go
{
    public class GeneratorSettingsGo : IsSingleton<GeneratorSettingsGo>, IGeneratorSettings
    {
        public virtual string Name => "Go";

        public virtual string Description => "Generic Go code generator.";
    }
}
