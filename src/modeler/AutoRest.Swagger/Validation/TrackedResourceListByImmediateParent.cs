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
    public class TrackedResourceListByImmediateParent : TypedRule<Dictionary<string, Dictionary<string, Operation>>>
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
        public override Category Severity => Category.Warning;

        /*
         * This regular expression tries to filter the paths which has child resources. Now we could take the following paths:
         *
         *      Case 1: /subscriptions/{subscriptionId}/resourceGroup/{resourceGroupName}/providers/Microsoft.Sql/servers/{server1}
         *      Case 2: /subscriptions/{subscriptionId}/resourceGroup/{resourceGroupName}/providers/Microsoft.Sql/servers/{server1}/poweroff
         *      Case 3: /subscriptions/{subscriptionId}/resourceGroup/{resourceGroupName}/providers/Microsoft.Sql/servers/{server1}/databases
         *      Case 4: /subscriptions/{subscriptionId}/resourceGroup/{resourceGroupName}/providers/Microsoft.Sql/servers/{server1}/databases/{database1}
         *      Case 5: /subscriptions/{subscriptionId}/resourceGroup/{resourceGroupName}/providers/Microsoft.Sql/servers/{server1}/databases/{database1}/restart
         *
         * Case 1 does not have a child resource. So, this can be rejected.
         *
         * Case 2 & Case 3 are special cases. Here, Case 3 does have a child resource - 'databases'. But, Case 2 does not have a child resource. The 'poweroff' is 
         * an operation - not a child resource. But, it is difficult to determine, using regular expressions, whether the 'poweroff' is an operation or child resource.
         * We could filter both and determine based on the response whether it is a child resource. While this is valid, it seems to be complex. So, a decision has been
         * made to reject this pattern altogether and not look for child resource in this path pattern. Note: Case 5 is also rejected for the same reason.
         *
         * Case 4 is a valid scenario which has a child resource. Also, in this pattern, there is no ambiguity about any operation. So, in order to find the path, with 
         * child resources, we use only this pattern. i.e. the path must have atleast one parent resource similar to '/servers/{server1}' followed by any number of child
         * resources and end with the child resource pattern - similar to '/databases/{database1}'.
         *
         * Note: If in a swagger file, there are the following paths:
         *
         *      1: /subscriptions/{subscriptionId}/resourceGroup/{resourceGroupName}/providers/Microsoft.Sql/servers/{server1}
         *      2: /subscriptions/{subscriptionId}/resourceGroup/{resourceGroupName}/providers/Microsoft.Sql/servers/{server1}/databases
         *
         * and do not have the following path:
         *
         *      3: /subscriptions/{subscriptionId}/resourceGroup/{resourceGroupName}/providers/Microsoft.Sql/servers/{server1}/databases/{database1}
         *
         * then we will miss the child resource 'databases'. But, the possibility of such an occurence is extremely rare, if not impossible. It is quite possible that 
         * 1 & 3 are present without 2 and 1-2-3 are present. So, it is fine to use this logic.
         *
         * Immediate Parent Resource Logic
         * ===============================
         * The path with the child resource has been determined and the name of the child resource has been identified. Now, in order to find the immediate parent resource,
         * consider the following cases:
         *
         *      1. /subscriptions/{subscriptionId}/resourceGroup/{resourceGroupName}/providers/Microsoft.Sql/servers/{server1}/databases/{databases1} - Child: databases-Immediate Parent: servers
         *      2. /subscriptions/{subscriptionId}/resourceGroup/{resourceGroupName}/providers/Microsoft.Sql/servers/{server1}/databases/{databases1}/disks/{disk1} - Child: disks-Immediate Parent: databases
         *
         *  So, we do string manipulation to determine the immediate parent. We find the last index of "/{" twice and remove after that. Then we find the last index of "/" and find the string after that.
         *  To visualize it:
         *
         *      Start: /subscriptions/{subscriptionId}/resourceGroup/{resourceGroupName}/providers/Microsoft.Sql/servers/{server1}/databases/{databases1}/disks/{disk1}
         *      Step 1: /subscriptions/{subscriptionId}/resourceGroup/{resourceGroupName}/providers/Microsoft.Sql/servers/{server1}/databases/{databases1}/disks
         *      Step 2: /subscriptions/{subscriptionId}/resourceGroup/{resourceGroupName}/providers/Microsoft.Sql/servers/{server1}/databases
         *      Step 3: databases
         */
        private static readonly Regex resourcePathPattern = new Regex("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/[^/]+/[^/]+/{[^/]+}.*/(?<childresource>\\w+)/{[^/]+}$", RegexOptions.IgnoreCase);

        private KeyValuePair<string, string> GetChildAndImmediateParentResource(string path, Dictionary<string, Dictionary<string, Operation>> paths, Dictionary<string, Schema> definitions)
        {
            Match match = resourcePathPattern.Match(path);
            KeyValuePair<string, string> result = new KeyValuePair<string, string>();
            if (match.Success)
            {
                string childResourceName = match.Groups["childresource"].Value;
                string immediateParentResourceNameInPath = GetImmediateParentResourceName(path);
                string immediateParentResourceNameActual = GetActualParentResourceName(immediateParentResourceNameInPath, paths, definitions);
                result = new KeyValuePair<string, string>(childResourceName, immediateParentResourceNameActual);
            }

            return result;
        }

        /// <summary>
        /// Gets the immediate parent resource name
        /// </summary>
        /// <param name="childResourcePaths">paths that fits the child resource criteria</param>
        /// <returns>name of the immediate parent resource name</returns>
        private string GetImmediateParentResourceName(string pathToEvaluate)
        {
            pathToEvaluate = pathToEvaluate.Substring(0, pathToEvaluate.LastIndexOf("/{"));
            pathToEvaluate = pathToEvaluate.Substring(0, pathToEvaluate.LastIndexOf("/{"));
            return pathToEvaluate.Substring(pathToEvaluate.LastIndexOf("/") + 1);
        }

        private string GetActualParentResourceName(string nameInPath, Dictionary<string, Dictionary<string, Operation>> paths, Dictionary<string, Schema> definitions)
        {
            Regex pathRegEx = new Regex("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/.*/" + nameInPath + "/{[^/]+}$", RegexOptions.IgnoreCase);

            IEnumerable<KeyValuePair<string, Dictionary<string, Operation>>> matchingPaths = paths.Where((KeyValuePair<string, Dictionary<string, Operation>> pth) => pathRegEx.IsMatch(pth.Key));
            if (!matchingPaths.Any()) return null;
            KeyValuePair<string, Dictionary<string, Operation>> path = matchingPaths.First();

            IEnumerable<KeyValuePair<string, Operation>> operations = path.Value.Where(op => op.Key.Equals("get", StringComparison.CurrentCultureIgnoreCase));
            if (!operations.Any()) return null;
            KeyValuePair<string, Operation>  operation = operations.First();

            IEnumerable<KeyValuePair<string, OperationResponse>> responses = operation.Value.Responses.Where(resp => resp.Key.Equals("200"));
            if (!responses.Any()) return null;
            KeyValuePair<string, OperationResponse> response = responses.First();

            return GetReferencedModel(response.Value.Schema.Reference, definitions);
        }

        private string GetReferencedModel(String schema, Dictionary<string, Schema> definitions)
        {
            Schema referencedSchema = Schema.FindReferencedSchema(schema, definitions);

            if (referencedSchema == null) return null;

            if (referencedSchema.Reference == null)
            {
                IEnumerable<KeyValuePair<string, Schema>> definition = definitions.Where(def => def.Value == referencedSchema);
                if (!definition.Any()) return null;
                return definition.First().Key;
            }
            
            return GetReferencedModel(referencedSchema.Reference, definitions);
        }

        /// <summary>
        /// Validates if the child tracked resources have List by immediate parent operation.
        /// </summary>
        /// <param name="definitions"></param>
        /// <param name="context"></param>
        /// <returns></returns>
        public override IEnumerable<ValidationMessage> GetValidationMessages(Dictionary<string, Dictionary<string, Operation>> paths, RuleContext context)
        {
            foreach(KeyValuePair<string, Dictionary<string, Operation>> pathDefinition in paths)
            {
                KeyValuePair<string, string> childResourceMapping = GetChildAndImmediateParentResource(pathDefinition.Key, paths, context.Root.Definitions);
                if(childResourceMapping.Key != null && childResourceMapping.Value != null)
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

                        yield return new ValidationMessage(new FileObjectPath(context.File, context.Path.AppendProperty("#/definitions/" + childResourceMapping.Key)), this, formatParameters);
                    }

                }
            }
        }
    }
}
