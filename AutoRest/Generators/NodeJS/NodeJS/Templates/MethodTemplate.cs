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
            WriteLiteral("/**\r\n");
#line 7 "MethodTemplate.cshtml"
Write(WrapComment(" * ", Model.Documentation));

#line default
#line hidden
            WriteLiteral("\r\n");
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
            WriteLiteral("\r\n *\r\n");
#line 12 "MethodTemplate.cshtml"
}

#line default
#line hidden

#line 13 "MethodTemplate.cshtml"
Write(WrapComment(" * ", " @param {object} [options]"));

#line default
#line hidden
            WriteLiteral("\r\n *\r\n");
#line 15 "MethodTemplate.cshtml"
Write(WrapComment(" * ", " @param {object} [options.customHeaders] headers that will be added to request"));

#line default
#line hidden
            WriteLiteral("\r\n *\r\n");
#line 17 "MethodTemplate.cshtml"
Write(WrapComment(" * ",  " @param {function} callback"));

#line default
#line hidden
            WriteLiteral("\r\n *\r\n");
#line 19 "MethodTemplate.cshtml"
Write(WrapComment(" * ",  " @returns {Stream} The Response stream"));

#line default
#line hidden
            WriteLiteral("\r\n */\r\n");
#line 21 "MethodTemplate.cshtml"
Write(Model.OperationName);

#line default
#line hidden
            WriteLiteral(".prototype.");
#line 21 "MethodTemplate.cshtml"
                             Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" = function (");
#line 21 "MethodTemplate.cshtml"
                                                       Write(Model.MethodParameterDeclarationWithCallback);

#line default
#line hidden
            WriteLiteral(") {\r\n  var client = ");
#line 22 "MethodTemplate.cshtml"
           Write(Model.ClientReference);

#line default
#line hidden
            WriteLiteral(";\r\n  if(!callback && typeof options === \'function\') {\r\n    callback = options;\r\n " +
"   options = null;\r\n  }\r\n  if (!callback) {\r\n    throw new Error(\'callback canno" +
"t be null.\');\r\n  }\r\n");
#line 30 "MethodTemplate.cshtml"
  

#line default
#line hidden

#line 30 "MethodTemplate.cshtml"
   if (Model.LocalParameters.Any())
  {

#line default
#line hidden

            WriteLiteral("  // Validate\r\n  try {\r\n");
#line 34 "MethodTemplate.cshtml"
  

#line default
#line hidden

#line 34 "MethodTemplate.cshtml"
   foreach (var parameter in Model.LocalParameters)
  {
    if (parameter.IsRequired)
    {

#line default
#line hidden

            WriteLiteral("    if (");
#line 38 "MethodTemplate.cshtml"
      Write(parameter.Name);

#line default
#line hidden
            WriteLiteral(" === null || ");
#line 38 "MethodTemplate.cshtml"
                                    Write(parameter.Name);

#line default
#line hidden
            WriteLiteral(" === undefined) {\r\n      throw new Error(\'\\\'");
#line 39 "MethodTemplate.cshtml"
                       Write(parameter.Name);

#line default
#line hidden
            WriteLiteral("\\\' cannot be null\');\r\n    }\r\n   \r\n");
#line 42 "MethodTemplate.cshtml"
    }
      if (!(Model.HttpMethod == HttpMethod.Patch  && parameter.Type is CompositeType))
    {

#line default
#line hidden

            WriteLiteral("    ");
#line 45 "MethodTemplate.cshtml"
  Write(parameter.Type.ValidateType(Model.Scope, parameter.Name));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 46 "MethodTemplate.cshtml"
    }
  }

#line default
#line hidden

#line 47 "MethodTemplate.cshtml"
   

#line default
#line hidden

            WriteLiteral("  } catch (error) {\r\n    return callback(error);\r\n  }\r\n");
#line 51 "MethodTemplate.cshtml"
  }

#line default
#line hidden

            WriteLiteral("  ");
#line 52 "MethodTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n  // Construct URL\r\n");
#line 54 "MethodTemplate.cshtml"
  

