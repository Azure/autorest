// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

namespace AutoRest.AzureResourceSchema {
    using Core.Extensibility;

    public class GeneratorSettingsArs : IGeneratorSettings {
        public virtual string Name {get {return "AzureResourceSchema";}}

        public virtual string Description {get {return "Azure Resource Schema generator";}}
    }
}