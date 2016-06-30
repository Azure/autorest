// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;

namespace AutoRest.Ruby.TemplateModels
{
    /// <summary>
    /// The model for method group template.
    /// </summary>
    public class MethodGroupTemplateModel : ServiceClient
    {
        /// <summary>
        /// Initializes a new instance of the class MethodGroupTemplateModel.
        /// </summary>
        /// <param name="serviceClient">The service client.</param>
        /// <param name="methodGroupName">The method group name.</param>
        public MethodGroupTemplateModel(ServiceClient serviceClient, string methodGroupName)
        {
            this.LoadFrom(serviceClient);

            HasModelTypes = serviceClient.HasModelTypes();

            MethodTemplateModels = new List<MethodTemplateModel>();

            Methods.Where(m => m.Group == methodGroupName)
                .ForEach(m => MethodTemplateModels.Add(new MethodTemplateModel(m, serviceClient)));

            MethodGroupName = methodGroupName;
        }

        /// <summary>
        /// Gets the flag indicating whether method include model types.
        /// </summary>
        public bool HasModelTypes { get; private set; }

        /// <summary>
        /// Gets the method template models.
        /// </summary>
        public List<MethodTemplateModel> MethodTemplateModels { get; set; }

        /// <summary>
        /// Gets the method group (also known as operation) name.
        /// </summary>
        public string MethodGroupName { get; set; }

        /// <summary>
        /// Gets the list of modules/classes which need to be included.
        /// </summary>
        public virtual List<string> Includes
        {
            get { return new List<string>(); }
        }
    }
}