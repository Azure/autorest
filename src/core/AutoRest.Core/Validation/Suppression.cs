using AutoRest.Core.Logging;
using Newtonsoft.Json;

namespace AutoRest.Core.Validation
{
    public class Suppression
    {
        [JsonProperty("what", Required=Required.Always)]
        public string ID { get; set; }

        [JsonProperty("why", Required = Required.Always)]
        public string Reason { get; set; }

        [JsonProperty("where", Required = Required.Always)]
        public string Path { get; set; }

        public bool Matches(LogMessage message)
        {
            var validationMessage = message as ValidationMessage;
            return validationMessage != null
                && validationMessage.Type.Name == ID
                && validationMessage.Path.XPath == Path;
        }
    }
}
