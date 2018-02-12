using System.Collections.Generic;

namespace AutoRest.TypeScript.SuperAgent.Model
{
    public class ClientMethodModel
    {
        public string OperationId { get; set; }

        public string MethodName { get; set; }

        public string RequestTypeName { get; set; }

        public string ResponseTypeName { get; set; }

        public string HttpMethod { get; set; }

        public string UrlTemplate { get; set; }

        public string QueryStringTemplate { get; set; }

        public string ResponsePromiseTypeName { get; set; }

        public List<string> ParamNamesInPath { get; set; }

        public List<string> ParamNamesInQuery { get; set; }

        public List<string> ParamNamesInBody { get; set; }

        public List<string> ParamNamesInHeader { get; set; }
    }
}
