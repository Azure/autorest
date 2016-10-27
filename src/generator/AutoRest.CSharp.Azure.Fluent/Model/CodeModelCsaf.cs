// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System.Collections.Generic;
using AutoRest.Core.Model;
using AutoRest.CSharp.Azure.Model;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.CSharp.Azure.Fluent.Model
{
    public class CodeModelCsaf : CodeModelCsa
    {
        internal HashSet<CompositeType> _innerTypes;
        internal CompositeType _resourceType;
        internal CompositeType _subResourceType;

        public CodeModelCsaf()
        {
            _innerTypes = new HashSet<CompositeType>();

            _resourceType = New<CompositeType>(new
            {
                Name = "Microsoft.Rest.Azure.Resource",
                SerializedName = "Resource",
            });

            var stringType = New<PrimaryType>(KnownPrimaryType.String,new
            {
                Name = "string"
            });

            _resourceType.Add(New <Property>(new { Name = "location", SerializedName = "location", Type = stringType }));
            _resourceType.Add(New <Property>(new { Name = "id", SerializedName = "id", Type = stringType }));
            _resourceType.Add(New <Property>(new { Name = "name", SerializedName = "name", Type = stringType }));
            _resourceType.Add(New <Property>(new { Name = "type", SerializedName = "type", Type = stringType }));
            _resourceType.Add(New <Property>(new { Name = "tags", SerializedName = "tags", Type = New<DictionaryType>(new { ValueType = stringType, NameFormat = "System.Collections.Generic.IDictionary<string, {0}>" }) }));

            _subResourceType = New<CompositeType>(new
            {
                Name = "Microsoft.Rest.Azure.SubResource",
                SerializedName = "SubResource"
            });
            _subResourceType.Add(New<Property>(new { Name = "id", SerializedName = "id", Type = stringType }));
        }
    }
}