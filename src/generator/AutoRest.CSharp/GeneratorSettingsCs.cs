// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Core;
using AutoRest.Core.Extensibility;

namespace AutoRest.CSharp
{
    public class GeneratorSettingsCs : IGeneratorSettings
    {
        /// <summary>
        ///     Indicates whether ctor needs to be generated with internal protection level.
        /// </summary>
        public bool InternalConstructors { get; set; }

        /// <summary>
        ///     Specifies mode for generating sync wrappers.
        /// </summary>
        public SyncMethodsGenerationMode SyncMethods { get; set; }

        public bool UseDateTimeOffset { get; set; }

        /// <summary>
        /// Indicates whether to generate client side validation.
        /// </summary>
        public bool ClientSideValidation { get; set; }
    }
}