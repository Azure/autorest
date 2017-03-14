using System.Collections.Generic;
using AutoRest.Core.Model;
using AutoRest.TypeScript.SuperAgent.ModelBinder;
using NUnit.Framework;

namespace AutoRest.TypeScript.SuperAgent.Tests
{
    [TestFixture]
    public class TypeTextTest
    {
        [Test, Parallelizable, TestCaseSource(nameof(GetTypeTextTestCases))]
        public void GetTypeTextTest(IModelType modelType, string moduleName, string expectedText)
        {
            var binder = new ModelBinderBaseTs();
            var text = binder.GetTypeText(modelType, moduleName);
            Assert.IsNotNull(text);
            Assert.IsTrue(text.Trim() == expectedText.Trim());
        }

        public static IEnumerable<object[]> GetTypeTextTestCases()
        {
            foreach (var testCase in GetPrimaryTypeTestCases())
            {
                yield return testCase;
            }
        }

        public static IEnumerable<object[]> GetPrimaryTypeTestCases()
        {
            var namespaces = new [] {null, "stuff"};

            foreach (var ns in namespaces)
            {
                yield return new object[] {new PrimaryTypeTs(KnownPrimaryType.Boolean), ns, PrimaryTypeTs.BoolTypeName};
                yield return
                    new object[]
                    {
                        new SequenceTypeTs {ElementType = new PrimaryTypeTs(KnownPrimaryType.Boolean)}, ns,
                        $"{PrimaryTypeTs.BoolTypeName}[]"
                    };

                foreach (var primaryType in PrimaryTypeTs.NumericTypes)
                {
                    yield return new object[] {new PrimaryTypeTs(primaryType), ns, PrimaryTypeTs.NumberTypeName};
                    yield return
                        new object[]
                        {
                            new SequenceTypeTs {ElementType = new PrimaryTypeTs(primaryType)}, ns,
                            $"{PrimaryTypeTs.NumberTypeName}[]"
                        };
                }

                foreach (var primaryType in PrimaryTypeTs.TextTypes)
                {
                    yield return new object[] {new PrimaryTypeTs(primaryType), ns, PrimaryTypeTs.TextTypeName};
                    yield return
                        new object[]
                        {
                            new SequenceTypeTs {ElementType = new PrimaryTypeTs(primaryType)}, ns,
                            $"{PrimaryTypeTs.TextTypeName}[]"
                        };
                }

                foreach (var primaryType in PrimaryTypeTs.DateTypes)
                {
                    yield return new object[] {new PrimaryTypeTs(primaryType), ns, PrimaryTypeTs.DateTypeName};
                    yield return
                        new object[]
                        {
                            new SequenceTypeTs {ElementType = new PrimaryTypeTs(primaryType)}, ns,
                            $"{PrimaryTypeTs.DateTypeName}[]"
                        };
                }
            }
        }
    }
}
