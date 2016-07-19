// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Globalization;
using System.Linq;
using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Core.Validation;
using AutoRest.Swagger.Model;

namespace AutoRest.Swagger.Validation
{
    [SuppressMessage("Microsoft.Naming", "CA1704:IdentifiersShouldBeSpelledCorrectly", MessageId = "Xms")]
    public class XmsPathsMustOverloadPaths : TypedRule<ServiceDefinition>
    {
        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.XMSPathBaseNotInPaths;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override LogEntrySeverity Severity => LogEntrySeverity.Warning;

        public override IEnumerable<ValidationMessage> GetValidationMessages(ServiceDefinition entity)
        {
            return entity?.CustomPaths?.Keys
                .Where(customPath => !entity.Paths.ContainsKey(GetBasePath(customPath)))
                .Select(basePath => new ValidationMessage(this,basePath))
                
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
    }
}