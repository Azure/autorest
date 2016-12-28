// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace AutoRest.CSharp.Templates.Rest.Common
{
#line 1 "EnumTemplate.cshtml"
using System.Linq

#line default
#line hidden
    ;
#line 2 "EnumTemplate.cshtml"
using AutoRest.Core.Model

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class EnumTemplate : AutoRest.Core.Template<AutoRest.CSharp.Model.EnumTypeCs>
    {
        #line hidden
        public EnumTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
#line 4 "EnumTemplate.cshtml"
Write(Header("// "));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 5 "EnumTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\nnamespace ");
#line 6 "EnumTemplate.cshtml"
      Write(Settings.Namespace);

#line default
#line hidden
            WriteLiteral(".");
#line 6 "EnumTemplate.cshtml"
                            Write(Settings.ModelsName);

#line default
#line hidden
            WriteLiteral("\r\n{\r\n");
#line 8 "EnumTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n    /// <summary>\r\n    ");
#line 10 "EnumTemplate.cshtml"
Write(WrapComment("/// ", "Defines values for " + Model.Name + "."));

#line default
#line hidden
            WriteLiteral("\r\n    /// </summary>\r\n");
#line 12 "EnumTemplate.cshtml"
    

#line default
#line hidden

#line 12 "EnumTemplate.cshtml"
     if (!Model.ModelAsString)
    {

#line default
#line hidden

            WriteLiteral("    [Newtonsoft.Json.JsonConverter(typeof(Newtonsoft.Json.Converters.StringEnumCo" +
"nverter))]\r\n    public enum ");
#line 15 "EnumTemplate.cshtml"
             Write(Model.ClassName);

#line default
#line hidden
            WriteLiteral("\r\n    {\r\n");
#line 17 "EnumTemplate.cshtml"
        for (int i = 0; i < Model.Values.Count - 1; i++)
        {

#line default
#line hidden

            WriteLiteral("        [System.Runtime.Serialization.EnumMember(Value = \"");
#line 19 "EnumTemplate.cshtml"
                                                       Write(Model.Values[i].SerializedName);

#line default
#line hidden
            WriteLiteral("\")]\r\n        ");
#line 20 "EnumTemplate.cshtml"
      Write(Model.Values[i].MemberName);

#line default
#line hidden
            WriteLiteral(",\r\n");
#line 21 "EnumTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("        [System.Runtime.Serialization.EnumMember(Value = \"");
#line 22 "EnumTemplate.cshtml"
                                                       Write(Model.Values.Last().SerializedName);

#line default
#line hidden
            WriteLiteral("\")]\r\n        ");
#line 23 "EnumTemplate.cshtml"
      Write(Model.Values.Last().MemberName);

#line default
#line hidden
            WriteLiteral("\r\n    }\r\n");
#line 25 "EnumTemplate.cshtml"
    }
    else
    {

#line default
#line hidden

            WriteLiteral("    public static class ");
#line 28 "EnumTemplate.cshtml"
                     Write(Model.ClassName);

#line default
#line hidden
            WriteLiteral("\r\n    {\r\n");
#line 30 "EnumTemplate.cshtml"
        foreach (var t in Model.Values)
        {

#line default
#line hidden

            WriteLiteral("        public const string ");
#line 32 "EnumTemplate.cshtml"
                         Write(t.MemberName);

#line default
#line hidden
            WriteLiteral(" = \"");
#line 32 "EnumTemplate.cshtml"
                                          Write(t.SerializedName);

#line default
#line hidden
            WriteLiteral("\";\r\n");
#line 33 "EnumTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("    }\r\n");
#line 35 "EnumTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("}\r\n");
        }
        #pragma warning restore 1998
    }
}