#line default
#line hidden

#line 54 "MethodTemplate.cshtml"
   if (Model.IsAbsoluteUrl)
  {

#line default
#line hidden

            WriteLiteral("  var requestUrl = \'");
#line 56 "MethodTemplate.cshtml"
                  Write(Model.Url);

#line default
#line hidden
            WriteLiteral("\';\r\n");
#line 57 "MethodTemplate.cshtml"
  }
  else
  {

#line default
#line hidden

            WriteLiteral("  var requestUrl = ");
#line 60 "MethodTemplate.cshtml"
                 Write(Model.ClientReference);

#line default
#line hidden
            WriteLiteral(".baseUri + \r\n                   \'/");
#line 61 "MethodTemplate.cshtml"
                   Write(Model.Url);

#line default
#line hidden
            WriteLiteral("\';\r\n");
#line 62 "MethodTemplate.cshtml"
  }

#line default
#line hidden

            WriteLiteral("  ");
#line 63 "MethodTemplate.cshtml"
Write(Model.BuildUrl("requestUrl"));

#line default
#line hidden
            WriteLiteral("\r\n  ");
#line 64 "MethodTemplate.cshtml"
Write(Model.RemoveDuplicateForwardSlashes("requestUrl"));

#line default
#line hidden
            WriteLiteral("\r\n  ");
#line 65 "MethodTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n  // Create HTTP transport objects\r\n  var httpRequest = new WebResource();\r\n  h" +
"ttpRequest.method = \'");
#line 68 "MethodTemplate.cshtml"
                    Write(Model.HttpMethod.ToString().ToUpper());

#line default
#line hidden
            WriteLiteral("\';\r\n  httpRequest.headers = {};\r\n  httpRequest.url = requestUrl;\r\n\r\n  // Set Head" +
"ers\r\n");
#line 73 "MethodTemplate.cshtml"
  

#line default
#line hidden

#line 73 "MethodTemplate.cshtml"
   foreach (var parameter in Model.Parameters.Where(p => p.Location == ParameterLocation.Header))
  {

#line default
#line hidden

            WriteLiteral("  if (");
#line 75 "MethodTemplate.cshtml"
    Write(parameter.Name);

#line default
#line hidden
            WriteLiteral(" !== null) {\r\n    httpRequest.headers[\'");
#line 76 "MethodTemplate.cshtml"
                       Write(parameter.SerializedName);

#line default
#line hidden
            WriteLiteral("\'] = ");
#line 76 "MethodTemplate.cshtml"
                                                      Write(parameter.Type.ToString(parameter.Name));

#line default
#line hidden
            WriteLiteral(";\r\n  }\r\n");
#line 78 "MethodTemplate.cshtml"
  }

#line default
#line hidden

            WriteLiteral("  httpRequest.headers[\'Content-Type\'] = \'application/json; charset=utf-8\';\r\n");
#line 80 "MethodTemplate.cshtml"
  

#line default
#line hidden

