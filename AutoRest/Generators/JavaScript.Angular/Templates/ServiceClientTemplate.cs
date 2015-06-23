// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest.Generator.JavaScript.Angular.Templates
{
#line 1 "ServiceClientTemplate.cshtml"
using Microsoft.Rest.Generator.ClientModel

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class ServiceClientTemplate : Microsoft.Rest.Generator.Template<Microsoft.Rest.Generator.ClientModel.ServiceClient>
    {
        #line hidden
        public ServiceClientTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
            WriteLiteral("<script src=\"Scripts/angular.js\"></script>\r\n<script type=\"text/javascript\">\r\n    " +
"angular.module(\'");
#line 6 "ServiceClientTemplate.cshtml"
               Write(Model.Name);

#line default
#line hidden
            WriteLiteral("\', []).controller(\'");
#line 6 "ServiceClientTemplate.cshtml"
                                              Write(Model.Name);

#line default
#line hidden
            WriteLiteral("Ctrlr\', function ($scope, $http) {\r\n        $scope.baseUri = \'");
#line 7 "ServiceClientTemplate.cshtml"
                     Write(Model.BaseUrl);

#line default
#line hidden
            WriteLiteral("\';\r\n");
#line 8 "ServiceClientTemplate.cshtml"
        

#line default
#line hidden

#line 8 "ServiceClientTemplate.cshtml"
         foreach(var method in Model.Methods)
        {
            var url = "$scope.baseUri + '" + method.Url +  "'";
            //TODO: Add support for query parameters
            foreach (var param in method.Parameters)
            {
                if (param.Location == ParameterLocation.Path)
                {
                    url += ".replace('{" + param.SerializedName + "}', " + param.Name + ")";
                }
            }

#line default
#line hidden

            WriteLiteral("        $scope.");
#line 19 "ServiceClientTemplate.cshtml"
            Write(method.Name);

#line default
#line hidden
            WriteLiteral(" = function () {\r\n            $http({\r\n                method: \'");
#line 21 "ServiceClientTemplate.cshtml"
                      Write(method.HttpMethod.ToString().ToUpper());

#line default
#line hidden
            WriteLiteral("\',\r\n                url: ");
#line 22 "ServiceClientTemplate.cshtml"
                  Write(url);

#line default
#line hidden
            WriteLiteral(",\r\n                headers: {\r\n                    \'Content-Type\': \'application/j" +
"son\'\r\n                }\r\n            }).then(function (data, status) {\r\n");
#line 27 "ServiceClientTemplate.cshtml"
                foreach(var response in method.Responses)
                {
                  if (response.Value == null)
                  {
                      continue;
                  }

#line default
#line hidden

            WriteLiteral("                if (status == ");
#line 33 "ServiceClientTemplate.cshtml"
                            Write((int)response.Key);

#line default
#line hidden
            WriteLiteral(") {\r\n                    $scope.");
#line 34 "ServiceClientTemplate.cshtml"
                        Write(response.Value.Name);

#line default
#line hidden
            WriteLiteral(" = data;\r\n                }\r\n");
#line 36 "ServiceClientTemplate.cshtml"
                }

#line default
#line hidden

            WriteLiteral("            });\r\n        };\r\n");
#line 39 "ServiceClientTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("    });\r\n</script>");
        }
        #pragma warning restore 1998
    }
}
