// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest.Generator.CSharp.Templates
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
using Microsoft.Rest.Generator.CSharp.TemplateModels

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class MethodTemplate : Microsoft.Rest.Generator.Template<Microsoft.Rest.Generator.CSharp.MethodTemplateModel>
    {
        #line hidden
        public MethodTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
            WriteLiteral("/// <summary>\r\n");
#line 6 "MethodTemplate.cshtml"
Write(WrapComment("/// ", Model.Documentation));

#line default
#line hidden
            WriteLiteral("\r\n/// </summary>\r\n");
#line 8 "MethodTemplate.cshtml"
 foreach (var parameter in Model.LocalParameters)
{

#line default
#line hidden

            WriteLiteral("/// <param name=\'");
#line 10 "MethodTemplate.cshtml"
              Write(parameter.Name);

#line default
#line hidden
            WriteLiteral("\'>\r\n");
#line 11 "MethodTemplate.cshtml"

#line default
#line hidden

#line 11 "MethodTemplate.cshtml"
Write(WrapComment("/// ", parameter.Documentation));

#line default
#line hidden
            WriteLiteral("\r\n/// </param>    \r\n");
#line 13 "MethodTemplate.cshtml"
}

#line default
#line hidden

            WriteLiteral("/// <param name=\'cancellationToken\'>\r\n/// Cancellation token.\r\n/// </param>\r\npubl" +
"ic async Task<");
#line 17 "MethodTemplate.cshtml"
              Write(Model.OperationResponseReturnTypeString);

#line default
#line hidden
            WriteLiteral("> ");
#line 17 "MethodTemplate.cshtml"
                                                          Write(Model.Name);

#line default
#line hidden
            WriteLiteral("WithOperationResponseAsync(");
#line 17 "MethodTemplate.cshtml"
                                                                                                  Write(Model.AsyncMethodParameterDeclaration);

#line default
#line hidden
            WriteLiteral(")\r\n{\r\n");
#line 19 "MethodTemplate.cshtml"
    

#line default
#line hidden

#line 19 "MethodTemplate.cshtml"
     foreach (var parameter in Model.LocalParameters)
    {
        if (parameter.IsRequired)
        {

#line default
#line hidden

            WriteLiteral("    if (");
#line 23 "MethodTemplate.cshtml"
      Write(parameter.Name);

#line default
#line hidden
            WriteLiteral(" == null)\r\n    {\r\n        throw new ArgumentNullException(\"");
#line 25 "MethodTemplate.cshtml"
                                       Write(parameter.Name);

#line default
#line hidden
            WriteLiteral("\");\r\n    }\r\n\r\n");
#line 28 "MethodTemplate.cshtml"
        }
        if(parameter.Location != ParameterLocation.Query &&
            (Model.HttpMethod != HttpMethod.Patch || parameter.Location != ParameterLocation.Body))
        {

#line default
#line hidden

            WriteLiteral("    ");
#line 32 "MethodTemplate.cshtml"
  Write(parameter.Type.ValidateType(Model.Scope, parameter.Name));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 33 "MethodTemplate.cshtml"
        }
    }

#line default
#line hidden

            WriteLiteral(@"    // Tracing
    bool shouldTrace = ServiceClientTracing.IsEnabled;
    string invocationId = null;
    if (shouldTrace)
    {
        invocationId = ServiceClientTracing.NextInvocationId.ToString();
        Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
");
#line 42 "MethodTemplate.cshtml"
    

#line default
#line hidden

#line 42 "MethodTemplate.cshtml"
     foreach (var parameter in Model.LocalParameters)
    {

#line default
#line hidden

            WriteLiteral("        tracingParameters.Add(\"");
#line 44 "MethodTemplate.cshtml"
                             Write(parameter.Name);

#line default
#line hidden
            WriteLiteral("\", ");
#line 44 "MethodTemplate.cshtml"
                                                 Write(parameter.Name);

#line default
#line hidden
            WriteLiteral(");\r\n");
#line 45 "MethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("        tracingParameters.Add(\"cancellationToken\", cancellationToken);\r\n        S" +
"erviceClientTracing.Enter(invocationId, this, \"");
#line 47 "MethodTemplate.cshtml"
                                                    Write(Model.Name);

#line default
#line hidden
            WriteLiteral("\", tracingParameters);\r\n    }\r\n\r\n    // Construct URL\r\n");
#line 51 "MethodTemplate.cshtml"
    

#line default
#line hidden

#line 51 "MethodTemplate.cshtml"
     if (Model.IsAbsoluteUrl)
    {

#line default
#line hidden

            WriteLiteral("    string url = \"");
#line 53 "MethodTemplate.cshtml"
                Write(Model.Url);

#line default
#line hidden
            WriteLiteral("\";       \r\n");
#line 54 "MethodTemplate.cshtml"
    } 
    else 
    {

#line default
#line hidden

            WriteLiteral("    string url = ");
#line 57 "MethodTemplate.cshtml"
               Write(Model.ClientReference);

#line default
#line hidden
            WriteLiteral(".BaseUri.AbsoluteUri + \r\n                 \"/");
#line 58 "MethodTemplate.cshtml"
                 Write(Model.Url);

#line default
#line hidden
            WriteLiteral("\";\r\n");
#line 59 "MethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("    ");
#line 60 "MethodTemplate.cshtml"
Write(Model.BuildUrl("url"));

#line default
#line hidden
            WriteLiteral("\r\n    ");
#line 61 "MethodTemplate.cshtml"
Write(Model.RemoveDuplicateForwardSlashes("url"));

#line default
#line hidden
            WriteLiteral("\r\n    // Create HTTP transport objects\r\n    HttpRequestMessage httpRequest = new " +
"HttpRequestMessage();\r\n    httpRequest.Method = new HttpMethod(\"");
#line 64 "MethodTemplate.cshtml"
                                     Write(Model.HttpMethod.ToString().ToUpper());

#line default
#line hidden
            WriteLiteral("\");\r\n    httpRequest.RequestUri = new Uri(url);\r\n    // Set Headers\r\n");
#line 67 "MethodTemplate.cshtml"
    

#line default
#line hidden

#line 67 "MethodTemplate.cshtml"
     foreach (var parameter in Model.Parameters.Where(p => p.Location == ParameterLocation.Header))
    {

#line default
#line hidden

            WriteLiteral("    if (");
#line 69 "MethodTemplate.cshtml"
      Write(parameter.Name);

#line default
#line hidden
            WriteLiteral(" != null)\r\n    {\r\n        httpRequest.Headers.Add(\"");
#line 71 "MethodTemplate.cshtml"
                               Write(parameter.SerializedName);

#line default
#line hidden
            WriteLiteral("\", ");
#line 71 "MethodTemplate.cshtml"
                                                            Write(parameter.Type.ToString(Model.ClientReference, parameter.Name));

#line default
#line hidden
            WriteLiteral(");\r\n    }\r\n");
#line 73 "MethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("    ");
#line 74 "MethodTemplate.cshtml"
     if (Settings.AddCredentials)
    {

#line default
#line hidden

            WriteLiteral("        \r\n    // Set Credentials\r\n    cancellationToken.ThrowIfCancellationReques" +
"ted();\r\n    await ");
#line 79 "MethodTemplate.cshtml"
      Write(Model.ClientReference);

#line default
#line hidden
            WriteLiteral(".Credentials.ProcessHttpRequestAsync(httpRequest, cancellationToken).ConfigureAwa" +
"it(false);\r\n        \r\n");
#line 81 "MethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("\r\n\r\n");
#line 84 "MethodTemplate.cshtml"
    

#line default
#line hidden

#line 84 "MethodTemplate.cshtml"
     if (Model.RequestBody != null)
    {

#line default
#line hidden

            WriteLiteral("        \r\n    // Serialize Request  \r\n    string requestContent = JsonConvert.Ser" +
"ializeObject(");
#line 88 "MethodTemplate.cshtml"
                                                    Write(Model.RequestBody.Name);

#line default
#line hidden
            WriteLiteral(", ");
#line 88 "MethodTemplate.cshtml"
                                                                               Write(Model.GetSerializationSettingsReference(Model.RequestBody.Type));

#line default
#line hidden
            WriteLiteral(");\r\n    httpRequest.Content = new StringContent(requestContent, Encoding.UTF8);\r\n" +
"    httpRequest.Content.Headers.ContentType = MediaTypeHeaderValue.Parse(\"applic" +
"ation/json; charset=utf-8\");\r\n                \r\n");
#line 92 "MethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("    // Send Request\r\n    if (shouldTrace)\r\n    {\r\n        ServiceClientTracing.Se" +
"ndRequest(invocationId, httpRequest);\r\n    }\r\n\r\n    cancellationToken.ThrowIfCan" +
"cellationRequested();\r\n    HttpResponseMessage httpResponse = await ");
#line 100 "MethodTemplate.cshtml"
                                         Write(Model.ClientReference);

#line default
#line hidden
            WriteLiteral(@".HttpClient.SendAsync(httpRequest, cancellationToken).ConfigureAwait(false);
    if (shouldTrace)
    {
        ServiceClientTracing.ReceiveResponse(invocationId, httpResponse);
    }

    HttpStatusCode statusCode = httpResponse.StatusCode;
    cancellationToken.ThrowIfCancellationRequested();
    string responseContent = await httpResponse.Content.ReadAsStringAsync().ConfigureAwait(false);
    if (!(");
#line 109 "MethodTemplate.cshtml"
      Write(Model.SuccessStatusCodePredicate);

#line default
#line hidden
            WriteLiteral("))\r\n    {\r\n        var ex = new ");
#line 111 "MethodTemplate.cshtml"
                 Write(Model.OperationExceptionTypeString);

#line default
#line hidden
            WriteLiteral("(string.Format(\"Operation returned an invalid status code \'{0}\'\", statusCode));\r\n" +
"");
#line 112 "MethodTemplate.cshtml"
    

#line default
#line hidden

#line 112 "MethodTemplate.cshtml"
     if (Model.DefaultResponse != null)
    {

#line default
#line hidden

            WriteLiteral("        ");
#line 114 "MethodTemplate.cshtml"
      Write(Model.DefaultResponse.Name);

#line default
#line hidden
            WriteLiteral(" errorBody = JsonConvert.DeserializeObject<");
#line 114 "MethodTemplate.cshtml"
                                                                              Write(Model.DefaultResponse.Name);

#line default
#line hidden
            WriteLiteral(">(responseContent, ");
#line 114 "MethodTemplate.cshtml"
                                                                                                                              Write(Model.GetDeserializationSettingsReference(Model.DefaultResponse));

#line default
#line hidden
            WriteLiteral(");\r\n        if (errorBody != null)\r\n        {\r\n            ");
#line 117 "MethodTemplate.cshtml"
          Write(Model.InitializeExceptionWithMessage);

#line default
#line hidden
            WriteLiteral("\r\n            ex.Body = errorBody;\r\n        }\r\n");
#line 120 "MethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("        ex.Request = httpRequest;\r\n        ex.Response = httpResponse;\r\n        i" +
"f (shouldTrace)\r\n        {\r\n            ServiceClientTracing.Error(invocationId," +
" ex);\r\n        }\r\n\r\n        throw ex;\r\n    }\r\n\r\n    // Create Result\r\n    var re" +
"sult = new ");
#line 132 "MethodTemplate.cshtml"
                 Write(Model.OperationResponseReturnTypeString);

#line default
#line hidden
            WriteLiteral("();\r\n    result.Request = httpRequest;\r\n    result.Response = httpResponse;\r\n    " +
"");
#line 135 "MethodTemplate.cshtml"
Write(Model.InitializeResponseBody);

#line default
#line hidden
            WriteLiteral("\r\n\r\n");
#line 137 "MethodTemplate.cshtml"
    

#line default
#line hidden

#line 137 "MethodTemplate.cshtml"
     foreach (var responsePair in Model.Responses.Where(r => r.Value != null))
    {

#line default
#line hidden

            WriteLiteral("    \r\n    // Deserialize Response\r\n    if (statusCode == ");
#line 141 "MethodTemplate.cshtml"
                 Write(Model.GetStatusCodeReference(responsePair.Key));

#line default
#line hidden
            WriteLiteral(")\r\n    {\r\n        result.Body = JsonConvert.DeserializeObject<");
#line 143 "MethodTemplate.cshtml"
                                                Write(responsePair.Value.Name);

#line default
#line hidden
            WriteLiteral(">(responseContent, ");
#line 143 "MethodTemplate.cshtml"
                                                                                             Write(Model.GetDeserializationSettingsReference(responsePair.Value));

#line default
#line hidden
            WriteLiteral(");\r\n    }\r\n            \r\n");
#line 146 "MethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("    ");
#line 147 "MethodTemplate.cshtml"
     if (Model.ReturnType != null && Model.DefaultResponse != null && !Model.Responses.Any())
    {

#line default
#line hidden

            WriteLiteral("result.Body = JsonConvert.DeserializeObject<");
#line 149 "MethodTemplate.cshtml"
                                          Write(Model.DefaultResponse.Name);

#line default
#line hidden
            WriteLiteral(">(responseContent, ");
#line 149 "MethodTemplate.cshtml"
                                                                                          Write(Model.GetDeserializationSettingsReference(Model.DefaultResponse));

#line default
#line hidden
            WriteLiteral(");\r\n");
#line 150 "MethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("    \r\n    if (shouldTrace)\r\n    {\r\n        ServiceClientTracing.Exit(invocationId" +
", result);\r\n    }\r\n\r\n    return result;\r\n}");
        }
        #pragma warning restore 1998
    }
}
