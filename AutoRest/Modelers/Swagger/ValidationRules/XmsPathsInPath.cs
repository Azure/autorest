using System.Collections.Generic;
using Microsoft.Rest.Generator;
using Microsoft.Rest.Modeler.Swagger.Model;

namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1704:IdentifiersShouldBeSpelledCorrectly", MessageId = "Xms")]
    public class XmsPathsInPath : TypeRule<ServiceDefinition>
    {
        public override IEnumerable<ValidationMessage> GetValidationMessages(ServiceDefinition entity)
        {
            if (entity != null && entity.CustomPaths != null)
            {
                foreach (var customPath in entity.CustomPaths.Keys)
                {
                    var basePath = GetBasePath(customPath);
                    if (!entity.Paths.ContainsKey(basePath))
                    {
                        yield return CreateException(null, Exception, customPath);
                    }
                }
            }

            yield break;
        }

        private static string GetBasePath(string customPath)
        {
            var index = customPath.IndexOf('?');
            return customPath.Substring(0, index);
        }

        public override ValidationExceptionName Exception
        {
            get
            {
                return ValidationExceptionName.XmsPathsMustOverloadPaths;
            }
        }
    }
}
