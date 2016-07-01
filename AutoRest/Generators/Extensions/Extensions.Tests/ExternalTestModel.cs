using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace Microsoft.Rest.Generator.Tests.ExternalModels
{
    [JsonObject()]
    public class ExternalTestModel
    {
        public string Id { get; set; }

        public DateTime? DateTime { get; set; }
    }
}
