// This file is used by Code Analysis to maintain SuppressMessage 
// attributes that are applied to this project.
// Project-level suppressions either have no target or are given 
// a specific target and scoped to a namespace, type, member, etc.
//
// To add a suppression to this file, right-click the message in the 
// Code Analysis results, point to "Suppress Message", and click 
// "In Suppression File".
// You do not need to add suppressions to this file manually.

[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1020:AvoidNamespacesWithFewTypes", 
    Scope = "namespace", Target = "Microsoft.Rest.Generator.Extensibility", 
    Justification = "Logic grouping for extensibility points.")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA2204:Literals should be spelled correctly", 
    MessageId = "AutoRest", Scope = "member", Target = "Microsoft.Rest.Generator.AutoRest.#Generate(Microsoft.Rest.Generator.Settings)", Justification = "Proper spelling.")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Globalization", "CA1308:NormalizeStringsToUppercase", 
    Scope = "member", Target = "Microsoft.Rest.Generator.CodeNamingFramework.#FormatCase(System.String,System.Boolean)", 
    Justification = "Required by design.")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1036:OverrideMethodsOnComparableTypes", 
    Scope = "type", Target = "Microsoft.Rest.Generator.ClientModel.EnumValue")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1019:DefineAccessorsForAttributeArguments", 
    Scope = "type", Target = "Microsoft.Rest.Generator.SettingsInfoAttribute", Justification="Parameter is optional")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1704:IdentifiersShouldBeSpelledCorrectly", 
    MessageId = "Api", Scope = "member", Target = "Microsoft.Rest.Generator.ClientModel.ServiceClient.#ApiVersion")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1704:IdentifiersShouldBeSpelledCorrectly", 
    MessageId = "Mit", Scope = "member", Target = "Microsoft.Rest.Generator.Settings.#MicrosoftMitLicenseHeader")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1704:IdentifiersShouldBeSpelledCorrectly", 
    MessageId = "V", Scope = "member", Target = "Microsoft.Rest.Generator.Template`1.#Include`2(!!0,!!1)")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1704:IdentifiersShouldBeSpelledCorrectly", 
    MessageId = "U", Scope = "member", Target = "Microsoft.Rest.Generator.Template`1.#Include`2(!!0,!!1)")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Globalization", "CA1308:NormalizeStringsToUppercase", 
    Scope = "member", Target = "Microsoft.Rest.Generator.CodeNamer.#FormatCase(System.String,System.Boolean)")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1704:IdentifiersShouldBeSpelledCorrectly", 
    MessageId = "Namer", Scope = "type", Target = "Microsoft.Rest.Generator.CodeNamer")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1716:IdentifiersShouldNotMatchKeywords", 
    MessageId = "Property", Scope = "type", Target = "Microsoft.Rest.Generator.ClientModel.Property")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1721:PropertyNamesShouldNotMatchGetMethods", 
    Scope = "member", Target = "Microsoft.Rest.Generator.ClientModel.Parameter.#Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1721:PropertyNamesShouldNotMatchGetMethods", 
    Scope = "member", Target = "Microsoft.Rest.Generator.ClientModel.Property.#Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Reliability", "CA2000:Dispose objects before losing scope", 
    Scope = "member", Target = "Microsoft.Rest.Generator.Utilities.MemoryFileSystem.#GetTextWriter(System.String)")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", 
    "CA1810:InitializeReferenceTypeStaticFieldsInline", Scope = "member", 
    Target = "Microsoft.Rest.Generator.ClientModel.PrimaryType.#.cctor()")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Reliability", 
    "CA2000:Dispose objects before losing scope", 
    Scope = "member", Target = "Microsoft.Rest.Generator.Template`1.#ToString()")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1002:DoNotExposeGenericLists", 
    Scope = "member", Target = "Microsoft.Rest.Generator.ClientModel.Method.#Parameters")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1704:IdentifiersShouldBeSpelledCorrectly", MessageId = "Rfc", Scope = "member", Target = "Microsoft.Rest.Generator.ClientModel.PrimaryType.#DateTimeRfc1123")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1002:DoNotExposeGenericLists", Scope = "member", Target = "Microsoft.Rest.Generator.ClientModel.Method.#InputParameterMappings")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1716:IdentifiersShouldNotMatchKeywords", MessageId = "Boolean", Scope = "type", Target = "Microsoft.Rest.Generator.ClientModel.PrimaryType+Boolean")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1034:NestedTypesShouldNotBeVisible", Scope = "type", Target = "Microsoft.Rest.Generator.ClientModel.PrimaryType+Boolean")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1034:NestedTypesShouldNotBeVisible", Scope = "type", Target = "Microsoft.Rest.Generator.ClientModel.PrimaryType+ByteArray")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1034:NestedTypesShouldNotBeVisible", Scope = "type", Target = "Microsoft.Rest.Generator.ClientModel.PrimaryType+Credentials")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1716:IdentifiersShouldNotMatchKeywords", MessageId = "Date", Scope = "type", Target = "Microsoft.Rest.Generator.ClientModel.PrimaryType+Date")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1034:NestedTypesShouldNotBeVisible", Scope = "type", Target = "Microsoft.Rest.Generator.ClientModel.PrimaryType+Date")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1034:NestedTypesShouldNotBeVisible", Scope = "type", Target = "Microsoft.Rest.Generator.ClientModel.PrimaryType+DateTime")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1704:IdentifiersShouldBeSpelledCorrectly", MessageId = "Rfc", Scope = "type", Target = "Microsoft.Rest.Generator.ClientModel.PrimaryType+DateTimeRfc1123")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1034:NestedTypesShouldNotBeVisible", Scope = "type", Target = "Microsoft.Rest.Generator.ClientModel.PrimaryType+DateTimeRfc1123")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1716:IdentifiersShouldNotMatchKeywords", MessageId = "Decimal", Scope = "type", Target = "Microsoft.Rest.Generator.ClientModel.PrimaryType+Decimal")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1034:NestedTypesShouldNotBeVisible", Scope = "type", Target = "Microsoft.Rest.Generator.ClientModel.PrimaryType+Decimal")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1716:IdentifiersShouldNotMatchKeywords", MessageId = "Double", Scope = "type", Target = "Microsoft.Rest.Generator.ClientModel.PrimaryType+Double")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1034:NestedTypesShouldNotBeVisible", Scope = "type", Target = "Microsoft.Rest.Generator.ClientModel.PrimaryType+Double")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1034:NestedTypesShouldNotBeVisible", Scope = "type", Target = "Microsoft.Rest.Generator.ClientModel.PrimaryType+Int")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1716:IdentifiersShouldNotMatchKeywords", MessageId = "Long", Scope = "type", Target = "Microsoft.Rest.Generator.ClientModel.PrimaryType+Long")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1034:NestedTypesShouldNotBeVisible", Scope = "type", Target = "Microsoft.Rest.Generator.ClientModel.PrimaryType+Long")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1716:IdentifiersShouldNotMatchKeywords", MessageId = "Object", Scope = "type", Target = "Microsoft.Rest.Generator.ClientModel.PrimaryType+Object")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1034:NestedTypesShouldNotBeVisible", Scope = "type", Target = "Microsoft.Rest.Generator.ClientModel.PrimaryType+Object")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1711:IdentifiersShouldNotHaveIncorrectSuffix", Scope = "type", Target = "Microsoft.Rest.Generator.ClientModel.PrimaryType+Stream")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1034:NestedTypesShouldNotBeVisible", Scope = "type", Target = "Microsoft.Rest.Generator.ClientModel.PrimaryType+Stream")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1716:IdentifiersShouldNotMatchKeywords", MessageId = "String", Scope = "type", Target = "Microsoft.Rest.Generator.ClientModel.PrimaryType+String")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1034:NestedTypesShouldNotBeVisible", Scope = "type", Target = "Microsoft.Rest.Generator.ClientModel.PrimaryType+String")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1034:NestedTypesShouldNotBeVisible", Scope = "type", Target = "Microsoft.Rest.Generator.ClientModel.PrimaryType+TimeSpan")]

