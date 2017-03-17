// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Swagger.Validation.Core;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

namespace AutoRest.Swagger.Logging.Core
{
    public class JsonValidationLogListener : ILogListener
    {
        private readonly List<Dictionary<string, string>> rawMessageCollection = new List<Dictionary<string, string>>();

        private readonly Regex resPathPattern = new Regex(@"/providers/(?<providerNamespace>[^{/]+)/((?<resource>[^{/]+)/)?((?<resourceName>[^/]+)/)?((?<childResource>[^{/]+)/)?((?<childResourceName>[^/]+)/)?((?<grandChildResource>[^{/]+)/)?((?<grandChildResourceName>[^\/]+))?");

        public void Log(LogMessage message)
        {
            var validationMessage = message as ValidationMessage;
            if (validationMessage != null && message.Severity > Category.Debug)
            {
                string path = validationMessage.Path.ObjectPath.Path
                    .OfType<ObjectPathPartProperty>()
                    .Select(p => p.Property)
                    .SkipWhile(p => p != "paths")
                    .Skip(1)
                    .FirstOrDefault();
                var pathComponents = resPathPattern.Match(path ?? "");
                var pathComponentProviderNamespace = pathComponents.Groups["providerNamespace"];
                var pathComponentResource = pathComponents.Groups["resource"];
                var pathComponentChildResource = pathComponents.Groups["childResource"];
                var pathComponentGrandChildResource = pathComponents.Groups["grandChildResource"];

                string violatingResourceType = "";
                if (pathComponentResource.Success)
                {
                    violatingResourceType = string.IsNullOrWhiteSpace(pathComponentResource.Value) ? violatingResourceType : pathComponentResource.Value;
                }
                if (pathComponentChildResource.Success)
                {
                    violatingResourceType = string.IsNullOrWhiteSpace(pathComponentChildResource.Value) ? violatingResourceType : pathComponentChildResource.Value;
                }
                if (pathComponentGrandChildResource.Success)
                {
                    violatingResourceType = string.IsNullOrWhiteSpace(pathComponentGrandChildResource.Value) ? violatingResourceType : pathComponentGrandChildResource.Value;
                }

                var rawMessage = new Dictionary<string, string>();
                rawMessage["type"] = validationMessage.Severity.ToString();
                rawMessage["code"] = validationMessage.Rule.GetType().Name;
                rawMessage["message"] = validationMessage.Message;
                rawMessage["jsonref"] = validationMessage.Path.JsonReference;
                rawMessage["json-path"] = validationMessage.Path.ReadablePath;
                rawMessage["id"] = validationMessage.Rule.Id;
                rawMessage["validationCategory"] = validationMessage.Rule.ValidationCategory.ToString();
                rawMessage["providerNamespace"] = pathComponentProviderNamespace.Success ? pathComponentProviderNamespace.Value : null;
                rawMessage["resourceType"] = violatingResourceType;
                rawMessageCollection.Add(rawMessage);
            }
        }

        public string GetValidationMessagesAsJson() => JsonConvert.SerializeObject(rawMessageCollection, Formatting.Indented);
    }
}
