// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace AutoRest.CSharp.Templates.Rest.Common
{
#line 1 "ExtensionMethodTemplate.cshtml"
using System.Text

#line default
#line hidden
    ;
#line 2 "ExtensionMethodTemplate.cshtml"
using System

#line default
#line hidden
    ;
#line 3 "ExtensionMethodTemplate.cshtml"
using AutoRest.Core.Model

#line default
#line hidden
    ;
#line 4 "ExtensionMethodTemplate.cshtml"
using AutoRest.Core.Utilities

#line default
#line hidden
    ;
#line 5 "ExtensionMethodTemplate.cshtml"
using AutoRest.CSharp

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class ExtensionMethodTemplate : AutoRest.Core.Template<AutoRest.CSharp.Model.MethodCs>
    {
        #line hidden
        public ExtensionMethodTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
#line 7 "ExtensionMethodTemplate.cshtml"
  
if (Model.SyncMethods == SyncMethodsGenerationMode.All || Model.SyncMethods == SyncMethodsGenerationMode.Essential)
{
    if (!String.IsNullOrEmpty(Model.Description) || !String.IsNullOrEmpty(Model.Summary))
    {

#line default
#line hidden

            WriteLiteral("/// <summary>\r\n");
#line 13 "ExtensionMethodTemplate.cshtml"
Write(WrapComment("/// ", String.IsNullOrEmpty(Model.Summary) ? Model.Description.EscapeXmlComment() : Model.Summary.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 14 "ExtensionMethodTemplate.cshtml"
        if (!String.IsNullOrEmpty(Model.ExternalDocsUrl))
        {

#line default
#line hidden

            WriteLiteral("/// <see href=\"");
#line 16 "ExtensionMethodTemplate.cshtml"
            Write(Model.ExternalDocsUrl);

#line default
#line hidden
            WriteLiteral("\" />\r\n");
#line 17 "ExtensionMethodTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("/// </summary>\r\n");
#line 19 "ExtensionMethodTemplate.cshtml"
    }
    if (!String.IsNullOrEmpty(Model.Description) && !String.IsNullOrEmpty(Model.Summary))
    {

#line default
#line hidden

            WriteLiteral("/// <remarks>\r\n");
#line 23 "ExtensionMethodTemplate.cshtml"
Write(WrapComment("/// ", Model.Description.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n/// </remarks>\r\n");
#line 25 "ExtensionMethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("/// <param name=\'operations\'>\r\n/// The operations group for this extension method" +
".\r\n/// </param>\r\n");
#line 29 "ExtensionMethodTemplate.cshtml"
    foreach (var parameter in Model.LocalParameters)
    {

#line default
#line hidden

            WriteLiteral("/// <param name=\'");
#line 31 "ExtensionMethodTemplate.cshtml"
              Write(parameter.Name);

#line default
#line hidden
            WriteLiteral("\'>\r\n");
#line 32 "ExtensionMethodTemplate.cshtml"
Write(WrapComment("/// ", parameter.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n/// </param>\r\n");
#line 34 "ExtensionMethodTemplate.cshtml"
    }

#line default
#line hidden

#line 35 "ExtensionMethodTemplate.cshtml"
 if (Model.Deprecated)
{

#line default
#line hidden

            WriteLiteral("[System.Obsolete()]\r\n");
#line 38 "ExtensionMethodTemplate.cshtml"
}

#line default
#line hidden

#line 38 "ExtensionMethodTemplate.cshtml"
 

#line default
#line hidden

            WriteLiteral("public static ");
#line 39 "ExtensionMethodTemplate.cshtml"
           Write(Model.ReturnTypeString);

#line default
#line hidden
            WriteLiteral(" ");
#line 39 "ExtensionMethodTemplate.cshtml"
                                    Write(Model.Name);

#line default
#line hidden
            WriteLiteral("(");
#line 39 "ExtensionMethodTemplate.cshtml"
                                                 Write(Model.GetExtensionParameters(Model.GetSyncMethodParameterDeclaration(false)));

#line default
#line hidden
            WriteLiteral(")\r\n{\r\n");
#line 41 "ExtensionMethodTemplate.cshtml"
    if (Model.ReturnType.Body != null)
    {

#line default
#line hidden

            WriteLiteral("    return ((I");
#line 43 "ExtensionMethodTemplate.cshtml"
            Write(Model.MethodGroup.TypeName);

#line default
#line hidden
            WriteLiteral(")operations).");
#line 43 "ExtensionMethodTemplate.cshtml"
                                                      Write(Model.Name);

#line default
#line hidden
            WriteLiteral("Async(");
#line 43 "ExtensionMethodTemplate.cshtml"
                                                                         Write(Model.SyncMethodInvocationArgs);

#line default
#line hidden
            WriteLiteral(").GetAwaiter().GetResult();\r\n");
#line 44 "ExtensionMethodTemplate.cshtml"
    }
    else if (Model.ReturnType.Headers != null)
    {

#line default
#line hidden

            WriteLiteral("    return ((I");
#line 47 "ExtensionMethodTemplate.cshtml"
            Write(Model.MethodGroup.TypeName);

#line default
#line hidden
            WriteLiteral(")operations).");
#line 47 "ExtensionMethodTemplate.cshtml"
                                                      Write(Model.Name);

#line default
#line hidden
            WriteLiteral("Async(");
#line 47 "ExtensionMethodTemplate.cshtml"
                                                                         Write(Model.SyncMethodInvocationArgs);

#line default
#line hidden
            WriteLiteral(").GetAwaiter().GetResult();\r\n");
#line 48 "ExtensionMethodTemplate.cshtml"
    }
    else
    {

#line default
#line hidden

            WriteLiteral("    ((I");
#line 51 "ExtensionMethodTemplate.cshtml"
     Write(Model.MethodGroup.TypeName);

#line default
#line hidden
            WriteLiteral(")operations).");
#line 51 "ExtensionMethodTemplate.cshtml"
                                               Write(Model.Name);

#line default
#line hidden
            WriteLiteral("Async(");
#line 51 "ExtensionMethodTemplate.cshtml"
                                                                  Write(Model.SyncMethodInvocationArgs);

#line default
#line hidden
            WriteLiteral(").GetAwaiter().GetResult();\r\n");
#line 52 "ExtensionMethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("}\r\n");
#line 54 "ExtensionMethodTemplate.cshtml"

#line default
#line hidden

#line 54 "ExtensionMethodTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
#line 54 "ExtensionMethodTemplate.cshtml"
          
}

if (!String.IsNullOrEmpty(Model.Description) || !String.IsNullOrEmpty(Model.Summary))
{

#line default
#line hidden

            WriteLiteral("/// <summary>\r\n");
#line 60 "ExtensionMethodTemplate.cshtml"
Write(WrapComment("/// ", String.IsNullOrEmpty(Model.Summary) ? Model.Description.EscapeXmlComment() : Model.Summary.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 61 "ExtensionMethodTemplate.cshtml"
    if (!String.IsNullOrEmpty(Model.ExternalDocsUrl))
    {

#line default
#line hidden

            WriteLiteral("/// <see href=\"");
#line 63 "ExtensionMethodTemplate.cshtml"
            Write(Model.ExternalDocsUrl);

#line default
#line hidden
            WriteLiteral("\" />\r\n");
#line 64 "ExtensionMethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("/// </summary>\r\n");
#line 66 "ExtensionMethodTemplate.cshtml"
}
if (!String.IsNullOrEmpty(Model.Description) && !String.IsNullOrEmpty(Model.Summary))
{

#line default
#line hidden

            WriteLiteral("/// <remarks>\r\n");
#line 70 "ExtensionMethodTemplate.cshtml"
Write(WrapComment("/// ", Model.Description.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n/// </remarks>\r\n");
#line 72 "ExtensionMethodTemplate.cshtml"
}

#line default
#line hidden

            WriteLiteral("/// <param name=\'operations\'>\r\n/// The operations group for this extension method" +
".\r\n/// </param>\r\n");
#line 76 "ExtensionMethodTemplate.cshtml"
foreach (var parameter in Model.LocalParameters)
{

#line default
#line hidden

            WriteLiteral("/// <param name=\'");
#line 78 "ExtensionMethodTemplate.cshtml"
              Write(parameter.Name);

#line default
#line hidden
            WriteLiteral("\'>\r\n");
#line 79 "ExtensionMethodTemplate.cshtml"
Write(WrapComment("/// ", parameter.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n/// </param>\r\n");
#line 81 "ExtensionMethodTemplate.cshtml"
}

#line default
#line hidden

            WriteLiteral("/// <param name=\'cancellationToken\'>\r\n/// The cancellation token.\r\n/// </param>\r\n" +
"");
#line 85 "ExtensionMethodTemplate.cshtml"

#line default
#line hidden

#line 85 "ExtensionMethodTemplate.cshtml"
 if (Model.Deprecated)
{

#line default
#line hidden

            WriteLiteral("[System.Obsolete()]\r\n");
#line 88 "ExtensionMethodTemplate.cshtml"
}

#line default
#line hidden

#line 88 "ExtensionMethodTemplate.cshtml"
 

#line default
#line hidden

            WriteLiteral("public static async ");
#line 89 "ExtensionMethodTemplate.cshtml"
                 Write(Model.TaskExtensionReturnTypeString);

#line default
#line hidden
            WriteLiteral(" ");
#line 89 "ExtensionMethodTemplate.cshtml"
                                                       Write(Model.Name);

#line default
#line hidden
            WriteLiteral("Async(");
#line 89 "ExtensionMethodTemplate.cshtml"
                                                                         Write(Model.GetExtensionParameters(Model.GetAsyncMethodParameterDeclaration()));

#line default
#line hidden
            WriteLiteral(")\r\n{\r\n");
#line 91 "ExtensionMethodTemplate.cshtml"
    if (Model.ReturnType.Body != null)
    {
        if (Model.ReturnType.Body.IsPrimaryType(KnownPrimaryType.Stream))
        {

#line default
#line hidden

            WriteLiteral("    var _result = await operations.");
#line 95 "ExtensionMethodTemplate.cshtml"
                                 Write(Model.Name);

#line default
#line hidden
            WriteLiteral("WithHttpMessagesAsync(");
#line 95 "ExtensionMethodTemplate.cshtml"
                                                                    Write(Model.GetAsyncMethodInvocationArgs("null"));

#line default
#line hidden
            WriteLiteral(").ConfigureAwait(false);\r\n    _result.Request.Dispose();\r\n    return _result.Body" +
";\r\n");
#line 98 "ExtensionMethodTemplate.cshtml"
        }
        else
        {

#line default
#line hidden

            WriteLiteral("    using (var _result = await operations.");
#line 101 "ExtensionMethodTemplate.cshtml"
                                        Write(Model.Name);

#line default
#line hidden
            WriteLiteral("WithHttpMessagesAsync(");
#line 101 "ExtensionMethodTemplate.cshtml"
                                                                           Write(Model.GetAsyncMethodInvocationArgs("null"));

#line default
#line hidden
            WriteLiteral(").ConfigureAwait(false))\r\n    {\r\n        return _result.Body;\r\n    }\r\n");
#line 105 "ExtensionMethodTemplate.cshtml"
        }
    }
    else if (Model.ReturnType.Headers != null)
    {

#line default
#line hidden

            WriteLiteral("    using (var _result = await operations.");
#line 109 "ExtensionMethodTemplate.cshtml"
                                        Write(Model.Name);

#line default
#line hidden
            WriteLiteral("WithHttpMessagesAsync(");
#line 109 "ExtensionMethodTemplate.cshtml"
                                                                           Write(Model.GetAsyncMethodInvocationArgs("null"));

#line default
#line hidden
            WriteLiteral(").ConfigureAwait(false))\r\n    {\r\n        return _result.Headers;\r\n    }\r\n");
#line 113 "ExtensionMethodTemplate.cshtml"
    }
    else
    {

#line default
#line hidden

            WriteLiteral("    await operations.");
#line 116 "ExtensionMethodTemplate.cshtml"
                   Write(Model.Name);

#line default
#line hidden
            WriteLiteral("WithHttpMessagesAsync(");
#line 116 "ExtensionMethodTemplate.cshtml"
                                                      Write(Model.GetAsyncMethodInvocationArgs("null"));

#line default
#line hidden
            WriteLiteral(").ConfigureAwait(false);\r\n");
#line 117 "ExtensionMethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("}\r\n");
#line 119 "ExtensionMethodTemplate.cshtml"

    if (Model.SyncMethods == SyncMethodsGenerationMode.All)
    {

#line default
#line hidden

#line 122 "ExtensionMethodTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
#line 122 "ExtensionMethodTemplate.cshtml"
          
    if (!String.IsNullOrEmpty(Model.Description) || !String.IsNullOrEmpty(Model.Summary))
    {

#line default
#line hidden

            WriteLiteral("/// <summary>\r\n");
#line 126 "ExtensionMethodTemplate.cshtml"
Write(WrapComment("/// ", String.IsNullOrEmpty(Model.Summary) ? Model.Description.EscapeXmlComment() : Model.Summary.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 127 "ExtensionMethodTemplate.cshtml"
        if (!String.IsNullOrEmpty(Model.ExternalDocsUrl))
        {

#line default
#line hidden

            WriteLiteral("/// <see href=\"");
#line 129 "ExtensionMethodTemplate.cshtml"
            Write(Model.ExternalDocsUrl);

#line default
#line hidden
            WriteLiteral("\" />\r\n");
#line 130 "ExtensionMethodTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("/// </summary>\r\n");
#line 132 "ExtensionMethodTemplate.cshtml"
    }
    if (!String.IsNullOrEmpty(Model.Description) && !String.IsNullOrEmpty(Model.Summary))
    {

#line default
#line hidden

            WriteLiteral("/// <remarks>\r\n");
#line 136 "ExtensionMethodTemplate.cshtml"
Write(WrapComment("/// ", Model.Description.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n/// </remarks>\r\n");
#line 138 "ExtensionMethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("/// <param name=\'operations\'>\r\n/// The operations group for this extension method" +
".\r\n/// </param>\r\n");
#line 142 "ExtensionMethodTemplate.cshtml"
    foreach (var parameter in Model.LocalParameters)
    {

#line default
#line hidden

            WriteLiteral("/// <param name=\'");
#line 144 "ExtensionMethodTemplate.cshtml"
              Write(parameter.Name);

#line default
#line hidden
            WriteLiteral("\'>\r\n");
#line 145 "ExtensionMethodTemplate.cshtml"
Write(WrapComment("/// ", parameter.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n/// </param>\r\n");
#line 147 "ExtensionMethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("/// <param name=\'customHeaders\'>\r\n/// Headers that will be added to request.\r\n///" +
" </param>\r\n");
#line 151 "ExtensionMethodTemplate.cshtml"

#line default
#line hidden

#line 151 "ExtensionMethodTemplate.cshtml"
 if (Model.Deprecated)
{

#line default
#line hidden

            WriteLiteral("[System.Obsolete()]\r\n");
#line 154 "ExtensionMethodTemplate.cshtml"
}

#line default
#line hidden

#line 154 "ExtensionMethodTemplate.cshtml"
 

#line default
#line hidden

            WriteLiteral("public static ");
#line 155 "ExtensionMethodTemplate.cshtml"
           Write(Model.OperationResponseReturnTypeString);

#line default
#line hidden
            WriteLiteral(" ");
#line 155 "ExtensionMethodTemplate.cshtml"
                                                     Write(Model.Name);

#line default
#line hidden
            WriteLiteral("WithHttpMessages(");
#line 155 "ExtensionMethodTemplate.cshtml"
                                                                                  Write(Model.GetExtensionParameters(Model.GetSyncMethodParameterDeclaration(true)));

#line default
#line hidden
            WriteLiteral(")\r\n{\r\n    return operations.");
#line 157 "ExtensionMethodTemplate.cshtml"
                    Write(Model.Name);

#line default
#line hidden
            WriteLiteral("WithHttpMessagesAsync(");
#line 157 "ExtensionMethodTemplate.cshtml"
                                                       Write(Model.GetAsyncMethodInvocationArgs("customHeaders", "System.Threading.CancellationToken.None"));

#line default
#line hidden
            WriteLiteral(").ConfigureAwait(false).GetAwaiter().GetResult();\r\n}\r\n\r\n");
#line 160 "ExtensionMethodTemplate.cshtml"
    }

#line default
#line hidden

        }
        #pragma warning restore 1998
    }
}
