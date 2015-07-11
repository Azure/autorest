// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest.Generator.NodeJS.Templates
{
#line 1 "MethodStreamPipelineTemplate.cshtml"
using System.Linq;

#line default
#line hidden
#line 2 "MethodStreamPipelineTemplate.cshtml"
using Microsoft.Rest.Generator.ClientModel

#line default
#line hidden
    ;
#line 3 "MethodStreamPipelineTemplate.cshtml"
using Microsoft.Rest.Generator.NodeJS

#line default
#line hidden
    ;
#line 4 "MethodStreamPipelineTemplate.cshtml"
using Microsoft.Rest.Generator.NodeJS.TemplateModels

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class MethodStreamPipelineTemplate : Microsoft.Rest.Generator.Template<Microsoft.Rest.Generator.NodeJS.MethodTemplateModel>
    {
        #line hidden
        public MethodStreamPipelineTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
            WriteLiteral("// Send Request\r\nhttpRequest.streamedResponse = true;\r\nreturn client.pipeline(htt" +
"pRequest, function (err, response) {\r\n  if (err) {\r\n    return callback(err);\r\n " +
" }\r\n");
#line 12 "MethodStreamPipelineTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n\r\n  var statusCode = response.statusCode;\r\n  if (");
#line 15 "MethodStreamPipelineTemplate.cshtml"
  Write(Model.FailureStatusCodePredicate);

#line default
#line hidden
            WriteLiteral(") {\r\n    var error = new Error(util.format(\'Unexpected status code: %s\', statusCo" +
"de));\r\n    error.statusCode = response.statusCode;\r\n    error.request = httpRequ" +
"est;\r\n    error.response = response;\r\n    return callback(error);\r\n  }\r\n");
#line 22 "MethodStreamPipelineTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n\r\n  // Create Result\r\n  var result = new msRest.HttpOperationResponse();\r\n  res" +
"ult.request = httpRequest;\r\n  result.response = response;\r\n  result.body = respo" +
"nse;\r\n  return callback(null, result);\r\n});");
        }
        #pragma warning restore 1998
    }
}
