// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;

namespace AutoRest.NodeJS.TemplateModels
{
    public class MethodGroupTemplateModel : ServiceClient
    {
        public MethodGroupTemplateModel(ServiceClient serviceClient, string methodGroupName)
        {
            this.LoadFrom(serviceClient);
            MethodTemplateModels = new List<MethodTemplateModel>();
            // MethodGroup name and type are always the same but can be 
            // changed in derived classes
            MethodGroupName = methodGroupName;
            MethodGroupType = methodGroupName.ToPascalCase();
            Methods.Where(m => m.Group == MethodGroupName)
                .ForEach(m => MethodTemplateModels.Add(new MethodTemplateModel(m, serviceClient)));
        }
        public List<MethodTemplateModel> MethodTemplateModels { get; private set; }

        public string MethodGroupName { get; set; }

        public string MethodGroupType { get; set; }

        public bool ContainsTimeSpan
        {
            get
            {
                Method method = this.MethodTemplateModels.FirstOrDefault(m => m.Parameters.FirstOrDefault(p =>
                    p.Type.IsPrimaryType(KnownPrimaryType.TimeSpan) ||
                    (p.Type is SequenceType && (p.Type as SequenceType).ElementType.IsPrimaryType(KnownPrimaryType.TimeSpan)) ||
                    (p.Type is DictionaryType && (p.Type as DictionaryType).ValueType.IsPrimaryType(KnownPrimaryType.TimeSpan)) ||
                    (p.Type is CompositeType && (p.Type as CompositeType).ContainsTimeSpan())) != null);
                
                return  method != null;
            }
        }

        public bool ContainsStream
        {
            get {
                return this.Methods.Any(m => m.Parameters.FirstOrDefault(p => p.Type.IsPrimaryType(KnownPrimaryType.Stream)) != null ||
                        m.ReturnType.Body.IsPrimaryType(KnownPrimaryType.Stream)); }
        }
    }
}