// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

namespace AutoRest.NodeJS
{
    public interface INodeJsSettings
    {
        /// <summary>
        ///     Change to true if you want to no longer generate the 3 d.ts files, for some reason
        /// </summary>
        bool DisableTypeScriptGeneration { get; set; }
    }
}