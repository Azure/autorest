// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Core.Extensibility;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Python
{
    public class GeneratorSettingsPy : IsSingleton<GeneratorSettingsPy>, IGeneratorSettings
    {
        public virtual string Name => "Python";

        public virtual string Description => "Generic Python code generator.";

        public virtual string CredentialObject => "A msrest Authentication object<msrest.authentication>";
    }
}