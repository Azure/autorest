// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Java.Azure.Model;
using AutoRest.Java.Model;
using AutoRest.Core;
using Newtonsoft.Json;
using System;
using AutoRest.Core.Utilities.Collections;

namespace AutoRest.Java.Azure.Fluent.Model
{
    public class MethodJvaf : MethodJva
    {
        public override void Disambiguate()
        {
            if (this.HttpMethod == HttpMethod.Get)
            {
                var url = this.Url.Value;
                var urlSplits = url.Split('/');
                if (urlSplits.Count() == 6 || urlSplits.Count() == 8)
                {
                    var originalName = Name;
                    string newName = null;
                    if (urlSplits.Count() == 6 && StringComparer.OrdinalIgnoreCase.Equals(urlSplits[1], "subscriptions"))
                    {
                        newName = "List";
                    }
                    else if (urlSplits.Count() == 8 && StringComparer.OrdinalIgnoreCase.Equals(urlSplits[1], "subscriptions")
                        && StringComparer.OrdinalIgnoreCase.Equals(urlSplits[3], "resourceGroups"))
                    {
                        newName = "ListByResourceGroup";
                    }
                    if (!string.IsNullOrWhiteSpace(newName))
                    {
                        this.SimulateAsPagingOperation = true;
                        var name = CodeNamer.Instance.GetUnique(newName, this, Parent.IdentifiersInScope, Parent.Children.Except(this.SingleItemAsEnumerable()));
                        if (name != originalName)
                        {
                            Name = name;
                        }
                        return;
                    }
                }
            }
            base.Disambiguate();
        }

        [JsonIgnore]
        public override IEnumerable<ParameterJv> RetrofitParameters
        {
            get
            {
                List<ParameterJv> parameters = base.RetrofitParameters.ToList();

                parameters.First(p => p.SerializedName == "User-Agent")
                    .ClientProperty = new PropertyJvaf
                    {
                        Name = "userAgent"
                    };
                return parameters;
            }
        }

        protected override void TransformPagingGroupedParameter(IndentedStringBuilder builder, MethodJva nextMethod, bool filterRequired = false)
        {
            if (this.InputParameterTransformation.IsNullOrEmpty() || nextMethod.InputParameterTransformation.IsNullOrEmpty())
            {
                return;
            }
            var groupedType = this.InputParameterTransformation.First().ParameterMappings[0].InputParameter;
            var nextGroupType = nextMethod.InputParameterTransformation.First().ParameterMappings[0].InputParameter;
            if (nextGroupType.Name == groupedType.Name)
            {
                return;
            }
            var nextGroupTypeName = CodeNamer.Instance.GetTypeName(nextGroupType.Name) + "Inner";
            if (filterRequired && !groupedType.IsRequired)
            {
                return;
            }
            if (!groupedType.IsRequired)
            {
                builder.AppendLine("{0} {1} = null;", nextGroupTypeName, nextGroupType.Name.ToCamelCase());
                builder.AppendLine("if ({0} != null) {{", groupedType.Name.ToCamelCase());
                builder.Indent();
                builder.AppendLine("{0} = new {1}();", nextGroupType.Name.ToCamelCase(), nextGroupTypeName);
            }
            else
            {
                builder.AppendLine("{1} {0} = new {1}();", nextGroupType.Name.ToCamelCase(), nextGroupTypeName);
            }
            foreach (var outParam in nextMethod.InputParameterTransformation.Select(t => t.OutputParameter))
            {
                builder.AppendLine("{0}.with{1}({2}.{3}());", nextGroupType.Name.ToCamelCase(), outParam.Name.ToPascalCase(), groupedType.Name.ToCamelCase(), outParam.Name.ToCamelCase());
            }
            if (!groupedType.IsRequired)
            {
                builder.Outdent().AppendLine(@"}");
            }
        }

        [JsonIgnore]
        public override List<string> InterfaceImports
        {
            get
            {
                var imports = base.InterfaceImports;
                if (this.IsPagingOperation || this.IsPagingNextOperation || this.SimulateAsPagingOperation)
                {
                    if (this.IsPagingOperation || this.IsPagingNextOperation)
                    {
                        imports.Add("com.microsoft.azure.ListOperationCallback");
                        imports.Add("com.microsoft.azure.PagedList");
                    }

                    imports.Remove("com.microsoft.rest.ServiceCallback");

                    var pageType = ReturnTypeJva.BodyClientType as SequenceTypeJva;
                    if (pageType != null)
                    {
                        imports.AddRange(new CompositeTypeJvaf(pageType.PageImplType).ImportSafe());
                    }
                }
                return imports;
            }
        }

        [JsonIgnore]
        public override List<string> ImplImports
        {
            get
            {
                var pageType = ReturnTypeJva.BodyClientType as SequenceTypeJva;

                var imports = base.ImplImports;
                if (OperationExceptionTypeString != "CloudException" && OperationExceptionTypeString != "RestException")
                {
                    imports.RemoveAll(i => new CompositeTypeJva(OperationExceptionTypeString) { CodeModel = CodeModel }.ImportSafe().Contains(i));
                    imports.AddRange(new CompositeTypeJvaf(OperationExceptionTypeString) { CodeModel = CodeModel }.ImportSafe());
                }
                if (this.IsLongRunningOperation)
                {
                    imports.Remove("com.microsoft.azure.AzureResponseBuilder");
                    this.Responses.Select(r => r.Value.Body).Concat(new IModelType[]{ DefaultResponse.Body })
                        .SelectMany(t => t.ImportSafe())
                        .Where(i => !this.Parameters.Any(p => p.ModelType.ImportSafe().Contains(i)))
                        .ForEach(i => imports.Remove(i));
                    // return type may have been removed as a side effect
                    imports.AddRange(this.ReturnTypeJva.ImplImports);
                }
                if (this.IsPagingOperation || this.IsPagingNextOperation || SimulateAsPagingOperation)
                {
                    imports.Remove("com.microsoft.rest.ServiceCallback");
                    if (this.IsPagingOperation || this.IsPagingNextOperation)
                    {
                        imports.Add("com.microsoft.azure.ListOperationCallback");
                        imports.Add("com.microsoft.azure.PagedList");
                    }

                    imports.Add("com.microsoft.azure.Page");
                    if (pageType != null)
                    {
                        imports.RemoveAll(i => new CompositeTypeJva((ReturnTypeJva.BodyClientType as SequenceTypeJva).PageImplType) { CodeModel = CodeModel }.ImportSafe().Contains(i));
                    }
                }

                if (this.IsPagingNonPollingOperation && pageType != null)
                {
                    imports.RemoveAll(i => new CompositeTypeJva((ReturnTypeJva.BodyClientType as SequenceTypeJva).PageImplType) { CodeModel = CodeModel }.ImportSafe().Contains(i));
                }
                return imports;
            }
        }
    }
}