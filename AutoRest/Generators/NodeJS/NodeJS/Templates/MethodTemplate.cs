// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest.Generator.NodeJS.Templates
{
#line 1 "MethodTemplate.cshtml"
using System.Linq;

#line default
#line hidden
#line 2 "MethodTemplate.cshtml"
using Microsoft.Rest.Generator.ClientModel

#line default
#line hidden
    ;
#line 3 "MethodTemplate.cshtml"
using Microsoft.Rest.Generator.NodeJS.TemplateModels

#line default
#line hidden
    ;
#line 4 "MethodTemplate.cshtml"
using Microsoft.Rest.Generator.NodeJS.Templates

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class MethodTemplate : Microsoft.Rest.Generator.Template<Microsoft.Rest.Generator.NodeJS.MethodTemplateModel>
    {
        #line hidden
        public MethodTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
            WriteLiteral("/**\r\n");
#line 8 "MethodTemplate.cshtml"
Write(WrapComment(" * ", Model.Documentation));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 9 "MethodTemplate.cshtml"
 foreach (var parameter in Model.DocumentationParameters)
{

#line default
#line hidden

            WriteLiteral(" * @param {");
#line 11 "MethodTemplate.cshtml"
         Write(parameter.Type.Name);

#line default
#line hidden
            WriteLiteral("} ");
#line 11 "MethodTemplate.cshtml"
                               Write(Model.GetParameterDocumentationName(parameter));

#line default
#line hidden
            WriteLiteral(" ");
#line 11 "MethodTemplate.cshtml"
                                                                               Write(parameter.Documentation);

#line default
#line hidden
            WriteLiteral("\r\n *\r\n");
#line 13 "MethodTemplate.cshtml"
}

#line default
#line hidden

#line 14 "MethodTemplate.cshtml"
Write(WrapComment(" * ", " @param {object} [options]"));

#line default
#line hidden
            WriteLiteral("\r\n *\r\n");
#line 16 "MethodTemplate.cshtml"
Write(WrapComment(" * ", " @param {object} [options.customHeaders] headers that will be added to request"));

#line default
#line hidden
            WriteLiteral("\r\n *\r\n");
#line 18 "MethodTemplate.cshtml"
Write(WrapComment(" * ",  " @param {function} callback"));

#line default
#line hidden
            WriteLiteral("\r\n *\r\n");
#line 20 "MethodTemplate.cshtml"
Write(WrapComment(" * ",  " @returns {Stream} The Response stream"));

#line default
#line hidden
            WriteLiteral("\r\n */\r\n");
#line 22 "MethodTemplate.cshtml"
Write(Model.OperationName);

#line default
#line hidden
            WriteLiteral(".prototype.");
#line 22 "MethodTemplate.cshtml"
                             Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" = function (");
#line 22 "MethodTemplate.cshtml"
                                                       Write(Model.MethodParameterDeclarationWithCallback);

#line default
#line hidden
            WriteLiteral(") {\r\n  var client = ");
#line 23 "MethodTemplate.cshtml"
           Write(Model.ClientReference);

#line default
#line hidden
            WriteLiteral(";\r\n  if(!callback && typeof options === \'function\') {\r\n    callback = options;\r\n " +
"   options = null;\r\n  }\r\n  if (!callback) {\r\n    throw new Error(\'callback canno" +
"t be null.\');\r\n  }\r\n");
#line 31 "MethodTemplate.cshtml"
  

#line default
#line hidden

#line 31 "MethodTemplate.cshtml"
   if (Model.ParameterTemplateModels.Any())
  {

#line default
#line hidden

            WriteLiteral("  // Validate\r\n  try {\r\n");
#line 35 "MethodTemplate.cshtml"
  

#line default
#line hidden

#line 35 "MethodTemplate.cshtml"
   foreach (var parameter in Model.ParameterTemplateModels)
  {
    if (parameter.IsRequired)
    {

#line default
#line hidden

            WriteLiteral("    if (");
#line 39 "MethodTemplate.cshtml"
      Write(parameter.Name);

#line default
#line hidden
            WriteLiteral(" === null || ");
#line 39 "MethodTemplate.cshtml"
                                    Write(parameter.Name);

#line default
#line hidden
            WriteLiteral(" === undefined) {\r\n      throw new Error(\'\\\'");
#line 40 "MethodTemplate.cshtml"
                       Write(parameter.Name);

#line default
#line hidden
            WriteLiteral("\\\' cannot be null\');\r\n    }\r\n   \r\n");
#line 43 "MethodTemplate.cshtml"
    }
      if (!(Model.HttpMethod == HttpMethod.Patch  && parameter.Type is CompositeType))
    {

#line default
#line hidden

            WriteLiteral("    ");
#line 46 "MethodTemplate.cshtml"
  Write(parameter.Type.ValidateType(Model.Scope, parameter.Name));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 47 "MethodTemplate.cshtml"
    }
  }

#line default
#line hidden

#line 48 "MethodTemplate.cshtml"
   

#line default
#line hidden

            WriteLiteral("  } catch (error) {\r\n    return callback(error);\r\n  }\r\n");
#line 52 "MethodTemplate.cshtml"
  }

#line default
#line hidden

            WriteLiteral("  ");
#line 53 "MethodTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n  // Construct URL\r\n");
#line 55 "MethodTemplate.cshtml"
  

#line default
#line hidden

#line 55 "MethodTemplate.cshtml"
   if (Model.IsAbsoluteUrl)
  {

#line default
#line hidden

            WriteLiteral("  var requestUrl = \'");
#line 57 "MethodTemplate.cshtml"
                  Write(Model.Url);

#line default
#line hidden
            WriteLiteral("\';\r\n");
#line 58 "MethodTemplate.cshtml"
  }
  else
  {

#line default
#line hidden

            WriteLiteral("  var requestUrl = ");
#line 61 "MethodTemplate.cshtml"
                 Write(Model.ClientReference);

#line default
#line hidden
            WriteLiteral(".baseUri + \r\n                   \'/");
#line 62 "MethodTemplate.cshtml"
                   Write(Model.Url);

#line default
#line hidden
            WriteLiteral("\';\r\n");
#line 63 "MethodTemplate.cshtml"
  }

#line default
#line hidden

            WriteLiteral("  ");
#line 64 "MethodTemplate.cshtml"
Write(Model.BuildUrl("requestUrl"));

#line default
#line hidden
            WriteLiteral("\r\n  ");
#line 65 "MethodTemplate.cshtml"
Write(Model.RemoveDuplicateForwardSlashes("requestUrl"));

#line default
#line hidden
            WriteLiteral("\r\n  ");
#line 66 "MethodTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n  // Create HTTP transport objects\r\n  var httpRequest = new WebResource();\r\n  h" +
"ttpRequest.method = \'");
#line 69 "MethodTemplate.cshtml"
                    Write(Model.HttpMethod.ToString().ToUpper());

