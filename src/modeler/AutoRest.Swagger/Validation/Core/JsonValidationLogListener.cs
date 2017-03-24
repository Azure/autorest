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

        private static readonly Regex resPathPattern = new Regex(@"/providers/(?<providerNamespace>[^{/]+)/((?<resourceType>[^{/]+)/)?");

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
                var pathComponentResourceType = pathComponents.Groups["resourceType"];

                var rawMessage = new Dictionary<string, string>();
                rawMessage["type"] = validationMessage.Severity.ToString();
                rawMessage["code"] = validationMessage.Rule.GetType().Name;
                rawMessage["message"] = validationMessage.Message;
                rawMessage["jsonref"] = validationMessage.Path.JsonReference;
                rawMessage["json-path"] = validationMessage.Path.ReadablePath;
                rawMessage["id"] = validationMessage.Rule.Id;
                rawMessage["validationCategory"] = validationMessage.Rule.ValidationCategory.ToString();
                rawMessage["providerNamespace"] = pathComponentProviderNamespace.Success ? pathComponentProviderNamespace.Value : null;
                rawMessage["resourceType"] = pathComponentResourceType.Success ? pathComponentResourceType.Value : null;
                rawMessageCollection.Add(rawMessage);
            }
        }

        public string GetValidationMessagesAsJson() => JsonConvert.SerializeObject(rawMessageCollection, Formatting.Indented);
    }
}
