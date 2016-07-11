// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;

namespace AutoRest.Java.TemplateModels
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

        public string MethodGroupFullType
        {
            get
            {
                return Namespace.ToLower(CultureInfo.InvariantCulture) + "." + MethodGroupType;
            }
        }

        public virtual string MethodGroupDeclarationType
        {
            get
            {
                return MethodGroupType;
            }
        }

        public string MethodGroupImplType
        {
            get
            {
                return MethodGroupType + ImplClassSuffix;
            }
        }

        public virtual string ImplClassSuffix
        {
            get
            {
                return "Impl";
            }
        }

        public virtual string ParentDeclaration
        {
            get
            {
                return " implements " + MethodGroupTypeString;
            }
        }

        public virtual string ImplPackage
        {
            get
            {
                return "implementation";
            }
        }

        public string MethodGroupTypeString
        {
            get
            {
                if (this.MethodTemplateModels
                    .SelectMany(m => m.ImplImports)
                    .Any(i => i.Split('.').LastOrDefault() == MethodGroupType))
                {
                    return MethodGroupFullType;
                }
                return MethodGroupType;
            }
        }

        public string MethodGroupServiceType
        {
            get
            {
                return JavaCodeNamer.GetServiceName(MethodGroupName.ToPascalCase());
            }
        }

        public virtual string ServiceClientType
        {
            get
            {
                return this.Name + "Impl";
            }
        }

        public virtual IEnumerable<string> ImplImports
        {
            get
            {
                var imports = new List<string>();
                imports.Add("retrofit2.Retrofit");
                if (MethodGroupTypeString == MethodGroupType)
                {
                    imports.Add(MethodGroupFullType);
                }
                imports.AddRange(this.MethodTemplateModels
                    .SelectMany(m => m.ImplImports)
                    .OrderBy(i => i).Distinct());
                return imports;
            }
        }

        public virtual IEnumerable<string> InterfaceImports
        {
            get
            {
                return this.MethodTemplateModels
                    .SelectMany(m => m.InterfaceImports)
                    .OrderBy(i => i).Distinct();
            }
        }
    }
}