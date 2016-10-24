// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using AutoRest.Ruby.Model;

namespace AutoRest.Ruby.Azure.Model
{
    /// <summary>
    /// The model for the Azure method template.
    /// </summary>
    public class MethodGroupRba : MethodGroupRb
    {
        public MethodGroupRba(string name):base(name)
        {
        }

        public MethodGroupRba() : base()
        {
        }

        /// <summary>
        /// Gets the list of modules/classes which need to be included.
        /// </summary>
        public override IEnumerable<string> Includes
        {
            get { yield return "MsRestAzure"; }
        }
    }
}