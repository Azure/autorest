// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.Model;
using Newtonsoft.Json;

namespace AutoRest.Ruby.Model
{
    /// <summary>
    /// The model for method group template.
    /// </summary>
    public class MethodGroupRb : MethodGroup
    {
        /// <summary>
        /// Initializes a new instance of the class MethodGroupTemplateModel.
        /// </summary>
        /// <param name="name">The method group name.</param>
        public MethodGroupRb(string name):base(name)
        {
        }

        public MethodGroupRb() : base()
        {
        }

        [JsonIgnore]
        public IEnumerable<MethodRb> MethodTemplateModels => Methods.Cast<MethodRb>();

        /// <summary>
        /// Gets the list of modules/classes which need to be included.
        /// </summary>
        public virtual IEnumerable<string> Includes => Enumerable.Empty<string>();
    }
}