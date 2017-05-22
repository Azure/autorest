using AutoRest.Core.Logging;
using AutoRest.Swagger.Model;
using AutoRest.Core.Properties;
using System.Collections.Generic;
using AutoRest.Swagger.Validation.Core;
using AutoRest.Swagger.Model.Utilities;
using Newtonsoft.Json.Linq;

namespace AutoRest.Swagger.Validation
{
    public class XMSPageableListByRGAndSubscriptions : TypedRule<Dictionary<string, Schema>>
    {
        private static readonly string NextLinkName = "nextLinkName";

        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "R3060";

        /// <summary>
        /// Violation category of the Rule.
        /// </summary>
        public override ValidationCategory ValidationCategory => ValidationCategory.SDKViolation;

        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.XMSPagableListByRGAndSubscriptionsMismatch;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Warning;

        private bool IsEqual(JObject obj1, JObject obj2)
        {
            if(obj1.Count != obj2.Count && obj1.Count != 1)
            {
                return false;
            }

            JToken value1 = obj1.GetValue(NextLinkName);
            JToken value2 = obj2.GetValue(NextLinkName);

            if(!JToken.DeepEquals(value1, value2))
            {
                return false;
            }

            return true;
        }

        public override IEnumerable<ValidationMessage> GetValidationMessages(Dictionary<string, Schema> definitions, RuleContext context)
        {
            IEnumerable<string> parentTrackedResourceModels = context.ParentTrackedResourceModels;

            foreach(string resourceModel in parentTrackedResourceModels)
            {
                Operation listByResourceGroupOperation = ValidationUtilities.GetListByResourceGroupOperation(resourceModel, definitions, context.Root);
                Operation listBySubscriptionOperation = ValidationUtilities.GetListBySubscriptionOperation(resourceModel, definitions, context.Root);

                if(listByResourceGroupOperation != null && listBySubscriptionOperation != null)
                {
                    JObject rgXMSPageableExtension = (JObject)listByResourceGroupOperation.Extensions[ValidationUtilities.XmsPageable];
                    JObject subXMSPageableExtension = (JObject)listBySubscriptionOperation.Extensions[ValidationUtilities.XmsPageable];
                    if (!IsEqual(rgXMSPageableExtension,subXMSPageableExtension))
                    {
                        yield return new ValidationMessage(new FileObjectPath(context.File, context.Path.AppendProperty(resourceModel)), this, resourceModel);
                    }
                }
            }
        }
    }
}
