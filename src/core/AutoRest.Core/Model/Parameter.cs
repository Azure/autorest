// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Utilities;
using Newtonsoft.Json;

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

        private Method _method;
        /// <summary>
        /// The method that this parameter belongs to.
        /// </summary>
        [JsonIgnore]
        public Method Method
        {
            get { return _method; }
            set
            {
                // when the reference to the parent is set
                // we should disambiguate the name 
                // it is imporant that this reference gets set before 
                // the item is actually added to the containing collection.

                if (!ReferenceEquals(_method, value))
                {
                    // only perform disambiguation if this item is not already 
                    // referencing the parent 
                    _method = value;

                    // (which implies that it's in the collection, but I can't prove that.)
                    Disambiguate();
                }
            }
        }

        /// <summary>
        /// Indicates whether the parameter should be set via a property on the client instance 
        /// instead of being passed to each API method that needs it.
        /// </summary>
        [JsonIgnore]
        public virtual bool IsClientProperty => ClientProperty != null && XmsExtensions.ParameterLocation.Location.Method != ParameterLocation;

        [JsonIgnore]
        public XmsExtensions.ParameterLocation.Location? ParameterLocation => Extensions.Get<XmsExtensions.ParameterLocation.Location>(XmsExtensions.ParameterLocation.Name);
        /// <summary>
        /// Reference to the global Property that provides value for the parameter.
        /// </summary>
        public virtual Property ClientProperty { get; set; }

        [JsonIgnore]
        public bool IsContentTypeHeader => Location == Model.ParameterLocation.Header && SerializedName == "Content-Type";

        /// <summary>
        /// Gets or sets parameter location.
        /// </summary>
        public virtual ParameterLocation Location { get; set; }

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
