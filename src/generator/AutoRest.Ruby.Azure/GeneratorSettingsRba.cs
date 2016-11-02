// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

namespace AutoRest.Ruby.Azure
{
    public class GeneratorSettingsRba : GeneratorSettingsRb
    {
        /// <summary>
        ///     Gets the name of code generator.
        /// </summary>
        public override string Name => "Azure.Ruby";

        /// <summary>
        ///     Gets the description of code generator.
        /// </summary>
        public override string Description => "Azure specific Ruby code generator.";
    }
}