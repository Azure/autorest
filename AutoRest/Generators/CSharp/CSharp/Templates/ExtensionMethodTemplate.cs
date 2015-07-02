// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest.Generator.CSharp.Templates
{
#line 1 "ExtensionMethodTemplate.cshtml"
using System.Text

#line default
#line hidden
    ;
#line 2 "ExtensionMethodTemplate.cshtml"
using Microsoft.Rest.Generator.CSharp

#line default
#line hidden
    ;
#line 3 "ExtensionMethodTemplate.cshtml"
using Microsoft.Rest.Generator.CSharp.Templates

#line default
#line hidden
    ;
#line 4 "ExtensionMethodTemplate.cshtml"
using Microsoft.Rest.Generator.CSharp.TemplateModels

#line default
#line hidden
    ;
#line 5 "ExtensionMethodTemplate.cshtml"
using Microsoft.Rest.Generator.Utilities

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class ExtensionMethodTemplate : Microsoft.Rest.Generator.Template<Microsoft.Rest.Generator.CSharp.MethodTemplateModel>
    {
        #line hidden
        public ExtensionMethodTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
#line 8 "ExtensionMethodTemplate.cshtml"
  

#line default
#line hidden

            WriteLiteral("/// <summary>\r\n");
#line 10 "ExtensionMethodTemplate.cshtml"
Write(WrapComment("/// ", Model.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n/// </summary>\r\n/// <param name=\'operations\'>\r\n/// The operations group for thi" +
"s extension method\r\n/// </param>\r\n");
#line 15 "ExtensionMethodTemplate.cshtml"
foreach (var parameter in Model.Parameters)
{

#line default
#line hidden

            WriteLiteral("/// <param name=\'");
#line 17 "ExtensionMethodTemplate.cshtml"
              Write(parameter.Name);

#line default
#line hidden
            WriteLiteral("\'>\r\n");
#line 18 "ExtensionMethodTemplate.cshtml"
Write(WrapComment("/// ", parameter.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n/// </param>\r\n");
#line 20 "ExtensionMethodTemplate.cshtml"
}

#line default
#line hidden

            WriteLiteral("public static ");
#line 21 "ExtensionMethodTemplate.cshtml"
           Write(Model.ReturnTypeString);

#line default
#line hidden
            WriteLiteral(" ");
#line 21 "ExtensionMethodTemplate.cshtml"
                                    Write(Model.Name);

#line default
#line hidden
            WriteLiteral("(");
#line 21 "ExtensionMethodTemplate.cshtml"
                                                 Write(Model.GetExtensionParameters(Model.SyncMethodParameterDeclaration));

#line default
#line hidden
            WriteLiteral(")\r\n{\r\n");
#line 23 "ExtensionMethodTemplate.cshtml"
    if (Model.ReturnType != null)
    {

#line default
#line hidden

            WriteLiteral("    return Task.Factory.StartNew(s => ((I");
#line 25 "ExtensionMethodTemplate.cshtml"
                                       Write(Model.MethodGroupName);

#line default
#line hidden
            WriteLiteral(")s).");
#line 25 "ExtensionMethodTemplate.cshtml"
                                                                   Write(Model.Name);

#line default
#line hidden
            WriteLiteral("Async(");
#line 25 "ExtensionMethodTemplate.cshtml"
                                                                                      Write(Model.SyncMethodInvocationArgs);

#line default
#line hidden
            WriteLiteral("), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.De" +
"fault).Unwrap().GetAwaiter().GetResult();\r\n");
#line 26 "ExtensionMethodTemplate.cshtml"
    }
    else
    {

#line default
#line hidden

            WriteLiteral("    Task.Factory.StartNew(s => ((I");
#line 29 "ExtensionMethodTemplate.cshtml"
                                Write(Model.MethodGroupName);

#line default
#line hidden
            WriteLiteral(")s).");
#line 29 "ExtensionMethodTemplate.cshtml"
                                                            Write(Model.Name);

#line default
#line hidden
            WriteLiteral("Async(");
#line 29 "ExtensionMethodTemplate.cshtml"
                                                                               Write(Model.SyncMethodInvocationArgs);

#line default
#line hidden
            WriteLiteral("), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.De" +
"fault).Unwrap().GetAwaiter().GetResult();\r\n");
#line 30 "ExtensionMethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("}\r\n");
#line 32 "ExtensionMethodTemplate.cshtml"

#line default
#line hidden

#line 32 "ExtensionMethodTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
#line 32 "ExtensionMethodTemplate.cshtml"
          

#line default
#line hidden

            WriteLiteral("/// <summary>\r\n");
#line 34 "ExtensionMethodTemplate.cshtml"
Write(WrapComment("/// ", Model.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n/// </summary>\r\n/// <param name=\'operations\'>\r\n/// The operations group for thi" +
"s extension method\r\n/// </param>\r\n");
#line 39 "ExtensionMethodTemplate.cshtml"
foreach (var parameter in Model.Parameters)
{

#line default
#line hidden

            WriteLiteral("/// <param name=\'");
#line 41 "ExtensionMethodTemplate.cshtml"
              Write(parameter.Name);

#line default
#line hidden
            WriteLiteral("\'>\r\n");
#line 42 "ExtensionMethodTemplate.cshtml"
Write(WrapComment("/// ", parameter.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n/// </param>\r\n");
#line 44 "ExtensionMethodTemplate.cshtml"
}

#line default
#line hidden

            WriteLiteral("/// <param name=\'cancellationToken\'>\r\n/// Cancellation token.\r\n/// </param>\r\npubl" +
"ic static async ");
#line 48 "ExtensionMethodTemplate.cshtml"
                 Write(Model.TaskExtensionReturnTypeString);

#line default
#line hidden
            WriteLiteral(" ");
#line 48 "ExtensionMethodTemplate.cshtml"
                                                       Write(Model.Name);

#line default
#line hidden
            WriteLiteral("Async( ");
#line 48 "ExtensionMethodTemplate.cshtml"
                                                                          Write(Model.GetExtensionParameters(Model.GetAsyncMethodParameterDeclaration()));

#line default
#line hidden
            WriteLiteral(")\r\n{\r\n");
#line 50 "ExtensionMethodTemplate.cshtml"
    if (Model.ReturnType != null)
    {

#line default
#line hidden

            WriteLiteral("    ");
#line 52 "ExtensionMethodTemplate.cshtml"
 Write(Model.OperationResponseReturnTypeString);

#line default
#line hidden
            WriteLiteral(" result = await operations.");
#line 52 "ExtensionMethodTemplate.cshtml"
                                                                     Write(Model.Name);

#line default
#line hidden
            WriteLiteral("WithOperationResponseAsync(");
#line 52 "ExtensionMethodTemplate.cshtml"
                                                                                                             Write(Model.GetAsyncMethodInvocationArgs("null"));

#line default
#line hidden
            WriteLiteral(").ConfigureAwait(false);\r\n    return result.Body;\r\n");
#line 54 "ExtensionMethodTemplate.cshtml"
    }
    else
    {

#line default
#line hidden

            WriteLiteral("    await operations.");
#line 57 "ExtensionMethodTemplate.cshtml"
                   Write(Model.Name);

#line default
#line hidden
            WriteLiteral("WithOperationResponseAsync(");
#line 57 "ExtensionMethodTemplate.cshtml"
                                                           Write(Model.GetAsyncMethodInvocationArgs("null"));

#line default
#line hidden
            WriteLiteral(").ConfigureAwait(false);\r\n");
#line 58 "ExtensionMethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("}\r\n\r\n");
#line 61 "ExtensionMethodTemplate.cshtml"

#line default
#line hidden

        }
        #pragma warning restore 1998
    }
}
