// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Globalization;
using System.Collections.Generic;
using Resources = Microsoft.Rest.Modeler.Swagger.Properties.Resources;
using Newtonsoft.Json;
using Microsoft.Rest.Generator;
using Microsoft.Rest.Modeler.Swagger.Validators;

namespace Microsoft.Rest.Modeler.Swagger.Model
{
    [Serializable]
    [Rule(typeof(ClientNameRequired))]
    public abstract class SwaggerBase
    {
        protected SwaggerBase()
        {
            Extensions = new Dictionary<string, object>();
        }

        public SourceContext Source { get; set; }

        /// <summary>
        /// Vendor extensions.
        /// </summary>
        [JsonExtensionData]
        public Dictionary<string, object> Extensions { get; set; }

        /// <summary>
        /// Compares the Swagger object against the prior version, looking for potential breaking changes.
        /// </summary>
        /// <param name="priorVersion"></param>
        /// <param name="context"></param>
        /// <returns></returns>
        public virtual bool Compare(SwaggerBase priorVersion, ValidationContext context)
        {
            if (priorVersion == null)
            {
                throw new ArgumentNullException("priorVersion");
            }
            if (context == null)
            {
                throw new ArgumentNullException("context");
            }
            return true;
        }
    }


}