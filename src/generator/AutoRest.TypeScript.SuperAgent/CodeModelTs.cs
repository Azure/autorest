using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using AutoRest.Core.Model;
using Newtonsoft.Json;

namespace AutoRest.TypeScript.SuperAgent
{
    public class CodeModelTs : CodeModel
    {
        public string GeneratedBy => System.Security.Principal.WindowsIdentity.GetCurrent().Name;

        public string GeneratedAt => DateTime.Now.ToString();

        public string GeneratorVersion => "1.0.0"; // TODO: get this from the version text

        [JsonIgnore]
        public IEnumerable<Method> MethodsWithSuccessResponse
        {
            get { return Methods.Where(method => method.Responses.ContainsKey(HttpStatusCode.OK)); }
        }

        [JsonIgnore]
        public IEnumerable<IGrouping<string, Method>> MethodGroups
        {
            get
            {
                var groupings = MethodsWithSuccessResponse.GroupBy(m =>
                                                          {
                                                              var name = m.SerializedName.Value;
                                                              return name.Split('_').FirstOrDefault() ?? name;
                                                          }).ToArray();

                return groupings;
            }
        }
    }
}
