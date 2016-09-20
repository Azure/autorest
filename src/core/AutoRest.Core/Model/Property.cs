// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Globalization;
using AutoRest.Core.Utilities;

namespace AutoRest.Core.ClientModel
{
    /// <summary>
    /// Defines model properties.
    /// </summary>
    public class Property : IParameter
    {
        private string _summary;
        private string _documentation;

        /// <summary>
        /// Creates a new instance of Property class.
        /// </summary>
        public Property()
        {
            Constraints = new Dictionary<Constraint, string>();
            Extensions = new Dictionary<string, object>();
        }

        /// <summary>
        /// Gets or sets the property name.
        /// </summary>
        public string Name { get; set; }

        /// <summary>
        /// Gets or sets the property name on the wire.
        /// </summary>
        public string SerializedName { get; set; }

        /// <summary>
        /// Gets or sets the default value.
        /// </summary>
        public string DefaultValue { get; set; }

        /// <summary>
        /// Gets or sets the model type.
        /// </summary>
        public IType Type { get; set; }

        /// <summary>
        /// Indicates whether this property is read only.
        /// </summary>
        public bool IsReadOnly { get; set; }

        /// <summary>
        /// Indicates whether the property is required.
        /// </summary>
        public bool IsRequired { get; set; }

        /// <summary>
        /// Indicates whether the parameter value is constant. If true, default value can not be null.
        /// </summary>
        public bool IsConstant { get; set; }

        /// <summary>
        /// Gets or sets the constraints.
        /// </summary>
        public Dictionary<Constraint, string> Constraints { get; private set; }

        /// <summary>
        /// Gets or sets the summary.
        /// </summary>
        public string Summary
        {
            get { return _summary; }
            set { _summary = value.StripControlCharacters(); }
        }

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
        /// Gets or sets collection format for array parameters.
        /// </summary>
        public CollectionFormat CollectionFormat { get; set; }

        /// <summary>
        /// Returns a string representation of the Property object.
        /// </summary>
        /// <returns>
        /// A string representation of the Property object.
        /// </returns>
        public override string ToString()
        {
            return string.Format(CultureInfo.InvariantCulture, "{0} {1} {{get;{2}}}", Type, Name, IsReadOnly ? "" : "set;");
        }

        /// <summary>
        /// Performs a deep clone of a property.
        /// </summary>
        /// <returns>A deep clone of current object.</returns>
        public object Clone()
        {
            Property property = new Property();
            property.LoadFrom(this);
            property.Constraints = new Dictionary<Constraint, string>(this.Constraints);
            property.Extensions = new Dictionary<string, object>(this.Extensions);
            return property;
        }
    }
}