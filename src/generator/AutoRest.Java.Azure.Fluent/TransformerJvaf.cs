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

            Action<IModelType> markAsInner = null;
            markAsInner = mt =>
            {
                var modelType = mt as CompositeTypeJvaf;
                if (modelType != null)
                {
                    modelType.IsInnerModel = true;
                }
                var sequenceType = mt as SequenceType;
                if (sequenceType != null)
                {
                    markAsInner(sequenceType.ElementType);
                }
            };

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

            NormalizePaginatedMethods(codeModel, codeModel.pageClasses);

            // determine inner models
            foreach (var compType in codeModel.ModelTypes.Where(mt => (mt.BaseModelType as CompositeTypeJvaf)?.IsResource == true))
            {
                markAsInner(compType);
            }
            foreach (MethodJvaf method in codeModel.Methods)
            {
                //markAsInner(method.ReturnTypeJva.Body);
                //markAsInner(method.ReturnTypeJva.Headers);
                //markAsInner(method.DefaultResponse.Body);
                //markAsInner(method.DefaultResponse.Headers);
                foreach (var response in method.Responses)
                {
                    markAsInner(response.Value.Body);
                    markAsInner(response.Value.Headers);
                }
                foreach (var parameter in method.Parameters)
                {
                    markAsInner(parameter.ModelType);
                }
            }

            // param order (PATH first)
            foreach (MethodJva method in codeModel.Methods)
            {
                var ps = method.Parameters.ToList();
                method.ClearParameters();
                foreach (var p in ps.Where(x => x.Location == ParameterLocation.Path))
                {
                    method.Add(p);
                }
                foreach (var p in ps.Where(x => x.Location != ParameterLocation.Path))
                {
                    method.Add(p);
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
