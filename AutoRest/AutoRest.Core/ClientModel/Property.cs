// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Globalization;

namespace Microsoft.Rest.Generator.ClientModel
{
    /// <summary>
    /// Defines model properties.
    /// </summary>
    public class Property
    {
        /// <summary>
        /// Creates a new instance of Property class.
        /// </summary>
        public Property()
        {
            Constraints = new Dictionary<Constraint, string>();
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
        /// Gets or sets the constraints.
        /// </summary>
        public Dictionary<Constraint, string> Constraints { get; set; }

        /// <summary>
        /// Gets or sets the documentation.
        /// </summary>
        public string Documentation { get; set; }

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
    }
}