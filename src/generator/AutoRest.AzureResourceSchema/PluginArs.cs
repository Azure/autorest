// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

namespace AutoRest.AzureResourceSchema {
    using Core;
    using Core.Extensibility;
    using Core.Model;

    public sealed class PluginArs : Plugin<GeneratorSettingsArs, ModelSerializer<CodeModel>, CodeModelTransformer<CodeModel>, CodeGeneratorArs, CodeNamer, CodeModel> {
    }
}