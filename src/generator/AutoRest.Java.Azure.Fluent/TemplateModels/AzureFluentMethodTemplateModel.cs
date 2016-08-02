// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;
using AutoRest.Java.Azure.Fluent.TypeModels;
using AutoRest.Java.Azure.TemplateModels;
using AutoRest.Java.Azure.TypeModels;
using AutoRest.Java.TypeModels;

namespace AutoRest.Java.Azure.Fluent.TemplateModels
{
    public class AzureFluentMethodTemplateModel : AzureMethodTemplateModel
    {
        private AzureJavaFluentCodeNamer _namer;

        public AzureFluentMethodTemplateModel(Method source, ServiceClient serviceClient)
            : base(source, serviceClient)
        {
            _namer = new AzureJavaFluentCodeNamer(serviceClient.Namespace);
        }

        public override IEnumerable<ParameterModel> RetrofitParameters
        {
            get
            {
                List<ParameterModel> parameters = base.RetrofitParameters.ToList();

                parameters.First(p => p.SerializedName == "User-Agent")
                    .ClientProperty = new FluentPropertyModel(new Property
                    {
                        Name = "userAgent"
                    }, ServiceClient.Namespace, false);
                return parameters;
            }
        }

        protected override void TransformPagingGroupedParameter(IndentedStringBuilder builder, AzureMethodTemplateModel nextMethod, bool filterRequired = false)
        {
            if (this.InputParameterTransformation.IsNullOrEmpty())
            {
                return;
            }
            var groupedType = this.InputParameterTransformation.First().ParameterMappings[0].InputParameter;
            var nextGroupType = nextMethod.InputParameterTransformation.First().ParameterMappings[0].InputParameter;
            if (nextGroupType.Name == groupedType.Name)
            {
                return;
            }
            var nextGroupTypeName = _namer.GetTypeName(nextGroupType.Name) + "Inner";
            if (filterRequired && !nextGroupType.IsRequired)
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

        public override List<string> InterfaceImports
        {
            get
            {
                var imports = base.InterfaceImports;
                if (this.IsPagingOperation || this.IsPagingNextOperation)
                {
                    imports.Remove("com.microsoft.rest.ServiceCallback");
                    imports.Add("com.microsoft.azure.ListOperationCallback");
                    imports.Add("com.microsoft.azure.PagedList");
                    imports.Remove("java.util.List");
                    imports.AddRange(new CompositeTypeModel(ServiceClient.Namespace) { Name = ((AzureSequenceTypeModel) ReturnTypeModel.BodyClientType).PageImplType }.ImportSafe());
                }
                return imports;
            }
        }

        public override List<string> ImplImports
        {
            get
            {
                var imports = base.ImplImports;
                if (OperationExceptionTypeString != "CloudException" && OperationExceptionTypeString != "ServiceException")
                {
                    imports.RemoveAll(i => new CompositeTypeModel(ServiceClient.Namespace) { Name = OperationExceptionTypeString }.ImportSafe().Contains(i));
                    imports.AddRange(new FluentCompositeTypeModel(ServiceClient.Namespace) { Name = OperationExceptionTypeString }.ImportSafe());
                }
                if (this.IsLongRunningOperation)
                {
                    imports.Remove("com.microsoft.rest.ServiceResponseEmptyCallback");
                    imports.Remove("com.microsoft.rest.ServiceResponseCallback");
                    imports.Remove("com.microsoft.azure.AzureServiceResponseBuilder");
                    imports.Add("retrofit2.Callback");
                    this.Responses.Select(r => r.Value.Body).Concat(new IType[]{ DefaultResponse.Body })
                        .SelectMany(t => t.ImportSafe())
                        .Where(i => !this.Parameters.Any(p => p.Type.ImportSafe().Contains(i)))
                        .ForEach(i => imports.Remove(i));
                    // return type may have been removed as a side effect
                    imports.AddRange(this.ReturnTypeModel.ImplImports);
                }
                if (this.IsPagingOperation || this.IsPagingNextOperation)
                {
                    imports.Remove("com.microsoft.rest.ServiceCallback");
                    imports.Add("com.microsoft.azure.ListOperationCallback");
                    imports.Add("com.microsoft.azure.Page");
                    imports.Add("com.microsoft.azure.PagedList");
                    imports.RemoveAll(i => new CompositeTypeModel(ServiceClient.Namespace) { Name = ((AzureSequenceTypeModel)ReturnTypeModel.BodyClientType).PageImplType }.ImportSafe().Contains(i));
                }
                if (this.IsPagingNonPollingOperation)
                {
                    imports.RemoveAll(i => new CompositeTypeModel(ServiceClient.Namespace) { Name = ((AzureSequenceTypeModel)ReturnTypeModel.BodyClientType).PageImplType }.ImportSafe().Contains(i));
                }
                return imports;
            }
        }
    }
}