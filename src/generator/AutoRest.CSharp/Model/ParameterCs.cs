// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;

namespace AutoRest.CSharp.Model
{
    public class ParameterCs : Parameter
    {
        public ParameterCs()
        {
            Name.OnGet += value => IsClientProperty ? true== Method?.Group.IsNullOrEmpty() ? $"this.{ClientProperty.Name}" : $"this.Client.{ClientProperty.Name}" : CodeNamer.Instance.GetParameterName(value);
        }
        /// <summary>
        /// Gets True if parameter can call .Validate method
        /// </summary>
        public virtual bool CanBeValidated => true;

        public override string ModelTypeName => ModelType.AsNullableType(this.IsNullable());

    }
}