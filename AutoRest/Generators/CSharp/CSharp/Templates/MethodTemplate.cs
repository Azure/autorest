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
using Microsoft.Rest.Generator.CSharp

#line default
#line hidden
    ;
#line 4 "MethodTemplate.cshtml"
using Microsoft.Rest.Generator.CSharp.TemplateModels

#line default
#line hidden
    ;
#line 5 "MethodTemplate.cshtml"
using Microsoft.Rest.Generator.Utilities

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
            WriteLiteral("/// <summary>\n");
#line 8 "MethodTemplate.cshtml"
Write(WrapComment("/// ", Model.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\n/// </summary>\n");
#line 10 "MethodTemplate.cshtml"
 foreach (var parameter in Model.LocalParameters)
{

#line default
#line hidden

            WriteLiteral("/// <param name=\'");
#line 12 "MethodTemplate.cshtml"
              Write(parameter.Name);

#line default
#line hidden
            WriteLiteral("\'>\n");
#line 13 "MethodTemplate.cshtml"

#line default
#line hidden

#line 13 "MethodTemplate.cshtml"
Write(WrapComment("/// ", parameter.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\n/// </param>    \n");
#line 15 "MethodTemplate.cshtml"
}

#line default
#line hidden

            WriteLiteral("/// <param name=\'customHeaders\'>\n/// Headers that will be added to request.\n/// <" +
"/param>\n/// <param name=\'cancellationToken\'>\n/// Cancellation token.\n/// </param" +
">\npublic async Task<");
#line 22 "MethodTemplate.cshtml"
              Write(Model.OperationResponseReturnTypeString);

#line default
#line hidden
            WriteLiteral("> ");
#line 22 "MethodTemplate.cshtml"
                                                          Write(Model.Name);

#line default
#line hidden
            WriteLiteral("WithOperationResponseAsync(");
#line 22 "MethodTemplate.cshtml"
                                                                                                  Write(Model.GetAsyncMethodParameterDeclaration(true));

#line default
#line hidden
            WriteLiteral(")\n{\n");
#line 24 "MethodTemplate.cshtml"
    

#line default
#line hidden

#line 24 "MethodTemplate.cshtml"
     foreach (var parameter in Model.LocalParameters)
    {
        if (parameter.IsRequired)
        {

#line default
#line hidden

            WriteLiteral("    if (");
#line 28 "MethodTemplate.cshtml"
      Write(parameter.Name);

#line default
#line hidden
            WriteLiteral(" == null)\n    {\n        throw new ValidationException(ValidationRules.CannotBeNul" +
"l, \"");
#line 30 "MethodTemplate.cshtml"
                                                                   Write(parameter.Name);

#line default
#line hidden
            WriteLiteral("\");\n    }\n\n");
#line 33 "MethodTemplate.cshtml"
        }
        if(parameter.Location != ParameterLocation.Query &&
            (Model.HttpMethod != HttpMethod.Patch || parameter.Location != ParameterLocation.Body))
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

            WriteLiteral(@"    // Tracing
    bool shouldTrace = ServiceClientTracing.IsEnabled;
    string invocationId = null;
    if (shouldTrace)
    {
        invocationId = ServiceClientTracing.NextInvocationId.ToString();
        Dictionary<string, object> tracingParameters = new Dictionary<string, object>();
");
#line 47 "MethodTemplate.cshtml"
    

#line default
#line hidden

#line 47 "MethodTemplate.cshtml"
     foreach (var parameter in Model.LocalParameters)
    {

#line default
#line hidden

            WriteLiteral("        tracingParameters.Add(\"");
#line 49 "MethodTemplate.cshtml"
                             Write(parameter.Name);

#line default
#line hidden
            WriteLiteral("\", ");
#line 49 "MethodTemplate.cshtml"
                                                 Write(parameter.Name);

#line default
#line hidden
            WriteLiteral(");\n");
#line 50 "MethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("        tracingParameters.Add(\"cancellationToken\", cancellationToken);\n        Se" +
"rviceClientTracing.Enter(invocationId, this, \"");
#line 52 "MethodTemplate.cshtml"
                                                    Write(Model.Name);

#line default
#line hidden
            WriteLiteral("\", tracingParameters);\n    }\n\n    // Construct URL\n");
#line 56 "MethodTemplate.cshtml"
    

#line default
#line hidden

#line 56 "MethodTemplate.cshtml"
     if (Model.IsAbsoluteUrl)
    {

#line default
#line hidden

            WriteLiteral("    string url = \"");
#line 58 "MethodTemplate.cshtml"
                Write(Model.Url);

#line default
#line hidden
            WriteLiteral("\";       \n");
#line 59 "MethodTemplate.cshtml"
    } 
    else 
    {

#line default
#line hidden

            WriteLiteral("    string url = ");
#line 62 "MethodTemplate.cshtml"
               Write(Model.ClientReference);

#line default
#line hidden
            WriteLiteral(".BaseUri.AbsoluteUri + \n                 \"/");
#line 63 "MethodTemplate.cshtml"
                 Write(Model.Url);

#line default
#line hidden
            WriteLiteral("\";\n");
#line 64 "MethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("    ");
#line 65 "MethodTemplate.cshtml"
Write(Model.BuildUrl("url"));

#line default
#line hidden
            WriteLiteral("\n    ");
#line 66 "MethodTemplate.cshtml"
Write(Model.RemoveDuplicateForwardSlashes("url"));

#line default
#line hidden
            WriteLiteral("\n    // Create HTTP transport objects\n    HttpRequestMessage httpRequest = new Ht" +
"tpRequestMessage();\n    httpRequest.Method = new HttpMethod(\"");
#line 69 "MethodTemplate.cshtml"
                                     Write(Model.HttpMethod.ToString().ToUpper());

#line default
#line hidden
            WriteLiteral("\");\n    httpRequest.RequestUri = new Uri(url);\n    // Set Headers\n");
#line 72 "MethodTemplate.cshtml"
    

#line default
#line hidden

#line 72 "MethodTemplate.cshtml"
     foreach (var parameter in Model.Parameters.Where(p => p.Location == ParameterLocation.Header))
    {

#line default
#line hidden

            WriteLiteral("    if (");
#line 74 "MethodTemplate.cshtml"
      Write(parameter.Name);

#line default
#line hidden
            WriteLiteral(" != null)\n    {\n        httpRequest.Headers.Add(\"");
#line 76 "MethodTemplate.cshtml"
                               Write(parameter.SerializedName);

#line default
#line hidden
            WriteLiteral("\", ");
#line 76 "MethodTemplate.cshtml"
                                                            Write(parameter.Type.ToString(Model.ClientReference, parameter.Name));

#line default
#line hidden
            WriteLiteral(");\n    }\n");
#line 78 "MethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("    if (customHeaders != null)\n    {\n        foreach(var header in customHeaders)" +
"\n        {\n            httpRequest.Headers.Add(header.Key, header.Value);\n      " +
"  }\n    }\n    ");
#line 86 "MethodTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\n");
#line 87 "MethodTemplate.cshtml"
    

#line default
#line hidden

#line 87 "MethodTemplate.cshtml"
     if (Settings.AddCredentials)
    {

#line default
#line hidden

            WriteLiteral("        \n    // Set Credentials\n    cancellationToken.ThrowIfCancellationRequeste" +
"d();\n    await ");
#line 92 "MethodTemplate.cshtml"
      Write(Model.ClientReference);

#line default
#line hidden
            WriteLiteral(".Credentials.ProcessHttpRequestAsync(httpRequest, cancellationToken).ConfigureAwa" +
"it(false);\n        \n");
#line 94 "MethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("\n\n");
#line 97 "MethodTemplate.cshtml"
    

#line default
#line hidden

#line 97 "MethodTemplate.cshtml"
     if (Model.RequestBody != null)
    {

#line default
#line hidden

            WriteLiteral("        \n    // Serialize Request  \n    string requestContent = JsonConvert.Seria" +
"lizeObject(");
#line 101 "MethodTemplate.cshtml"
                                                    Write(Model.RequestBody.Name);

#line default
#line hidden
            WriteLiteral(", ");
#line 101 "MethodTemplate.cshtml"
                                                                               Write(Model.GetSerializationSettingsReference(Model.RequestBody.Type));

#line default
#line hidden
            WriteLiteral(");\n    httpRequest.Content = new StringContent(requestContent, Encoding.UTF8);\n  " +
"  httpRequest.Content.Headers.ContentType = MediaTypeHeaderValue.Parse(\"applicat" +
"ion/json; charset=utf-8\");\n                \n");
#line 105 "MethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("    // Send Request\n    if (shouldTrace)\n    {\n        ServiceClientTracing.SendR" +
"equest(invocationId, httpRequest);\n    }\n\n    cancellationToken.ThrowIfCancellat" +
"ionRequested();\n    HttpResponseMessage httpResponse = await ");
#line 113 "MethodTemplate.cshtml"
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
#line 122 "MethodTemplate.cshtml"
      Write(Model.SuccessStatusCodePredicate);

#line default
#line hidden
            WriteLiteral("))\n    {\n        var ex = new ");
#line 124 "MethodTemplate.cshtml"
                 Write(Model.OperationExceptionTypeString);

#line default
#line hidden
            WriteLiteral("(string.Format(\"Operation returned an invalid status code \'{0}\'\", statusCode));\n");
#line 125 "MethodTemplate.cshtml"
    

#line default
#line hidden

#line 125 "MethodTemplate.cshtml"
     if (Model.DefaultResponse != null)
    {

#line default
#line hidden

            WriteLiteral("        ");
#line 127 "MethodTemplate.cshtml"
      Write(Model.DefaultResponse.Name);

#line default
#line hidden
            WriteLiteral(" errorBody = JsonConvert.DeserializeObject<");
#line 127 "MethodTemplate.cshtml"
                                                                              Write(Model.DefaultResponse.Name);

#line default
#line hidden
            WriteLiteral(">(responseContent, ");
#line 127 "MethodTemplate.cshtml"
                                                                                                                              Write(Model.GetDeserializationSettingsReference(Model.DefaultResponse));

#line default
#line hidden
            WriteLiteral(");\n        if (errorBody != null)\n        {\n            ");
#line 130 "MethodTemplate.cshtml"
          Write(Model.InitializeExceptionWithMessage);

#line default
#line hidden
            WriteLiteral("\n            ex.Body = errorBody;\n        }\n");
#line 133 "MethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("        ex.Request = httpRequest;\n        ex.Response = httpResponse;\n        if " +
"(shouldTrace)\n        {\n            ServiceClientTracing.Error(invocationId, ex)" +
";\n        }\n\n        throw ex;\n    }\n\n    // Create Result\n    var result = new " +
"");
#line 145 "MethodTemplate.cshtml"
                 Write(Model.OperationResponseReturnTypeString);

#line default
#line hidden
            WriteLiteral("();\n    result.Request = httpRequest;\n    result.Response = httpResponse;\n    ");
#line 148 "MethodTemplate.cshtml"
Write(Model.InitializeResponseBody);

#line default
#line hidden
            WriteLiteral("\n\n");
#line 150 "MethodTemplate.cshtml"
    

#line default
#line hidden

#line 150 "MethodTemplate.cshtml"
     foreach (var responsePair in Model.Responses.Where(r => r.Value != null))
    {

#line default
#line hidden

            WriteLiteral("    \n    // Deserialize Response\n    if (statusCode == ");
#line 154 "MethodTemplate.cshtml"
                 Write(MethodTemplateModel.GetStatusCodeReference(responsePair.Key));

#line default
#line hidden
            WriteLiteral(")\n    {\n        result.Body = JsonConvert.DeserializeObject<");
#line 156 "MethodTemplate.cshtml"
                                                Write(responsePair.Value.Name);

#line default
#line hidden
            WriteLiteral(">(responseContent, ");
#line 156 "MethodTemplate.cshtml"
                                                                                             Write(Model.GetDeserializationSettingsReference(responsePair.Value));

#line default
#line hidden
            WriteLiteral(");\n    }\n            \n");
#line 159 "MethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("    ");
#line 160 "MethodTemplate.cshtml"
     if (Model.ReturnType != null && Model.DefaultResponse != null && !Model.Responses.Any())
    {

#line default
#line hidden

            WriteLiteral("result.Body = JsonConvert.DeserializeObject<");
#line 162 "MethodTemplate.cshtml"
                                          Write(Model.DefaultResponse.Name);

#line default
#line hidden
            WriteLiteral(">(responseContent, ");
#line 162 "MethodTemplate.cshtml"
                                                                                          Write(Model.GetDeserializationSettingsReference(Model.DefaultResponse));

#line default
#line hidden
            WriteLiteral(");\n");
#line 163 "MethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("    \n    if (shouldTrace)\n    {\n        ServiceClientTracing.Exit(invocationId, r" +
"esult);\n    }\n\n    return result;\n}");
        }
        #pragma warning restore 1998
    }
}
