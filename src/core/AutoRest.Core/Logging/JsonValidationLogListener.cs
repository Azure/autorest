// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Validation;
using Newtonsoft.Json;
using System.Collections.Generic;

namespace AutoRest.Core.Logging
{
    public class JsonValidationLogListener : ILogListener
    {
        private List<Dictionary<string, string>> rawMessageCollection = new List<Dictionary<string, string>>();

        public void Log(LogMessage message)
        {
            var validationMessage = message as ValidationMessage;
            if (validationMessage != null && message.Severity > Category.Debug)
            {
                var rawMessage = new Dictionary<string, string>();
                rawMessage["type"] = validationMessage.Severity.ToString();
                rawMessage["code"] = validationMessage.Rule.GetType().Name;
                rawMessage["message"] = validationMessage.Message;
                rawMessage["jsonref"] = validationMessage.Path.JsonReference;
                rawMessage["json-path"] = validationMessage.Path.ReadablePath;
                rawMessage["id"] = validationMessage.Rule.Id;
                rawMessage["validationCategory"] = validationMessage.Rule.ValidationCategory.ToString();
                rawMessage["providerNamespace"] = "providerNamespace_WAT";
                rawMessage["resourceType"] = "resourceType_WAT";
                rawMessageCollection.Add(rawMessage);
            }
        }

        public string GetValidationMessagesAsJson() => JsonConvert.SerializeObject(rawMessageCollection, Formatting.Indented);
    }
}