#line default
#line hidden
            WriteLiteral("\';\r\n  httpRequest.headers = {};\r\n  httpRequest.url = requestUrl;\r\n\r\n  // Set Head" +
"ers\r\n  ");
#line 74 "MethodTemplate.cshtml"
Write(Model.SetDefaultHeaders);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 75 "MethodTemplate.cshtml"
  

#line default
#line hidden

#line 75 "MethodTemplate.cshtml"
   foreach (var parameter in Model.Parameters.Where(p => p.Location == ParameterLocation.Header))
  {

#line default
#line hidden

            WriteLiteral("  if (");
#line 77 "MethodTemplate.cshtml"
    Write(parameter.Name);

#line default
#line hidden
            WriteLiteral(" !== null) {\r\n    httpRequest.headers[\'");
#line 78 "MethodTemplate.cshtml"
                       Write(parameter.SerializedName);

#line default
#line hidden
            WriteLiteral("\'] = ");
#line 78 "MethodTemplate.cshtml"
                                                      Write(parameter.Type.ToString(parameter.Name));

#line default
#line hidden
            WriteLiteral(";\r\n  }\r\n");
#line 80 "MethodTemplate.cshtml"
  }

#line default
#line hidden

            WriteLiteral(@"  if(options) {
    for(var headerName in options['customHeaders']) {
      if (options['customHeaders'].hasOwnProperty(headerName)) {
        httpRequest.headers[headerName] = options['customHeaders'][headerName];
      }
    }
  }
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';

");
#line 90 "MethodTemplate.cshtml"
  

#line default
#line hidden

#line 90 "MethodTemplate.cshtml"
   if (Model.RequestBody != null)
  {

#line default
#line hidden

            WriteLiteral("  \r\n  // Serialize Request\r\n  var requestContent = null;\r\n  requestContent = JSON" +
".stringify(msRest.serializeObject(");
#line 95 "MethodTemplate.cshtml"
                                                     Write(Model.RequestBody.Name);

#line default
#line hidden
            WriteLiteral("));\r\n  httpRequest.body = requestContent;\r\n  httpRequest.headers[\'Content-Length\'" +
"] = Buffer.isBuffer(requestContent) ? requestContent.length : Buffer.byteLength(" +
"requestContent, \'UTF8\');\r\n  \r\n");
#line 99 "MethodTemplate.cshtml"
  }
  else
  {

#line default
#line hidden

            WriteLiteral("  \r\n  httpRequest.body = null;\r\n  httpRequest.headers[\'Content-Length\'] = 0;\r\n  \r" +
"\n");
#line 106 "MethodTemplate.cshtml"
  }

#line default
#line hidden

            WriteLiteral("\r\n");
#line 108 "MethodTemplate.cshtml"
  

#line default
#line hidden

#line 108 "MethodTemplate.cshtml"
   if (Model.Responses.Any(r => r.Value == PrimaryType.Stream))
  {

#line default
#line hidden

            WriteLiteral("  ");
#line 110 "MethodTemplate.cshtml"
Write(Include(new MethodStreamPipelineTemplate(), Model));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 111 "MethodTemplate.cshtml"
  }
  else
  {

#line default
#line hidden

            WriteLiteral("  ");
#line 114 "MethodTemplate.cshtml"
Write(Include(new MethodJsonPipelineTemplate(), Model));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 115 "MethodTemplate.cshtml"
  }

#line default
#line hidden

            WriteLiteral("};\r\n");
        }
        #pragma warning restore 1998
    }
}
