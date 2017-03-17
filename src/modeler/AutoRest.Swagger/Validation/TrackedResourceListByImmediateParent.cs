using AutoRest.Swagger.Validation.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Swagger.Model;
using AutoRest.Swagger.Model.Utilities;
using System.Text.RegularExpressions;

namespace AutoRest.Swagger.Validation
{
    class TrackedResourceListByImmediateParent : TypedRule<Dictionary<string, Schema>>
    {
        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "M3010";

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
        public override Category Severity => Category.Error;

        /// <summary>
        /// Get the paths that fits the child resource criteria.
        /// </summary>
        /// <param name="childResource">name of the child resource</param>
        /// <param name="serviceDefinition">service definition</param>
        /// <returns>the paths that fit the child resource criteria</returns>
        private IEnumerable<KeyValuePair<string, Dictionary<string, Operation>>> GetChildResourcesPaths(string childResource, ServiceDefinition serviceDefinition)
        {
            Regex pathRegEx = new Regex("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/.+/.+/{.+}.*/" + childResource + "s$", RegexOptions.IgnoreCase);
            IEnumerable<KeyValuePair<string, Dictionary<string, Operation>>> filteredPaths = serviceDefinition.Paths.Where(path => pathRegEx.IsMatch(path.Key));
            return filteredPaths;
        }

        /// <summary>
        /// Gets the immediate parent resource name
        /// </summary>
        /// <param name="childResourcePaths">paths that fits the child resource criteria</param>
        /// <returns>name of the immediate parent resource name</returns>
        private string GetImmediateParentResourceName(IEnumerable<KeyValuePair<string, Dictionary<string, Operation>>> childResourcePaths)
        {
            string pathToEvaluate = childResourcePaths.First().Key;
            pathToEvaluate = pathToEvaluate.Substring(0, pathToEvaluate.LastIndexOf("s/{"));
            return pathToEvaluate.Substring(pathToEvaluate.LastIndexOf("/") + 1);
        }

        /// <summary>
        /// Validates if the child tracked resources have List by immediate parent operation.
        /// </summary>
        /// <param name="definitions"></param>
        /// <param name="context"></param>
        /// <returns></returns>
        public override bool IsValid(Dictionary<string, Schema> definitions, RuleContext context, out object[] formatParameters)
        {
            // Retrieve the list of TrackedResources
            List<string> trackedResources = ValidationUtilities.GetTrackedResources();

            foreach (string trackedResource in trackedResources)
            {
                IEnumerable<KeyValuePair<string, Dictionary<string, Operation>>> childResourcePaths = GetChildResourcesPaths(trackedResource, context.Root);

                // There must be only one path matching this criteria. If there is more than one path matching this criteria, there is
                // something wrong with the swagger file. So, throw an exception.
                if (childResourcePaths.Count() > 1)
                {
                    throw new Exception("Swagger file has more than one path for a resource: " + trackedResource);
                }

                // If there is no filtered path, then it means the tracked resource is not a child resource.
                // so continue to the next tracked resource.
                if (childResourcePaths.Count() == 0)
                {
                    continue;
                }

                string immediateParentResourceName = GetImmediateParentResourceName(childResourcePaths);
                string operationIdToFind = trackedResource + "s_ListBy" + immediateParentResourceName;
                bool listByImmediateParent = childResourcePaths.Any(filteredPath => 
                    filteredPath.Value.Where(operationKeyValuePair => operationKeyValuePair.Value.OperationId.Equals(operationIdToFind, StringComparison.CurrentCultureIgnoreCase)).Count() == 1
                );

                if(!listByImmediateParent)
                {
                    formatParameters = new object[2];
                    formatParameters[0] = trackedResource;
                    formatParameters[1] = immediateParentResourceName;
                    return false;
                }
            }

            formatParameters = new object[0];
            return true;
        }
    }
}
