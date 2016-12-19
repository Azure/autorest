// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace AutoRest.CSharp.Templates
{
#line 1 "MethodTemplate.cshtml"
using System.Globalization

#line default
#line hidden
    ;
#line 2 "MethodTemplate.cshtml"
using System.Linq;

#line default
#line hidden
#line 3 "MethodTemplate.cshtml"
using System

#line default
#line hidden
    ;
#line 4 "MethodTemplate.cshtml"
using AutoRest.Core.Model

#line default
#line hidden
    ;
#line 5 "MethodTemplate.cshtml"
using AutoRest.Core.Utilities

#line default
#line hidden
    ;
#line 6 "MethodTemplate.cshtml"
using AutoRest.CSharp

#line default
#line hidden
    ;
#line 7 "MethodTemplate.cshtml"
using AutoRest.CSharp.Model

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class MethodTemplate : AutoRest.Core.Template<AutoRest.CSharp.Model.MethodCs>
    {
        #line hidden
        public MethodTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
#line 10 "MethodTemplate.cshtml"
 if (!string.IsNullOrWhiteSpace(Model.Description) || !string.IsNullOrEmpty(Model.Summary))
{

#line default
#line hidden

            WriteLiteral("/// <summary>\r\n");
#line 13 "MethodTemplate.cshtml"
Write(WrapComment("/// ", String.IsNullOrEmpty(Model.Summary) ? Model.Description.EscapeXmlComment() : Model.Summary.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 14 "MethodTemplate.cshtml"
    if (!string.IsNullOrEmpty(Model.ExternalDocsUrl))
    {

#line default
#line hidden

            WriteLiteral("/// <see href=\"");
#line 16 "MethodTemplate.cshtml"
            Write(Model.ExternalDocsUrl);

#line default
#line hidden
            WriteLiteral("\" />\r\n");
#line 17 "MethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("/// </summary>\r\n");
#line 19 "MethodTemplate.cshtml"
}

#line default
#line hidden

#line 20 "MethodTemplate.cshtml"
 if (!String.IsNullOrEmpty(Model.Description) && !String.IsNullOrEmpty(Model.Summary))
{

#line default
#line hidden

            WriteLiteral("/// <remarks>\r\n");
#line 23 "MethodTemplate.cshtml"
Write(WrapComment("/// ", Model.Description.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n/// </remarks>\r\n");
#line 25 "MethodTemplate.cshtml"
}

#line default
#line hidden

#line 26 "MethodTemplate.cshtml"
 foreach (var parameter in Model.LocalParameters)
{

#line default
#line hidden

            WriteLiteral("/// <param name=\'");
#line 28 "MethodTemplate.cshtml"
              Write(parameter.Name);

#line default
#line hidden
            WriteLiteral("\'>\r\n");
#line 29 "MethodTemplate.cshtml"

#line default
#line hidden

#line 29 "MethodTemplate.cshtml"
Write(WrapComment("/// ", parameter.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n/// </param>\r\n");
#line 31 "MethodTemplate.cshtml"
}

#line default
#line hidden

            WriteLiteral("/// <param name=\'customHeaders\'>\r\n/// Headers that will be added to request.\r\n///" +
" </param>\r\n/// <param name=\'cancellationToken\'>\r\n/// The cancellation token.\r\n//" +
"/ </param>\r\n/// <exception");
            WriteAttribute("cref", Tuple.Create(" cref=\"", 1187), Tuple.Create("\"", 1231), 
            Tuple.Create(Tuple.Create("", 1194), Tuple.Create<System.Object, System.Int32>(Model.OperationExceptionTypeString, 1194), false));
            WriteLiteral(">\r\n/// Thrown when the operation returned an invalid status code\r\n/// </exception" +
">\r\n");
#line 41 "MethodTemplate.cshtml"
 if (Model.Responses.Where(r => r.Value.Body != null).Any())
{

#line default
#line hidden

            WriteLiteral("/// <exception cref=\"Microsoft.Rest.SerializationException\">\r\n/// Thrown when una" +
"ble to deserialize the response\r\n/// </exception>\r\n");
#line 46 "MethodTemplate.cshtml"
}

#line default
#line hidden

#line 47 "MethodTemplate.cshtml"
 if (Model.Parameters.Cast<ParameterCs>().Any(p => !p.IsConstant && p.IsRequired &&p.IsNullable()))
{

#line default
#line hidden

            WriteLiteral("/// <exception cref=\"Microsoft.Rest.ValidationException\">\r\n/// Thrown when a requ" +
"ired parameter is null\r\n/// </exception>\r\n/// <exception cref=\"System.ArgumentNu" +
"llException\">\r\n/// Thrown when a required parameter is null\r\n/// </exception>\r\n");
#line 55 "MethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("/// <return>\r\n/// A response object containing the response body and response hea" +
"ders.\r\n/// </return>\r\n");
#line 59 "MethodTemplate.cshtml"
 if (Model.Deprecated)
{

#line default
#line hidden

            WriteLiteral("[System.Obsolete()]\r\n");
#line 62 "MethodTemplate.cshtml"
}

#line default
#line hidden

            WriteLiteral("public async System.Threading.Tasks.Task<");
#line 63 "MethodTemplate.cshtml"
                                     Write(Model.OperationResponseReturnTypeString);

#line default
#line hidden
            WriteLiteral("> ");
#line 63 "MethodTemplate.cshtml"
                                                                                 Write(Model.Name);

#line default
#line hidden
            WriteLiteral("WithHttpMessagesAsync(");
#line 63 "MethodTemplate.cshtml"
                                                                                                                    Write(Model.GetAsyncMethodParameterDeclaration(true));

#line default
#line hidden
            WriteLiteral(")\r\n{\r\n");
#line 65 "MethodTemplate.cshtml"
    

#line default
#line hidden

#line 65 "MethodTemplate.cshtml"
     foreach (ParameterCs parameter in Model.Parameters.Where(p => !p.IsConstant))
    {
        if (parameter.IsRequired && parameter.IsNullable())
        {

#line default
#line hidden

            WriteLiteral("    if (");
#line 69 "MethodTemplate.cshtml"
      Write(parameter.Name);

#line default
#line hidden
            WriteLiteral(" == null)\r\n    {\r\n        throw new Microsoft.Rest.ValidationException(Microsoft." +
"Rest.ValidationRules.CannotBeNull, \"");
#line 71 "MethodTemplate.cshtml"
                                                                                                 Write(parameter.Name);

#line default
#line hidden
            WriteLiteral("\");\r\n    }\r\n\r\n");
#line 74 "MethodTemplate.cshtml"
        }
        if(parameter.CanBeValidated  && (Model.HttpMethod != HttpMethod.Patch || parameter.Location != ParameterLocation.Body))
        {

#line default
#line hidden

            WriteLiteral("    ");
#line 77 "MethodTemplate.cshtml"
  Write(parameter.ModelType.ValidateType(Model, parameter.Name, parameter.Constraints));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 78 "MethodTemplate.cshtml"
        }
    }

#line default
#line hidden

            WriteLiteral("\r\n");
#line 81 "MethodTemplate.cshtml"
    

#line default
#line hidden

#line 81 "MethodTemplate.cshtml"
     foreach (ParameterCs parameter in Model.Parameters)
    {
        if (parameter.IsConstant && !parameter.IsClientProperty)
        {

#line default
#line hidden

            WriteLiteral("    ");
#line 85 "MethodTemplate.cshtml"
  Write(parameter.ModelTypeName);

#line default
#line hidden
            WriteLiteral(" ");
#line 85 "MethodTemplate.cshtml"
                             Write(parameter.Name);

#line default
#line hidden
            WriteLiteral(" = ");
#line 85 "MethodTemplate.cshtml"
                                                 Write(parameter.DefaultValue);

#line default
#line hidden
            WriteLiteral(";\r\n");
#line 86 "MethodTemplate.cshtml"
        }

        if (parameter.ModelType is CompositeType
            && !parameter.IsConstant
            && parameter.IsRequired
            && !parameter.IsClientProperty
            && ((CompositeType)parameter.ModelType).ContainsConstantProperties)
        {

#line default
#line hidden

            WriteLiteral("    if (");
#line 94 "MethodTemplate.cshtml"
      Write(parameter.Name);

#line default
#line hidden
            WriteLiteral(" == null)\r\n    {\r\n        ");
#line 96 "MethodTemplate.cshtml"
      Write(parameter.Name);

#line default
#line hidden
            WriteLiteral(" = new ");
#line 96 "MethodTemplate.cshtml"
                              Write(parameter.ModelTypeName);

#line default
#line hidden
            WriteLiteral("();\r\n    }\r\n");
#line 98 "MethodTemplate.cshtml"
        }

    }

#line default
#line hidden

            WriteLiteral("    ");
#line 101 "MethodTemplate.cshtml"
Write(Model.BuildInputMappings());

#line default
#line hidden
            WriteLiteral(@"
    // Tracing
    bool _shouldTrace = Microsoft.Rest.ServiceClientTracing.IsEnabled;
    string _invocationId = null;
    if (_shouldTrace)
    {
        _invocationId = Microsoft.Rest.ServiceClientTracing.NextInvocationId.ToString();
        System.Collections.Generic.Dictionary<string, object> tracingParameters = new System.Collections.Generic.Dictionary<string, object>();
");
#line 109 "MethodTemplate.cshtml"
    

#line default
#line hidden

#line 109 "MethodTemplate.cshtml"
     foreach (var parameter in Model.LogicalParameters.Where(p => !p.IsClientProperty))
    {

#line default
#line hidden

            WriteLiteral("        tracingParameters.Add(\"");
#line 111 "MethodTemplate.cshtml"
                             Write(parameter.Name);

#line default
#line hidden
            WriteLiteral("\", ");
#line 111 "MethodTemplate.cshtml"
                                                 Write(parameter.Name);

#line default
#line hidden
            WriteLiteral(");\r\n");
#line 112 "MethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("        tracingParameters.Add(\"cancellationToken\", cancellationToken);\r\n        M" +
"icrosoft.Rest.ServiceClientTracing.Enter(_invocationId, this, \"");
#line 114 "MethodTemplate.cshtml"
                                                                    Write(Model.Name);

#line default
#line hidden
            WriteLiteral("\", tracingParameters);\r\n    }\r\n\r\n    // Construct URL\r\n");
#line 118 "MethodTemplate.cshtml"
 if (Model.IsAbsoluteUrl)
{

#line default
#line hidden

            WriteLiteral("    string _url = \"");
#line 120 "MethodTemplate.cshtml"
                 Write(Model.Url);

#line default
#line hidden
            WriteLiteral("\";\r\n");
#line 121 "MethodTemplate.cshtml"
}
else
{
if (Model.IsCustomBaseUri)
{

#line default
#line hidden

            WriteLiteral("    var _baseUrl = ");
#line 126 "MethodTemplate.cshtml"
                 Write(Model.ClientReference);

#line default
#line hidden
            WriteLiteral(".BaseUri;\r\n    var _url = _baseUrl + (_baseUrl.EndsWith(\"/\") ? \"\" : \"/\") + \"");
#line 127 "MethodTemplate.cshtml"
                                                               Write(Model.Url.TrimStart('/'));

#line default
#line hidden
            WriteLiteral("\";\r\n");
#line 128 "MethodTemplate.cshtml"
}
else
{

#line default
#line hidden

            WriteLiteral("    var _baseUrl = ");
#line 131 "MethodTemplate.cshtml"
                 Write(Model.ClientReference);

#line default
#line hidden
            WriteLiteral(".BaseUri.AbsoluteUri;\r\n    var _url = new System.Uri(new System.Uri(_baseUrl + (_" +
"baseUrl.EndsWith(\"/\") ? \"\" : \"/\")), \"");
#line 132 "MethodTemplate.cshtml"
                                                                                             Write(Model.Url.TrimStart('/'));

#line default
#line hidden
            WriteLiteral("\").ToString();\r\n");
#line 133 "MethodTemplate.cshtml"
}    
}

#line default
#line hidden

            WriteLiteral("    ");
#line 135 "MethodTemplate.cshtml"
Write(Model.BuildUrl("_url"));

#line default
#line hidden
            WriteLiteral("\r\n    // Create HTTP transport objects\r\n    var _httpRequest = new System.Net.Htt" +
"p.HttpRequestMessage();\r\n    System.Net.Http.HttpResponseMessage _httpResponse =" +
" null;\r\n\r\n    _httpRequest.Method = new System.Net.Http.HttpMethod(\"");
#line 140 "MethodTemplate.cshtml"
                                                      Write(Model.HttpMethod.ToString().ToUpper());

#line default
#line hidden
            WriteLiteral("\");\r\n    _httpRequest.RequestUri = new System.Uri(_url);\r\n    // Set Headers\r\n   " +
" ");
#line 143 "MethodTemplate.cshtml"
Write(Model.SetDefaultHeaders);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 144 "MethodTemplate.cshtml"
    

#line default
#line hidden

#line 144 "MethodTemplate.cshtml"
     foreach (ParameterCs parameter in Model.LogicalParameters.Where(p => p.Location == ParameterLocation.Header))
    {
        if (!parameter.IsNullable())
        {

#line default
#line hidden

            WriteLiteral("    if (_httpRequest.Headers.Contains(\"");
#line 148 "MethodTemplate.cshtml"
                                     Write(parameter.SerializedName);

#line default
#line hidden
            WriteLiteral("\"))\r\n    {\r\n        _httpRequest.Headers.Remove(\"");
#line 150 "MethodTemplate.cshtml"
                                   Write(parameter.SerializedName);

#line default
#line hidden
            WriteLiteral("\");\r\n    }\r\n    _httpRequest.Headers.TryAddWithoutValidation(\"");
#line 152 "MethodTemplate.cshtml"
                                                Write(parameter.SerializedName);

#line default
#line hidden
            WriteLiteral("\", ");
#line 152 "MethodTemplate.cshtml"
                                                                             Write(parameter.ModelType.ToString(Model.ClientReference, parameter.Name));

#line default
#line hidden
            WriteLiteral(");\r\n");
#line 153 "MethodTemplate.cshtml"
        }
        else
        {

#line default
#line hidden

            WriteLiteral("    if (");
#line 156 "MethodTemplate.cshtml"
      Write(parameter.Name);

#line default
#line hidden
            WriteLiteral(" != null)\r\n    {\r\n        if (_httpRequest.Headers.Contains(\"");
#line 158 "MethodTemplate.cshtml"
                                         Write(parameter.SerializedName);

#line default
#line hidden
            WriteLiteral("\"))\r\n        {\r\n            _httpRequest.Headers.Remove(\"");
#line 160 "MethodTemplate.cshtml"
                                       Write(parameter.SerializedName);

#line default
#line hidden
            WriteLiteral("\");\r\n        }\r\n        _httpRequest.Headers.TryAddWithoutValidation(\"");
#line 162 "MethodTemplate.cshtml"
                                                    Write(parameter.SerializedName);

#line default
#line hidden
            WriteLiteral("\", ");
#line 162 "MethodTemplate.cshtml"
                                                                                 Write(parameter.ModelType.ToString(Model.ClientReference, parameter.Name));

#line default
#line hidden
            WriteLiteral(");\r\n    }\r\n");
#line 164 "MethodTemplate.cshtml"
        }
    }

#line default
#line hidden

            WriteLiteral(@"    if (customHeaders != null)
    {
        foreach(var _header in customHeaders)
        {
            if (_httpRequest.Headers.Contains(_header.Key))
            {
                _httpRequest.Headers.Remove(_header.Key);
            }
            _httpRequest.Headers.TryAddWithoutValidation(_header.Key, _header.Value);
        }
    }
    ");
#line 177 "MethodTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n\r\n    // Serialize Request\r\n    string _requestContent = null;\r\n");
#line 181 "MethodTemplate.cshtml"
    

#line default
#line hidden

#line 181 "MethodTemplate.cshtml"
     if (Model.RequestBody != null)
    {
        if (Model.RequestBody.ModelType.IsPrimaryType(KnownPrimaryType.Stream))
        {
            if (Model.RequestBody.IsRequired)
            {

#line default
#line hidden

            WriteLiteral("    if(");
#line 187 "MethodTemplate.cshtml"
     Write(Model.RequestBody.Name);

#line default
#line hidden
            WriteLiteral(" == null)\r\n    {\r\n      throw new System.ArgumentNullException(\"");
#line 189 "MethodTemplate.cshtml"
                                            Write(Model.RequestBody.Name);

#line default
#line hidden
            WriteLiteral("\");\r\n    }\r\n");
#line 191 "MethodTemplate.cshtml"
            }

#line default
#line hidden

            WriteLiteral("        \r\n    if (");
#line 193 "MethodTemplate.cshtml"
    Write(Model.RequestBody.Name);

#line default
#line hidden
            WriteLiteral(" != null && ");
#line 193 "MethodTemplate.cshtml"
                                         Write(Model.RequestBody.Name);

#line default
#line hidden
            WriteLiteral(" != Stream.Null)\r\n    {\r\n      _httpRequest.Content = new System.Net.Http.StreamC" +
"ontent(");
#line 195 "MethodTemplate.cshtml"
                                                           Write(Model.RequestBody.Name);

#line default
#line hidden
            WriteLiteral(");\r\n      _httpRequest.Content.Headers.ContentType =System.Net.Http.Headers.Media" +
"TypeHeaderValue.Parse(\"");
#line 196 "MethodTemplate.cshtml"
                                                                                                Write(Model.RequestContentType);

#line default
#line hidden
            WriteLiteral("\");\r\n    }\r\n        \r\n");
#line 199 "MethodTemplate.cshtml"
        }
        else
        {
            if (!Model.RequestBody.IsNullable())
            {

#line default
#line hidden

            WriteLiteral("    _requestContent = Microsoft.Rest.Serialization.SafeJsonConvert.SerializeObjec" +
"t(");
#line 204 "MethodTemplate.cshtml"
                                                                                 Write(Model.RequestBody.Name);

#line default
#line hidden
            WriteLiteral(", ");
#line 204 "MethodTemplate.cshtml"
                                                                                                            Write(Model.GetSerializationSettingsReference(Model.RequestBody.ModelType));

#line default
#line hidden
            WriteLiteral(");\r\n    _httpRequest.Content = new System.Net.Http.StringContent(_requestContent," +
" System.Text.Encoding.UTF8);\r\n    _httpRequest.Content.Headers.ContentType =Syst" +
"em.Net.Http.Headers.MediaTypeHeaderValue.Parse(\"");
#line 206 "MethodTemplate.cshtml"
                                                                                                Write(Model.RequestContentType);

#line default
#line hidden
            WriteLiteral("\");\r\n");
#line 207 "MethodTemplate.cshtml"
            }
            else
            {

#line default
#line hidden

            WriteLiteral("    if(");
#line 210 "MethodTemplate.cshtml"
     Write(Model.RequestBody.Name);

#line default
#line hidden
            WriteLiteral(" != null)\r\n    {\r\n        _requestContent = Microsoft.Rest.Serialization.SafeJson" +
"Convert.SerializeObject(");
#line 212 "MethodTemplate.cshtml"
                                                                                     Write(Model.RequestBody.Name);

#line default
#line hidden
            WriteLiteral(", ");
#line 212 "MethodTemplate.cshtml"
                                                                                                                Write(Model.GetSerializationSettingsReference(Model.RequestBody.ModelType));

#line default
#line hidden
            WriteLiteral(");\r\n        _httpRequest.Content = new System.Net.Http.StringContent(_requestCont" +
"ent, System.Text.Encoding.UTF8);\r\n        _httpRequest.Content.Headers.ContentTy" +
"pe =System.Net.Http.Headers.MediaTypeHeaderValue.Parse(\"");
#line 214 "MethodTemplate.cshtml"
                                                                                                    Write(Model.RequestContentType);

#line default
#line hidden
            WriteLiteral("\");\r\n    }\r\n");
#line 216 "MethodTemplate.cshtml"
            }
        }
    }
    else if (Model.LogicalParameters.Where(p => p.Location == ParameterLocation.FormData).Any())
    {

#line default
#line hidden

            WriteLiteral("        \r\n    System.Net.Http.MultipartFormDataContent _multiPartContent = new Sy" +
"stem.Net.Http.MultipartFormDataContent();\r\n        \r\n");
#line 224 "MethodTemplate.cshtml"
        foreach (ParameterCs parameter in Model.LogicalParameters.Where(p => p.Location == ParameterLocation.FormData))
        {

#line default
#line hidden

            WriteLiteral("    if (");
#line 226 "MethodTemplate.cshtml"
      Write(parameter.Name);

#line default
#line hidden
            WriteLiteral(" != null)\r\n    {\r\n");
#line 228 "MethodTemplate.cshtml"
        

#line default
#line hidden

#line 228 "MethodTemplate.cshtml"
           string localParam = "_"+ @parameter.Name.Value.Replace("this.", ""); 

#line default
#line hidden

#line 228 "MethodTemplate.cshtml"
                                                                                 
        if (parameter.ModelType.IsPrimaryType(KnownPrimaryType.Stream))
        {

#line default
#line hidden

            WriteLiteral("                \r\n         System.Net.Http.StreamContent _");
#line 232 "MethodTemplate.cshtml"
                                   Write(parameter.Name);

#line default
#line hidden
            WriteLiteral(" = new System.Net.Http.StreamContent(");
#line 232 "MethodTemplate.cshtml"
                                                                                       Write(parameter.Name);

#line default
#line hidden
            WriteLiteral(");\r\n        ");
#line 233 "MethodTemplate.cshtml"
    Write(localParam);

#line default
#line hidden
            WriteLiteral(".Headers.ContentType = new System.Net.Http.Headers.MediaTypeHeaderValue(\"applicat" +
"ion/octet-stream\");\r\n        System.IO.FileStream ");
#line 234 "MethodTemplate.cshtml"
                         Write(localParam);

#line default
#line hidden
            WriteLiteral("AsFileStream = ");
#line 234 "MethodTemplate.cshtml"
                                                    Write(parameter.Name);

#line default
#line hidden
            WriteLiteral(" as System.IO.FileStream;\r\n        if (");
#line 235 "MethodTemplate.cshtml"
        Write(localParam);

#line default
#line hidden
            WriteLiteral(@"AsFileStream != null)
        {
            System.Net.Http.Headers.ContentDispositionHeaderValue _contentDispositionHeaderValue = new System.Net.Http.Headers.ContentDispositionHeaderValue(""form-data"");
            _contentDispositionHeaderValue.Name = """);
#line 238 "MethodTemplate.cshtml"
                                               Write(parameter.SerializedName);

#line default
#line hidden
            WriteLiteral("\";\r\n            _contentDispositionHeaderValue.FileName = ");
#line 239 "MethodTemplate.cshtml"
                                                  Write(localParam);

#line default
#line hidden
            WriteLiteral("AsFileStream.Name;\r\n            ");
#line 240 "MethodTemplate.cshtml"
        Write(localParam);

#line default
#line hidden
            WriteLiteral(".Headers.ContentDisposition = _contentDispositionHeaderValue;        \r\n        } " +
"   \r\n        \r\n");
#line 243 "MethodTemplate.cshtml"
            }
            else
            {

#line default
#line hidden

            WriteLiteral("        System.Net.Http.StringContent ");
#line 246 "MethodTemplate.cshtml"
                                    Write(localParam);

#line default
#line hidden
            WriteLiteral(" = new System.Net.Http.StringContent(");
#line 246 "MethodTemplate.cshtml"
                                                                                      Write(parameter.ModelType.ToString(Model.ClientReference, parameter.Name));

#line default
#line hidden
            WriteLiteral(", System.Text.Encoding.UTF8);\r\n");
#line 247 "MethodTemplate.cshtml"
            }

#line default
#line hidden

            WriteLiteral("        _multiPartContent.Add(");
#line 248 "MethodTemplate.cshtml"
                            Write(localParam);

#line default
#line hidden
            WriteLiteral(", \"");
#line 248 "MethodTemplate.cshtml"
                                            Write(parameter.SerializedName);

#line default
#line hidden
            WriteLiteral("\");\r\n    }\r\n");
#line 250 "MethodTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("    _httpRequest.Content = _multiPartContent;\r\n");
#line 252 "MethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("\r\n");
#line 254 "MethodTemplate.cshtml"
    

#line default
#line hidden

#line 254 "MethodTemplate.cshtml"
     if (Settings.AddCredentials)
    {

#line default
#line hidden

            WriteLiteral("        \r\n    // Set Credentials\r\n    if (");
#line 258 "MethodTemplate.cshtml"
    Write(Model.ClientReference);

#line default
#line hidden
            WriteLiteral(".Credentials != null)\r\n    {\r\n        cancellationToken.ThrowIfCancellationReques" +
"ted();\r\n        await ");
#line 261 "MethodTemplate.cshtml"
          Write(Model.ClientReference);

#line default
#line hidden
            WriteLiteral(".Credentials.ProcessHttpRequestAsync(_httpRequest, cancellationToken).ConfigureAw" +
"ait(false);\r\n    }\r\n        \r\n");
#line 264 "MethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("    \r\n    // Send Request\r\n    if (_shouldTrace)\r\n    {\r\n        Microsoft.Rest.S" +
"erviceClientTracing.SendRequest(_invocationId, _httpRequest);\r\n    }\r\n\r\n    canc" +
"ellationToken.ThrowIfCancellationRequested();\r\n");
#line 273 "MethodTemplate.cshtml"
    

#line default
#line hidden

#line 273 "MethodTemplate.cshtml"
     if (Model.ReturnType.Body.IsPrimaryType(KnownPrimaryType.Stream) || Model.HttpMethod == HttpMethod.Head)
    {

#line default
#line hidden

            WriteLiteral("    _httpResponse = await ");
#line 275 "MethodTemplate.cshtml"
                        Write(Model.ClientReference);

#line default
#line hidden
            WriteLiteral(".HttpClient.SendAsync(_httpRequest, System.Net.Http.HttpCompletionOption.Response" +
"HeadersRead, cancellationToken).ConfigureAwait(false);\r\n");
#line 276 "MethodTemplate.cshtml"
    }
    else
    {

#line default
#line hidden

            WriteLiteral("    _httpResponse = await ");
#line 279 "MethodTemplate.cshtml"
                        Write(Model.ClientReference);

#line default
#line hidden
            WriteLiteral(".HttpClient.SendAsync(_httpRequest, cancellationToken).ConfigureAwait(false);\r\n");
#line 280 "MethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral(@"    if (_shouldTrace)
    {
        Microsoft.Rest.ServiceClientTracing.ReceiveResponse(_invocationId, _httpResponse);
    }

    System.Net.HttpStatusCode _statusCode = _httpResponse.StatusCode;
    cancellationToken.ThrowIfCancellationRequested();
    string _responseContent = null;

    if (");
#line 290 "MethodTemplate.cshtml"
    Write(Model.FailureStatusCodePredicate);

#line default
#line hidden
            WriteLiteral(")\r\n    {\r\n        var ex = new ");
#line 292 "MethodTemplate.cshtml"
                 Write(Model.OperationExceptionTypeString);

#line default
#line hidden
            WriteLiteral("(string.Format(\"Operation returned an invalid status code \'{0}\'\", _statusCode));\r" +
"\n");
#line 293 "MethodTemplate.cshtml"
    

#line default
#line hidden

#line 293 "MethodTemplate.cshtml"
     if (Model.DefaultResponse.Body != null)
    {

#line default
#line hidden

            WriteLiteral("        try\r\n        {\r\n");
#line 297 "MethodTemplate.cshtml"
            if (Model.DefaultResponse.Body.IsPrimaryType(KnownPrimaryType.Stream))
            {

#line default
#line hidden

            WriteLiteral("            ");
#line 299 "MethodTemplate.cshtml"
          Write(Model.DefaultResponse.Body.AsNullableType());

#line default
#line hidden
            WriteLiteral(" _errorBody = await _httpResponse.Content.ReadAsStreamAsync().ConfigureAwait(fals" +
"e);\r\n");
#line 300 "MethodTemplate.cshtml"
            }
            else
            {

#line default
#line hidden

            WriteLiteral("            _responseContent = await _httpResponse.Content.ReadAsStringAsync().Co" +
"nfigureAwait(false);\r\n            ");
#line 304 "MethodTemplate.cshtml"
          Write(Model.DefaultResponse.Body.AsNullableType());

#line default
#line hidden
            WriteLiteral(" _errorBody =  Microsoft.Rest.Serialization.SafeJsonConvert.DeserializeObject<");
#line 304 "MethodTemplate.cshtml"
                                                                                                                                      Write(Model.DefaultResponse.Body.AsNullableType());

#line default
#line hidden
            WriteLiteral(">(_responseContent, ");
#line 304 "MethodTemplate.cshtml"
                                                                                                                                                                                                        Write(Model.GetDeserializationSettingsReference(Model.DefaultResponse.Body));

#line default
#line hidden
            WriteLiteral(");\r\n");
#line 305 "MethodTemplate.cshtml"
            }

#line default
#line hidden

            WriteLiteral("            if (_errorBody != null)\r\n            {\r\n                ");
#line 308 "MethodTemplate.cshtml"
              Write(Model.InitializeExceptionWithMessage);

#line default
#line hidden
            WriteLiteral("\r\n                ex.Body = _errorBody;\r\n            }\r\n        }\r\n        catch " +
"(Newtonsoft.Json.JsonException)\r\n        {\r\n            // Ignore the exception\r" +
"\n        }\r\n");
#line 316 "MethodTemplate.cshtml"
    }
    else
    {
        //If not defined by default model, read content as string

#line default
#line hidden

            WriteLiteral("        if (_httpResponse.Content != null) {\r\n            _responseContent = awai" +
"t _httpResponse.Content.ReadAsStringAsync().ConfigureAwait(false);\r\n        }\r\n " +
"       else {\r\n            _responseContent = string.Empty;\r\n        }\r\n");
#line 326 "MethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("\r\n        ex.Request = new Microsoft.Rest.HttpRequestMessageWrapper(_httpRequest," +
" _requestContent);\r\n        ex.Response = new Microsoft.Rest.HttpResponseMessage" +
"Wrapper(_httpResponse, _responseContent);\r\n        ");
#line 330 "MethodTemplate.cshtml"
    Write(Model.InitializeException);

#line default
#line hidden
            WriteLiteral(@"
        if (_shouldTrace)
        {
            Microsoft.Rest.ServiceClientTracing.Error(_invocationId, ex);
        }

        _httpRequest.Dispose();
        if (_httpResponse != null)
        {
            _httpResponse.Dispose();
        }
        throw ex;
    }

    // Create Result
    var _result = new ");
#line 345 "MethodTemplate.cshtml"
                  Write(Model.OperationResponseReturnTypeString);

#line default
#line hidden
            WriteLiteral("();\r\n    _result.Request = _httpRequest;\r\n    _result.Response = _httpResponse;\r\n" +
"    ");
#line 348 "MethodTemplate.cshtml"
Write(Model.InitializeResponseBody);

#line default
#line hidden
            WriteLiteral("\r\n\r\n");
#line 350 "MethodTemplate.cshtml"
    

#line default
#line hidden

#line 350 "MethodTemplate.cshtml"
     foreach (var responsePair in Model.Responses.Where(r => r.Value.Body != null))
    {

#line default
#line hidden

            WriteLiteral("    \r\n    // Deserialize Response\r\n    if ((int)_statusCode == ");
#line 354 "MethodTemplate.cshtml"
                       Write(MethodCs.GetStatusCodeReference(responsePair.Key));

#line default
#line hidden
            WriteLiteral(")\r\n    {\r\n");
#line 356 "MethodTemplate.cshtml"
        

#line default
#line hidden

#line 356 "MethodTemplate.cshtml"
         if (responsePair.Value.Body.IsPrimaryType(KnownPrimaryType.Stream))
        {

#line default
#line hidden

            WriteLiteral("        _result.Body = await _httpResponse.Content.ReadAsStreamAsync().ConfigureA" +
"wait(false);\r\n");
#line 359 "MethodTemplate.cshtml"
        }
        else
        {


#line default
#line hidden

            WriteLiteral("        _responseContent = await _httpResponse.Content.ReadAsStringAsync().Config" +
"ureAwait(false);\r\n        try\r\n        {\r\n            _result.Body = Microsoft.R" +
"est.Serialization.SafeJsonConvert.DeserializeObject<");
#line 366 "MethodTemplate.cshtml"
                                                                                        Write(responsePair.Value.Body.AsNullableType());

#line default
#line hidden
            WriteLiteral(">(_responseContent, ");
#line 366 "MethodTemplate.cshtml"
                                                                                                                                                       Write(Model.GetDeserializationSettingsReference(responsePair.Value.Body));

#line default
#line hidden
            WriteLiteral(@");
        }
        catch (Newtonsoft.Json.JsonException ex)
        {
            _httpRequest.Dispose();
            if (_httpResponse != null)
            {
                _httpResponse.Dispose();
            }
            throw new Microsoft.Rest.SerializationException(""Unable to deserialize the response."", _responseContent, ex);
        }
");
#line 377 "MethodTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("    }\r\n    \r\n");
#line 380 "MethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("\r\n");
#line 382 "MethodTemplate.cshtml"
    

#line default
#line hidden

#line 382 "MethodTemplate.cshtml"
     if (Model.ReturnType.Body != null && Model.DefaultResponse.Body != null && !Model.Responses.Any())
    {
        if (Model.DefaultResponse.Body.IsPrimaryType(KnownPrimaryType.Stream))
        {

#line default
#line hidden

            WriteLiteral("    _result.Body = await _httpResponse.Content.ReadAsStreamAsync().ConfigureAwait" +
"(false);\r\n");
#line 387 "MethodTemplate.cshtml"
        }
        else
        {

#line default
#line hidden

            WriteLiteral("    string _defaultResponseContent = await _httpResponse.Content.ReadAsStringAsyn" +
"c().ConfigureAwait(false);\r\n    try\r\n    {\r\n        _result.Body = Microsoft.Res" +
"t.Serialization.SafeJsonConvert.DeserializeObject<");
#line 393 "MethodTemplate.cshtml"
                                                                                    Write(Model.DefaultResponse.Body.AsNullableType());

#line default
#line hidden
            WriteLiteral(">(_defaultResponseContent, ");
#line 393 "MethodTemplate.cshtml"
                                                                                                                                                             Write(Model.GetDeserializationSettingsReference(Model.DefaultResponse.Body));

#line default
#line hidden
            WriteLiteral(@");
    }
    catch (Newtonsoft.Json.JsonException ex)
    {
        _httpRequest.Dispose();
        if (_httpResponse != null)
        {
            _httpResponse.Dispose();
        }
        throw new Microsoft.Rest.SerializationException(""Unable to deserialize the response."", _defaultResponseContent, ex);
    }
");
#line 404 "MethodTemplate.cshtml"
        }
    }

#line default
#line hidden

            WriteLiteral("\r\n");
#line 407 "MethodTemplate.cshtml"
    

#line default
#line hidden

#line 407 "MethodTemplate.cshtml"
     if (Model.ReturnType.Headers != null)
    {


#line default
#line hidden

            WriteLiteral("    try\r\n    {\r\n        _result.Headers = _httpResponse.GetHeadersAsJson().ToObje" +
"ct<");
#line 412 "MethodTemplate.cshtml"
                                                                  Write(Model.ReturnType.Headers.Name);

#line default
#line hidden
            WriteLiteral(">(Newtonsoft.Json.JsonSerializer.Create(");
#line 412 "MethodTemplate.cshtml"
                                                                                                                                          Write(Model.GetDeserializationSettingsReference(Model.DefaultResponse.Body));

#line default
#line hidden
            WriteLiteral(@"));
    }
    catch (Newtonsoft.Json.JsonException ex)
    {
        _httpRequest.Dispose();
        if (_httpResponse != null)
        {
            _httpResponse.Dispose();
        }
        throw new Microsoft.Rest.SerializationException(""Unable to deserialize the headers."", _httpResponse.GetHeadersAsJson().ToString(), ex);
    }
");
#line 423 "MethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("\r\n    if (_shouldTrace)\r\n    {\r\n        Microsoft.Rest.ServiceClientTracing.Exit(" +
"_invocationId, _result);\r\n    }\r\n\r\n    return _result;\r\n}\r\n");
        }
        #pragma warning restore 1998
    }
}