#line 80 "MethodTemplate.cshtml"
   if (Model.RequestBody != null)
  {

#line default
#line hidden

            WriteLiteral("  \r\n  // Serialize Request\r\n  var requestContent = null;\r\n  requestContent = JSON" +
".stringify(msRest.serializeObject(");
#line 85 "MethodTemplate.cshtml"
                                                     Write(Model.RequestBody.Name);

#line default
#line hidden
            WriteLiteral("));\r\n  httpRequest.body = requestContent;\r\n  httpRequest.headers[\'Content-Length\'" +
"] = Buffer.isBuffer(requestContent) ? requestContent.length : Buffer.byteLength(" +
"requestContent, \'UTF8\');\r\n  \r\n");
#line 89 "MethodTemplate.cshtml"
  }
  else
  {

#line default
#line hidden

            WriteLiteral("  \r\n  httpRequest.body = null;\r\n  httpRequest.headers[\'Content-Length\'] = 0;\r\n  \r" +
"\n");
#line 96 "MethodTemplate.cshtml"
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
  // Send Request
  return client.pipeline(httpRequest, function (err, response, responseBody) {
    if (err) {
      return callback(err);
    }
    var statusCode = response.statusCode;
    if (");
#line 110 "MethodTemplate.cshtml"
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
#line 120 "MethodTemplate.cshtml"
            

#line default
#line hidden

#line 120 "MethodTemplate.cshtml"
             if (Model.DefaultResponse != null) {
            var deserializeErrorBody = Model.GetDeserializationString(Model.DefaultResponse, "error.body");
            if (!string.IsNullOrWhiteSpace(deserializeErrorBody))
            {

#line default
#line hidden

            WriteLiteral("          if (error.body !== null && error.body !== undefined) {\r\n            ");
#line 125 "MethodTemplate.cshtml"
          Write(deserializeErrorBody);

#line default
#line hidden
            WriteLiteral("\r\n          }\r\n");
#line 127 "MethodTemplate.cshtml"
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
#line 141 "MethodTemplate.cshtml"
Write(Model.InitializeResponseBody);

#line default
#line hidden
            WriteLiteral("\r\n\r\n");
#line 143 "MethodTemplate.cshtml"
    

#line default
#line hidden

#line 143 "MethodTemplate.cshtml"
     foreach (var responsePair in Model.Responses.Where(r => r.Value != null))
    {

#line default
#line hidden

            WriteLiteral("     \r\n    // Deserialize Response\r\n    if (statusCode === ");
#line 147 "MethodTemplate.cshtml"
                  Write(MethodTemplateModel.GetStatusCodeReference(responsePair.Key));

#line default
#line hidden
            WriteLiteral(") {\r\n      var parsedResponse;\r\n      try {\r\n        parsedResponse = JSON.parse(" +
"responseBody);\r\n        result.body = parsedResponse;\r\n");
#line 152 "MethodTemplate.cshtml"
        

#line default
#line hidden

#line 152 "MethodTemplate.cshtml"
          
          var deserializeBody = Model.GetDeserializationString(Model.ReturnType);
          if (!string.IsNullOrWhiteSpace(deserializeBody))
          {

#line default
#line hidden

            WriteLiteral("        if (result.body !== null && result.body !== undefined) {\r\n          ");
#line 157 "MethodTemplate.cshtml"
        Write(deserializeBody);

#line default
#line hidden
            WriteLiteral("\r\n        }\r\n");
#line 159 "MethodTemplate.cshtml"
          }
        

#line default
#line hidden

            WriteLiteral("\r\n      } catch (error) {\r\n        ");
#line 162 "MethodTemplate.cshtml"
    Write(Model.DeserializationError);

#line default
#line hidden
            WriteLiteral("\r\n      }\r\n    }\r\n    \r\n");
#line 166 "MethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("    ");
#line 167 "MethodTemplate.cshtml"
     if (Model.ReturnType != null && Model.DefaultResponse != null && !Model.Responses.Any())
    {

#line default
#line hidden

            WriteLiteral("      var parsedResponse;\r\n      try {\r\n        parsedResponse = JSON.parse(respo" +
"nseBody);\r\n        result.body = parsedResponse;\r\n");
#line 173 "MethodTemplate.cshtml"
        var deserializeBody = Model.GetDeserializationString(Model.DefaultResponse);
        if (!string.IsNullOrWhiteSpace(deserializeBody))
        {

#line default
#line hidden

            WriteLiteral("        if (result.body !== null && result.body !== undefined) {\r\n          ");
#line 177 "MethodTemplate.cshtml"
        Write(deserializeBody);

#line default
#line hidden
            WriteLiteral("\r\n        }\r\n");
#line 179 "MethodTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("      } catch (error) {\r\n        ");
#line 181 "MethodTemplate.cshtml"
      Write(Model.DeserializationError);

#line default
#line hidden
            WriteLiteral("\r\n      }\r\n");
#line 183 "MethodTemplate.cshtml"
    }

#line default
#line hidden

#line 184 "MethodTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n    return callback(null, result);\r\n  });\r\n};\r\n");
        }
        #pragma warning restore 1998
    }
}
