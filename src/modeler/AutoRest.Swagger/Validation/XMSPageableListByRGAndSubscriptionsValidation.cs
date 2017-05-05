using AutoRest.Core.Logging;
using AutoRest.Swagger.Model;
using AutoRest.Core.Properties;
using System.Collections.Generic;
using AutoRest.Swagger.Validation.Core;
using AutoRest.Swagger.Model.Utilities;
using Newtonsoft.Json.Linq;

namespace AutoRest.Swagger.Validation
{
    public class XMSPageableListByRGAndSubscriptionsValidation : TypedRule<Dictionary<string, Schema>>
    {
        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "M3060";

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

        private string RemoveAndTrim(string str)
        {
            str = str.Replace('\r', ' ');
            str = str.Replace('\n', ' ');
            str = str.Replace(" ", "");
            return str.Trim();
        }

        private bool IsEqual(JObject obj1, JObject obj2)
        {
            string obj1String = RemoveAndTrim(obj1.ToString());
            string obj2String = RemoveAndTrim(obj2.ToString());
            return obj1String.Equals(obj2String);
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
