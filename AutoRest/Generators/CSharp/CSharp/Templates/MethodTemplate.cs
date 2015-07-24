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
            WriteLiteral("/// <summary>\r\n");
#line 8 "MethodTemplate.cshtml"
Write(WrapComment("/// ", Model.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n/// </summary>\r\n");
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
            WriteLiteral("\'>\r\n");
#line 13 "MethodTemplate.cshtml"

#line default
#line hidden

#line 13 "MethodTemplate.cshtml"
Write(WrapComment("/// ", parameter.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n/// </param>    \r\n");
#line 15 "MethodTemplate.cshtml"
}

#line default
#line hidden

            WriteLiteral("/// <param name=\'customHeaders\'>\r\n/// Headers that will be added to request.\r\n///" +
" </param>\r\n/// <param name=\'cancellationToken\'>\r\n/// Cancellation token.\r\n/// </" +
"param>\r\npublic async Task<");
#line 22 "MethodTemplate.cshtml"
              Write(Model.OperationResponseReturnTypeString);

#line default
#line hidden
            WriteLiteral("> ");
#line 22 "MethodTemplate.cshtml"
                                                          Write(Model.Name);

#line default
#line hidden
            WriteLiteral("WithHttpMessagesAsync(");
#line 22 "MethodTemplate.cshtml"
                                                                                             Write(Model.GetAsyncMethodParameterDeclaration(true));

#line default
#line hidden
            WriteLiteral(")\r\n{\r\n");
#line 24 "MethodTemplate.cshtml"
    

#line default
#line hidden

#line 24 "MethodTemplate.cshtml"
     foreach (var parameter in Model.ParameterTemplateModels)
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
            WriteLiteral(" == null)\r\n    {\r\n        throw new ValidationException(ValidationRules.CannotBeN" +
"ull, \"");
#line 30 "MethodTemplate.cshtml"
                                                                   Write(parameter.Name);

#line default
#line hidden
            WriteLiteral("\");\r\n    }\r\n\r\n");
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
            WriteLiteral("\r\n");
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
            WriteLiteral(");\r\n");
#line 50 "MethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("        tracingParameters.Add(\"cancellationToken\", cancellationToken);\r\n        S" +
"erviceClientTracing.Enter(invocationId, this, \"");
#line 52 "MethodTemplate.cshtml"
                                                    Write(Model.Name);

#line default
#line hidden
            WriteLiteral("\", tracingParameters);\r\n    }\r\n\r\n    // Construct URL\r\n");
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
            WriteLiteral("\";       \r\n");
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
            WriteLiteral(".BaseUri.AbsoluteUri + \r\n                 \"/");
#line 63 "MethodTemplate.cshtml"
                 Write(Model.Url);

#line default
#line hidden
            WriteLiteral("\";\r\n");
#line 64 "MethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("    ");
#line 65 "MethodTemplate.cshtml"
Write(Model.BuildUrl("url"));

#line default
#line hidden
            WriteLiteral("\r\n    ");
#line 66 "MethodTemplate.cshtml"
Write(Model.RemoveDuplicateForwardSlashes("url"));

#line default
#line hidden
            WriteLiteral("\r\n    // Create HTTP transport objects\r\n    HttpRequestMessage httpRequest = new " +
"HttpRequestMessage();\r\n    httpRequest.Method = new HttpMethod(\"");
#line 69 "MethodTemplate.cshtml"
                                     Write(Model.HttpMethod.ToString().ToUpper());

#line default
#line hidden
            WriteLiteral("\");\r\n    httpRequest.RequestUri = new Uri(url);\r\n    // Set Headers\r\n    ");
#line 72 "MethodTemplate.cshtml"
Write(Model.SetDefaultHeaders);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 73 "MethodTemplate.cshtml"
    

#line default
#line hidden

#line 73 "MethodTemplate.cshtml"
     foreach (var parameter in Model.Parameters.Where(p => p.Location == ParameterLocation.Header))
    {

#line default
#line hidden

            WriteLiteral("    if (");
#line 75 "MethodTemplate.cshtml"
      Write(parameter.Name);

#line default
#line hidden
            WriteLiteral(" != null)\r\n    {\r\n        if (httpRequest.Headers.Contains(\"");
#line 77 "MethodTemplate.cshtml"
                                        Write(parameter.SerializedName);

#line default
#line hidden
            WriteLiteral("\"))\r\n        {\r\n            httpRequest.Headers.Remove(\"");
#line 79 "MethodTemplate.cshtml"
                                      Write(parameter.SerializedName);

#line default
#line hidden
            WriteLiteral("\");\r\n        }\r\n        httpRequest.Headers.TryAddWithoutValidation(\"");
#line 81 "MethodTemplate.cshtml"
                                                   Write(parameter.SerializedName);

#line default
#line hidden
            WriteLiteral("\", ");
#line 81 "MethodTemplate.cshtml"
                                                                                Write(parameter.Type.ToString(Model.ClientReference, parameter.Name));

#line default
#line hidden
            WriteLiteral(");\r\n    }\r\n");
#line 83 "MethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral(@"    if (customHeaders != null)
    {
        foreach(var header in customHeaders)
        {
            if (httpRequest.Headers.Contains(header.Key))
            {
                httpRequest.Headers.Remove(header.Key);
            }
            httpRequest.Headers.TryAddWithoutValidation(header.Key, header.Value);
        }
    }
    ");
#line 95 "MethodTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 96 "MethodTemplate.cshtml"
    

#line default
#line hidden

#line 96 "MethodTemplate.cshtml"
     if (Settings.AddCredentials)
    {

#line default
#line hidden

            WriteLiteral("        \r\n    // Set Credentials\r\n    if (");
#line 100 "MethodTemplate.cshtml"
    Write(Model.ClientReference);

#line default
#line hidden
            WriteLiteral(".Credentials != null)\r\n    {\r\n        cancellationToken.ThrowIfCancellationReques" +
"ted();\r\n        await ");
#line 103 "MethodTemplate.cshtml"
          Write(Model.ClientReference);

#line default
#line hidden
            WriteLiteral(".Credentials.ProcessHttpRequestAsync(httpRequest, cancellationToken).ConfigureAwa" +
"it(false);\r\n    }\r\n        \r\n");
#line 106 "MethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("\r\n\r\n");
#line 109 "MethodTemplate.cshtml"
    

#line default
#line hidden

#line 109 "MethodTemplate.cshtml"
     if (Model.RequestBody != null)
    {

#line default
#line hidden

            WriteLiteral("        \r\n    // Serialize Request  \r\n    string requestContent = JsonConvert.Ser" +
"ializeObject(");
#line 113 "MethodTemplate.cshtml"
                                                    Write(Model.RequestBody.Name);

#line default
#line hidden
            WriteLiteral(", ");
#line 113 "MethodTemplate.cshtml"
                                                                               Write(Model.GetSerializationSettingsReference(Model.RequestBody.Type));

#line default
#line hidden
            WriteLiteral(");\r\n    httpRequest.Content = new StringContent(requestContent, Encoding.UTF8);\r\n" +
"    httpRequest.Content.Headers.ContentType = MediaTypeHeaderValue.Parse(\"applic" +
"ation/json; charset=utf-8\");\r\n                \r\n");
#line 117 "MethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("    // Send Request\r\n    if (shouldTrace)\r\n    {\r\n        ServiceClientTracing.Se" +
"ndRequest(invocationId, httpRequest);\r\n    }\r\n\r\n    cancellationToken.ThrowIfCan" +
"cellationRequested();\r\n    HttpResponseMessage httpResponse = await ");
#line 125 "MethodTemplate.cshtml"
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
    if (!(");
#line 133 "MethodTemplate.cshtml"
      Write(Model.SuccessStatusCodePredicate);

#line default
#line hidden
            WriteLiteral("))\r\n    {\r\n        var ex = new ");
#line 135 "MethodTemplate.cshtml"
                 Write(Model.OperationExceptionTypeString);

#line default
#line hidden
            WriteLiteral("(string.Format(\"Operation returned an invalid status code \'{0}\'\", statusCode));\r\n" +
"");
#line 136 "MethodTemplate.cshtml"
    

#line default
#line hidden

#line 136 "MethodTemplate.cshtml"
     if (Model.DefaultResponse != null)
    {
        if (Model.DefaultResponse == PrimaryType.Stream)
        {

#line default
#line hidden

            WriteLiteral("        ");
#line 140 "MethodTemplate.cshtml"
      Write(Model.DefaultResponse.Name);

#line default
#line hidden
            WriteLiteral(" errorBody = await httpResponse.Content.ReadAsStreamAsync().ConfigureAwait(false)" +
";\r\n");
#line 141 "MethodTemplate.cshtml"
        }
        else
        {

#line default
#line hidden

            WriteLiteral("        string responseContent = await httpResponse.Content.ReadAsStringAsync().C" +
"onfigureAwait(false);\r\n        ");
#line 145 "MethodTemplate.cshtml"
      Write(Model.DefaultResponse.Name);

#line default
#line hidden
            WriteLiteral(" errorBody = JsonConvert.DeserializeObject<");
#line 145 "MethodTemplate.cshtml"
                                                                              Write(Model.DefaultResponse.Name);

#line default
#line hidden
            WriteLiteral(">(responseContent, ");
#line 145 "MethodTemplate.cshtml"
                                                                                                                              Write(Model.GetDeserializationSettingsReference(Model.DefaultResponse));

#line default
#line hidden
            WriteLiteral(");\r\n");
#line 146 "MethodTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("        if (errorBody != null)\r\n        {\r\n            ");
#line 149 "MethodTemplate.cshtml"
          Write(Model.InitializeExceptionWithMessage);

#line default
#line hidden
            WriteLiteral("\r\n            ex.Body = errorBody;\r\n        }\r\n");
#line 152 "MethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("        ex.Request = httpRequest;\r\n        ex.Response = httpResponse;\r\n        i" +
"f (shouldTrace)\r\n        {\r\n            ServiceClientTracing.Error(invocationId," +
" ex);\r\n        }\r\n\r\n        throw ex;\r\n    }\r\n\r\n    // Create Result\r\n    var re" +
"sult = new ");
#line 164 "MethodTemplate.cshtml"
                 Write(Model.OperationResponseReturnTypeString);

#line default
#line hidden
            WriteLiteral("();\r\n    result.Request = httpRequest;\r\n    result.Response = httpResponse;\r\n    " +
"");
#line 167 "MethodTemplate.cshtml"
Write(Model.InitializeResponseBody);

#line default
#line hidden
            WriteLiteral("\r\n\r\n");
#line 169 "MethodTemplate.cshtml"
    

#line default
#line hidden

#line 169 "MethodTemplate.cshtml"
     foreach (var responsePair in Model.Responses.Where(r => r.Value != null))
    {

#line default
#line hidden

            WriteLiteral("    \r\n    // Deserialize Response\r\n    if (statusCode == ");
#line 173 "MethodTemplate.cshtml"
                 Write(MethodTemplateModel.GetStatusCodeReference(responsePair.Key));

#line default
#line hidden
            WriteLiteral(")\r\n    {\r\n");
#line 175 "MethodTemplate.cshtml"
        

#line default
#line hidden

#line 175 "MethodTemplate.cshtml"
         if (responsePair.Value == PrimaryType.Stream)
        {

#line default
#line hidden

            WriteLiteral("        result.Body = await httpResponse.Content.ReadAsStreamAsync().ConfigureAwa" +
"it(false);\r\n");
#line 178 "MethodTemplate.cshtml"
        }
        else 
        {

#line default
#line hidden

            WriteLiteral("        string responseContent = await httpResponse.Content.ReadAsStringAsync().C" +
"onfigureAwait(false);\r\n        result.Body = JsonConvert.DeserializeObject<");
#line 182 "MethodTemplate.cshtml"
                                                  Write(responsePair.Value.Name);

#line default
#line hidden
            WriteLiteral(">(responseContent, ");
#line 182 "MethodTemplate.cshtml"
                                                                                               Write(Model.GetDeserializationSettingsReference(responsePair.Value));

#line default
#line hidden
            WriteLiteral(");\r\n");
#line 183 "MethodTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("    }\r\n            \r\n");
#line 186 "MethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("    ");
#line 187 "MethodTemplate.cshtml"
     if (Model.ReturnType != null && Model.DefaultResponse != null && !Model.Responses.Any())
    {
        if (Model.DefaultResponse == PrimaryType.Stream)
        {

#line default
#line hidden

            WriteLiteral("            result.Body = await httpResponse.Content.ReadAsStreamAsync().Configur" +
"eAwait(false);\r\n");
#line 192 "MethodTemplate.cshtml"
        }
        else
        {

#line default
#line hidden

            WriteLiteral("            string defaultResponseContent = await httpResponse.Content.ReadAsStri" +
"ngAsync().ConfigureAwait(false);\r\n            result.Body = JsonConvert.Deserial" +
"izeObject<");
#line 196 "MethodTemplate.cshtml"
                                                      Write(Model.DefaultResponse.Name);

#line default
#line hidden
            WriteLiteral(">(defaultResponseContent, ");
#line 196 "MethodTemplate.cshtml"
                                                                                                             Write(Model.GetDeserializationSettingsReference(Model.DefaultResponse));

#line default
#line hidden
            WriteLiteral(");\r\n");
#line 197 "MethodTemplate.cshtml"
        }
    }

#line default
#line hidden

            WriteLiteral("    \r\n    if (shouldTrace)\r\n    {\r\n        ServiceClientTracing.Exit(invocationId" +
", result);\r\n    }\r\n\r\n    return result;\r\n}");
        }
        #pragma warning restore 1998
    }
}
