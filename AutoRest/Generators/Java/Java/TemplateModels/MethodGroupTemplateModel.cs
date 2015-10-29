// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Java.TemplateModels;
using Microsoft.Rest.Generator.Utilities;

namespace Microsoft.Rest.Generator.Java
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

        public string MethodGroupServiceType
        {
            get
            {
                string ret = MethodGroupType;
                if (MethodGroupType.EndsWith("Operations", StringComparison.Ordinal))
                {
                    ret = MethodGroupType.Substring(0, MethodGroupType.Length - 10);
                }
                return JavaCodeNamer.GetServiceName(ret);
            }
        }

        public virtual IEnumerable<string> ImplImports
        {
            get
            {
                //Omit parameter group types for now since they don't get generated
                var parameters = this.MethodTemplateModels.SelectMany(m => m.Parameters);

                var types = parameters.Select(p => p.Type)
                    .Concat(this.MethodTemplateModels.SelectMany(mtm => mtm.Responses.Select(res => res.Value)))
                    .Concat(this.MethodTemplateModels.Select(mtm => mtm.DefaultResponse))
                    .Distinct()
                    .ToList();

                HashSet<string> classes = types.TypeImports(this.Namespace);

                if (this.MethodTemplateModels.Any(m => !m.ParametersToValidate.IsNullOrEmpty()))
                {
                    classes.Add("com.microsoft.rest.Validator");
                }

                var nonBodyParams = parameters.Where(p => p.Location != ParameterLocation.Body);

                foreach (var param in nonBodyParams)
                {
                    if (param.Type.Name == "LocalDate" ||
                        param.Type.Name == "DateTime" ||
                        param.Type is CompositeType ||
                        param.Type is SequenceType ||
                        param.Type is DictionaryType)
                    {
                        classes.Add("com.microsoft.rest.serializer.JacksonHelper");
                    }
                    if (param.Type is SequenceType)
                    {
                        classes.Add("com.microsoft.rest.serializer.CollectionFormat");
                    }
                    if (param.Type is PrimaryType)
                    {
                        var importedFrom = JavaCodeNamer.ImportedFrom(param.Type as PrimaryType);
                        if (importedFrom != null)
                        {
                            classes.Add(importedFrom);
                        }
                    }
                }
                
                return classes.AsEnumerable();
            }
        }

        public virtual IEnumerable<string> InterfaceImports
        {
            get
            {
                IList<IType> types = this.MethodTemplateModels
                    .SelectMany(mtm => mtm.Parameters.Select(p => p.Type))
                    .Concat(this.MethodTemplateModels.Select(mtm => mtm.ReturnType))
                    .Distinct()
                    .ToList();

                HashSet<string> classes = types.TypeImports(this.Namespace);

                foreach (var method in this.MethodTemplateModels)
                {
                    if (method.HttpMethod == HttpMethod.Delete)
                    {
                        classes.Add("retrofit.http.HTTP");
                    }
                    else
                    {
                        classes.Add("retrofit.http." + method.HttpMethod.ToString().ToUpper(CultureInfo.InvariantCulture));
                    }
                    foreach (var param in method.Parameters)
                    {
                        if (param.Location != ParameterLocation.None &&
                            param.Location != ParameterLocation.FormData)
                            classes.Add("retrofit.http." + param.Location.ToString());

                        if (param.Type is PrimaryType)
                        {
                            var importedFrom = JavaCodeNamer.ImportedFrom(param.Type as PrimaryType);
                            if (importedFrom != null)
                            {
                                classes.Add(importedFrom);
                            }
                        }
                    }
                }
                return classes.AsEnumerable();
            }
        }
    }
}