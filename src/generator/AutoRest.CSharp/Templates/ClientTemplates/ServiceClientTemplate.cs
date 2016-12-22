// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace AutoRest.CSharp.Templates
{
#line 1 "ServiceClientTemplate.cshtml"
using System

#line default
#line hidden
    ;
#line 2 "ServiceClientTemplate.cshtml"
using System.Linq

#line default
#line hidden
    ;
#line 3 "ServiceClientTemplate.cshtml"
using AutoRest.Core.Utilities

#line default
#line hidden
    ;
#line 4 "ServiceClientTemplate.cshtml"
using AutoRest.CSharp.Model

#line default
#line hidden
    ;
#line 5 "ServiceClientTemplate.cshtml"
using AutoRest.CSharp.Templates

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class ServiceClientTemplate : AutoRest.Core.Template<CodeModelCs>
    {
        #line hidden
        public ServiceClientTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
#line 7 "ServiceClientTemplate.cshtml"
Write(Header("// "));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 8 "ServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\nnamespace ");
#line 9 "ServiceClientTemplate.cshtml"
     Write(Settings.Namespace);

#line default
#line hidden
            WriteLiteral("\r\n{\r\n    using Microsoft.Rest;\r\n");
#line 12 "ServiceClientTemplate.cshtml"
 foreach (var usingString in Model.Usings) {

#line default
#line hidden

            WriteLiteral("    using ");
#line 13 "ServiceClientTemplate.cshtml"
       Write(usingString);

#line default
#line hidden
            WriteLiteral(";\r\n");
#line 14 "ServiceClientTemplate.cshtml"
}

#line default
#line hidden

#line 15 "ServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 16 "ServiceClientTemplate.cshtml"
    

#line default
#line hidden

#line 16 "ServiceClientTemplate.cshtml"
     if (!string.IsNullOrWhiteSpace(Model.Documentation))
    {

#line default
#line hidden

            WriteLiteral("    /// <summary>\r\n    ");
#line 19 "ServiceClientTemplate.cshtml"
 Write(WrapComment("/// ", Model.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n    /// </summary>\r\n");
#line 21 "ServiceClientTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("\r\n    public partial class ");
#line 23 "ServiceClientTemplate.cshtml"
                    Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" : Microsoft.Rest.ServiceClient<");
#line 23 "ServiceClientTemplate.cshtml"
                                                               Write(Model.Name);

#line default
#line hidden
            WriteLiteral(">, I");
#line 23 "ServiceClientTemplate.cshtml"
                                                                               Write(Model.Name);

#line default
#line hidden
            WriteLiteral("\r\n    {\r\n        ");
#line 25 "ServiceClientTemplate.cshtml"
    Write(Include(new ServiceClientBodyTemplate(), Model));

#line default
#line hidden
            WriteLiteral(@"

        /// <summary>
        /// An optional partial-method to perform custom initialization.
        ///</summary> 
        partial void CustomInitialize();

        /// <summary>
        /// Initializes client properties.
        /// </summary>
        private void Initialize()
        {
");
#line 37 "ServiceClientTemplate.cshtml"
        

#line default
#line hidden

#line 37 "ServiceClientTemplate.cshtml"
         foreach (var operation in Model.AllOperations) 
        {

#line default
#line hidden

            WriteLiteral("            this.");
#line 39 "ServiceClientTemplate.cshtml"
               Write(operation.NameForProperty);

#line default
#line hidden
            WriteLiteral(" = new ");
#line 39 "ServiceClientTemplate.cshtml"
                                                  Write(operation.TypeName);

#line default
#line hidden
            WriteLiteral("(this);\r\n");
#line 40 "ServiceClientTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("\r\n");
#line 42 "ServiceClientTemplate.cshtml"
        

#line default
#line hidden

#line 42 "ServiceClientTemplate.cshtml"
         if (Model.IsCustomBaseUri)
        {

#line default
#line hidden

            WriteLiteral("            this.BaseUri = \"");
#line 44 "ServiceClientTemplate.cshtml"
                         Write(Model.BaseUrl);

#line default
#line hidden
            WriteLiteral("\";\r\n");
#line 45 "ServiceClientTemplate.cshtml"
        }
        else
        {

#line default
#line hidden

            WriteLiteral("            this.BaseUri = new System.Uri(\"");
#line 48 "ServiceClientTemplate.cshtml"
                                        Write(Model.BaseUrl);

#line default
#line hidden
            WriteLiteral("\");\r\n");
#line 49 "ServiceClientTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("\r\n");
#line 51 "ServiceClientTemplate.cshtml"
        

#line default
#line hidden

#line 51 "ServiceClientTemplate.cshtml"
         foreach (var property in Model.Properties.Where(p => !p.DefaultValue.IsNullOrEmpty()))
        {

#line default
#line hidden

            WriteLiteral("            this.");
#line 53 "ServiceClientTemplate.cshtml"
               Write(property.Name);

#line default
#line hidden
            WriteLiteral(" = ");
#line 53 "ServiceClientTemplate.cshtml"
                                  Write(property.DefaultValue);

#line default
#line hidden
            WriteLiteral(";\r\n");
#line 54 "ServiceClientTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral(@"
            SerializationSettings = new Newtonsoft.Json.JsonSerializerSettings
            {
                Formatting = Newtonsoft.Json.Formatting.Indented,
                DateFormatHandling = Newtonsoft.Json.DateFormatHandling.IsoDateFormat,
                DateTimeZoneHandling = Newtonsoft.Json.DateTimeZoneHandling.Utc,
                NullValueHandling = Newtonsoft.Json.NullValueHandling.Ignore,
                ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Serialize,
                ContractResolver = new Microsoft.Rest.Serialization.ReadOnlyJsonContractResolver(),
                Converters = new  System.Collections.Generic.List<Newtonsoft.Json.JsonConverter>
                    {
                        new Microsoft.Rest.Serialization.Iso8601TimeSpanConverter()
                    }
            };
");
#line 69 "ServiceClientTemplate.cshtml"
            

#line default
#line hidden

#line 69 "ServiceClientTemplate.cshtml"
             if (Model.NeedsTransformationConverter)
            {

#line default
#line hidden

            WriteLiteral("            SerializationSettings.Converters.Add(new Microsoft.Rest.Serialization" +
".TransformationJsonConverter());\r\n");
#line 72 "ServiceClientTemplate.cshtml"
            }

#line default
#line hidden

            WriteLiteral(@"            DeserializationSettings = new Newtonsoft.Json.JsonSerializerSettings
            {
                DateFormatHandling = Newtonsoft.Json.DateFormatHandling.IsoDateFormat,
                DateTimeZoneHandling = Newtonsoft.Json.DateTimeZoneHandling.Utc,
                NullValueHandling = Newtonsoft.Json.NullValueHandling.Ignore,
                ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Serialize,
                ContractResolver = new Microsoft.Rest.Serialization.ReadOnlyJsonContractResolver(),
                Converters = new System.Collections.Generic.List<Newtonsoft.Json.JsonConverter>
                    {
                        new Microsoft.Rest.Serialization.Iso8601TimeSpanConverter()
                    }
            };
");
#line 85 "ServiceClientTemplate.cshtml"
            

#line default
#line hidden

#line 85 "ServiceClientTemplate.cshtml"
             foreach (var polymorphicType in Model.ModelTypes.Where(t => t.IsPolymorphic))
            {

#line default
#line hidden

            WriteLiteral("            SerializationSettings.Converters.Add(new Microsoft.Rest.Serialization" +
".PolymorphicSerializeJsonConverter<");
#line 87 "ServiceClientTemplate.cshtml"
                                                                                                                  Write(polymorphicType.Name);

#line default
#line hidden
            WriteLiteral(">(\"");
#line 87 "ServiceClientTemplate.cshtml"
                                                                                                                                            Write(polymorphicType.PolymorphicDiscriminator);

#line default
#line hidden
            WriteLiteral("\"));\r\n            DeserializationSettings.Converters.Add(new  Microsoft.Rest.Seri" +
"alization.PolymorphicDeserializeJsonConverter<");
#line 88 "ServiceClientTemplate.cshtml"
                                                                                                                       Write(polymorphicType.Name);

#line default
#line hidden
            WriteLiteral(">(\"");
#line 88 "ServiceClientTemplate.cshtml"
                                                                                                                                                 Write(polymorphicType.PolymorphicDiscriminator);

#line default
#line hidden
            WriteLiteral("\"));\r\n");
#line 89 "ServiceClientTemplate.cshtml"
            }

#line default
#line hidden

            WriteLiteral("\r\n            CustomInitialize();\r\n            \r\n");
#line 93 "ServiceClientTemplate.cshtml"
            

#line default
#line hidden

#line 93 "ServiceClientTemplate.cshtml"
             if (Model.NeedsTransformationConverter)
            {

#line default
#line hidden

            WriteLiteral("            DeserializationSettings.Converters.Add(new Microsoft.Rest.Serializati" +
"on.TransformationJsonConverter());\r\n");
#line 96 "ServiceClientTemplate.cshtml"
            }

#line default
#line hidden

            WriteLiteral("    \r\n        }    \r\n    \r\n");
#line 100 "ServiceClientTemplate.cshtml"
        

#line default
#line hidden

#line 100 "ServiceClientTemplate.cshtml"
         foreach (MethodCs method in Model.Methods.Where( m => m.Group.IsNullOrEmpty()))
        {

#line default
#line hidden

            WriteLiteral("        ");
#line 102 "ServiceClientTemplate.cshtml"
      Write(Include(new MethodTemplate(), method));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 103 "ServiceClientTemplate.cshtml"
        

#line default
#line hidden

#line 103 "ServiceClientTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
#line 103 "ServiceClientTemplate.cshtml"
                  

#line default
#line hidden

            WriteLiteral("        \r\n");
#line 105 "ServiceClientTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("    }\r\n}\r\n");
        }
        #pragma warning restore 1998
    }
}
