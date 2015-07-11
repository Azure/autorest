// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest.Generator.NodeJS.Templates
{
#line 1 "MethodJsonPipelineTemplate.cshtml"
using System.Linq;

#line default
#line hidden
#line 2 "MethodJsonPipelineTemplate.cshtml"
using Microsoft.Rest.Generator.ClientModel

#line default
#line hidden
    ;
#line 3 "MethodJsonPipelineTemplate.cshtml"
using Microsoft.Rest.Generator.NodeJS

#line default
#line hidden
    ;
#line 4 "MethodJsonPipelineTemplate.cshtml"
using Microsoft.Rest.Generator.NodeJS.TemplateModels

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class MethodJsonPipelineTemplate : Microsoft.Rest.Generator.Template<Microsoft.Rest.Generator.NodeJS.MethodTemplateModel>
    {
        #line hidden
        public MethodJsonPipelineTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
            WriteLiteral("// Send Request\r\nreturn client.pipeline(httpRequest, function (err, response, res" +
"ponseBody) {\r\n  if (err) {\r\n    return callback(err);\r\n  }\r\n  var statusCode = r" +
"esponse.statusCode;\r\n  if (");
#line 12 "MethodJsonPipelineTemplate.cshtml"
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
#line 22 "MethodJsonPipelineTemplate.cshtml"
  

#line default
#line hidden

#line 22 "MethodJsonPipelineTemplate.cshtml"
   if (Model.DefaultResponse != null)
  {
      var deserializeErrorBody = Model.GetDeserializationString(Model.DefaultResponse, "error.body");
      if (!string.IsNullOrWhiteSpace(deserializeErrorBody))
      {

#line default
#line hidden

            WriteLiteral("      if (error.body !== null && error.body !== undefined) {\r\n        ");
#line 28 "MethodJsonPipelineTemplate.cshtml"
      Write(deserializeErrorBody);

#line default
#line hidden
            WriteLiteral("\r\n      }\r\n");
#line 30 "MethodJsonPipelineTemplate.cshtml"
      }
  }

#line default
#line hidden

            WriteLiteral(@"    } catch (defaultError) {
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
#line 44 "MethodJsonPipelineTemplate.cshtml"
Write(Model.InitializeResponseBody);

#line default
#line hidden
            WriteLiteral("\r\n\r\n");
#line 46 "MethodJsonPipelineTemplate.cshtml"
  

#line default
#line hidden

#line 46 "MethodJsonPipelineTemplate.cshtml"
   foreach (var responsePair in Model.Responses.Where(r => r.Value != null))
  {

#line default
#line hidden

            WriteLiteral("      \r\n  // Deserialize Response\r\n  if (statusCode === ");
#line 50 "MethodJsonPipelineTemplate.cshtml"
                Write(MethodTemplateModel.GetStatusCodeReference(responsePair.Key));

#line default
#line hidden
            WriteLiteral(") {\r\n    var parsedResponse;\r\n    try {\r\n      parsedResponse = JSON.parse(respon" +
"seBody);\r\n      result.body = parsedResponse;\r\n");
#line 55 "MethodJsonPipelineTemplate.cshtml"
  

#line default
#line hidden

#line 55 "MethodJsonPipelineTemplate.cshtml"
    
      var deserializeBody = Model.GetDeserializationString(Model.ReturnType);
      if (!string.IsNullOrWhiteSpace(deserializeBody))
      {

#line default
#line hidden

            WriteLiteral("      if (result.body !== null && result.body !== undefined) {\r\n        ");
#line 60 "MethodJsonPipelineTemplate.cshtml"
      Write(deserializeBody);

#line default
#line hidden
            WriteLiteral("\r\n      }\r\n");
#line 62 "MethodJsonPipelineTemplate.cshtml"
      }
          

#line default
#line hidden

            WriteLiteral("\r\n    } catch (error) {\r\n      ");
#line 65 "MethodJsonPipelineTemplate.cshtml"
  Write(Model.DeserializationError);

#line default
#line hidden
            WriteLiteral("\r\n    }\r\n  }\r\n      \r\n");
#line 69 "MethodJsonPipelineTemplate.cshtml"
  }

#line default
#line hidden

            WriteLiteral("  ");
#line 70 "MethodJsonPipelineTemplate.cshtml"
   if (Model.ReturnType != null && Model.DefaultResponse != null && !Model.Responses.Any())
  {

#line default
#line hidden

            WriteLiteral("  var parsedResponse;\r\n  try {\r\n    parsedResponse = JSON.parse(responseBody);\r\n " +
"   result.body = parsedResponse;\r\n");
#line 76 "MethodJsonPipelineTemplate.cshtml"
    var deserializeBody = Model.GetDeserializationString(Model.DefaultResponse);
    if (!string.IsNullOrWhiteSpace(deserializeBody))
    {

#line default
#line hidden

            WriteLiteral("    if (result.body !== null && result.body !== undefined) {\r\n      ");
#line 80 "MethodJsonPipelineTemplate.cshtml"
    Write(deserializeBody);

#line default
#line hidden
            WriteLiteral("\r\n    }\r\n");
#line 82 "MethodJsonPipelineTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("  } catch (error) {\r\n");
#line 84 "MethodJsonPipelineTemplate.cshtml"
Write(Model.DeserializationError);

#line default
#line hidden
            WriteLiteral("\r\n}\r\n");
#line 86 "MethodJsonPipelineTemplate.cshtml"
  }

#line default
#line hidden

            WriteLiteral("  ");
#line 87 "MethodJsonPipelineTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n\r\n  return callback(null, result);\r\n});");
        }
        #pragma warning restore 1998
    }
}
