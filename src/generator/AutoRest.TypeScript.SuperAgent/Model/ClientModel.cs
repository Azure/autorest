
using System.Collections.Generic;

namespace AutoRest.TypeScript.SuperAgent.Model
{
    public class ClientModel
    {
        public string Name { get; set; }

        public string InterfaceName { get; set; }

        public List<ClientMethodModel> Methods { get; set; }

    }
}
