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
    public class ParameterMapping 
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

        public string CreateCode(Parameter outputParameter)
        {
            string outputPath = outputParameter.Name;
            if (OutputParameterProperty != null)
            {
                outputPath += "." + OutputParameterProperty;
            }
            string inputPath = InputParameter.Name;
            if (InputParameterProperty != null)
            {
                inputPath += "." + InputParameterProperty;
            }
            return $"{outputPath} = {inputPath}";
        }

        /// <summary>
        /// Performs a deep clone of a parameter mapping.
        /// </summary>
        /// <returns>A deep clone of current object.</returns>
        public object Clone()
        {
            return new ParameterMapping
            {
                InputParameter = Duplicate(InputParameter),
                InputParameterProperty = InputParameterProperty,
                OutputParameterProperty = OutputParameterProperty
            };
        }
    }
}