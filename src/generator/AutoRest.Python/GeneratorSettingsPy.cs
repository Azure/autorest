// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Core.Extensibility;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Python
{
    public class GeneratorSettingsPy : IGeneratorSettings
    {
        public static GeneratorSettingsPy Instance => Singleton<GeneratorSettingsPy>.Instance;
        public virtual string CredentialObject => "A msrest Authentication object<msrest.authentication>";
    }
}