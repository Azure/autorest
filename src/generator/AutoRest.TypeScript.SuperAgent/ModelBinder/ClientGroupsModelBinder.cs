using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.TypeScript.SuperAgent.Model;

namespace AutoRest.TypeScript.SuperAgent.ModelBinder
{
    public class ClientGroupsModelBinder : ModelBinderBaseTs, ITsModelBinder<ClientGroupsModel>
    {
        public ClientGroupsModel Bind(CodeModelTs codeModel)
        {
            var model = new ClientGroupsModel
                        {
                            ModelModuleName = "model",
                            Header = new HeaderModel(),
                            Clients = new List<ClientModel>()
                        };

            foreach (var group in codeModel.MethodGroups)
            {
                var groupName = group.Key;
                var methods = group.ToArray();

                var client = new ClientModel
                             {
                                 Name = $"{groupName.ToPascalCase().Replace("Api", "")}Api",
                                 Methods = new List<ClientMethodModel>()
                             };

                client.InterfaceName = $"I{client.Name}";

                foreach (var method in methods)
                {
                    IModelType modelType = null;
                    string responseName = null;
                    string requestName = null;
                    if (!TryGetResponseName(method, out modelType, out responseName, out requestName, model.ModelModuleName))
                    {
                        continue;
                    }

                    var clientMethod = new ClientMethodModel
                                       {
                                           OperationId = method.SerializedName.ToString(),
                                           UrlTemplate = GetUrlTemplate(method),
                                           QueryStringTemplate = GetQueryParameterTemplate(method),
                                           HttpMethod = method.HttpMethod.ToString().ToLower(),
                                           MethodName = method.Name.Value.Replace($"{groupName}_", "").ToCamelCase(),
                                           RequestTypeName = requestName,
                                           ResponseTypeName = responseName,
                                           ParamNamesInPath =
                                               method.Parameters.Where(p => p.Location == ParameterLocation.Path)
                                                   .Select(p => p.Name.Value)
                                                   .ToList(),

                                           ParamNamesInQuery =
                                               method.Parameters.Where(p => p.Location == ParameterLocation.Query)
                                                   .Select(p => p.Name.Value)
                                                   .ToList(),

                                           ParamNamesInBody =
                                               method.Parameters.Where(p => p.Location == ParameterLocation.Body)
                                                   .Select(p => p.Name.Value)
                                                   .ToList(),

                                           ParamNamesInHeader =
                                               method.Parameters.Where(p => p.Location == ParameterLocation.Header)
                                                   .Select(p => p.Name.Value)
                                                   .ToList()
                                       };

                    clientMethod.ResponsePromiseTypeName = $"Promise<{clientMethod.ResponseTypeName}>";
                    client.Methods.Add(clientMethod);
                }

                model.Clients.Add(client);
            }

            return model;
        }

        public string GetUrlTemplate(Method method)
        {
            var url = method.Url.Value;

            foreach (var param in method.Parameters.Where(p => p.Location == ParameterLocation.Path))
            {
                url = url.Replace($"{{{param.Name.Value}}}", $"${{request.{param.Name.Value}}}");
            }

            return $"${{this.baseUrl}}{url}";
        }

        public string GetQueryParameterTemplate(Method method)
        {
            var pairs = method.Parameters.Where(p => p.Location == ParameterLocation.Query)
                .Select(param => $"{param.Name.Value}: request.{param.Name.Value}");

            return $"{{ {string.Join(", ", pairs)} }}";
        }
    }
}
