using System.Collections.Generic;
using System.Linq;
using System.Net;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.TypeScript.SuperAgent.Model;

namespace AutoRest.TypeScript.SuperAgent.ModelBinder
{
    public class ClientGroupsModelBinder : ITsModelBinder<ClientGroupsModel>
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
                    var okResponse = method.Responses[HttpStatusCode.OK];

                    var doNotWrap = okResponse.Body.IsPrimaryType() || okResponse.Body.IsSequenceType();

                    string requestName = null;
                    string responseName = null;

                    if (doNotWrap)
                    {
                        var serializedName = method.SerializedName.Value;
                        var parts = serializedName.Split('_');
                        if (parts.Length > 1)
                        {
                            requestName = parts[0];
                        }
                        else
                        {
                            responseName = okResponse.Body.GetImplementationName();
                        }
                    }
                    else
                    {
                        responseName = okResponse.Body.Name;
                    }

                    if (string.IsNullOrWhiteSpace(requestName))
                    {
                        requestName = okResponse.Body.GetImplementationName();
                    }

                    if (string.IsNullOrWhiteSpace(responseName))
                    {
                        responseName = okResponse.Body.GetImplementationName();
                    }

                    requestName = $"{model.ModelModuleName}.{requestName}Request";

                    if (!doNotWrap)
                    {
                        responseName = $"{model.ModelModuleName}.I{responseName}";
                    }

                    var clientMethod = new ClientMethodModel
                                       {
                                           UrlTemplate = GetUrlTemplate(method),
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
                url = url.Replace($"{{{param.Name.Value}}}", $"${{requestDto.{param.Name.Value}}}");
            }

            for (var index = 0;
                index < method.Parameters.Where(p => p.Location == ParameterLocation.Query).ToArray().Length;
                index++)
            {
                var param = method.Parameters.Where(p => p.Location == ParameterLocation.Query).ToArray()[index];
                char separator = index == 0 ? '?' : '&';
                url += $"{separator}{param.Name.Value}=${{requestDto.{param.Name.Value}}}";
            }

            return $"${{this.baseUrl}}{url}";
        }
    }
}
