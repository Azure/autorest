using System.IO;
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
            using (var fileSystem = "Bug1152".GenerateCodeInto(fileSystem : CreateMockFilesystem(), modeler : "Swagger"))
            {
                var expectedPath = Path.Combine("GeneratedCode", "Models", "TestObject.cs");
                Assert.True(fileSystem.FileExists(expectedPath));
                var testObject = fileSystem.ReadAllText(expectedPath);

                Assert.DoesNotContain(@"\\\\", Regex.Match(testObject, "Default is.*").Value);
            }
        }
    }
}