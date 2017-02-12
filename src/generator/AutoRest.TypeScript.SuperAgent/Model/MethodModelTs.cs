using System.Net;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;

namespace AutoRest.TypeScript.SuperAgent.Model
{
    public class MethodModelTs
    {
        private readonly Method _method;
        private readonly string _groupName;

        public MethodModelTs(string groupName, Method method)
        {
            _method = method;
            _groupName = groupName;
        }

        public string MethodName => _method.Name.Value.Replace($"{_groupName}_", "").ToCamelCase();

        public string OkResponseTypeName => _method.Responses[HttpStatusCode.OK].Body.GetImplementationName();
        public string RequestTypeName =>  $"{OkResponseTypeName}Request";

        public string ResponseTypeName => $"{OkResponseTypeName}Response";

        public string ResponsePromiseTypeName => $"Promise<{ResponseTypeName}>";
    }
}
