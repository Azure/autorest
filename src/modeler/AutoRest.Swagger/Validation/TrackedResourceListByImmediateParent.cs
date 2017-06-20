using AutoRest.Swagger.Validation.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Swagger.Model;
using System.Text.RegularExpressions;
using AutoRest.Swagger.Model.Utilities;

namespace AutoRest.Swagger.Validation
{
    public class TrackedResourceListByImmediateParent : TypedRule<Dictionary<string, Dictionary<string, Operation>>>
    {
        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "R3010";

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
        public override string MessageTemplate => Resources.TrackedResourceListByImmediateParentOperationMissing;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Warning;

        /// <summary>
        /// What kind of open api document type this rule should be applied to
        /// </summary>
        public override ServiceDefinitionDocumentType ServiceDefinitionDocumentType => ServiceDefinitionDocumentType.ARM;

        /// <summary>
        /// ListByParent operation could be defined in a json different than the one where it is defined, hence need the composed state
        /// </summary>
        public override ServiceDefinitionDocumentState ValidationRuleMergeState => ServiceDefinitionDocumentState.Composed;


        /// <summary>
        /// For a given child tracked resource, finds the corresponding url
        /// </summary>
        /// <param name="childResource">The child tracked resource</param>
        /// <param name="paths">The paths in which to find the child tracked resource</param>
        /// <returns>The url corresponding to the child tracked resource</returns>
        private string GetPathForChildResource(string childResource, Dictionary<string, Dictionary<string, Operation>> paths)
        {
            foreach (var path in paths.Keys)
            {
                Match match = ValidationUtilities.ResourcePathPattern.Match(path);
                if (match.Success)
                {
                    if (match.Groups["childresource"].Value == childResource)
                    {
                        return path;
                    }

                }
            }
            return string.Empty;
        }

        /// <summary>
        /// Validates if the child tracked resources have List by immediate parent operation.
        /// </summary>
        /// <param name="definitions"></param>
        /// <param name="context"></param>
        /// <returns></returns>
        public override IEnumerable<ValidationMessage> GetValidationMessages(Dictionary<string, Dictionary<string, Operation>> paths, RuleContext context)
        {
            foreach(KeyValuePair<string, string> childResourceMapping in context.ChildTrackedResourceModels)
            {
                string operationIdToFind = childResourceMapping.Key + "_ListBy" + childResourceMapping.Value;
                bool listByImmediateParent = paths.Any(filteredPath =>
                    filteredPath.Value.Any(operationKeyValuePair => operationKeyValuePair.Value.OperationId.Equals(operationIdToFind, StringComparison.CurrentCultureIgnoreCase))
                );
                if (!listByImmediateParent)
                {
                    object[] formatParameters = new object[2];
                    formatParameters[0] = childResourceMapping.Key;
                    formatParameters[1] = childResourceMapping.Value;

                    yield return new ValidationMessage(new FileObjectPath(context.File, context.Parent.Path.AppendProperty("paths").AppendProperty(GetPathForChildResource(childResourceMapping.Key, paths))), this, formatParameters);
                }
            }
        }
    }
}
