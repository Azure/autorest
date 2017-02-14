using System.Collections.Generic;

namespace AutoRest.TypeScript.SuperAgent.Model
{
    public class ClientGroupsModel
    {
        public string ModelModuleName { get; set; }
        public HeaderModel Header { get; set; }
        public List<ClientModel> Clients { get; set; }
    }
}
