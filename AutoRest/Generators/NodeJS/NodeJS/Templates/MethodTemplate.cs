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
            WriteLiteral("/**\n");
#line 7 "MethodTemplate.cshtml"
Write(WrapComment(" * ", Model.Documentation));

#line default
#line hidden
            WriteLiteral("\n");
#line 8 "MethodTemplate.cshtml"
 foreach (var parameter in Model.DocumentationParameters)
{

#line default
#line hidden

            WriteLiteral(" * @param {");
#line 10 "MethodTemplate.cshtml"
         Write(parameter.Type.Name);

#line default
#line hidden
            WriteLiteral("} [");
#line 10 "MethodTemplate.cshtml"
                                Write(parameter.Name);

#line default
#line hidden
            WriteLiteral("] ");
#line 10 "MethodTemplate.cshtml"
                                                 Write(parameter.Documentation);

#line default
#line hidden
            WriteLiteral("\n *\n");
#line 12 "MethodTemplate.cshtml"
}

#line default
#line hidden

#line 13 "MethodTemplate.cshtml"
Write(WrapComment(" * ",  " @param {function} callback"));

#line default
#line hidden
            WriteLiteral("\n *\n");
#line 15 "MethodTemplate.cshtml"
Write(WrapComment(" * ",  " @returns {Stream} The Response stream"));

#line default
#line hidden
            WriteLiteral("\n */\n");
#line 17 "MethodTemplate.cshtml"
Write(Model.OperationName);

#line default
#line hidden
            WriteLiteral(".prototype.");
#line 17 "MethodTemplate.cshtml"
                             Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" = function (");
#line 17 "MethodTemplate.cshtml"
                                                       Write(Model.MethodParameterDeclarationWithCallback);

#line default
#line hidden
            WriteLiteral(") {\n  var client = ");
#line 18 "MethodTemplate.cshtml"
           Write(Model.ClientReference);

#line default
#line hidden
            WriteLiteral(";\n  if (!callback) {\n    throw new Error(\'callback cannot be null.\');\n  }\n");
#line 22 "MethodTemplate.cshtml"
  

#line default
#line hidden

#line 22 "MethodTemplate.cshtml"
   if (Model.LocalParameters.Any())
  {

#line default
#line hidden

            WriteLiteral("  // Validate\n  try {\n");
#line 26 "MethodTemplate.cshtml"
  

#line default
#line hidden

#line 26 "MethodTemplate.cshtml"
   foreach (var parameter in Model.LocalParameters)
  {
    if (parameter.IsRequired)
    {

#line default
#line hidden

            WriteLiteral("    if (");
#line 30 "MethodTemplate.cshtml"
      Write(parameter.Name);

#line default
#line hidden
            WriteLiteral(" === null || ");
#line 30 "MethodTemplate.cshtml"
                                    Write(parameter.Name);

#line default
#line hidden
            WriteLiteral(" === undefined) {\n      throw new Error(\'\\\'");
#line 31 "MethodTemplate.cshtml"
                       Write(parameter.Name);

#line default
#line hidden
            WriteLiteral("\\\' cannot be null\');\n    }\n   \n");
#line 34 "MethodTemplate.cshtml"
    }
      if (!(Model.HttpMethod == HttpMethod.Patch  && parameter.Type is CompositeType))
    {

#line default
#line hidden

            WriteLiteral("    ");
#line 37 "MethodTemplate.cshtml"
  Write(parameter.Type.ValidateType(Model.Scope, parameter.Name));

#line default
#line hidden
            WriteLiteral("\n");
#line 38 "MethodTemplate.cshtml"
    }
  }

#line default
#line hidden

#line 39 "MethodTemplate.cshtml"
   

#line default
#line hidden

            WriteLiteral("  } catch (error) {\n    return callback(error);\n  }\n");
#line 43 "MethodTemplate.cshtml"
  }

#line default
#line hidden

            WriteLiteral("  ");
#line 44 "MethodTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\n  // Construct URL\n");
#line 46 "MethodTemplate.cshtml"
  

#line default
#line hidden

