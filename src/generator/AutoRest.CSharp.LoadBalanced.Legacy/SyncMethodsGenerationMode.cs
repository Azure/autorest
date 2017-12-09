// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.


namespace AutoRest.CSharp.LoadBalanced.Legacy
{
    /// <summary>
    /// Defines supported modes for sync wrapper generation
    /// </summary>
    public enum SyncMethodsGenerationMode
    {
        /// <summary>
        /// Default. Generates only one sync returning body or header.
        /// </summary>
        Essential,
        /// <summary>
        /// Generates one sync method for each async method.
        /// </summary>
        All,
        /// <summary>
        /// Does not generate any sync methods.
        /// </summary>
        None
    }
}
