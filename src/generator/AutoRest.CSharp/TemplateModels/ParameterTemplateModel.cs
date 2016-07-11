// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;

namespace AutoRest.CSharp.TemplateModels
{
    public class ParameterTemplateModel : Parameter
    {
        public ParameterTemplateModel(Parameter source)
        {
            this.LoadFrom(source);
        }

        /// <summary>
        /// Gets parameter declaration
        /// </summary>
        public virtual string DeclarationExpression
        {
            get { return Type.Name; }
        }

        /// <summary>
        /// Gets True if parameter can call .Validate method
        /// </summary>
        public virtual bool CanBeValidated
        {
            get
            {
                return true;
            }
        }
        
    }
}