#line 46 "MethodTemplate.cshtml"
   if (Model.IsAbsoluteUrl)
  {

#line default
#line hidden

            WriteLiteral("  var requestUrl = \'");
#line 48 "MethodTemplate.cshtml"
                  Write(Model.Url);

#line default
#line hidden
            WriteLiteral("\';\n");
#line 49 "MethodTemplate.cshtml"
  }
  else
  {

#line default
#line hidden

            WriteLiteral("  var requestUrl = ");
#line 52 "MethodTemplate.cshtml"
                 Write(Model.ClientReference);

#line default
#line hidden
            WriteLiteral(".baseUri + \n                   \'/");
#line 53 "MethodTemplate.cshtml"
                   Write(Model.Url);

#line default
#line hidden
            WriteLiteral("\';\n");
#line 54 "MethodTemplate.cshtml"
  }

#line default
#line hidden

            WriteLiteral("  ");
#line 55 "MethodTemplate.cshtml"
Write(Model.BuildUrl("requestUrl"));

#line default
#line hidden
            WriteLiteral("\n  ");
#line 56 "MethodTemplate.cshtml"
Write(Model.RemoveDuplicateForwardSlashes("requestUrl"));

#line default
#line hidden
            WriteLiteral("\n  ");
#line 57 "MethodTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\n  // Create HTTP transport objects\n  var httpRequest = new WebResource();\n  http" +
"Request.method = \'");
#line 60 "MethodTemplate.cshtml"
                    Write(Model.HttpMethod.ToString().ToUpper());

#line default
#line hidden
            WriteLiteral("\';\n  httpRequest.headers = {};\n  httpRequest.url = requestUrl;\n\n  // Set Headers\n" +
"");
#line 65 "MethodTemplate.cshtml"
  

#line default
#line hidden

#line 65 "MethodTemplate.cshtml"
   foreach (var parameter in Model.Parameters.Where(p => p.Location == ParameterLocation.Header))
  {

#line default
#line hidden

            WriteLiteral("  if (");
#line 67 "MethodTemplate.cshtml"
    Write(parameter.Name);

#line default
#line hidden
            WriteLiteral(" !== null) {\n    httpRequest.headers[\'");
#line 68 "MethodTemplate.cshtml"
                       Write(parameter.SerializedName);

#line default
#line hidden
            WriteLiteral("\'] = ");
#line 68 "MethodTemplate.cshtml"
                                                      Write(parameter.Type.ToString(parameter.Name));

#line default
#line hidden
            WriteLiteral(";\n  }\n");
#line 70 "MethodTemplate.cshtml"
  }

#line default
#line hidden

            WriteLiteral("  httpRequest.headers[\'Content-Type\'] = \'application/json; charset=utf-8\';\n\n");
#line 73 "MethodTemplate.cshtml"
  

#line default
#line hidden

#line 73 "MethodTemplate.cshtml"
   if (Model.RequestBody != null)
  {

#line default
#line hidden

            WriteLiteral("  \n  // Serialize Request\n  var requestContent = null;\n  requestContent = JSON.st" +
"ringify(msRest.serializeObject(");
#line 78 "MethodTemplate.cshtml"
                                                     Write(Model.RequestBody.Name);

#line default
#line hidden
            WriteLiteral("));\n  httpRequest.body = requestContent;\n  httpRequest.headers[\'Content-Length\'] " +
"= Buffer.isBuffer(requestContent) ? requestContent.length : Buffer.byteLength(re" +
"questContent, \'UTF8\');\n  \n");
#line 82 "MethodTemplate.cshtml"
  }
  else
  {

#line default
#line hidden

            WriteLiteral("  \n  httpRequest.body = null;\n  httpRequest.headers[\'Content-Length\'] = 0;\n  \n");
#line 89 "MethodTemplate.cshtml"
  }

#line default
#line hidden

            WriteLiteral("  // Send Request\n  return client.pipeline(httpRequest, function (err, response, " +
"responseBody) {\n    if (err) {\n      return callback(err);\n    }\n    var statusC" +
"ode = response.statusCode;\n    if (");
#line 96 "MethodTemplate.cshtml"
    Write(Model.FailureStatusCodePredicate);

