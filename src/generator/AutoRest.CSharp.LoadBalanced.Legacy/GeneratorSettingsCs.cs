// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Core;
using AutoRest.Core.Extensibility;

namespace AutoRest.CSharp.LoadBalanced.Legacy
{
    public class GeneratorSettingsCs : IGeneratorSettings
    {
        public virtual string Name => "CSharp";

        public virtual string Description => "Generic C# code generator.";

        /// <summary>
        ///     Indicates whether ctor needs to be generated with internal protection level.
        /// </summary>
        [SettingsInfo("Indicates whether ctor needs to be generated with internal protection level.")]
        [SettingsAlias("internal")]
        public bool InternalConstructors { get; set; }

        /// <summary>
        ///     Specifies mode for generating sync wrappers.
        /// </summary>
        [SettingsInfo("Specifies mode for generating sync wrappers.")]
        [SettingsAlias("syncMethods")]
        public SyncMethodsGenerationMode SyncMethods { get; set; }

        [SettingsInfo("Indicates whether to use DateTimeOffset instead of DateTime to model date-time types")]
        public bool UseDateTimeOffset { get; set; }
    }
}