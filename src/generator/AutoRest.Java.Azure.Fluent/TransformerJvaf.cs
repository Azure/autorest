// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using Newtonsoft.Json.Linq;
using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Core.Utilities.Collections;
using AutoRest.Extensions;
using AutoRest.Extensions.Azure;
using AutoRest.Java.Azure.Model;
using AutoRest.Java.Model;
using static AutoRest.Core.Utilities.DependencyInjection;
using AutoRest.Java.Azure.Fluent.Model;

namespace AutoRest.Java.Azure
{
    public class TransformerJvaf : TransformerJva, ITransformer<CodeModelJvaf>
    {
        public override CodeModelJv TransformCodeModel(CodeModel cm)
        {
            var codeModel = cm as CodeModelJva;
            
            foreach (CompositeTypeJvaf compType in codeModel.ErrorTypes)
            {
                compType.IsSpecialType = true;
            }
            foreach (CompositeTypeJvaf compType in codeModel.ModelTypes.Where(mt => mt.Name.RawValue == "OdataFilter"))
            {
                compType.IsSpecialType = true;
            }

            // we're guaranteed to be in our language-specific context here.
            Settings.Instance.AddCredentials = true;

            PopulateAdditionalProperties(codeModel);

            // This extension from general extensions must be run prior to Azure specific extensions.
            AzureExtensions.ProcessParameterizedHost(codeModel);
            AzureExtensions.ProcessClientRequestIdExtension(codeModel);
            AzureExtensions.UpdateHeadMethods(codeModel);
            AzureExtensions.ProcessGlobalParameters(codeModel);
            AzureExtensions.FlattenModels(codeModel);
            AzureExtensions.FlattenMethodParameters(codeModel);
            ParameterGroupExtensionHelper.AddParameterGroups(codeModel);
            AddLongRunningOperations(codeModel);
            AzureExtensions.AddAzureProperties(codeModel);
            AzureExtensions.SetDefaultResponses(codeModel);

            foreach (CompositeTypeJvaf compType in codeModel.ModelTypes.Where(mt => mt.Name.RawValue == "cloudError"))
            {
                compType.IsSpecialType = true;
            }
            foreach (CompositeTypeJvaf compType in codeModel.ModelTypes.Where(mt => (mt as CompositeTypeJvaf).IsResource))
            {
                compType.IsSpecialType = true;
            }

            // set Parent on responses (required for pageable)
            foreach (MethodJva method in codeModel.Methods)
            {
                foreach (ResponseJva response in method.Responses.Values)
                {
                    response.Parent = method;
                }
                (method.DefaultResponse as ResponseJva).Parent = method;
                method.ReturnTypeJva.Parent = method;
            }
            AzureExtensions.AddPageableMethod(codeModel);

            // pluralize method groups
            foreach (var mg in codeModel.Operations)
            {
                mg.Name.OnGet += name => name.IsNullOrEmpty() || name.EndsWith("s", StringComparison.OrdinalIgnoreCase) ? $"{name}" : $"{name}s";
            }

            //(CodeNamerJva.Instance as CodeNamerJva).NormalizeClientModel(codeModel);
            //(CodeNamerJva.Instance as CodeNamerJva).ResolveNameCollisions(codeModel, Settings.Namespace, Settings.Namespace + ".Models");
            //NormalizePaginatedMethods(codeModel);

            //// Do parameter transformations
            //TransformParameters(codeModel);

            NormalizePaginatedMethods(codeModel, codeModel.pageClasses);
            //NormalizeODataMethods(codeModel);

            // param order (PATH first)
            foreach (MethodJva method in codeModel.Methods)
            {
                var list = method.Parameters as ListEx<Parameter>;
                var ps = list.ToList();
                list.Clear();
                foreach (var p in ps.Where(x => x.Location == ParameterLocation.Path))
                {
                    list.Add(p);
                }
                foreach (var p in ps.Where(x => x.Location != ParameterLocation.Path))
                {
                    list.Add(p);
                }
            }

            return codeModel;
        }

        CodeModelJvaf ITransformer<CodeModelJvaf>.TransformCodeModel(CodeModel cm)
        {
            return TransformCodeModel(cm) as CodeModelJvaf;
        }
    }
}