#line default
#line hidden
            WriteLiteral(@") {
      var error = new Error(responseBody);
      error.statusCode = response.statusCode;
      error.request = httpRequest;
      error.response = response;
      if (responseBody === '') responseBody = null;
      var parsedErrorResponse;
      try {
        parsedErrorResponse = JSON.parse(responseBody);
        error.body = parsedErrorResponse;
");
#line 106 "MethodTemplate.cshtml"
            

#line default
#line hidden

#line 106 "MethodTemplate.cshtml"
             if (Model.DefaultResponse != null) {
            var deserializeErrorBody = Model.GetDeserializationString(Model.DefaultResponse, "error.body");
            if (!string.IsNullOrWhiteSpace(deserializeErrorBody))
            {

#line default
#line hidden

            WriteLiteral("          if (error.body !== null && error.body !== undefined) {\n            ");
#line 111 "MethodTemplate.cshtml"
          Write(deserializeErrorBody);

#line default
#line hidden
            WriteLiteral("\n          }\n");
#line 113 "MethodTemplate.cshtml"
            }
            }

#line default
#line hidden

            WriteLiteral(@"      } catch (defaultError) {
        error.message = util.format('Error ""%s"" occurred in deserializing the responseBody - ""%s"" for the default response.', defaultError, responseBody);
        return callback(error);
      }
      return callback(error);
    }

    // Create Result
    var result = new msRest.HttpOperationResponse();
    result.request = httpRequest;
    result.response = response;
    if (responseBody === '') responseBody = null;
    ");
#line 127 "MethodTemplate.cshtml"
Write(Model.InitializeResponseBody);

#line default
#line hidden
            WriteLiteral("\n\n");
#line 129 "MethodTemplate.cshtml"
    

#line default
#line hidden

#line 129 "MethodTemplate.cshtml"
     foreach (var responsePair in Model.Responses.Where(r => r.Value != null))
    {

#line default
#line hidden

            WriteLiteral("     \n    // Deserialize Response\n    if (statusCode === ");
#line 133 "MethodTemplate.cshtml"
                  Write(MethodTemplateModel.GetStatusCodeReference(responsePair.Key));

#line default
#line hidden
            WriteLiteral(") {\n      var parsedResponse;\n      try {\n        parsedResponse = JSON.parse(res" +
"ponseBody);\n        result.body = parsedResponse;\n");
#line 138 "MethodTemplate.cshtml"
        

#line default
#line hidden

#line 138 "MethodTemplate.cshtml"
          
          var deserializeBody = Model.GetDeserializationString(Model.ReturnType);
          if (!string.IsNullOrWhiteSpace(deserializeBody))
          {

#line default
#line hidden

            WriteLiteral("        if (result.body !== null && result.body !== undefined) {\n          ");
#line 143 "MethodTemplate.cshtml"
        Write(deserializeBody);

#line default
#line hidden
            WriteLiteral("\n        }\n");
#line 145 "MethodTemplate.cshtml"
          }
        

#line default
#line hidden

            WriteLiteral("\n      } catch (error) {\n        ");
#line 148 "MethodTemplate.cshtml"
    Write(Model.DeserializationError);

#line default
#line hidden
            WriteLiteral("\n      }\n    }\n    \n");
#line 152 "MethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("    ");
#line 153 "MethodTemplate.cshtml"
     if (Model.ReturnType != null && Model.DefaultResponse != null && !Model.Responses.Any())
    {

#line default
#line hidden

            WriteLiteral("      var parsedResponse;\n      try {\n        parsedResponse = JSON.parse(respons" +
"eBody);\n        result.body = parsedResponse;\n");
#line 159 "MethodTemplate.cshtml"
        var deserializeBody = Model.GetDeserializationString(Model.DefaultResponse);
        if (!string.IsNullOrWhiteSpace(deserializeBody))
        {

#line default
#line hidden

            WriteLiteral("        if (result.body !== null && result.body !== undefined) {\n          ");
#line 163 "MethodTemplate.cshtml"
        Write(deserializeBody);

#line default
#line hidden
            WriteLiteral("\n        }\n");
#line 165 "MethodTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("      } catch (error) {\n        ");
#line 167 "MethodTemplate.cshtml"
      Write(Model.DeserializationError);

#line default
#line hidden
            WriteLiteral("\n      }\n");
#line 169 "MethodTemplate.cshtml"
    }

#line default
#line hidden

#line 170 "MethodTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\n    return callback(null, result);\n  });\n};\n");
        }
        #pragma warning restore 1998
    }
}
