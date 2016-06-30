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
    Scope = "namespace", Target = "AutoRest.CSharp.Azure.Templates", Justification="Parallel with other generators.")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1020:AvoidNamespacesWithFewTypes", 
    Scope = "namespace", Target = "AutoRest.CSharp", Justification="Parallel with other generators.")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Globalization", 
    "CA1303:Do not pass literals as localized parameters", 
    MessageId = "AutoRest.Core.Utilities.IndentedStringBuilder.AppendLine(System.String)", Scope = "member", 
    Target = "AutoRest.CSharp.Azure.AzureMethodTemplateModel.#BuildUrl(System.String)", 
    Justification="Literal string is generated code.")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Globalization", 
    "CA1303:Do not pass literals as localized parameters", 
    MessageId = "AutoRest.Core.Utilities.IndentedStringBuilder.AppendLine(System.String)", Scope = "member", 
    Target = "AutoRest.CSharp.Azure.AzureMethodTemplateModel.#AddQueryParametersToUri(System.String,AutoRest.Core.Utilities.IndentedStringBuilder)", 
    Justification="Literal string is generated code.")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Globalization", 
    "CA1303:Do not pass literals as localized parameters", 
    MessageId = "AutoRest.Core.Utilities.IndentedStringBuilder.AppendLine(System.String)", Scope = "member", 
    Target = "AutoRest.CSharp.Azure.AzureMethodTemplateModel.#ReplaceSubscriptionIdInUri(System.String,AutoRest.Core.Utilities.IndentedStringBuilder)", 
    Justification="Literal string is generated code.")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Globalization", "CA1303:Do not pass literals as localized parameters", MessageId = "AutoRest.Core.Utilities.IndentedStringBuilder.AppendLine(System.String)", Scope = "member", Target = "AutoRest.CSharp.Azure.AzureMethodTemplateModel.#SetDefaultHeaders",
    Justification = "Required for Azure customization.")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Globalization", "CA1303:Do not pass literals as localized parameters", MessageId = "AutoRest.Core.Utilities.IndentedStringBuilder.AppendLine(System.String)", Scope = "member", Target = "AutoRest.CSharp.Azure.AzureMethodTemplateModel.#InitializeResponseBody",
    Justification = "Required for Azure customization.")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Globalization", "CA1303:Do not pass literals as localized parameters", MessageId = "AutoRest.Core.Utilities.IndentedStringBuilder.AppendLine(System.String)", Scope = "member", Target = "AutoRest.CSharp.Azure.AzureMethodTemplateModel.#InitializeException")]

