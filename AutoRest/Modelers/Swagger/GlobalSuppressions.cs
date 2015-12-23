// This file is used by Code Analysis to maintain SuppressMessage 
// attributes that are applied to this project.
// Project-level suppressions either have no target or are given 
// a specific target and scoped to a namespace, type, member, etc.
//
// To add a suppression to this file, right-click the message in the 
// Code Analysis results, point to "Suppress Message", and click 
// "In Suppression File".
// You do not need to add suppressions to this file manually.

[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1006:DoNotNestGenericTypesInMemberSignatures", 
    Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Model.Operation.#Security", 
    Justification = "This type is strictly a serialization model.")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1006:DoNotNestGenericTypesInMemberSignatures", 
    Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Model.ServiceDefinition.#Paths", 
    Justification = "This type is strictly a serialization model.")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1006:DoNotNestGenericTypesInMemberSignatures", 
    Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Model.ServiceDefinition.#Security", 
    Justification = "This type is strictly a serialization model.")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1054:UriParametersShouldNotBeStrings", 
    MessageId = "1#", Scope = "member", 
    Target = "Microsoft.Rest.Modeler.Swagger.OperationBuilder.#BuildMethod(Microsoft.Rest.Generator.ClientModel.HttpMethod,System.String,System.String,System.String)", Justification = "May not parse as valid Uri")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1054:UriParametersShouldNotBeStrings", 
    MessageId = "1#", Scope = "member", 
    Target = "Microsoft.Rest.Modeler.Swagger.SwaggerModeler.#BuildMethod(Microsoft.Rest.Generator.ClientModel.HttpMethod,System.String,System.String,Microsoft.Rest.Modeler.Swagger.Model.Operation)", Justification = "May not parse as valid Uri")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1055:UriReturnValuesShouldNotBeStrings", 
    Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.SwaggerModeler.#BuildMethodBaseUrl(Microsoft.Rest.Generator.ClientModel.ServiceClient,System.String)", Justification = "May not parse as valid Uri")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1056:UriPropertiesShouldNotBeStrings", 
    Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Model.Contact.#Url", Justification = "May not parse as valid Uri")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1056:UriPropertiesShouldNotBeStrings", 
    Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Model.ExternalDoc.#Url", Justification = "May not parse as valid Uri")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1056:UriPropertiesShouldNotBeStrings", 
    Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Model.License.#Url", Justification = "May not parse as valid Uri")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1056:UriPropertiesShouldNotBeStrings", 
    Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Model.SecurityDefinition.#AuthorizationUrl", Justification = "May not parse as valid Uri")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1056:UriPropertiesShouldNotBeStrings", 
    Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Model.SecurityDefinition.#TokenUrl", Justification = "May not parse as valid Uri")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Globalization", "CA1303:Do not pass literals as localized parameters", MessageId = "Microsoft.Rest.Generator.Logging.ErrorManager.CreateError(System.String,System.Object[])", Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.SwaggerParser.#Parse(System.String)", Justification = "Generated Code")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Globalization", "CA1308:NormalizeStringsToUppercase", 
    Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Extensions.#ToHttpMethod(System.String)", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Globalization", "CA1308:NormalizeStringsToUppercase", 
    Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.SchemaResolver.#Dereference(System.String)", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Globalization", "CA1308:NormalizeStringsToUppercase", 
    Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.SwaggerModeler.#InitializeClientModel()", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Maintainability", "CA1506:AvoidExcessiveClassCoupling", 
    Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.OperationBuilder.#BuildMethod(Microsoft.Rest.Generator.ClientModel.HttpMethod,System.String,System.String,System.String)", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1704:IdentifiersShouldBeSpelledCorrectly", 
    MessageId = "param", Scope = "member", 
    Target = "Microsoft.Rest.Modeler.Swagger.CollectionFormatBuilder.#OnBuildMethodParameter(Microsoft.Rest.Generator.ClientModel.Method,Microsoft.Rest.Modeler.Swagger.Model.SwaggerParameter,System.Text.StringBuilder)", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1704:IdentifiersShouldBeSpelledCorrectly", 
    MessageId = "Param", Scope = "member", 
    Target = "Microsoft.Rest.Modeler.Swagger.CollectionFormatBuilder.#OnBuildMethodParameter(Microsoft.Rest.Generator.ClientModel.Method,Microsoft.Rest.Modeler.Swagger.Model.SwaggerParameter,System.Text.StringBuilder)", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1702:CompoundWordsShouldBeCasedCorrectly", 
    MessageId = "OAuth", Scope = "type", Target = "Microsoft.Rest.Modeler.Swagger.Model.OAuthFlow", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1702:CompoundWordsShouldBeCasedCorrectly", 
    MessageId = "OAuth", Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Model.SecuritySchemeType.#OAuth2", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1704:IdentifiersShouldBeSpelledCorrectly", 
    MessageId = "Ws", Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Model.TransferProtocolScheme.#Ws", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1704:IdentifiersShouldBeSpelledCorrectly", 
    MessageId = "Wss", Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Model.TransferProtocolScheme.#Wss", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1709:IdentifiersShouldBeCasedCorrectly", 
    MessageId = "Ws", Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Model.TransferProtocolScheme.#Ws", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1716:IdentifiersShouldNotMatchKeywords", 
    MessageId = "Default", Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Model.SwaggerObject.#Default", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1716:IdentifiersShouldNotMatchKeywords", 
    MessageId = "Enum", Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Model.SwaggerObject.#Enum", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1721:PropertyNamesShouldNotMatchGetMethods", 
    Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Model.SwaggerObject.#Type", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1724:TypeNamesShouldNotMatchNamespaces", 
    Scope = "type", Target = "Microsoft.Rest.Modeler.Swagger.Model.Schema", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1800:DoNotCastUnnecessarily", 
    Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Model.SwaggerObject.#GetBuilder(Microsoft.Rest.Modeler.Swagger.SwaggerModeler)")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", 
    MessageId = "operation", Scope = "member", 
    Target = "Microsoft.Rest.Modeler.Swagger.OperationBuilder.#SwaggerOperationProducesJson(Microsoft.Rest.Modeler.Swagger.Model.Operation)")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", 
    MessageId = "operation", Scope = "member", 
    Target = "Microsoft.Rest.Modeler.Swagger.OperationBuilder.#SwaggerOperationConsumesJson(Microsoft.Rest.Modeler.Swagger.Model.Operation)")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", 
    MessageId = "operation", Scope = "member", 
    Target = "Microsoft.Rest.Modeler.Swagger.OperationBuilder.#SwaggerOperationProducesOctetStream(Microsoft.Rest.Modeler.Swagger.Model.Operation)")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", 
    MessageId = "operation", Scope = "member", 
    Target = "Microsoft.Rest.Modeler.Swagger.OperationBuilder.#SwaggerOperationConsumesMultipartFormData(Microsoft.Rest.Modeler.Swagger.Model.Operation)", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", 
    "CA1703:ResourceStringsShouldBeSpelledCorrectly", MessageId = "multi", Scope = "resource", 
    Target = "Microsoft.Rest.Modeler.Swagger.Properties.Resources.resources", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1704:IdentifiersShouldBeSpelledCorrectly", 
    MessageId = "Auth", Scope = "type", Target = "Microsoft.Rest.Modeler.Swagger.Model.OAuthFlow", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1704:IdentifiersShouldBeSpelledCorrectly", 
    MessageId = "Auth", Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Model.SecuritySchemeType.#OAuth2")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly", 
    Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Model.Operation.#Tags", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly", 
    Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Model.Operation.#Consumes", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly", 
    Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Model.Operation.#Produces", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly", 
    Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Model.Operation.#Parameters", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly", 
    Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Model.Operation.#Responses", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly", 
    Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Model.Operation.#Schemes", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly", 
    Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Model.Operation.#Security", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly", 
    Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Model.OperationResponse.#Headers", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly", 
    Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Model.OperationResponse.#Examples", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly", 
    Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Model.Schema.#Properties", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly", 
    Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Model.Schema.#Required", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly", 
    Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Model.Schema.#AllOf", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly", 
    Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Model.SecurityDefinition.#Scopes", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly", 
    Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Model.ServiceDefinition.#Schemes", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly", 
    Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Model.ServiceDefinition.#Consumes", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly", 
    Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Model.ServiceDefinition.#Produces", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly", 
    Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Model.ServiceDefinition.#Paths", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly", 
    Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Model.ServiceDefinition.#Definitions", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly", 
    Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Model.ServiceDefinition.#Parameters", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly", 
    Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Model.ServiceDefinition.#Responses", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly", 
    Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Model.ServiceDefinition.#SecurityDefinitions", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly", 
    Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Model.ServiceDefinition.#Security", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly", 
    Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Model.ServiceDefinition.#Tags", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly", 
    Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Model.ServiceDefinition.#ExternalReferences", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly", 
    Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Model.SwaggerBase.#Extensions", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly", 
    Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Model.SwaggerObject.#Enum", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly", 
    Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.JsonConverters.SwaggerJsonConverter.#Document", Justification = "Serialization Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly", 
    Scope = "member", Target = "Microsoft.Rest.Modeler.Swagger.Model.ServiceDefinition.#CustomPaths", Justification = "Serialization Type")]

