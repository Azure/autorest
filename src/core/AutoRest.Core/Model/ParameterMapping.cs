// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Globalization;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Core.Model
{
    /// <summary>
    /// Defines a parameter mapping.
    /// </summary>
    public class ParameterMapping : ICloneable
    {
        /// <summary>
        /// Gets or sets the input parameter.
        /// </summary>
        public Parameter InputParameter { get; set; }

        /// <summary>
        /// Gets or sets the input parameter dot separated property path.
        /// </summary>
        public string InputParameterProperty { get; set; }

        /// <summary>
        /// Gets or sets the output parameter dot separated property path.
        /// </summary>
        public string OutputParameterProperty { get; set; }

        /// <summary>
        /// Returns a string representation of the ParameterMapping object.
        /// </summary>
        /// <returns>
        /// A string representation of the ParameterMapping object.
        /// </returns>
        public override string ToString()
        {
            string outputPath = "";
            if (OutputParameterProperty != null)
            {
                outputPath += "." + OutputParameterProperty;
            }
            string inputPath = InputParameter.Name;
            if (InputParameterProperty != null)
            {
                inputPath += "." + InputParameterProperty;
            }
            return string.Format(CultureInfo.InvariantCulture, "{0} = {1}", outputPath, inputPath);
        }

        /// <summary>
        /// Performs a deep clone of a parameter mapping.
        /// </summary>
        /// <returns>A deep clone of current object.</returns>
        public object Clone()
        {
            return  new ParameterMapping
            {
                InputParameter = Duplicate(InputParameter),
                InputParameterProperty = InputParameterProperty,
                OutputParameterProperty = OutputParameterProperty
            };
        }
    }
}