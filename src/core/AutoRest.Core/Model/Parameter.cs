// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using AutoRest.Core.Utilities;
using AutoRest.Core.Utilities.Collections;
using AutoRest.Core.Validation;
using Newtonsoft.Json;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Core.Model
{
    /// <summary>
    /// Defines an HTTP method parameter.
    /// </summary>
    public class Parameter : IVariable
    {
        /// <summary>
        /// Creates a new instance of Parameter class.
        /// </summary>
        protected Parameter()
        {
            // Name can be overriden by x-ms-client-name
            Name.OnGet += v => CodeNamer.Instance.GetParameterName(Extensions.GetValue<string>("x-ms-client-name").Else(v));
        }

        /// <summary>
        /// The method that this parameter belongs to.
        /// </summary>
        [JsonIgnore]
        public Method Method { get; set; }

        /// <summary>
        /// Indicates whether the parameter should be set via a property on the client instance 
        /// instead of being passed to each API method that needs it.
        /// </summary>
        public virtual bool IsClientProperty => ClientProperty != null && XmsExtensions.ParameterLocation.Location.Method != ParameterLocation;

        [JsonIgnore]
        public XmsExtensions.ParameterLocation.Location? ParameterLocation => Extensions.Get<XmsExtensions.ParameterLocation.Location>(XmsExtensions.ParameterLocation.Name);
        /// <summary>
        /// Reference to the global Property that provides value for the parameter.
        /// </summary>
        public virtual Property ClientProperty { get; set; }

        /// <summary>
        /// Gets or sets parameter location.
        /// </summary>
        public virtual ParameterLocation Location { get; set; }

        /// <summary>
        /// Returns a string representation of the Parameter object.
        /// </summary>
        /// <returns>
        /// A string representation of the Parameter object.
        /// </returns>
        public override string ToString() => $"{ModelType} {Name}";

        [JsonIgnore]
        public override IParent Parent
        {
            get { return Method; }
            set { Method = value as Method; }
        }

        [JsonIgnore]
        public override string Qualifier => "Parameter";
    }
}
