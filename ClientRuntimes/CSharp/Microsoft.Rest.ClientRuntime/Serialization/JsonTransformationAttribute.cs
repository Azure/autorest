// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;

namespace Microsoft.Rest.Serialization
{
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Property | AttributeTargets.Field, AllowMultiple = false)]
    public class JsonTransformationAttribute : Attribute
    {
        public JsonTransformationAttribute() { }
        public JsonTransformationAttribute(string originalPropertyName)
        {
            PropertyName = originalPropertyName;
        }

        public string PropertyName { get; set; }
    }
}
