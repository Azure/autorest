// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

namespace AutoRest.CSharp
{
    public interface ICSharpGeneratorSettings
    {
        bool UseDateTimeOffset { get; set; }
        bool InternalConstructors { get; set; }
        SyncMethodsGenerationMode SyncMethods { get; set; }
    }
}