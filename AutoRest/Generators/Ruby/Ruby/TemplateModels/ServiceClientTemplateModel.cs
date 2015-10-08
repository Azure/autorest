// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Ruby.TemplateModels;
using Microsoft.Rest.Generator.Utilities;

namespace Microsoft.Rest.Generator.Ruby
{
    /// <summary>
    /// The model for the service client template.
    /// </summary>
    public class ServiceClientTemplateModel : ServiceClient
    {
        /// <summary>
        /// Initializes a new instance of ServiceClientTemplateModel class.
        /// </summary>
        /// <param name="serviceClient"></param>
        public ServiceClientTemplateModel(ServiceClient serviceClient)
        {
            this.LoadFrom(serviceClient);
            HasModelTypes = serviceClient.HasModelTypes();
            MethodTemplateModels = new List<MethodTemplateModel>();
            Methods.Where(m => m.Group == null)
                .ForEach(m => MethodTemplateModels.Add(new MethodTemplateModel(m, serviceClient)));
        }

        /// <summary>
        /// Gets the flag indicating whether client include model types.
        /// </summary>
        public bool HasModelTypes { get; private set; }

        /// <summary>
        /// Gets and sets the model template models.
        /// </summary>
        public List<MethodTemplateModel> MethodTemplateModels { get; set; }

        /// <summary>
        /// Gets the list of modules/classes which need to be included.
        /// </summary>
        public virtual List<string> Includes
        {
            get { return new List<string>(); }
        }

        /// <summary>
        /// Gets the base type of the client.
        /// </summary>
        public virtual string BaseType
        {
            get
            {
                return "MsRest::ServiceClient";
            }
        }
    }
}