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

            var stringType = New<PrimaryType>(KnownPrimaryType.String, new
            {
                Name = "string"
            });

            _resourceType = New<CompositeType>(new
            {
                SerializedName = "Resource",
            });
            _resourceType.Name.FixedValue = "Microsoft.Rest.Azure.Resource";
            _resourceType.Add(New <Property>(new { Name = "location", SerializedName = "location", ModelType = stringType }));
            _resourceType.Add(New <Property>(new { Name = "id", SerializedName = "id", ModelType = stringType }));
            _resourceType.Add(New <Property>(new { Name = "name", SerializedName = "name", ModelType = stringType }));
            _resourceType.Add(New <Property>(new { Name = "type", SerializedName = "type", ModelType = stringType }));
            _resourceType.Add(New <Property>(new { Name = "tags", SerializedName = "tags", ModelType = New<DictionaryType>(new { ValueType = stringType, NameFormat = "System.Collections.Generic.IDictionary<string, {0}>" }) }));

            _subResourceType = New<CompositeType>(new
            {
                SerializedName = "SubResource"
            });
            _subResourceType.Name.FixedValue = "Microsoft.Rest.Azure.SubResource";
            _subResourceType.Add(New<Property>(new { Name = "id", SerializedName = "id", ModelType = stringType }));
        }
    }
}