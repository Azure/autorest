using System.Collections.Generic;

namespace AutoRest.TypeScript.SuperAgent.Model
{
    public class EnumModel
    {
        public EnumModel()
        {
            Values = new Dictionary<string, object>();
        }

        public string Name { get; set; }

        public Dictionary<string, object> Values { get; set; }
    }
}
