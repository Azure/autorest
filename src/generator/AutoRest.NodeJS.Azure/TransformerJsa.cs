using System;
using System.Linq;
using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Extensions.Azure;
using AutoRest.NodeJS.Azure.Model;
using AutoRest.NodeJS.Model;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.NodeJS.Azure
{
    public class TransformerJsa : TransformerJs, ITransformer<CodeModelJsa>
    {

        public override CodeModelJs TransformCodeModel(CodeModel codeModel)
        {
            return ((ITransformer<CodeModelJsa>)this).TransformCodeModel(codeModel);
        }

        CodeModelJsa ITransformer<CodeModelJsa>.TransformCodeModel(CodeModel cm)
        {
            var codeModel = cm as CodeModelJsa;
            if (codeModel == null)
            {
                throw new InvalidCastException("Code Model is not a nodejs code model.");
            }

            // MethodNames are normalized explicitly to provide a consitent method name while 
            // generating cloned methods for long running operations with reserved words. For
            // example - beginDeleteMethod() insteadof beginDelete() as delete is a reserved word.
            // Namer.NormalizeMethodNames(serviceClient);

            AzureExtensions.NormalizeAzureClientModel(codeModel);

            base.TransformCodeModel(codeModel);

            NormalizePaginatedMethods(codeModel);
            ExtendAllResourcesToBaseResource(codeModel);

            return codeModel;
        }

        private static void ExtendAllResourcesToBaseResource(CodeModelJsa codeModel)
        {
            if (codeModel != null)
            {
                foreach (var model in codeModel.ModelTypes)
                {
                    if (model.Extensions.ContainsKey(AzureExtensions.AzureResourceExtension) &&
                        (bool)model.Extensions[AzureExtensions.AzureResourceExtension])
                    {
                        model.BaseModelType = New<CompositeType>( new { Name = "BaseResource", SerializedName = "BaseResource" });
                    }
                }
            }
        }

        /// <summary>
        /// Changes paginated method signatures to return Page type.
        /// </summary>
        /// <param name="codeModel"></param>
        public virtual void NormalizePaginatedMethods(CodeModelJsa codeModel)
        {
            if (codeModel == null)
            {
                throw new ArgumentNullException("codeModel");
            }

            foreach (var method in codeModel.Methods.Where(m => m.Extensions.ContainsKey(AzureExtensions.PageableExtension)))
            {
                string nextLinkName = null;
                var ext = method.Extensions[AzureExtensions.PageableExtension] as Newtonsoft.Json.Linq.JContainer;
                if (ext == null)
                {
                    continue;
                }

                nextLinkName = (string)ext["nextLinkName"];
                string itemName = (string)ext["itemName"] ?? "value";
                foreach (var responseStatus in method.Responses.Where(r => r.Value.Body is CompositeType).Select(s => s.Key).ToArray())
                {
                    var compositType = (CompositeType)method.Responses[responseStatus].Body;
                    var sequenceType = compositType.Properties.Select(p => p.ModelType).FirstOrDefault(t => t is SequenceType) as SequenceType;

                    // if the type is a wrapper over page-able response
                    if (sequenceType != null)
                    {
                        compositType.Extensions[AzureExtensions.PageableExtension] = true;
                        var pageTemplateModel = new PageCompositeTypeJsa(nextLinkName, itemName).LoadFrom(compositType);
                        // var pageTemplateModel = new PageTemplateModel(compositType, serviceClient, nextLinkName, itemName);
                        if (!codeModel.PageTemplateModels.Any(ptm => ptm.StructurallyEquals(pageTemplateModel)))
                        {
                            codeModel.PageTemplateModels.Add(pageTemplateModel);
                        }
                    }
                }
            }
        }
    }
}