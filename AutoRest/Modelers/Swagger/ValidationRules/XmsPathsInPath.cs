using System.Collections.Generic;
using Microsoft.Rest.Generator;
using Microsoft.Rest.Modeler.Swagger.Model;

namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    public class XmsPathsInPath : TypeRule<ServiceDefinition>
    {
        public override IEnumerable<ValidationMessage> GetValidationMessages(ServiceDefinition entity)
        {
            foreach(var customPath in entity.CustomPaths.Keys)
            {
                var basePath = GetBasePath(customPath);
                if (!entity.Paths.ContainsKey(basePath))
                {
                    yield return CreateException(null, Exception, customPath);
                }
            }

            yield break;
        }

        private string GetBasePath(string customPath)
        {
            var index = customPath.IndexOf('?');
            return customPath.Substring(0, index);
        }

        public override ValidationExceptionName Exception
        {
            get
            {
                return ValidationExceptionName.XMSPathsMustOverloadPaths;
            }
        }
    }
}
