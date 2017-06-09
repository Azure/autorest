// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Core.Extensibility;

namespace AutoRest.Java
{
    public class GeneratorSettingsJv : IGeneratorSettings
    {
        public virtual string Name => "Java";

        public virtual string Description => "Generic Java code generator.";
        
    }
}