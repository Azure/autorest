// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;

namespace Microsoft.Rest.Generator.Test.Resource
{
    /// <summary>
    /// Defines the client model for every service.
    /// </summary>
    public class SampleServiceClientTemplateModel : ServiceClient
    {
        /// <summary>
        /// Creates a new instance of Client class.
        /// </summary>
        public SampleServiceClientTemplateModel(ServiceClient source)
        {
            this.LoadFrom(source);
        }
    }
}
