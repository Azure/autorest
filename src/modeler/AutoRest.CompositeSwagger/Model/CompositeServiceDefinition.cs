// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using AutoRest.Swagger.Model;

namespace AutoRest.CompositeSwagger.Model
{
    /// <summary>
    /// Class that represents a Composite Swagger schema
    /// </summary>
    [Serializable]
    public class CompositeServiceDefinition : SpecObject
    {
        public CompositeServiceDefinition()
        {
            Documents = new List<string>();
        }

        /// <summary>
        /// Provides metadata about the API. The metadata can be used by the clients if needed.
        /// </summary>
        public Info Info { get; set; }

        /// <summary>
        /// A list of Swagger documents.
        /// </summary>
        public IList<string> Documents { get; set; }
    }
}