// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Extensions;

namespace AutoRest.CSharp.LoadBalanced.Legacy.Model
{
    public class ParameterCs : Parameter
    {
        public ParameterCs()
        {
            Name.OnGet += value => IsClientProperty ? true == Method?.Group.IsNullOrEmpty() ? $"this.{ClientProperty.Name}" : $"this.Client.{ClientProperty.Name}" : CodeNamer.Instance.GetParameterName(value);
        }
        /// <summary>
        /// Gets True if parameter can call .Validate method
        /// </summary>
        public virtual bool CanBeValidated => true;

        public override string ModelTypeName => ModelType.AsNullableType(this.IsNullable());

        public string HeaderCollectionPrefix => Extensions.GetValue<string>(SwaggerExtensions.HeaderCollectionPrefix);
        public bool IsHeaderCollection => !string.IsNullOrEmpty(HeaderCollectionPrefix);

        /// <summary>
        /// Gets or sets the model type.
        /// </summary>
        public override IModelType ModelType
        {
            get
            {
                if (base.ModelType == null || !this.IsHeaderCollection)
                {
                    return base.ModelType;
                }
                return new DictionaryTypeCs { ValueType = base.ModelType, CodeModel = base.ModelType.CodeModel, SupportsAdditionalProperties = false };
            }
            set
            {
                base.ModelType = value;
            }
        }
    }
}