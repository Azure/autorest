// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using AutoRest.Core;
using AutoRest.Core.ClientModel;
using AutoRest.Extensions;
using AutoRest.Extensions.Azure;

namespace AutoRest.CSharp.Azure.Fluent
{
    public class AzureCSharpFluentCodeNamer : AzureCSharpCodeNamer
    {
        private HashSet<CompositeType> _innerTypes;

        private CompositeType _resourceType;
        private CompositeType _subResourceType;

        public AzureCSharpFluentCodeNamer(Settings settings)
            :base(settings)
        {
            _innerTypes = new HashSet<CompositeType>();

            _resourceType = new CompositeType
            {
                Name = "Microsoft.Rest.Azure.Resource",
                SerializedName = "Resource",
            };

            var stringType = new PrimaryType(KnownPrimaryType.String)
            {
                Name = "string"
            };
            _resourceType.Properties.Add(new Property { Name = "location", SerializedName = "location", Type = stringType });
            _resourceType.Properties.Add(new Property { Name = "id", SerializedName = "id", Type = stringType });
            _resourceType.Properties.Add(new Property { Name = "name", SerializedName = "name", Type = stringType });
            _resourceType.Properties.Add(new Property { Name = "type", SerializedName = "type", Type = stringType });
            _resourceType.Properties.Add(new Property { Name = "tags", SerializedName = "tags", Type = new DictionaryType { ValueType = stringType, NameFormat = "System.Collections.Generic.IDictionary<string, {0}>" } });

            _subResourceType = new CompositeType
            {
                Name = "Microsoft.Rest.Azure.SubResource",
                SerializedName = "SubResource"
            };
            _subResourceType.Properties.Add(new Property { Name = "id", SerializedName = "id", Type = stringType });
        }

        public void NormalizeResourceTypes(ServiceClient serviceClient)
        {
            if (serviceClient != null)
            {
                foreach (var model in serviceClient.ModelTypes)
                {
                    if (model.BaseModelType != null && model.BaseModelType.Extensions != null &&
                        model.BaseModelType.Extensions.ContainsKey(AzureExtensions.AzureResourceExtension) &&
                        (bool)model.BaseModelType.Extensions[AzureExtensions.AzureResourceExtension])
                    {
                        if (model.BaseModelType.Name == "Resource")
                        {
                            model.BaseModelType = _resourceType;
                        }
                        else if (model.BaseModelType.Name == "SubResource")
                        {
                            model.BaseModelType = _subResourceType;
                        }
                    }
                }
            }
        }

        public void NormalizeTopLevelTypes(ServiceClient serviceClient)
        {
            foreach (var param in serviceClient.Methods.SelectMany(m => m.Parameters))
            {
                AppendInnerToTopLevelType(param.Type, serviceClient);
            }
            foreach (var response in serviceClient.Methods.SelectMany(m => m.Responses).Select(r => r.Value))
            {
                AppendInnerToTopLevelType(response.Body, serviceClient);
                AppendInnerToTopLevelType(response.Headers, serviceClient);
            }
            foreach (var model in serviceClient.ModelTypes)
            {
                if (model.BaseModelType != null && model.BaseModelType.IsResource())
                AppendInnerToTopLevelType(model, serviceClient);
            }
        }

        private void AppendInnerToTopLevelType(IType type, ServiceClient serviceClient)
        {
            if (type == null)
            {
                return;
            }
            CompositeType compositeType = type as CompositeType;
            SequenceType sequenceType = type as SequenceType;
            DictionaryType dictionaryType = type as DictionaryType;
            if (compositeType != null && !_innerTypes.Contains(compositeType))
            {
                compositeType.Name += "Inner";
                _innerTypes.Add(compositeType);
            }
            else if (sequenceType != null)
            {
                AppendInnerToTopLevelType(sequenceType.ElementType, serviceClient);
            }
            else if (dictionaryType != null)
            {
                AppendInnerToTopLevelType(dictionaryType.ValueType, serviceClient);
            }
        }

        public void NormalizeModelProperties(ServiceClient serviceClient)
        {
            foreach (var modelType in serviceClient.ModelTypes)
            {
                foreach (var property in modelType.Properties)
                {
                    AddNamespaceToResourceType(property.Type, serviceClient);
                }
            }
        }

        private void AddNamespaceToResourceType(IType type, ServiceClient serviceClient)
        {
            var compositeType = type as CompositeType;
            var sequenceType = type as SequenceType;
            var dictionaryType = type as DictionaryType;
            // SubResource property { get; set; } => Microsoft.Rest.Azure.SubResource property { get; set; }
            if (compositeType != null && (compositeType.Name.Equals("Resource") || compositeType.Name.Equals("SubResource")))
            {
                compositeType.Name = "Microsoft.Rest.Azure." + compositeType.Name;
            }
            // iList<SubResource> property { get; set; } => iList<Microsoft.Rest.Azure.SubResource> property { get; set; }
            else if (sequenceType != null)
            {
                AddNamespaceToResourceType(sequenceType.ElementType, serviceClient);
            }
            // IDictionary<string, SubResource> property { get; set; } => IDictionary<string, Microsoft.Rest.Azure.SubResource> property { get; set; }
            else if (dictionaryType != null)
            {
                AddNamespaceToResourceType(dictionaryType.ValueType, serviceClient);
            }
        }
    }
}
