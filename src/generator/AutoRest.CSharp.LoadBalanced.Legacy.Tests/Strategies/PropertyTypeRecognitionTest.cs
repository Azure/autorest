using System;
using System.Collections.Generic;
using AutoRest.Core.Model;
using NUnit.Framework;
using AutoRest.CSharp.LoadBalanced.Legacy.Strategies;

namespace AutoRest.CSharp.LoadBalanced.Legacy.Tests.Strategies
{
    [TestFixture]
    public class PropertyTypeRecognitionTest
    {
        [Test, TestCaseSource(nameof(GetTypeRecognitionTestCases))]
        public void TypeRecognitionTest(Func<Property, bool> typeCheck, Property property, bool expectedOutcome)
        {
            //Assert.AreEqual(typeCheck(property), expectedOutcome);
        }

        public static IEnumerable<object[]> GetTypeRecognitionTestCases()
        {
            var baseStrategy = new PropertyTypeSelectionStrategy();
            var wrappedStrategy = new WrappedPropertyTypeSelectionStrategy();
            foreach (var testCase in GetCommonTypeRecognitionTestCases(baseStrategy))
            {
                yield return testCase;
            }
            foreach (var testCase in GetCommonTypeRecognitionTestCases(wrappedStrategy))
            {
                yield return testCase;
            }
        }

        public static IEnumerable<object[]> GetCommonTypeRecognitionTestCases(IPropertyTypeSelectionStrategy strategy)
        {
            yield return new object[] { UseFunc(strategy.IsDateTime), null, true };
            yield return new object[] { UseFunc(strategy.IsUrl), null, true };
            yield return new object[] { UseFunc(strategy.IsDictionary), null, true };
            yield return new object[] { UseFunc(strategy.IsUInt64Value), null, true };
            yield return new object[] { UseFunc(strategy.IsInt32Value), null, true };
            yield return new object[] { UseFunc(strategy.IsUInt32Value), null, true };
            yield return new object[] { UseFunc(strategy.IsBoolValue), null, true };
            yield return new object[] { UseFunc(strategy.IsStringValue), null, true };
            yield return new object[] { UseFunc(strategy.IsBytesValue), null, true };
            yield return new object[] { UseFunc(strategy.IsMoney), null, true };
            yield return new object[] { UseFunc(strategy.IsGuid), null, true };
            yield return new object[] { UseFunc(strategy.IsBooleanString), null, true };
        }

        private static Func<Property, bool> UseFunc(Func<Property, bool> func)
        {
            return func;
        }
    }
}
