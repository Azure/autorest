// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.


using System.Collections.Generic;
using System.Text.RegularExpressions;
using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Swagger.Validation.Core;
using AutoRest.Swagger.Model;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json.Schema;
using System.Linq;

namespace AutoRest.Swagger.Validation
{
    public class XmsExamplesRequired : TypedRule<Dictionary<string, Dictionary<string, Operation>>>
    {
        // the maximum number of non-xms-examples operations to allow.
        private const int magicNumber = 10;
        
        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "R2022";

        private string OperationIdMessageSuffix => " Operation: '{0}'";

        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => "Please provide x-ms-examples describing minimum/maximum property set for response/request payloads for operations.{0}";

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Error;

        /// <summary>
        /// What kind of open api document type this rule should be applied to
        /// </summary>
        public override ServiceDefinitionDocumentType ServiceDefinitionDocumentType => ServiceDefinitionDocumentType.ARM;

        /// <summary>
        /// When to apply the validation rule, before or after it has been merged as a part of 
        /// its merged document as specified in the corresponding '.md' file
        /// By default consider all rules to be applied for After only
        /// </summary>
        public override ServiceDefinitionDocumentState ValidationRuleMergeState => ServiceDefinitionDocumentState.Individual;

        /// <summary>
        /// Violation category of the Rule.
        /// </summary>
        public override ValidationCategory ValidationCategory => ValidationCategory.SDKViolation;

        private bool IsValidJson(string jsonString)
        {
            try
            {
                var jObject = JObject.Parse(jsonString);
                if (jObject == null)
                {
                    return false;
                }
            }
            catch (System.Exception)
            {
                return false;
            }
            return true;
        }

        /// <summary>
        /// Validates whether operation has corresponding x-ms-examples
        /// </summary>
        /// <param name="entity">Operation name to be verified.</param>
        /// <param name="context">Rule context.</param>
        /// <returns>ValidationMessage</returns>
        /// (Dictionary<string, Dictionary<string, Operation>> entity, RuleContext context)
        public override IEnumerable<ValidationMessage> GetValidationMessages(Dictionary<string, Dictionary<string, Operation>> paths, RuleContext context)
        {
            // find all operations that do not have the x-ms-examples extension or those which have x-ms-examples extension as empty
            // but ignore operations_list
            var violatingOps = paths.SelectMany(pathObj => pathObj.Value.Where(opPair 
                                                            => (opPair.Value.Extensions?.ContainsKey("x-ms-examples") != true 
                                                               || string.IsNullOrWhiteSpace(opPair.Value.Extensions["x-ms-examples"].ToString())
                                                               || !IsValidJson(opPair.Value.Extensions["x-ms-examples"].ToString()))
                                                               && !opPair.Value.OperationId.ToLower().Equals("operations_list")));

            

            // if number of violations exceeds magicNumber, simply aggregate the message
            if (violatingOps.Count() > magicNumber)
            {
                yield return new ValidationMessage(new FileObjectPath(context.File, context.Path), this, string.Empty);
            }
            else
            {
                foreach (var violatingOp in violatingOps)
                {
                    var violatingPath = paths.First(pathObj => pathObj.Value.Values.Select(op => op.OperationId).Contains(violatingOp.Value.OperationId)).Key;
                    yield return new ValidationMessage(new FileObjectPath(context.File, context.Path.AppendProperty(violatingPath).AppendProperty(violatingOp.Key)), this, string.Format(OperationIdMessageSuffix, violatingOp.Value.OperationId));
                }
            }
        }
    }
}
