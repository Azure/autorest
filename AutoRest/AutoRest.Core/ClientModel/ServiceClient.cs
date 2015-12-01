// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using Microsoft.Rest.Generator.Utilities;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace Microsoft.Rest.Generator.ClientModel
{
    /// <summary>
    /// Defines the client model for every service.
    /// </summary>
    public class ServiceClient
    {
        /// <summary>
        /// Creates a new instance of Client class.
        /// </summary>
        public ServiceClient()
        {
            Extensions = new Dictionary<string, object>();
            Properties = new List<Property>();
            Methods = new List<Method>();
            ModelTypes = new HashSet<CompositeType>();
            EnumTypes = new HashSet<EnumType>();
            ErrorTypes = new HashSet<CompositeType>();
            HeaderTypes = new HashSet<CompositeType>();
        }

        /// <summary>
        /// Gets or sets the non-canonical name of the client model.
        /// </summary>
        public string Name { get; set; }

        /// <summary>
        /// Gets or sets the base namespace of the client model if applicable.
        /// </summary>
        public string Namespace { get; set; }

        /// <summary>
        /// Gets or sets the version of the API described by this service.
        /// </summary>
        public string ApiVersion { get; set; }

        /// <summary>
        /// Gets or sets the base url of the service.  This can be a templated url.
        /// </summary>
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design",
            "CA1056:UriPropertiesShouldNotBeStrings", 
            Justification = "Url might be used as a template, thus making " + 
            "it invalid url in certain scenarios.")]
        public string BaseUrl { get; set; }

        /// <summary>
        /// Gets or sets the client parameters.
        /// </summary>
        public IList<Property> Properties { get; private set; }

        /// <summary>
        /// Gets the model types.
        /// </summary>
        public ISet<CompositeType> ModelTypes { get; private set; }

        /// <summary>
        /// Gets the enum types.
        /// </summary>
        public ISet<EnumType> EnumTypes { get; private set; }

        /// <summary>
        /// Gets the list of error type for customize exceptions.
        /// </summary>
        public ISet<CompositeType> ErrorTypes { get; private set; }

        /// <summary>
        /// Gets the list of header types.
        /// </summary>
        public ISet<CompositeType> HeaderTypes { get; private set; }

        /// <summary>
        /// Gets the methods.
        /// </summary>
        public IList<Method> Methods { get; private set; }

        /// <summary>
        /// Gets the method groups.
        /// </summary>
        public IEnumerable<string> MethodGroups
        {
            get
            {
                // TODO this still seems like a very awkward way to access the method groups
                return Methods.Where(m => m.Group != null).Select(m => m.Group).Distinct();
            }
        }

        /// <summary>
        /// Gets or sets the documentation.
        /// </summary>
        public string Documentation { get; set; }

        /// <summary>
        /// Gets vendor extensions dictionary.
        /// </summary>
        public Dictionary<string, object> Extensions { get; private set; }

        /// <summary>
        /// Returns a string representation of the ServiceClient object.
        /// </summary>
        /// <returns>
        /// A string representation of the ServiceClient object.
        /// </returns>
        public override string ToString()
        {
            var jsonSettings = new JsonSerializerSettings
            {
                Formatting = Formatting.Indented,
                NullValueHandling = NullValueHandling.Ignore,
                ContractResolver = new CamelCaseContractResolver(),
                ReferenceLoopHandling = ReferenceLoopHandling.Ignore
            };
            jsonSettings.Converters.Add(new StringEnumConverter {CamelCaseText = true});

            return JsonConvert.SerializeObject(this, jsonSettings);
        }
    }
}