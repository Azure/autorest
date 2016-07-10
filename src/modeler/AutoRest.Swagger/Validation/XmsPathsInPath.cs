// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Validation;
using AutoRest.Swagger.Model;
using System.Collections.Generic;

namespace AutoRest.Swagger.Validation
{
    [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1704:IdentifiersShouldBeSpelledCorrectly", MessageId = "Xms")]
    public class XmsPathsInPath : TypedRule<ServiceDefinition>
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
                        yield return CreateException(Exception, customPath);
                    }
                }
            }

            yield break;
        }

        private static string GetBasePath(string customPath)
        {
            var index = customPath.IndexOf('?');
            if (index == -1)
            {
                index = customPath.Length;
            }
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
