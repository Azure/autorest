// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using AutoRest.Core.Utilities;
using AutoRest.Core.Model;

namespace AutoRest.Java.Model
{
    public class MethodGroupJv : MethodGroup
    {
        public MethodGroupJv()
        {
            Name.OnGet += Core.Utilities.Extensions.ToCamelCase;
        }
        public MethodGroupJv(string name) : base(name)
        {
            Name.OnGet += Core.Utilities.Extensions.ToCamelCase;
        }

        public string MethodGroupFullType
        {
            get
            {
                return (CodeModel.Namespace?.ToLower(CultureInfo.InvariantCulture) ?? "fallbackNamespaceOrWhatTODO") + "." + TypeName;
            }
        }

        public virtual string MethodGroupDeclarationType
        {
            get
            {
                return TypeName;
            }
        }

        public string MethodGroupImplType
        {
            get
            {
                return TypeName + ImplClassSuffix;
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
                if (this.Methods
                    .OfType<MethodJv>()
                    .SelectMany(m => m.ImplImports)
                    .Any(i => i.Split('.').LastOrDefault() == TypeName))
                {
                    return MethodGroupFullType;
                }
                return TypeName;
            }
        }

        public string MethodGroupServiceType
        {
            get
            {
                return CodeNamerJv.GetServiceName(Name.ToPascalCase());
            }
        }

        public virtual string ServiceClientType
        {
            get
            {
                return CodeModel.Name + "Impl";
            }
        }

        public virtual IEnumerable<string> ImplImports
        {
            get
            {
                var imports = new List<string>();
                imports.Add("retrofit2.Retrofit");
                if (MethodGroupTypeString == TypeName)
                {
                    imports.Add(MethodGroupFullType);
                }
                imports.AddRange(this.Methods
                    .OfType<MethodJv>()
                    .SelectMany(m => m.ImplImports)
                    .OrderBy(i => i).Distinct());
                return imports;
            }
        }

        public virtual IEnumerable<string> InterfaceImports
        {
            get
            {
                return this.Methods
                    .OfType<MethodJv>()
                    .SelectMany(m => m.InterfaceImports)
                    .OrderBy(i => i).Distinct();
            }
        }
    }
}