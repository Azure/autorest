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
#line 7 "ExtensionMethodTemplate.cshtml"
  

#line default
#line hidden

            WriteLiteral("/// <summary>\r\n");
#line 9 "ExtensionMethodTemplate.cshtml"
Write(WrapComment("/// ", Model.Documentation));

#line default
#line hidden
            WriteLiteral("\r\n/// </summary>\r\n/// <param name=\'operations\'>\r\n/// The operations group for thi" +
"s extension method\r\n/// </param>\r\n");
#line 14 "ExtensionMethodTemplate.cshtml"
foreach (var parameter in Model.Parameters)
{

#line default
#line hidden

            WriteLiteral("/// <param name=\'");
#line 16 "ExtensionMethodTemplate.cshtml"
              Write(parameter.Name);

#line default
#line hidden
            WriteLiteral("\'>\r\n");
#line 17 "ExtensionMethodTemplate.cshtml"
Write(WrapComment("/// ", parameter.Documentation));

#line default
#line hidden
            WriteLiteral("\r\n/// </param>\r\n");
#line 19 "ExtensionMethodTemplate.cshtml"
}

#line default
#line hidden

            WriteLiteral("public static ");
#line 20 "ExtensionMethodTemplate.cshtml"
           Write(Model.ReturnTypeString);

#line default
#line hidden
            WriteLiteral(" ");
#line 20 "ExtensionMethodTemplate.cshtml"
                                    Write(Model.Name);

#line default
#line hidden
            WriteLiteral("(");
#line 20 "ExtensionMethodTemplate.cshtml"
                                                 Write(Model.GetExtensionParameters(Model.SyncMethodParameterDeclaration));

#line default
#line hidden
            WriteLiteral(")\r\n{\r\n");
#line 22 "ExtensionMethodTemplate.cshtml"
    if (Model.ReturnType != null)
    {

#line default
#line hidden

            WriteLiteral("    return Task.Factory.StartNew(s => ((I");
#line 24 "ExtensionMethodTemplate.cshtml"
                                       Write(Model.MethodGroupName);

#line default
#line hidden
            WriteLiteral(")s).");
#line 24 "ExtensionMethodTemplate.cshtml"
                                                                   Write(Model.Name);

#line default
#line hidden
            WriteLiteral("Async(");
#line 24 "ExtensionMethodTemplate.cshtml"
                                                                                      Write(Model.SyncMethodInvocationArgs);

#line default
#line hidden
            WriteLiteral("), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.De" +
"fault).Unwrap().GetAwaiter().GetResult();\r\n");
#line 25 "ExtensionMethodTemplate.cshtml"
    }
    else
    {

#line default
#line hidden

            WriteLiteral("    Task.Factory.StartNew(s => ((I");
#line 28 "ExtensionMethodTemplate.cshtml"
                                Write(Model.MethodGroupName);

#line default
#line hidden
            WriteLiteral(")s).");
#line 28 "ExtensionMethodTemplate.cshtml"
                                                            Write(Model.Name);

#line default
#line hidden
            WriteLiteral("Async(");
#line 28 "ExtensionMethodTemplate.cshtml"
                                                                               Write(Model.SyncMethodInvocationArgs);

#line default
#line hidden
            WriteLiteral("), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.De" +
"fault).Unwrap().GetAwaiter().GetResult();\r\n");
#line 29 "ExtensionMethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("}\r\n");
#line 31 "ExtensionMethodTemplate.cshtml"

#line default
#line hidden

#line 31 "ExtensionMethodTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
#line 31 "ExtensionMethodTemplate.cshtml"
          

#line default
#line hidden

            WriteLiteral("/// <summary>\r\n");
#line 33 "ExtensionMethodTemplate.cshtml"
Write(WrapComment("/// ", Model.Documentation));

#line default
#line hidden
            WriteLiteral("\r\n/// </summary>\r\n/// <param name=\'operations\'>\r\n/// The operations group for thi" +
"s extension method\r\n/// </param>\r\n");
#line 38 "ExtensionMethodTemplate.cshtml"
foreach (var parameter in Model.Parameters)
{

#line default
#line hidden

            WriteLiteral("/// <param name=\'");
#line 40 "ExtensionMethodTemplate.cshtml"
              Write(parameter.Name);

#line default
#line hidden
            WriteLiteral("\'>\r\n");
#line 41 "ExtensionMethodTemplate.cshtml"
Write(WrapComment("/// ", parameter.Documentation));

#line default
#line hidden
            WriteLiteral("\r\n/// </param>\r\n");
#line 43 "ExtensionMethodTemplate.cshtml"
}

#line default
#line hidden

            WriteLiteral("/// <param name=\'cancellationToken\'>\r\n/// Cancellation token.\r\n/// </param>\r\npubl" +
"ic static async ");
#line 47 "ExtensionMethodTemplate.cshtml"
                 Write(Model.TaskExtensionReturnTypeString);

#line default
#line hidden
            WriteLiteral(" ");
#line 47 "ExtensionMethodTemplate.cshtml"
                                                       Write(Model.Name);

#line default
#line hidden
            WriteLiteral("Async( ");
#line 47 "ExtensionMethodTemplate.cshtml"
                                                                          Write(Model.GetExtensionParameters(Model.AsyncMethodParameterDeclaration));

#line default
#line hidden
            WriteLiteral(")\r\n{\r\n");
#line 49 "ExtensionMethodTemplate.cshtml"
    if (Model.ReturnType != null)
    {

#line default
#line hidden

            WriteLiteral("    ");
#line 51 "ExtensionMethodTemplate.cshtml"
 Write(Model.OperationResponseReturnTypeString);

#line default
#line hidden
            WriteLiteral(" result = await operations.");
#line 51 "ExtensionMethodTemplate.cshtml"
                                                                     Write(Model.Name);

#line default
#line hidden
            WriteLiteral("WithOperationResponseAsync(");
#line 51 "ExtensionMethodTemplate.cshtml"
                                                                                                             Write(Model.AsyncMethodInvocationArgs);

#line default
#line hidden
            WriteLiteral(").ConfigureAwait(false);\r\n    return result.Body;\r\n");
#line 53 "ExtensionMethodTemplate.cshtml"
    }
    else
    {

#line default
#line hidden

            WriteLiteral("    await operations.");
#line 56 "ExtensionMethodTemplate.cshtml"
                   Write(Model.Name);

#line default
#line hidden
            WriteLiteral("WithOperationResponseAsync(");
#line 56 "ExtensionMethodTemplate.cshtml"
                                                           Write(Model.AsyncMethodInvocationArgs);

#line default
#line hidden
            WriteLiteral(").ConfigureAwait(false);\r\n");
#line 57 "ExtensionMethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("}\r\n\r\n");
#line 60 "ExtensionMethodTemplate.cshtml"

#line default
#line hidden

        }
        #pragma warning restore 1998
    }
}
