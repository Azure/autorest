// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest.Generator.CSharp.Azure.Templates
{
#line 1 "AzureMethodTemplate.cshtml"
using Microsoft.Rest.Generator.CSharp

#line default
#line hidden
    ;
#line 2 "AzureMethodTemplate.cshtml"
using Microsoft.Rest.Generator.CSharp.Templates

#line default
#line hidden
    ;
#line 3 "AzureMethodTemplate.cshtml"
using Microsoft.Rest.Generator.CSharp.TemplateModels

#line default
#line hidden
    ;
#line 4 "AzureMethodTemplate.cshtml"
using Microsoft.Rest.Generator.CSharp.Azure

#line default
#line hidden
    ;
#line 5 "AzureMethodTemplate.cshtml"
using Microsoft.Rest.Generator.CSharp.Azure.Templates

#line default
#line hidden
    ;
#line 6 "AzureMethodTemplate.cshtml"
using Microsoft.Rest.Generator.Utilities

#line default
#line hidden
    ;
#line 7 "AzureMethodTemplate.cshtml"
using Microsoft.Rest.Generator.ClientModel

#line default
#line hidden
    ;
#line 8 "AzureMethodTemplate.cshtml"
using System.Linq

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class AzureMethodTemplate : Microsoft.Rest.Generator.Template<Microsoft.Rest.Generator.CSharp.Azure.AzureMethodTemplateModel>
    {
        #line hidden
        public AzureMethodTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
#line 11 "AzureMethodTemplate.cshtml"
 if (!Model.IsLongRunningOperation)
{

#line default
#line hidden

#line 13 "AzureMethodTemplate.cshtml"
Write(Include(new MethodTemplate(), (MethodTemplateModel)Model));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 14 "AzureMethodTemplate.cshtml"
}
else if (Model.HttpMethod == HttpMethod.Post || Model.HttpMethod == HttpMethod.Delete)
{

#line default
#line hidden

            WriteLiteral("/// <summary>\r\n");
#line 18 "AzureMethodTemplate.cshtml"

#line default
#line hidden

#line 18 "AzureMethodTemplate.cshtml"
Write(WrapComment("/// ", Model.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n/// </summary>\r\n");
#line 20 "AzureMethodTemplate.cshtml"

#line default
#line hidden

#line 20 "AzureMethodTemplate.cshtml"
 foreach (var parameter in Model.Parameters)
{

#line default
#line hidden

            WriteLiteral("/// <param name=\'");
#line 22 "AzureMethodTemplate.cshtml"
              Write(parameter.Name);

#line default
#line hidden
            WriteLiteral("\'>\r\n");
#line 23 "AzureMethodTemplate.cshtml"

#line default
#line hidden

#line 23 "AzureMethodTemplate.cshtml"
Write(WrapComment("/// ", parameter.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n/// </param>    \r\n");
#line 25 "AzureMethodTemplate.cshtml"
}

#line default
#line hidden

#line 25 "AzureMethodTemplate.cshtml"
 

#line default
#line hidden

            WriteLiteral("/// <param name=\'cancellationToken\'>\r\n/// Cancellation token.\r\n/// </param>\r\n\r\npu" +
"blic async Task<");
#line 30 "AzureMethodTemplate.cshtml"
              Write(Model.OperationResponseReturnTypeString);

#line default
#line hidden
            WriteLiteral("> ");
#line 30 "AzureMethodTemplate.cshtml"
                                                          Write(Model.Name);

#line default
#line hidden
            WriteLiteral("WithOperationResponseAsync(");
#line 30 "AzureMethodTemplate.cshtml"
                                                                                                  Write(Model.AsyncMethodParameterDeclaration);

#line default
#line hidden
            WriteLiteral(")\r\n{\r\n    // Send request\r\n    ");
#line 33 "AzureMethodTemplate.cshtml"
Write(Model.OperationResponseReturnTypeString);

#line default
#line hidden
            WriteLiteral(" response = await Begin");
#line 33 "AzureMethodTemplate.cshtml"
                                                                 Write(Model.Name);

#line default
#line hidden
            WriteLiteral("WithOperationResponseAsync(\r\n        ");
#line 34 "AzureMethodTemplate.cshtml"
    Write(Model.AsyncMethodInvocationArgs);

#line default
#line hidden
            WriteLiteral(");\r\n\r\n    return await ");
#line 36 "AzureMethodTemplate.cshtml"
             Write(Model.ClientReference);

#line default
#line hidden
            WriteLiteral(".GetPostOrDeleteOperationResultAsync(response, cancellationToken);\r\n}\r\n\r\n");
#line 39 "AzureMethodTemplate.cshtml"
}
else if (Model.HttpMethod == HttpMethod.Put)
{

#line default
#line hidden

            WriteLiteral("/// <summary>\r\n");
#line 43 "AzureMethodTemplate.cshtml"

#line default
#line hidden

#line 43 "AzureMethodTemplate.cshtml"
Write(WrapComment("/// ", Model.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n/// </summary>\r\n");
#line 45 "AzureMethodTemplate.cshtml"

#line default
#line hidden

#line 45 "AzureMethodTemplate.cshtml"
 foreach (var parameter in Model.Parameters)
{

#line default
#line hidden

            WriteLiteral("/// <param name=\'");
#line 47 "AzureMethodTemplate.cshtml"
              Write(parameter.Name);

#line default
#line hidden
            WriteLiteral("\'>\r\n");
#line 48 "AzureMethodTemplate.cshtml"

#line default
#line hidden

#line 48 "AzureMethodTemplate.cshtml"
Write(WrapComment("/// ", parameter.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n/// </param>    \r\n");
#line 50 "AzureMethodTemplate.cshtml"
}

#line default
#line hidden

#line 50 "AzureMethodTemplate.cshtml"
 

#line default
#line hidden

            WriteLiteral("/// <param name=\'cancellationToken\'>\r\n/// Cancellation token.\r\n/// </param>\r\n\r\npu" +
"blic async Task<");
#line 55 "AzureMethodTemplate.cshtml"
              Write(Model.OperationResponseReturnTypeString);

#line default
#line hidden
            WriteLiteral("> ");
#line 55 "AzureMethodTemplate.cshtml"
                                                          Write(Model.Name);

#line default
#line hidden
            WriteLiteral("WithOperationResponseAsync(");
#line 55 "AzureMethodTemplate.cshtml"
                                                                                                  Write(Model.AsyncMethodParameterDeclaration);

#line default
#line hidden
            WriteLiteral(")\r\n{\r\n    // Send Request\r\n    ");
#line 58 "AzureMethodTemplate.cshtml"
Write(Model.OperationResponseReturnTypeString);

#line default
#line hidden
            WriteLiteral(" response = await Begin");
#line 58 "AzureMethodTemplate.cshtml"
                                                                 Write(Model.Name);

#line default
#line hidden
            WriteLiteral("WithOperationResponseAsync(\r\n        ");
#line 59 "AzureMethodTemplate.cshtml"
    Write(Model.AsyncMethodInvocationArgs);

#line default
#line hidden
            WriteLiteral(");\r\n\r\n    return await ");
#line 61 "AzureMethodTemplate.cshtml"
             Write(Model.ClientReference);

#line default
#line hidden
            WriteLiteral(".GetPutOperationResultAsync<");
#line 61 "AzureMethodTemplate.cshtml"
                                                                 Write(Model.ReturnType.Name);

#line default
#line hidden
            WriteLiteral(">(response, \r\n        () => ");
#line 62 "AzureMethodTemplate.cshtml"
          Write(Model.GetMethod.Name);

#line default
#line hidden
            WriteLiteral("WithOperationResponseAsync(");
#line 62 "AzureMethodTemplate.cshtml"
                                                            Write(Model.GetMethod.AsyncMethodInvocationArgs);

#line default
#line hidden
            WriteLiteral("),\r\n        cancellationToken);\r\n}\r\n\r\n");
#line 66 "AzureMethodTemplate.cshtml"
}

#line default
#line hidden

        }
        #pragma warning restore 1998
    }
}
