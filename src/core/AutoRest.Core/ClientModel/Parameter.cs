// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Globalization;
using AutoRest.Core.Utilities;
using AutoRest.Core.Validation;

namespace AutoRest.Core.ClientModel
{
    /// <summary>
    /// Defines an HTTP method parameter.
    /// </summary>
    public class Parameter : IParameter
    {
        private string _documentation;

        /// <summary>
        /// Creates a new instance of Parameter class.
        /// </summary>
        public Parameter()
        {
            Constraints = new Dictionary<Constraint, string>();
            Extensions = new Dictionary<string, object>();
        }

        /// <summary>
        /// Gets or sets the parameter name.
        /// </summary>
        [Rule(typeof(IsIdentifier))]
        public string Name { get; set; }

        /// <summary>
        /// Gets or sets the parameter name on the wire.
        /// </summary>
        public string SerializedName { get; set; }

        /// <summary>
        /// Gets or sets the default value.
        /// </summary>
        public string DefaultValue { get; set; }
        
        // TODO: disambiguate Type and System.Type, rename IType to IModelType and Type to ModelType
        /// <summary>
        /// Gets or sets the model type.
        /// </summary>
        public IType Type { get; set; }

        /// <summary>
        /// Indicates whether the parameter is required.
        /// </summary>
        public bool IsRequired { get; set; }

        /// <summary>
        /// Indicates whether the parameter value is constant. If true, default value can not be null.
        /// </summary>
        public bool IsConstant { get; set; }

        /// <summary>
        /// Indicates whether the parameter should be set via a property on the client instance 
        /// instead of being passed to each API method that needs it.
        /// </summary>
        public bool IsClientProperty
        {
            get { return ClientProperty != null; }
        }
        
        /// <summary>
        /// Reference to the global Property that provides value for the parameter.
        /// </summary>
        public Property ClientProperty { get; set; }

        /// <summary>
        /// Gets or sets the constraints.
        /// </summary>
        public Dictionary<Constraint, string> Constraints { get; private set; }

        /// <summary>
        /// Gets or sets collection format for array parameters.
        /// </summary>
        public CollectionFormat CollectionFormat { get; set; }

        /// <summary>
        /// Gets or sets parameter location.
        /// </summary>
        public ParameterLocation Location { get; set; }

        /// <summary>
        /// Gets or sets the documentation.
        /// </summary>
        public string Documentation
        {
            get { return _documentation; }
            set { _documentation = value.StripControlCharacters(); }
        }

        /// <summary>
        /// Gets vendor extensions dictionary.
        /// </summary>
        public Dictionary<string, object> Extensions { get; private set; }

        /// <summary>
        /// Returns a string representation of the Parameter object.
        /// </summary>
        /// <returns>
        /// A string representation of the Parameter object.
        /// </returns>
        public override string ToString()
        {
            return string.Format(CultureInfo.InvariantCulture, "{0} {1}", Type, Name);
        }

        /// <summary>
        /// Performs a deep clone of a parameter.
        /// </summary>
        /// <returns>A deep clone of current object.</returns>
        public object Clone()
        {
            Parameter param = new Parameter();
            param.LoadFrom(this);
            return param;
        }
    }
}
