// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Swagger.Validation.Core;
using System.Collections.Generic;
using System.Linq;
using AutoRest.Swagger.Model;

namespace AutoRest.Swagger.Validation
{
    /// <summary>
    /// Validates the structure of Resource Model that it must contain id,
    /// name, type, location, tags with everything as readonly except location 
    /// and tags.
    /// </summary>
    public class ResourceModelValidation: TypedRule<Dictionary<string, Schema>>
    {

        private static readonly IEnumerable<string> ReadonlyProps = new List<string>() { "name", "id", "type" };
        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "M3001";

        /// <summary>
        /// Violation category of the Rule.
        /// </summary>
        public override ValidationCategory ValidationCategory => ValidationCategory.RPCViolation;

        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.ResourceModelIsNotValid;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Error;




        /// <summary>
        /// for each model, find if its allOfs on another model, and traverse that model
        /// </summary>
        /// <param name="modelName">model for which to find the root</param>
        /// <param name="definitions">models defined in the doc</param>
        /// <returns>true if the resource model is valid.false otherwise.</returns>
        private string GetRootModel(string modelName, Dictionary<string, Schema> definitions)
        {
            if (definitions[modelName].AllOf?.Any(modelRef => !string.IsNullOrEmpty(modelRef.Reference) && definitions.ContainsKey(modelRef.Reference.StripDefinitionPath())) != true)
            {
                return modelName;
            }
            return GetRootModel(definitions[modelName].AllOf.First().Reference.StripDefinitionPath(), definitions);
        }



        /// <summary>
        /// For each resource model, traverse its tree, find its root
        /// </summary>
        /// <param name="resourceModels">list of resource models found in the doc</param>
        /// <param name="definitions">models defined in the doc</param>
        /// <returns>true if the resource model is valid.false otherwise.</returns>
        private IEnumerable<string> GetRootResourceModels(IEnumerable<string> resourceModels, Dictionary<string, Schema> definitions)
        {
            foreach (var resourceModel in resourceModels)
            {
                yield return GetRootModel(resourceModel, definitions);
            }
        }
        
        /// <summary>
        /// Validates the structure of Resource Model
        /// </summary>
        /// <param name="definitions">Operation Definition to validate</param>
        /// <returns>true if the resource model is valid.false otherwise.</returns>
        public override IEnumerable<ValidationMessage> GetValidationMessages(Dictionary<string, Schema> definitions, RuleContext context)
        {
            var rootResourceModels = GetRootResourceModels(context.ResourceModels, definitions).Distinct();
            // It'd be strange to have more than one root resource model definitions in the same doc, 
            // but let's do our due diligence
            foreach (var rootResourceModel in rootResourceModels)
            {
                var modelReadonlyProps = definitions[rootResourceModel].Properties?.Where(prop => prop.Value.ReadOnly).Select(prop => prop.Key);
                if ((modelReadonlyProps?.Intersect(ReadonlyProps).Count()??0) < 3)
                {
                    yield return new ValidationMessage(new FileObjectPath(context.File, context.Path.AppendProperty(rootResourceModel)), this, rootResourceModel);
                }
            }
        }
        
    }
}
