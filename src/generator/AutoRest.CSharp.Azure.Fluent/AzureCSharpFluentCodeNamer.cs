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

        public AzureCSharpFluentCodeNamer(Settings settings)
            :base(settings)
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
            if (compositeType != null && !compositeType.IsGeneric() && !_innerTypes.Contains(compositeType))
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
    }
}
