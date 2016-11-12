// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System.Linq;
using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.CSharp.Azure.Fluent.Model;
using AutoRest.CSharp.Azure.Model;
using AutoRest.CSharp.Model;
using AutoRest.Extensions.Azure;

namespace AutoRest.CSharp.Azure.Fluent
{
    public class TransformerCsaf : TransformerCsa, ITransformer<CodeModelCsaf>
    {
        CodeModelCsaf ITransformer<CodeModelCsaf>.TransformCodeModel(CodeModel cs)
        {
            var codeModel = cs as CodeModelCsaf;

            // Do parameter transformations
            TransformParameters(codeModel);

            // todo: these should be turned into individual transformers
            AzureExtensions.NormalizeAzureClientModel(codeModel);

            // Fluent Specific stuff.
            NormalizeResourceTypes(codeModel);
            NormalizeTopLevelTypes(codeModel);
            NormalizeModelProperties(codeModel);


            NormalizePaginatedMethods(codeModel);
            NormalizeODataMethods(codeModel);

            return codeModel;
        }

        /// <summary>
        ///     A type-specific method for code model tranformation.
        ///     Note: This is the method you want to override.
        /// </summary>
        /// <param name="codeModel"></param>
        /// <returns></returns>
        public override CodeModelCs TransformCodeModel(CodeModel codeModel)
        {
            return ((ITransformer<CodeModelCsaf>) this).TransformCodeModel(codeModel);
        }

        public void NormalizeResourceTypes(CodeModelCsaf codeModel)
        {
            if (codeModel != null)
            {
                foreach (var model in codeModel.ModelTypes)
                {
                    if ((model.BaseModelType != null) && (model.BaseModelType.Extensions != null) &&
                        model.BaseModelType.Extensions.ContainsKey(AzureExtensions.AzureResourceExtension) &&
                        (bool) model.BaseModelType.Extensions[AzureExtensions.AzureResourceExtension])
                    {
                        if (model.BaseModelType.Name == "Resource")
                        {
                            model.BaseModelType = codeModel._resourceType;
                        }
                        else if (model.BaseModelType.Name == "SubResource")
                        {
                            model.BaseModelType = codeModel._subResourceType;
                        }
                    }
                }
            }
        }

        public void NormalizeTopLevelTypes(CodeModelCsaf codeModel)
        {
            foreach (var param in codeModel.Methods.SelectMany(m => m.Parameters))
            {
                AppendInnerToTopLevelType(param.ModelType, codeModel);
            }
            foreach (var response in codeModel.Methods.SelectMany(m => m.Responses).Select(r => r.Value))
            {
                AppendInnerToTopLevelType(response.Body, codeModel);
                AppendInnerToTopLevelType(response.Headers, codeModel);
            }
            foreach (var model in codeModel.ModelTypes)
            {
                if ((model.BaseModelType != null) && model.BaseModelType.IsResource())
                {
                    AppendInnerToTopLevelType(model, codeModel);
                }
            }
        }

        private void AppendInnerToTopLevelType(IModelType type, CodeModelCsaf codeModel)
        {
            if (type == null)
            {
                return;
            }
            var compositeType = type as CompositeType;
            var sequenceType = type as SequenceType;
            var dictionaryType = type as DictionaryType;
            if ((compositeType != null) && !codeModel._innerTypes.Contains(compositeType))
            {
                compositeType.Name.FixedValue += compositeType.Name + "Inner";
                codeModel._innerTypes.Add(compositeType);
            }
            else if (sequenceType != null)
            {
                AppendInnerToTopLevelType(sequenceType.ElementType, codeModel);
            }
            else if (dictionaryType != null)
            {
                AppendInnerToTopLevelType(dictionaryType.ValueType, codeModel);
            }
        }

        public void NormalizeModelProperties(CodeModelCsa serviceClient)
        {
            foreach (var modelType in serviceClient.ModelTypes)
            {
                foreach (var property in modelType.Properties)
                {
                    AddNamespaceToResourceType(property.ModelType, serviceClient);
                }
            }
        }

        private void AddNamespaceToResourceType(IModelType type, CodeModelCsa serviceClient)
        {
            var compositeType = type as CompositeType;
            var sequenceType = type as SequenceType;
            var dictionaryType = type as DictionaryType;
            // SubResource property { get; set; } => Microsoft.Rest.Azure.SubResource property { get; set; }
            if ((compositeType != null) &&
                (compositeType.Name.Equals("Resource") || compositeType.Name.Equals("SubResource")))
            {
                compositeType.Name.FixedValue = "Microsoft.Rest.Azure." + compositeType.Name;
            }
            // iList<SubResource> property { get; set; } => iList<Microsoft.Rest.Azure.SubResource> property { get; set; }
            else if (sequenceType != null)
            {
                AddNamespaceToResourceType(sequenceType.ElementType, serviceClient);
            }
            // IDictionary<string, SubResource> property { get; set; } => IDictionary<string, Microsoft.Rest.Azure.SubResource> property { get; set; }
            else if (dictionaryType != null)
            {
                AddNamespaceToResourceType(dictionaryType.ValueType, serviceClient);
            }
        }
    }
}