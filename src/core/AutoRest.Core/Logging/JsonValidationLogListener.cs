using AutoRest.Core.Validation;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Threading.Tasks;

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
                rawMessage["code"] = validationMessage.Type.Name;
                rawMessage["message"] = validationMessage.Message;
                rawMessage["jsonpath"] = validationMessage.Path.JsonPath;
                rawMessageCollection.Add(rawMessage);
            }
        }

        public string GetValidationMessagesAsJson() => JsonConvert.SerializeObject(rawMessageCollection, Formatting.Indented);
    }
}
