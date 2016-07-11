// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Validation;
using AutoRest.Swagger.Model;
using System.Collections.Generic;
using System.Linq;

namespace AutoRest.Swagger.Validation
{
    [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1704:IdentifiersShouldBeSpelledCorrectly", MessageId = "Xms")]
    public class XmsPathsInPath : TypedRule<ServiceDefinition>
    {
        public override IEnumerable<ValidationMessage> GetValidationMessages(ServiceDefinition entity)
        {
            return entity?.CustomPaths?.Keys
              .Where(customPath => !entity.Paths.ContainsKey(GetBasePath(customPath)))
              .Select(basePath => CreateException(Exception, basePath))

              ?? Enumerable.Empty<ValidationMessage>();
        }

        private static string GetBasePath(string customPath)
        {
            var index = customPath.IndexOf('?');
            if (index == -1)
            {
                return customPath;
            }
            return customPath.Substring(0, index);
        }

        public override ValidationExceptionName Exception => ValidationExceptionName.XmsPathsMustOverloadPaths;
    }
}
