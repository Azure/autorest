// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.CSharp.JsonRpcClient;

namespace AutoRest.CSharp.Azure.JsonRpcClient
{
    public class GeneratorSettingsCsa : GeneratorSettingsCs
    {
        public override string Description => "Azure specific C# code generator.";

        public override string Name => "Azure.CSharp.JsonRpcClient";
    }
}