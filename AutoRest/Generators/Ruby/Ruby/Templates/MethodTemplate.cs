// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest.Generator.Ruby.Templates
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
using Microsoft.Rest.Generator.Ruby.TemplateModels

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class MethodTemplate : Microsoft.Rest.Generator.Template<Microsoft.Rest.Generator.Ruby.MethodTemplateModel>
    {
        #line hidden
        public MethodTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
            WriteLiteral("#\r\n");
#line 7 "MethodTemplate.cshtml"
Write(WrapComment("# ", Model.Documentation));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 8 "MethodTemplate.cshtml"
 foreach (var parameter in Model.Parameters)
{

#line default
#line hidden

#line 10 "MethodTemplate.cshtml"
Write(WrapComment("# ", string.Format("@param {0} {1}{2}", parameter.Name, parameter.Type.GetYardDocumentation(), parameter.Documentation)));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 11 "MethodTemplate.cshtml"
}

#line default
#line hidden

#line 12 "MethodTemplate.cshtml"
Write(WrapComment("# ", string.Format("@return [{0}] Promise object which allows to get HTTP response.", "Concurrent::Promise")));

#line default
#line hidden
            WriteLiteral("\r\n#\r\ndef ");
#line 14 "MethodTemplate.cshtml"
Write(Model.Name);

#line default
#line hidden
            WriteLiteral("(");
#line 14 "MethodTemplate.cshtml"
              Write(Model.MethodParameterDeclaration);

#line default
#line hidden
            WriteLiteral(")\r\n");
#line 15 "MethodTemplate.cshtml"
  

#line default
#line hidden

#line 15 "MethodTemplate.cshtml"
   foreach (var parameter in Model.ParameterTemplateModels)
  {
    if (parameter.IsRequired)
    {

#line default
#line hidden

            WriteLiteral("  fail ArgumentError, \'");
#line 19 "MethodTemplate.cshtml"
                    Write(parameter.Name);

#line default
#line hidden
            WriteLiteral(" is nil\' if ");
#line 19 "MethodTemplate.cshtml"
                                                Write(parameter.Name);

#line default
#line hidden
            WriteLiteral(".nil?\r\n  \r\n");
#line 21 "MethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("  ");
#line 22 "MethodTemplate.cshtml"
Write(parameter.Type.ValidateType(Model.Scope, parameter.Name));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 23 "MethodTemplate.cshtml"
  }

#line default
#line hidden

            WriteLiteral("\r\n  # Construct URL\r\n  path = \"");
#line 26 "MethodTemplate.cshtml"
     Write(Model.Url);

#line default
#line hidden
            WriteLiteral("\"\r\n  ");
#line 27 "MethodTemplate.cshtml"
Write(Model.BuildUrl("path", "url"));

#line default
#line hidden
            WriteLiteral("\r\n  ");
#line 28 "MethodTemplate.cshtml"
Write(Model.RemoveDuplicateForwardSlashes("url"));

#line default
#line hidden
            WriteLiteral("\r\n\r\n  ");
#line 30 "MethodTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n  # Create HTTP transport objects\r\n  http_request = Net::HTTP::");
#line 32 "MethodTemplate.cshtml"
                        Write(Model.HttpMethod.ToString());

#line default
#line hidden
            WriteLiteral(".new(url.request_uri)\r\n\r\n");
#line 34 "MethodTemplate.cshtml"
  

#line default
#line hidden

#line 34 "MethodTemplate.cshtml"
   if (Model.Parameters.Any(p => p.Location == ParameterLocation.Header))
  {
  

#line default
#line hidden

#line 36 "MethodTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
#line 36 "MethodTemplate.cshtml"
            

#line default
#line hidden

            WriteLiteral("  # Set Headers\r\n  ");
#line 38 "MethodTemplate.cshtml"
Write(Model.SetDefaultHeaders);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 39 "MethodTemplate.cshtml"
    foreach (var parameter in Model.Parameters.Where(p => p.Location == ParameterLocation.Header))
    {
        if (parameter.SerializedName.ToLower() == "Content-Type".ToLower())
        {

#line default
#line hidden

            WriteLiteral("  fail RuntimeError, \'Header Content-Type is forbidden to change\'\r\n");
#line 44 "MethodTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("  http_request[\"");
#line 45 "MethodTemplate.cshtml"
              Write(parameter.SerializedName);

#line default
#line hidden
            WriteLiteral("\"] = ");
#line 45 "MethodTemplate.cshtml"
                                             Write(parameter.Type.ToString(parameter.Name));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 46 "MethodTemplate.cshtml"
    }
  }

#line default
#line hidden

            WriteLiteral("  ");
#line 48 "MethodTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n  unless custom_headers.nil?\r\n    custom_headers.each do |key, value|\r\n      ht" +
"tp_request[key] = value\r\n    end\r\n  end\r\n\r\n");
#line 55 "MethodTemplate.cshtml"
 if (Model.RequestBody != null)
  {
  

#line default
#line hidden

#line 57 "MethodTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
#line 57 "MethodTemplate.cshtml"
            

#line default
#line hidden

            WriteLiteral("  # Serialize Request\r\n  http_request.add_field(\'Content-Type\', \'application/json" +
"\')\r\n  ");
#line 60 "MethodTemplate.cshtml"
Write(Model.CreateSerializationString(Model.RequestBody.Name, Model.RequestBody.Type, "http_request.body", Settings.Namespace));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 61 "MethodTemplate.cshtml"
  }

#line default
#line hidden

            WriteLiteral("\r\n  ");
#line 63 "MethodTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n  # Send Request\r\n  promise = Concurrent::Promise.new { ");
#line 65 "MethodTemplate.cshtml"
                                  Write(Model.MakeRequestMethodReference);

#line default
#line hidden
            WriteLiteral("(http_request, url) }\r\n\r\n  ");
#line 67 "MethodTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n  promise = promise.then do |http_response|\r\n    status_code = http_response.co" +
"de.to_i\r\n    response_content = http_response.body\r\n    unless (");
#line 71 "MethodTemplate.cshtml"
       Write(Model.SuccessStatusCodePredicate);

#line default
#line hidden
            WriteLiteral(")\r\n");
#line 72 "MethodTemplate.cshtml"
      

#line default
#line hidden

#line 72 "MethodTemplate.cshtml"
       if (Model.DefaultResponse != null)
      {

#line default
#line hidden

            WriteLiteral("      error_model = JSON.load(response_content)\r\n      fail ");
#line 75 "MethodTemplate.cshtml"
         Write(Model.OperationExceptionTypeString);

#line default
#line hidden
            WriteLiteral(".new(http_request, http_response, error_model)\r\n");
#line 76 "MethodTemplate.cshtml"
      }
      else
      {

#line default
#line hidden

            WriteLiteral("      fail ");
#line 79 "MethodTemplate.cshtml"
         Write(Model.OperationExceptionTypeString);

#line default
#line hidden
            WriteLiteral(".new(http_request, http_response)\r\n");
#line 80 "MethodTemplate.cshtml"
      }

#line default
#line hidden

            WriteLiteral("    end\r\n\r\n    ");
#line 83 "MethodTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n    # Create Result\r\n    result = ");
#line 85 "MethodTemplate.cshtml"
         Write(Model.OperationResponseReturnTypeString);

#line default
#line hidden
            WriteLiteral(".new(http_request, http_response)\r\n    ");
#line 86 "MethodTemplate.cshtml"
Write(Model.InitializeResponseBody);

#line default
#line hidden
            WriteLiteral("\r\n\r\n");
#line 88 "MethodTemplate.cshtml"
    

#line default
#line hidden

#line 88 "MethodTemplate.cshtml"
     foreach (var responsePair in Model.Responses.Where(r => r.Value != null && r.Value.IsSerializable()))
    {

#line default
#line hidden

            WriteLiteral("    \r\n    # Deserialize Response\r\n    if status_code == ");
#line 92 "MethodTemplate.cshtml"
                 Write(Model.GetStatusCodeReference(responsePair.Key));

#line default
#line hidden
            WriteLiteral("\r\n      begin\r\n        ");
#line 94 "MethodTemplate.cshtml"
    Write(Model.CreateDeserializationString("response_content", Model.ReturnType, "result.body", Settings.Namespace));

#line default
#line hidden
            WriteLiteral("\r\n      rescue Exception => e\r\n        fail MsRest::DeserializationError.new(\"Err" +
"or occured in deserializing the response\", e.message, e.backtrace, response_cont" +
"ent)\r\n      end\r\n    end\r\n    \r\n");
#line 100 "MethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("\r\n");
#line 102 "MethodTemplate.cshtml"
    

#line default
#line hidden

#line 102 "MethodTemplate.cshtml"
     if (Model.ReturnType != null && Model.DefaultResponse != null && !Model.Responses.Any() && Model.DefaultResponse.IsSerializable())
    {

#line default
#line hidden

            WriteLiteral("    \r\n    begin\r\n      ");
#line 106 "MethodTemplate.cshtml"
  Write(Model.CreateDeserializationString("response_content", Model.ReturnType, "result.body", Settings.Namespace));

#line default
#line hidden
            WriteLiteral("\r\n    rescue Exception => e\r\n      fail MsRest::DeserializationError.new(\"Error o" +
"ccured in deserializing the response\", e.message, e.backtrace, response_content)" +
"\r\n    end\r\n    \r\n");
#line 111 "MethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("\r\n    ");
#line 113 "MethodTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n    result\r\n  end\r\n\r\n  ");
#line 117 "MethodTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n  promise.execute\r\nend\r\n");
        }
        #pragma warning restore 1998
    }
}
