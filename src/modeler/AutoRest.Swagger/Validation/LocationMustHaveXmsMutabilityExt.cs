// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Swagger.Model;
using AutoRest.Swagger.Model.Utilities;
using AutoRest.Swagger.Validation.Core;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
using System;

namespace AutoRest.Swagger.Validation
{
    public class LocationMustHaveXmsMutability : TypedRule<Dictionary<string, Schema>>
    {

        private static readonly IEnumerable<string> LocationPropertyMutability = new List<string>() { "read", "create" };


        /// <summary>
        /// What kind of open api document type this rule should be applied to
        /// </summary>
        public override ServiceDefinitionDocumentType ServiceDefinitionDocumentType => ServiceDefinitionDocumentType.ARM;


        /// <summary>
        /// The rule could be violated by a model referenced by many jsons belonging to the same
        /// composed state, to reduce duplicate messages, run validation rule in composed state
        /// </summary>
        public override ServiceDefinitionDocumentState ValidationRuleMergeState => ServiceDefinitionDocumentState.Composed;

        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "S4002";

        /// <summary>
        /// Violation category of the Rule.
        /// </summary>
        public override ValidationCategory ValidationCategory => ValidationCategory.SDKViolation;

        /// <summary>
        /// What kind of change implementing this rule can cause.
        /// </summary>
        public override ValidationChangesImpact ValidationChangesImpact => ValidationChangesImpact.SDKImpactingChanges;

        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => "Property 'location' must have '\"x-ms-mutability\":[\"read\", \"create\"]' extension defined. Resource Model: '{0}'";

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Warning;

        /// <summary>
        /// Verifies whether the location property for a tracked resource has the x-ms-mutability extension set correctly
        /// </summary>
        /// <param name="definitions"></param>
        /// <param name="context"></param>
        /// <returns></returns>
        public override IEnumerable<ValidationMessage> GetValidationMessages(Dictionary<string, Schema> definitions, RuleContext context)
        {
            var serviceDefinition = (ServiceDefinition)context.Root;
            var trackedResources = context.TrackedResourceModels;
            foreach (var resource in trackedResources)
            {
                var modelHierarchy = ValidationUtilities.EnumerateModelHierarchy(resource, definitions);
                var modelsWithLocationProp = modelHierarchy.Where(model => (definitions[model].Required?.Contains("location") == true) && 
                                                                            (definitions[model].Properties?.ContainsKey("location")==true));
                if (modelsWithLocationProp.Any())
                {
                    var modelWithLocationProp = modelsWithLocationProp.First();
                    if (definitions[modelWithLocationProp].Properties["location"].Extensions?.ContainsKey("x-ms-mutability") != true)
                    {
                        yield return new ValidationMessage(new FileObjectPath(context.File, context.Path.AppendProperty("properties").AppendProperty("location")), this, modelWithLocationProp);
                    }
                    else
                    {
                        var jObject = JsonConvert.DeserializeObject<object[]>(definitions[modelWithLocationProp].Properties["location"].Extensions["x-ms-mutability"].ToString());
                        // make sure jObject and the expected mutability properties have exact same elements
                        if (jObject.Except(LocationPropertyMutability).Any() || LocationPropertyMutability.Except(jObject).Any())
                        {
                            yield return new ValidationMessage(new FileObjectPath(context.File, context.Path.AppendProperty("properties").AppendProperty("location").AppendProperty("x-ms-mutability")), this, resource);
                        }
                    }
                }
            }
        }
    }
}
