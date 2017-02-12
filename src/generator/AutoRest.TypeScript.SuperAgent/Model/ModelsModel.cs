using System.Collections.Generic;

namespace AutoRest.TypeScript.SuperAgent.Model
{
    public class ModelsModel
    {
        public HeaderModel Header { get; set; }
        public List<Model> RequestModels { get; set; }
        public List<Model> ResponseModels { get; set; }
    }
}
