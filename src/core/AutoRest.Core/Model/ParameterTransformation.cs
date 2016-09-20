// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace AutoRest.Core.ClientModel
{
    /// <summary>
    /// Defines a parameter transformation.
    /// </summary>
    public class ParameterTransformation : ICloneable
    {
        public ParameterTransformation()
        {
            ParameterMappings = new List<ParameterMapping>();
        }
        /// <summary>
        /// Gets or sets the output parameter.
        /// </summary>
        public Parameter OutputParameter { get; set; }

        /// <summary>
        /// Gets the list of Parameter Mappings
        /// </summary>
        public List<ParameterMapping> ParameterMappings { get; private set; }

        /// <summary>
        /// Returns a string representation of the ParameterMapping object.
        /// </summary>
        /// <returns>
        /// A string representation of the ParameterMapping object.
        /// </returns>
        public override string ToString()
        {
            StringBuilder sb = new StringBuilder();
            if (OutputParameter != null)
            {
                sb.AppendLine("var " + OutputParameter.Name);
                foreach (var mapping in ParameterMappings)
                {
                    sb.AppendLine(OutputParameter.Name + mapping.ToString());
                }
            }
            return sb.ToString();
        }

        /// <summary>
        /// Performs a deep clone of a parameter transformation.
        /// </summary>
        /// <returns>A deep clone of current object.</returns>
        public object Clone()
        {
            //ParameterTransformation paramTransformation = (ParameterTransformation)this.MemberwiseClone();
            //return paramTransformation;

            var transformation = new ParameterTransformation();
            transformation.OutputParameter = (Parameter) this.OutputParameter.Clone();
            this.ParameterMappings.ToList().ForEach(pm => transformation.ParameterMappings.Add((ParameterMapping) pm.Clone()));
            return transformation;
        }
    }
}