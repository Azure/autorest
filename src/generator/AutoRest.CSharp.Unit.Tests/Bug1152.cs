using System.Text.RegularExpressions;
using Xunit;

namespace AutoRest.CSharp.Unit.Tests
{
    public class Bug1152 : BugTest
    {
        /// <summary>
        /// https://github.com/Azure/autorest/issues/1152
        /// 
        /// The C# code generator seems to needlessly escape backslashes when generating ///
        /// </summary>
        [Fact]
        public void SummaryCommentsContainImproperlyEscapedBackslashes()
        {
            // simplified test pattern for unit testing aspects of code generation
            using (var fileSystem = "Bug1152.yaml".GenerateCodeInto(CreateMockFilesystem()))
            {
                Assert.True(fileSystem.FileExists(@"GeneratedCode\Models\TestObject.cs"));
                var testObject = fileSystem.ReadFileAsText(@"GeneratedCode\Models\TestObject.cs");
               
                Assert.DoesNotContain(@"\\\\" , Regex.Match(testObject, "Default is.*").Value);
            }
        }
    }
}