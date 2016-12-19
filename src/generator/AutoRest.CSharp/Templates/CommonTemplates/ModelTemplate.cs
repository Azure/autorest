// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace AutoRest.CSharp.Templates
{
#line 1 "ModelTemplate.cshtml"
using System.Linq

#line default
#line hidden
    ;
#line 2 "ModelTemplate.cshtml"
using AutoRest.Core

#line default
#line hidden
    ;
#line 3 "ModelTemplate.cshtml"
using AutoRest.Core.Model

#line default
#line hidden
    ;
#line 4 "ModelTemplate.cshtml"
using AutoRest.Core.Utilities

#line default
#line hidden
    ;
#line 5 "ModelTemplate.cshtml"
using AutoRest.CSharp

#line default
#line hidden
    ;
#line 6 "ModelTemplate.cshtml"
using AutoRest.CSharp.Model

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class ModelTemplate : Template<global::AutoRest.CSharp.Model.CompositeTypeCs>
    {
        #line hidden
        public ModelTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
#line 8 "ModelTemplate.cshtml"
Write(Header("// "));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 9 "ModelTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\nnamespace ");
#line 10 "ModelTemplate.cshtml"
      Write(Settings.Namespace);

#line default
#line hidden
            WriteLiteral(".");
#line 10 "ModelTemplate.cshtml"
                            Write(Settings.ModelsName);

#line default
#line hidden
            WriteLiteral("\r\n{\r\n    using System.Linq;\r\n");
#line 13 "ModelTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n\r\n");
#line 15 "ModelTemplate.cshtml"
 if (!string.IsNullOrEmpty(Model.Summary) || !string.IsNullOrWhiteSpace(Model.Documentation))
{

#line default
#line hidden

            WriteLiteral("    /// <summary>\r\n    ");
#line 18 "ModelTemplate.cshtml"
 Write(WrapComment("/// ", (string.IsNullOrEmpty(Model.Summary) ? Model.Documentation : Model.Summary).EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 19 "ModelTemplate.cshtml"
        if (!string.IsNullOrEmpty(Model.ExternalDocsUrl))
        {

#line default
#line hidden

            WriteLiteral("    /// <see href=\"");
#line 21 "ModelTemplate.cshtml"
                Write(Model.ExternalDocsUrl);

#line default
#line hidden
            WriteLiteral("\" />\r\n");
#line 22 "ModelTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("    /// </summary>\r\n");
#line 24 "ModelTemplate.cshtml"
}

#line default
#line hidden

#line 25 "ModelTemplate.cshtml"
 if (!string.IsNullOrEmpty(Model.Summary) && !string.IsNullOrWhiteSpace(Model.Documentation))
{

#line default
#line hidden

            WriteLiteral("    /// <remarks>\r\n    ");
#line 28 "ModelTemplate.cshtml"
 Write(WrapComment("/// ", Model.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n    /// </remarks>\r\n");
#line 30 "ModelTemplate.cshtml"
}

#line default
#line hidden

            WriteLiteral("\r\n");
#line 32 "ModelTemplate.cshtml"
    

#line default
#line hidden

#line 32 "ModelTemplate.cshtml"
     if (Model.NeedsPolymorphicConverter)
    {

#line default
#line hidden

            WriteLiteral("    [Newtonsoft.Json.JsonObject(\"");
#line 34 "ModelTemplate.cshtml"
                              Write(Model.SerializedName);

#line default
#line hidden
            WriteLiteral("\")]\r\n");
#line 35 "ModelTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("\r\n");
#line 37 "ModelTemplate.cshtml"
    

#line default
#line hidden

#line 37 "ModelTemplate.cshtml"
     if (Model.NeedsTransformationConverter)
    {

#line default
#line hidden

            WriteLiteral("    [Microsoft.Rest.Serialization.JsonTransformation]\r\n");
#line 40 "ModelTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("\r\n    public partial class ");
#line 42 "ModelTemplate.cshtml"
                    Write(Model.Name);

#line default
#line hidden
#line 42 "ModelTemplate.cshtml"
                                Write(Model.BaseModelType != null ? " : " + Model.BaseModelType.Name : "");

#line default
#line hidden
            WriteLiteral("\r\n    {\r\n        /// <summary>\r\n        ");
#line 45 "ModelTemplate.cshtml"
   Write(WrapComment("/// ", ("Initializes a new instance of the " + Model.Name + " class.").EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n        /// </summary>\r\n");
#line 47 "ModelTemplate.cshtml"
        

#line default
#line hidden

#line 47 "ModelTemplate.cshtml"
         if (Model.Properties.Any(p => p.ModelType is CompositeType && ((CompositeType)p.ModelType).ContainsConstantProperties))
        {

#line default
#line hidden

            WriteLiteral("\r\n        public ");
#line 50 "ModelTemplate.cshtml"
           Write(Model.Name);

#line default
#line hidden
            WriteLiteral("()\r\n        {\r\n");
#line 52 "ModelTemplate.cshtml"
            

#line default
#line hidden

#line 52 "ModelTemplate.cshtml"
             foreach(var property in Model.ComposedProperties.Where(p => p.ModelType is CompositeType
                && !p.IsConstant
                && p.IsRequired
                && ((CompositeType)p.ModelType).ContainsConstantProperties))
            {

#line default
#line hidden

            WriteLiteral("            ");
#line 57 "ModelTemplate.cshtml"
          Write(property.Name);

#line default
#line hidden
            WriteLiteral(" = new ");
#line 57 "ModelTemplate.cshtml"
                                 Write(property.ModelTypeName);

#line default
#line hidden
            WriteLiteral("();\r\n");
#line 58 "ModelTemplate.cshtml"
            }

#line default
#line hidden

            WriteLiteral("        }\r\n\r\n");
#line 61 "ModelTemplate.cshtml"
        }
        else
        {

#line default
#line hidden

            WriteLiteral("        public ");
#line 64 "ModelTemplate.cshtml"
             Write(Model.Name);

#line default
#line hidden
            WriteLiteral("() { }\r\n");
#line 65 "ModelTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("        \r\n\r\n        ");
#line 68 "ModelTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n\r\n");
#line 70 "ModelTemplate.cshtml"
        

#line default
#line hidden

#line 70 "ModelTemplate.cshtml"
         if (!string.IsNullOrEmpty(Model.ConstructorParameters))
        {

#line default
#line hidden

            WriteLiteral("        /// <summary>\r\n        ");
#line 73 "ModelTemplate.cshtml"
     Write(WrapComment("/// ", ("Initializes a new instance of the " + Model.Name + " class.").EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n        /// </summary>\r\n");
#line 75 "ModelTemplate.cshtml"
        foreach (var parameter in Model.ConstructorParametersDocumentation)
        {

#line default
#line hidden

            WriteLiteral("        ");
#line 77 "ModelTemplate.cshtml"
     Write(WrapComment("/// ", parameter));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 78 "ModelTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("        public ");
#line 79 "ModelTemplate.cshtml"
             Write(Model.Name);

#line default
#line hidden
            WriteLiteral("(");
#line 79 "ModelTemplate.cshtml"
                          Write(Model.ConstructorParameters);

#line default
#line hidden
            WriteLiteral(")\r\n");
#line 80 "ModelTemplate.cshtml"
            if (!string.IsNullOrEmpty(Model.BaseConstructorCall))
            {

#line default
#line hidden

            WriteLiteral("            ");
#line 82 "ModelTemplate.cshtml"
          Write(Model.BaseConstructorCall);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 83 "ModelTemplate.cshtml"
            }

#line default
#line hidden

            WriteLiteral("        {\r\n");
#line 85 "ModelTemplate.cshtml"

            foreach (var property in Model.ComposedProperties.Where(p => p.ModelType is CompositeType
                     && !p.IsConstant
                     && p.IsRequired
                     && ((CompositeType)p.ModelType).ContainsConstantProperties))
            {

#line default
#line hidden

            WriteLiteral("            ");
#line 91 "ModelTemplate.cshtml"
          Write(property.Name);

#line default
#line hidden
            WriteLiteral(" = new ");
#line 91 "ModelTemplate.cshtml"
                                 Write(property.ModelTypeName);

#line default
#line hidden
            WriteLiteral("();\r\n");
#line 92 "ModelTemplate.cshtml"
            }

            foreach (var property in Model.Properties.Where(p => !p.IsConstant))
            {
                var propName = CodeNamer.Instance.CamelCase(property.Name);
                if (property.Name.Value.Equals(propName))
                {

#line default
#line hidden

            WriteLiteral("            this.");
#line 99 "ModelTemplate.cshtml"
               Write(property.Name);

#line default
#line hidden
            WriteLiteral(" = ");
#line 99 "ModelTemplate.cshtml"
                                 Write(propName);

#line default
#line hidden
            WriteLiteral(";\r\n");
#line 100 "ModelTemplate.cshtml"
                }
                else
                {

#line default
#line hidden

            WriteLiteral("            ");
#line 103 "ModelTemplate.cshtml"
          Write(property.Name);

#line default
#line hidden
            WriteLiteral(" = ");
#line 103 "ModelTemplate.cshtml"
                            Write(propName);

#line default
#line hidden
            WriteLiteral(";\r\n");
#line 104 "ModelTemplate.cshtml"
                }
            }            


#line default
#line hidden

            WriteLiteral("        }\r\n");
#line 108 "ModelTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("\r\n");
#line 110 "ModelTemplate.cshtml"
        

#line default
#line hidden

#line 110 "ModelTemplate.cshtml"
         if (Model.Properties.Any(p => p.IsConstant))
        {

#line default
#line hidden

            WriteLiteral("        /// <summary>\r\n        ");
#line 113 "ModelTemplate.cshtml"
     Write(WrapComment("/// ", ("Static constructor for " + Model.Name + " class.").EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n        /// </summary>\r\n        static ");
#line 115 "ModelTemplate.cshtml"
             Write(Model.Name);

#line default
#line hidden
            WriteLiteral("()\r\n        {\r\n");
#line 117 "ModelTemplate.cshtml"
            foreach (var property in Model.Properties.Where(p => p.IsConstant))
            {

#line default
#line hidden

            WriteLiteral("            ");
#line 119 "ModelTemplate.cshtml"
          Write(property.Name);

#line default
#line hidden
            WriteLiteral(" = ");
#line 119 "ModelTemplate.cshtml"
                             Write(property.DefaultValue);

#line default
#line hidden
            WriteLiteral(";\r\n");
#line 120 "ModelTemplate.cshtml"
            }

#line default
#line hidden

            WriteLiteral("        }\r\n");
#line 122 "ModelTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("\r\n        ");
#line 124 "ModelTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 125 "ModelTemplate.cshtml"
        

#line default
#line hidden

#line 125 "ModelTemplate.cshtml"
         foreach (var property in Model.Properties.Where(p => !p.IsConstant))
        {

#line default
#line hidden

            WriteLiteral("        /// <summary>\r\n        ");
#line 128 "ModelTemplate.cshtml"
     Write(WrapComment("/// ", property.GetFormattedPropertySummary()));

#line default
#line hidden
            WriteLiteral("\r\n        /// </summary>\r\n");
#line 130 "ModelTemplate.cshtml"
            if(!string.IsNullOrEmpty(property.Summary) && !string.IsNullOrEmpty(property.Documentation))
            { 

#line default
#line hidden

            WriteLiteral("        /// <remarks>\r\n        ");
#line 133 "ModelTemplate.cshtml"
     Write(WrapComment("/// ", property.Documentation));

#line default
#line hidden
            WriteLiteral("\r\n        /// </remarks>\r\n");
#line 135 "ModelTemplate.cshtml"
            }
            if (property.ModelType.IsPrimaryType(KnownPrimaryType.Date))
            {

#line default
#line hidden

            WriteLiteral("        [Newtonsoft.Json.JsonConverter(typeof(Microsoft.Rest.Serialization.DateJs" +
"onConverter))]\r\n");
#line 139 "ModelTemplate.cshtml"
            }
            if (property.ModelType.IsPrimaryType(KnownPrimaryType.DateTimeRfc1123))
            {

#line default
#line hidden

            WriteLiteral("        [Newtonsoft.Json.JsonConverter(typeof(Microsoft.Rest.Serialization.DateTi" +
"meRfc1123JsonConverter))]\r\n");
#line 143 "ModelTemplate.cshtml"
            }
            if (property.ModelType.IsPrimaryType(KnownPrimaryType.Base64Url))
            {

#line default
#line hidden

            WriteLiteral("        [Newtonsoft.Json.JsonConverter(typeof(Microsoft.Rest.Serialization.Base64" +
"UrlJsonConverter))]\r\n");
#line 147 "ModelTemplate.cshtml"
            }
            if (property.ModelType.IsPrimaryType(KnownPrimaryType.UnixTime))
            {

#line default
#line hidden

            WriteLiteral("        [Newtonsoft.Json.JsonConverter(typeof(Microsoft.Rest.Serialization.UnixTi" +
"meJsonConverter))]\r\n");
#line 151 "ModelTemplate.cshtml"
            }

            if (property.ModelType is DictionaryType && (property.ModelType as DictionaryType).SupportsAdditionalProperties)
            {

#line default
#line hidden

            WriteLiteral("        [Newtonsoft.Json.JsonExtensionData]\r\n");
#line 156 "ModelTemplate.cshtml"
            }
            else
            {

#line default
#line hidden

            WriteLiteral("        [Newtonsoft.Json.JsonProperty(PropertyName = \"");
#line 159 "ModelTemplate.cshtml"
                                                   Write(property.SerializedName);

#line default
#line hidden
            WriteLiteral("\")]\r\n");
#line 160 "ModelTemplate.cshtml"
            }

#line default
#line hidden

            WriteLiteral("        public ");
#line 161 "ModelTemplate.cshtml"
            Write(property.ModelTypeName);

#line default
#line hidden
            WriteLiteral(" ");
#line 161 "ModelTemplate.cshtml"
                                    Write(property.Name);

#line default
#line hidden
            WriteLiteral(" { get; ");
#line 161 "ModelTemplate.cshtml"
                                                           Write(property.IsReadOnly ? "protected " : "");

#line default
#line hidden
            WriteLiteral("set; }\r\n");
#line 162 "ModelTemplate.cshtml"
        

#line default
#line hidden

#line 162 "ModelTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
#line 162 "ModelTemplate.cshtml"
                  
        }

#line default
#line hidden

            WriteLiteral("\r\n");
#line 165 "ModelTemplate.cshtml"
        

#line default
#line hidden

#line 165 "ModelTemplate.cshtml"
         foreach (var property in Model.Properties.Where(p => p.IsConstant))
        {

#line default
#line hidden

            WriteLiteral("        /// <summary>\r\n        ");
#line 168 "ModelTemplate.cshtml"
     Write(WrapComment("/// ", property.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n        /// </summary>\r\n");
#line 170 "ModelTemplate.cshtml"
            if (property.ModelType.IsPrimaryType(KnownPrimaryType.Date))
            {

#line default
#line hidden

            WriteLiteral("        [Newtonsoft.Json.JsonConverter(typeof(DateJsonConverter))]\r\n");
#line 173 "ModelTemplate.cshtml"
            }
            if (property.ModelType.IsPrimaryType(KnownPrimaryType.DateTimeRfc1123))
            {

#line default
#line hidden

            WriteLiteral("        [Newtonsoft.Json.JsonConverter(typeof(DateTimeRfc1123JsonConverter))]\r\n");
#line 177 "ModelTemplate.cshtml"
            }
            if (property.ModelType.IsPrimaryType(KnownPrimaryType.Base64Url))
            {

#line default
#line hidden

            WriteLiteral("        [Newtonsoft.Json.JsonConverter(typeof(Base64UrlJsonConverter))]\r\n");
#line 181 "ModelTemplate.cshtml"
            }
            if (property.ModelType.IsPrimaryType(KnownPrimaryType.UnixTime))
            {

#line default
#line hidden

            WriteLiteral("        [Newtonsoft.Json.JsonConverter(typeof(UnixTimeJsonConverter))]\r\n");
#line 185 "ModelTemplate.cshtml"
            }

#line default
#line hidden

            WriteLiteral("        [Newtonsoft.Json.JsonProperty(PropertyName = \"");
#line 186 "ModelTemplate.cshtml"
                                                   Write(property.SerializedName);

#line default
#line hidden
            WriteLiteral("\")]\r\n        public static ");
#line 187 "ModelTemplate.cshtml"
                   Write(property.ModelTypeName);

#line default
#line hidden
            WriteLiteral(" ");
#line 187 "ModelTemplate.cshtml"
                                           Write(property.Name);

#line default
#line hidden
            WriteLiteral(" { get; private set; }\r\n");
#line 188 "ModelTemplate.cshtml"
        

#line default
#line hidden

#line 188 "ModelTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
#line 188 "ModelTemplate.cshtml"
                  
        }

#line default
#line hidden

#line 190 "ModelTemplate.cshtml"
 if(@Model.ShouldValidateChain())
{

#line default
#line hidden

            WriteLiteral("        /// <summary>\r\n        /// Validate the object.\r\n        /// </summary>\r\n" +
"        /// <exception cref=\"Microsoft.Rest.ValidationException\">\r\n        /// T" +
"hrown if validation fails\r\n        /// </exception>\r\n        public ");
#line 198 "ModelTemplate.cshtml"
            Write(Model.MethodQualifier);

#line default
#line hidden
            WriteLiteral(" void Validate()\r\n        {\r\n");
#line 200 "ModelTemplate.cshtml"
            bool anythingToValidate = false;

            if (Model.BaseModelType != null && Model.BaseModelType.ShouldValidateChain())
            {
                anythingToValidate = true;

#line default
#line hidden

            WriteLiteral("            base.Validate();\r\n");
#line 206 "ModelTemplate.cshtml"
            }

            foreach (PropertyCs property in Model.Properties.Where(p => p.IsRequired && !p.IsReadOnly && !p.IsConstant && p.IsNullable() ))
            {
                anythingToValidate = true;

#line default
#line hidden

            WriteLiteral("            if (");
#line 211 "ModelTemplate.cshtml"
             Write(property.Name);

#line default
#line hidden
            WriteLiteral(" == null)\r\n            {\r\n                throw new Microsoft.Rest.ValidationExce" +
"ption(Microsoft.Rest.ValidationRules.CannotBeNull, \"");
#line 213 "ModelTemplate.cshtml"
                                                                                                        Write(property.Name);

#line default
#line hidden
            WriteLiteral("\");\r\n            }\r\n            \r\n");
#line 216 "ModelTemplate.cshtml"
            }
            foreach (var property in Model.Properties.Where(p => !p.IsConstant 
                && (p.Constraints.Any() || !(p.ModelType is PrimaryType))))
            {
                anythingToValidate = true;

#line default
#line hidden

            WriteLiteral("            ");
#line 221 "ModelTemplate.cshtml"
         Write(property.ModelType.ValidateType(Model, $"this.{property.Name}", property.Constraints));

#line default
#line hidden
            WriteLiteral("\r\n            \r\n");
#line 223 "ModelTemplate.cshtml"
            }
            if (!anythingToValidate)
            {

#line default
#line hidden

            WriteLiteral("            //Nothing to validate\r\n");
#line 227 "ModelTemplate.cshtml"
            }

#line default
#line hidden

            WriteLiteral("        }\r\n");
#line 229 "ModelTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("    }\r\n}");
        }
        #pragma warning restore 1998
    }
}
