﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.42000
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace AutoRest.Core.Properties {
    using System;
    using System.Reflection;
    
    
    /// <summary>
    ///   A strongly-typed resource class, for looking up localized strings, etc.
    /// </summary>
    // This class was auto-generated by the StronglyTypedResourceBuilder
    // class via a tool like ResGen or Visual Studio.
    // To add or remove a member, edit your .ResX file then rerun ResGen
    // with the /str option, or rebuild your VS project.
    [global::System.CodeDom.Compiler.GeneratedCodeAttribute("System.Resources.Tools.StronglyTypedResourceBuilder", "4.0.0.0")]
    [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
    [global::System.Runtime.CompilerServices.CompilerGeneratedAttribute()]
    public class Resources {
        
        private static global::System.Resources.ResourceManager resourceMan;
        
        private static global::System.Globalization.CultureInfo resourceCulture;
        
        [global::System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1811:AvoidUncalledPrivateCode")]
        internal Resources() {
        }
        
        /// <summary>
        ///   Returns the cached ResourceManager instance used by this class.
        /// </summary>
        [global::System.ComponentModel.EditorBrowsableAttribute(global::System.ComponentModel.EditorBrowsableState.Advanced)]
        public static global::System.Resources.ResourceManager ResourceManager {
            get {
                if (object.ReferenceEquals(resourceMan, null)) {
                    global::System.Resources.ResourceManager temp = new global::System.Resources.ResourceManager("AutoRest.Core.Properties.Resources", typeof(Resources).GetTypeInfo().Assembly);
                    resourceMan = temp;
                }
                return resourceMan;
            }
        }
        
        /// <summary>
        ///   Overrides the current thread's CurrentUICulture property for all
        ///   resource lookups using this strongly typed resource class.
        /// </summary>
        [global::System.ComponentModel.EditorBrowsableAttribute(global::System.ComponentModel.EditorBrowsableState.Advanced)]
        public static global::System.Globalization.CultureInfo Culture {
            get {
                return resourceCulture;
            }
            set {
                resourceCulture = value;
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Top level properties should be one of name, type, id, location, properties, tags, plan, sku, etag, managedBy, identity. Extra properties found: &quot;{0}&quot;..
        /// </summary>
        public static string AllowedTopLevelProperties {
            get {
                return ResourceManager.GetString("AllowedTopLevelProperties", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Inline/anonymous models must not be used, instead define a schema with a model name in the &quot;definitions&quot; section and refer to it. This allows operations to share the models..
        /// </summary>
        public static string AnonymousTypesDiscouraged {
            get {
                return ResourceManager.GetString("AnonymousTypesDiscouraged", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to API Version must be in the format: yyyy-MM-dd, optionally followed by -preview, -alpha, -beta, -rc, -privatepreview..
        /// </summary>
        public static string APIVersionFormatIsNotValid {
            get {
                return ResourceManager.GetString("APIVersionFormatIsNotValid", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Top level property names should not be repeated inside the properties bag for ARM resource &apos;{0}&apos;. Properties [{1}] conflict with ARM top level properties. Please rename these..
        /// </summary>
        public static string ArmPropertiesBagValidationMessage {
            get {
                return ResourceManager.GetString("ArmPropertiesBagValidationMessage", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to AutoRest Core {0}.
        /// </summary>
        public static string AutoRestCore {
            get {
                return ResourceManager.GetString("AutoRestCore", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Each body parameter must have a schema.
        /// </summary>
        public static string BodyMustHaveSchema {
            get {
                return ResourceManager.GetString("BodyMustHaveSchema", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Property named: &quot;{0}&quot;, must follow camelCase style. Example: &quot;{1}&quot;..
        /// </summary>
        public static string BodyPropertyNameCamelCase {
            get {
                return ResourceManager.GetString("BodyPropertyNameCamelCase", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to A body parameter cannot have a type, format, or any other properties describing its type..
        /// </summary>
        public static string BodyWithType {
            get {
                return ResourceManager.GetString("BodyWithType", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Booleans are not descriptive and make them hard to use. Instead use string enums with allowed set of values defined: &apos;{0}&apos;..
        /// </summary>
        public static string BooleanPropertyNotRecommended {
            get {
                return ResourceManager.GetString("BooleanPropertyNotRecommended", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Errors found during Swagger document validation..
        /// </summary>
        public static string CodeGenerationError {
            get {
                return ResourceManager.GetString("CodeGenerationError", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Code generation failed with errors. See inner exceptions for details..
        /// </summary>
        public static string CodeGenerationFailed {
            get {
                return ResourceManager.GetString("CodeGenerationFailed", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Could not load CodeGenSettings file &apos;{0}&apos;. Exception: &apos;{1}&apos;..
        /// </summary>
        public static string CodeGenSettingsFileInvalid {
            get {
                return ResourceManager.GetString("CodeGenSettingsFileInvalid", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Collection object {0} returned by list operation {1} with &apos;x-ms-pageable&apos; extension, has no property named &apos;value&apos;..
        /// </summary>
        public static string CollectionObjectPropertiesNamingMessage {
            get {
                return ResourceManager.GetString("CollectionObjectPropertiesNamingMessage", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to \\\\.
        /// </summary>
        public static string CommentString {
            get {
                return ResourceManager.GetString("CommentString", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Plugins:
        ///  CSharp:
        ///    TypeName: PluginCs, AutoRest.CSharp
        ///  Azure.CSharp:
        ///    TypeName: PluginCsa, AutoRest.CSharp.Azure
        ///  Azure.CSharp.Fluent:
        ///    TypeName: PluginCsaf, AutoRest.CSharp.Azure.Fluent
        ///  Ruby:
        ///    TypeName: PluginRb, AutoRest.Ruby
        ///  Azure.Ruby:
        ///    TypeName: PluginRba, AutoRest.Ruby.Azure
        ///  NodeJS:
        ///    TypeName: PluginJs, AutoRest.NodeJS
        ///  Azure.NodeJS:
        ///    TypeName: PluginJsa, AutoRest.NodeJS.Azure
        ///  Python:
        ///    TypeName: PluginPy, AutoRest.Python
        ///  Azure.Python:
        ///    TypeNa [rest of string was truncated]&quot;;.
        /// </summary>
        public static string ConfigurationKnownPlugins {
            get {
                return ResourceManager.GetString("ConfigurationKnownPlugins", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Property named: &quot;{0}&quot;, for definition: &quot;{1}&quot; must follow camelCase style. Example: &quot;{2}&quot;..
        /// </summary>
        public static string DefinitionsPropertiesNameCamelCase {
            get {
                return ResourceManager.GetString("DefinitionsPropertiesNameCamelCase", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to &apos;Delete&apos; operation must not have a request body..
        /// </summary>
        public static string DeleteMustNotHaveRequestBody {
            get {
                return ResourceManager.GetString("DeleteMustNotHaveRequestBody", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to &apos;DELETE&apos; operation &apos;{0}&apos; must use method name &apos;Delete&apos;..
        /// </summary>
        public static string DeleteOperationNameNotValid {
            get {
                return ResourceManager.GetString("DeleteOperationNameNotValid", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to The value provided for description is not descriptive enough. Accurate and descriptive description is essential for maintaining reference documentation..
        /// </summary>
        public static string DescriptionNotDescriptive {
            get {
                return ResourceManager.GetString("DescriptionNotDescriptive", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Directory {0} does not exist..
        /// </summary>
        public static string DirectoryNotExist {
            get {
                return ResourceManager.GetString("DirectoryNotExist", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Empty x-ms-client-name property..
        /// </summary>
        public static string EmptyClientName {
            get {
                return ResourceManager.GetString("EmptyClientName", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to {0} with name &apos;{1}&apos; was renamed to &apos;{2}&apos; because it conflicts with following entities: {3}.
        /// </summary>
        public static string EntityConflictTitleMessage {
            get {
                return ResourceManager.GetString("EntityConflictTitleMessage", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Error generating client model: {0}.
        /// </summary>
        public static string ErrorGeneratingClientModel {
            get {
                return ResourceManager.GetString("ErrorGeneratingClientModel", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Error loading {0} assembly: {1}.
        /// </summary>
        public static string ErrorLoadingAssembly {
            get {
                return ResourceManager.GetString("ErrorLoadingAssembly", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Error saving generated code: {0}.
        /// </summary>
        public static string ErrorSavingGeneratedCode {
            get {
                return ResourceManager.GetString("ErrorSavingGeneratedCode", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Plugin {0} not found.
        /// </summary>
        public static string ExtensionNotFound {
            get {
                return ResourceManager.GetString("ExtensionNotFound", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Successfully initialized {0} Code Generator {1}.
        /// </summary>
        public static string GeneratorInitialized {
            get {
                return ResourceManager.GetString("GeneratorInitialized", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to &apos;GET&apos; operation &apos;{0}&apos; must use method name &apos;Get&apos; or Method name start with &apos;List&apos;.
        /// </summary>
        public static string GetOperationNameNotValid {
            get {
                return ResourceManager.GetString("GetOperationNameNotValid", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Guid used at the #/Definitions/{1}/.../{0}. Usage of Guid is not recommanded. If GUIDs are absolutely required in your service, please get sign off from the Azure API review board..
        /// </summary>
        public static string GuidUsageNotRecommended {
            get {
                return ResourceManager.GetString("GuidUsageNotRecommended", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Each header parameter should have an explicit client name defined for improved code generation output quality..
        /// </summary>
        public static string HeaderShouldHaveClientName {
            get {
                return ResourceManager.GetString("HeaderShouldHaveClientName", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Permissible values for HTTP Verb are delete,get,put,patch,head,options,post. .
        /// </summary>
        public static string HttpVerbIsNotValid {
            get {
                return ResourceManager.GetString("HttpVerbIsNotValid", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Initializing code generator..
        /// </summary>
        public static string InitializingCodeGenerator {
            get {
                return ResourceManager.GetString("InitializingCodeGenerator", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Initializing modeler..
        /// </summary>
        public static string InitializingModeler {
            get {
                return ResourceManager.GetString("InitializingModeler", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Constraint is not supported for this type and will be ignored..
        /// </summary>
        public static string InvalidConstraint {
            get {
                return ResourceManager.GetString("InvalidConstraint", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to The default value is not one of the values enumerated as valid for this element..
        /// </summary>
        public static string InvalidDefault {
            get {
                return ResourceManager.GetString("InvalidDefault", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Property name {0} cannot be used as an Identifier, as it contains only invalid characters..
        /// </summary>
        public static string InvalidIdentifierName {
            get {
                return ResourceManager.GetString("InvalidIdentifierName", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to When property is modeled as &quot;readOnly&quot;: true then x-ms-mutability extension can only have &quot;read&quot; value. When property is modeled as &quot;readOnly&quot;: false then applying x-ms-mutability extension with only &quot;read&quot; value is not allowed. Extension contains invalid values: &apos;{0}&apos;..
        /// </summary>
        public static string InvalidMutabilityValueForReadOnly {
            get {
                return ResourceManager.GetString("InvalidMutabilityValueForReadOnly", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Valid values for an x-ms-mutability extension are &apos;create&apos;, &apos;read&apos; and &apos;update&apos;. Applied extension contains invalid value(s): &apos;{0}&apos;..
        /// </summary>
        public static string InvalidMutabilityValues {
            get {
                return ResourceManager.GetString("InvalidMutabilityValues", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Only body parameters can have a schema defined..
        /// </summary>
        public static string InvalidSchemaParameter {
            get {
                return ResourceManager.GetString("InvalidSchemaParameter", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to &apos;{0}&apos; code generator does not support code generation to a single file..
        /// </summary>
        public static string LanguageDoesNotSupportSingleFileGeneration {
            get {
                return ResourceManager.GetString("LanguageDoesNotSupportSingleFileGeneration", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Since operation &apos;{0}&apos; response has model definition &apos;{1}&apos;, it should be named as &quot;list_*&quot;.
        /// </summary>
        public static string ListOperationsNamingWarningMessage {
            get {
                return ResourceManager.GetString("ListOperationsNamingWarningMessage", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to A &apos;{0}&apos; operation &apos;{1}&apos; with x-ms-long-running-operation extension must have a valid terminal success status code {2}..
        /// </summary>
        public static string LongRunningResponseNotValid {
            get {
                return ResourceManager.GetString("LongRunningResponseNotValid", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to {0} lacks &apos;description&apos; property. Consider adding a &apos;description&apos; element. Accurate description is essential for maintaining reference documentation..
        /// </summary>
        public static string MissingDescription {
            get {
                return ResourceManager.GetString("MissingDescription", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to &apos;{0}&apos; is supposedly required, but no such property exists..
        /// </summary>
        public static string MissingRequiredProperty {
            get {
                return ResourceManager.GetString("MissingRequiredProperty", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Successfully initialized modeler {0} v {1}..
        /// </summary>
        public static string ModelerInitialized {
            get {
                return ResourceManager.GetString("ModelerInitialized", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to For better generated code quality, remove all references to &quot;msdn.microsoft.com&quot;..
        /// </summary>
        public static string MsdnReferencesDiscouraged {
            get {
                return ResourceManager.GetString("MsdnReferencesDiscouraged", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to {0} (already used in {1}).
        /// </summary>
        public static string NamespaceConflictReasonMessage {
            get {
                return ResourceManager.GetString("NamespaceConflictReasonMessage", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Please consider changing your swagger specification to avoid naming conflicts..
        /// </summary>
        public static string NamingConflictsSuggestion {
            get {
                return ResourceManager.GetString("NamingConflictsSuggestion", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Could not find a definition for the path parameter &apos;{0}&apos;.
        /// </summary>
        public static string NoDefinitionForPathParameter {
            get {
                return ResourceManager.GetString("NoDefinitionForPathParameter", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Please make sure that media types other than &apos;application/json&apos; are supported by your service..
        /// </summary>
        public static string NonAppJsonTypeNotSupported {
            get {
                return ResourceManager.GetString("NonAppJsonTypeNotSupported", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Only 1 underscore is permitted in the operation id, following Noun_Verb conventions..
        /// </summary>
        public static string OnlyOneUnderscoreAllowedInOperationId {
            get {
                return ResourceManager.GetString("OnlyOneUnderscoreAllowedInOperationId", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to OperationId is required for all operations. Please add it for &apos;{0}&apos; operation of &apos;{1}&apos; path..
        /// </summary>
        public static string OperationIdMissing {
            get {
                return ResourceManager.GetString("OperationIdMissing", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Per the Noun_Verb convention for Operation Ids, the noun &apos;{0}&apos; should not appear after the underscore..
        /// </summary>
        public static string OperationIdNounInVerb {
            get {
                return ResourceManager.GetString("OperationIdNounInVerb", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Parameters &quot;subscriptionId&quot; and &quot;api-version&quot; are not allowed in the operations section, define these in the global parameters section instead.
        /// </summary>
        public static string OperationParametersNotAllowedMessage {
            get {
                return ResourceManager.GetString("OperationParametersNotAllowedMessage", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Operations API must be implemented for &apos;{0}&apos;..
        /// </summary>
        public static string OperationsAPINotImplemented {
            get {
                return ResourceManager.GetString("OperationsAPINotImplemented", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Parameter &apos;{0}&apos; is not expected..
        /// </summary>
        public static string ParameterIsNotValid {
            get {
                return ResourceManager.GetString("ParameterIsNotValid", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Parameter &apos;{0}&apos; is required..
        /// </summary>
        public static string ParameterValueIsMissing {
            get {
                return ResourceManager.GetString("ParameterValueIsMissing", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Parameter &apos;{0}&apos; value is not valid. Expect &apos;{1}&apos;.
        /// </summary>
        public static string ParameterValueIsNotValid {
            get {
                return ResourceManager.GetString("ParameterValueIsNotValid", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to &apos;PATCH&apos; operation &apos;{0}&apos; must use method name &apos;Update&apos;..
        /// </summary>
        public static string PatchOperationNameNotValid {
            get {
                return ResourceManager.GetString("PatchOperationNameNotValid", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to path cannot be null or an empty string or a string with white spaces while getting the parent directory.
        /// </summary>
        public static string PathCannotBeNullOrEmpty {
            get {
                return ResourceManager.GetString("PathCannotBeNullOrEmpty", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to {0} has different responses for PUT/GET/PATCH operations. The PUT/GET/PATCH operations must have same schema response..
        /// </summary>
        public static string PutGetPatchResponseInvalid {
            get {
                return ResourceManager.GetString("PutGetPatchResponseInvalid", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to &apos;PUT&apos; operation &apos;{0}&apos; must use method name &apos;Create&apos;..
        /// </summary>
        public static string PutOperationNameNotValid {
            get {
                return ResourceManager.GetString("PutOperationNameNotValid", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Property &apos;{0}&apos; is a required property. It should not be marked as &apos;readonly&apos;..
        /// </summary>
        public static string RequiredReadOnlyPropertiesValidation {
            get {
                return ResourceManager.GetString("RequiredReadOnlyPropertiesValidation", resourceCulture);
            }
        }

        /// <summary>
        ///   Looks up a localized string similar to A &apos;Resource&apos; definition must have x-ms-azure-resource extension enabled and set to true..
        /// </summary>
        public static string ResourceIsMsResourceNotValid {
            get {
                return ResourceManager.GetString("ResourceIsMsResourceNotValid", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to The id, name, type, location and tags properties of the Resource must be present with id, name and type as read-only.
        /// </summary>
        public static string ResourceModelIsNotValid {
            get {
                return ResourceManager.GetString("ResourceModelIsNotValid", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Parameter &quot;{0}&quot; is referenced but not defined in the global parameters section of Service Definition.
        /// </summary>
        public static string ServiceDefinitionParametersMissingMessage {
            get {
                return ResourceManager.GetString("ServiceDefinitionParametersMissingMessage", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Sku Model is not valid. A Sku model must have &apos;name&apos; property. It can also have &apos;tier&apos;, &apos;size&apos;, &apos;family&apos;, &apos;capacity&apos; as optional properties..
        /// </summary>
        public static string SkuModelIsNotValid {
            get {
                return ResourceManager.GetString("SkuModelIsNotValid", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Azure Resource Management only supports HTTPS scheme..
        /// </summary>
        public static string SupportedSchemesWarningMessage {
            get {
                return ResourceManager.GetString("SupportedSchemesWarningMessage", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Operations can not have more than one &apos;body&apos; parameter. The following were found: &apos;{0}&apos;.
        /// </summary>
        public static string TooManyBodyParameters {
            get {
                return ResourceManager.GetString("TooManyBodyParameters", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Tracked resource &apos;{0}&apos; must have a get operation..
        /// </summary>
        public static string TrackedResourceGetOperationMissing {
            get {
                return ResourceManager.GetString("TrackedResourceGetOperationMissing", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Tracked Resource failing validation is: &quot;{0}&quot;. Validation Failed: {1}.
        ///    A Tracked Resource must have: 
        ///    1. A Get Operation 
        ///    2. A ListByResourceGroup operation with x-ms-pageable extension and 
        ///    3. A ListBySubscriptionId operation with x-ms-pageable extension.
        ///    4. &quot;type&quot;,&quot;location&quot;,&quot;tags&quot; should not be used in the RP property bag named &quot;properties&quot;..
        /// </summary>
        public static string TrackedResourceIsNotValid {
            get {
                return ResourceManager.GetString("TrackedResourceIsNotValid", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Tracked resource &apos;{0}&apos; must have patch operation that at least supports the update of tags..
        /// </summary>
        public static string TrackedResourcePatchOperationMissing {
            get {
                return ResourceManager.GetString("TrackedResourcePatchOperationMissing", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Type &apos;{0}&apos; name should be assembly qualified. For example &apos;ClassName, AssemblyName&apos;.
        /// </summary>
        public static string TypeShouldBeAssemblyQualified {
            get {
                return ResourceManager.GetString("TypeShouldBeAssemblyQualified", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Multiple resource providers are not allowed in a single spec. More than one the resource paths were found: &apos;{0}&apos;..
        /// </summary>
        public static string UniqueResourcePaths {
            get {
                return ResourceManager.GetString("UniqueResourcePaths", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to &apos;{0}&apos; is not a known format..
        /// </summary>
        public static string UnknownFormat {
            get {
                return ResourceManager.GetString("UnknownFormat", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Value of &apos;x-ms-client-name&apos; cannot be the same as &apos;{0}&apos; Property/Model..
        /// </summary>
        public static string XmsClientNameInvalid {
            get {
                return ResourceManager.GetString("XmsClientNameInvalid", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Paths in x-ms-paths must overload a normal path in the paths section, i.e. a path in the x-ms-paths must either be same as a path in the paths section or a path in the paths sections followed by additional parameters..
        /// </summary>
        public static string XMSPathBaseNotInPaths {
            get {
                return ResourceManager.GetString("XMSPathBaseNotInPaths", resourceCulture);
            }
        }
    }
}
