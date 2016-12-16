// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.Model;
using AutoRest.Java.Azure.Fluent.Model;
using AutoRest.Java.Model;

namespace AutoRest.Java.Azure.Fluent
{
    public class CodeNamerJvaf : CodeNamerJva
    {
        private HashSet<CompositeType> _innerTypes = new HashSet<CompositeType>();
        
        public void NormalizeTopLevelTypes(CodeModel serviceClient)
        {
            foreach (var param in serviceClient.Methods.SelectMany(m => m.Parameters))
            {
                AppendInnerToTopLevelType(param.ModelType, serviceClient);
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

        //public override string GetMethodGroupName(string name)
        //{
        //    return base.GetMethodGroupName(name); + "Inner";
        //}

        private void AppendInnerToTopLevelType(IModelType type, CodeModel serviceClient)
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
                compositeType.Name.OnGet += name => name + "Inner";
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