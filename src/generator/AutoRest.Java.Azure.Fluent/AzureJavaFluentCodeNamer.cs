// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.ClientModel;
using AutoRest.Java.Azure.Fluent.TypeModels;
using AutoRest.Java.TypeModels;

namespace AutoRest.Java.Azure.Fluent
{
    public class AzureJavaFluentCodeNamer : AzureJavaCodeNamer
    {
        private HashSet<CompositeType> _innerTypes;

        public AzureJavaFluentCodeNamer(string nameSpace)
            : base(nameSpace)
        {
            _innerTypes = new HashSet<CompositeType>();
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
                if (model.BaseModelType != null && (model.BaseModelType.Name == "Resource" || model.BaseModelType.Name == "SubResource"))
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

        protected override CompositeTypeModel NewCompositeTypeModel(CompositeType compositeType)
        {
            return new FluentCompositeTypeModel(compositeType, _package);
        }

        protected override EnumTypeModel NewEnumTypeModel(EnumType enumType)
        {
            return new FluentEnumTypeModel(enumType, _package);
        }
    }
}