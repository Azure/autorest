// This file is used by Code Analysis to maintain SuppressMessage
// attributes that are applied to this project.
// Project-level suppressions either have no target or are given
// a specific target and scoped to a namespace, type, member, etc.
//
// To add a suppression to this file, right-click the message in the
// Code Analysis results, point to "Suppress Message", and click
// "In Suppression File".
// You do not need to add suppressions to this file manually.

[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Maintainability", "CA1502:AvoidExcessiveComplexity",
Scope = "member", Target = "Microsoft.Rest.Generator.CSharp.Azure.Tests.AcceptanceTests.#LroSadPathTests()", Justification="Test code is straighforward")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Reliability", "CA2000:Dispose objects before losing scope",
Scope = "member", Target = "Microsoft.Rest.Generator.CSharp.Azure.Tests.AcceptanceTests.#AzureSpecialParametersTests()", Justification="Process cannot be disposed at end of method - it is always disposed at end of test run")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1811:AvoidUncalledPrivateCode", Scope = "member",
    Target = "Fixtures.Azure.AcceptanceTestsResourceFlattening.Models.FlattenedProduct.#ProvisioningStateValues", Justification="Necessary for read-only properties in serialization types")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1811:AvoidUncalledPrivateCode", Scope = "member",
    Target = "Fixtures.Azure.AcceptanceTestsLro.Models.Product.#ProvisioningStateValues", Justification="Necessary for read-only properties in serialization types")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1811:AvoidUncalledPrivateCode", Scope = "member",
    Target = "Fixtures.Azure.AcceptanceTestsLro.Models.SubProduct.#ProvisioningStateValues", Justification="Necessary for read-only properties in serialization types")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Reliability", "CA2000:Dispose objects before losing scope", Scope = "member", Target = "Microsoft.Rest.Generator.CSharp.Azure.Tests.AcceptanceTests.#XmsRequestClientIdTest()")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Reliability", "CA2000:Dispose objects before losing scope", Scope = "member", Target = "Microsoft.Rest.Generator.CSharp.Azure.Tests.AcceptanceTests.#AzureODataTests()")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1710:IdentifiersShouldHaveCorrectSuffix", Scope = "type", Target = "Fixtures.Azure.AcceptanceTestsPaging.Models.Page`1")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1811:AvoidUncalledPrivateCode", Scope = "member", Target = "Fixtures.Azure.AcceptanceTestsLro.Models.Resource.#Id")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1811:AvoidUncalledPrivateCode", Scope = "member", Target = "Fixtures.Azure.AcceptanceTestsLro.Models.Resource.#Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1811:AvoidUncalledPrivateCode", Scope = "member", Target = "Fixtures.Azure.AcceptanceTestsLro.Models.Resource.#Name")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1811:AvoidUncalledPrivateCode", Scope = "member", Target = "Fixtures.Azure.AcceptanceTestsLro.Models.SubResource.#Id")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1811:AvoidUncalledPrivateCode", Scope = "member", Target = "Fixtures.Azure.AcceptanceTestsResourceFlattening.Models.Resource.#Id")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1811:AvoidUncalledPrivateCode", Scope = "member", Target = "Fixtures.Azure.AcceptanceTestsResourceFlattening.Models.Resource.#Type")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1811:AvoidUncalledPrivateCode", Scope = "member", Target = "Fixtures.Azure.AcceptanceTestsResourceFlattening.Models.Resource.#Name")]

