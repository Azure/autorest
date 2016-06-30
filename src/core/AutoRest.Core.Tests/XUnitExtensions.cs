// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using Xunit;

namespace AutoRest.Core.Tests
{
    public static class AssertEx
    {
        public static void Fail(string text = null)
        {
            throw new ApplicationException(text);
        }

        public static void Equal<T>(T expectedValue, T actualValue, string text)
        {
            try
            {
                Assert.Equal(expectedValue, actualValue);
            }
            catch (Exception e)
            {
                throw new ApplicationException(text, e);
            }
        }

        public static void Equivalent<T>(IEnumerable<T> expectedValue, IEnumerable<T> actualValue)
        {
            Assert.Equal(expectedValue.Count(), actualValue.Count());
            foreach (var item in expectedValue)
            {
                Assert.True(actualValue.Contains(item),
                    item + " was not found in collection [" + string.Join(",", actualValue) + "]");
            }
        }

        public static void Null<T>(T actualValue, string text)
        {
            try
            {
                Assert.Null(actualValue);
            }
            catch (Exception e)
            {
                throw new ApplicationException(text, e);
            }
        }

        public static void NotNull<T>(T actualValue, string text)
        {
            try
            {
                Assert.NotNull(actualValue);
            }
            catch (Exception e)
            {
                throw new ApplicationException(text, e);
            }
        }

        public static bool ContainsMultiline(this string text, string textToMatch)
        {
            if (text == textToMatch)
            {
                return true;
            }

            if (text == null || textToMatch == null)
            {
                return false;
            }

            var splitText = text.Split(new[] {"\n", "\r\n"}, StringSplitOptions.RemoveEmptyEntries);
            var splitTextToMatch = textToMatch.Split(new[] {"\n", "\r\n"}, StringSplitOptions.RemoveEmptyEntries);

            // Simple case with 1 line in text to match
            if (splitTextToMatch.Length == 1)
            {
                return text.Contains(textToMatch.Trim());
            }

            // Case with text to match empty
            if (splitTextToMatch.Length == 0)
            {
                return true;
            }

            for (int i = 0; i < splitText.Length; i++)
            {
                if (splitText[i].EqualsIgnoreSpace(splitTextToMatch[0]))
                {
                    var match = TryMatchSubstrings(i, splitText, splitTextToMatch);
                    if (match)
                    {
                        return true;
                    }
                }
            }

            return false;
        }

        private static bool TryMatchSubstrings(int lineToStartFrom, string[] splitText, string[] splitTextToMatch)
        {
            var linesLeftInSplitText = splitText.Length - lineToStartFrom;

            if (splitTextToMatch.Length > linesLeftInSplitText)
            {
                return false;
            }

            var counter = 0;
            for (int i = lineToStartFrom; i < lineToStartFrom + splitTextToMatch.Length; i++)
            {
                if (!splitText[i].EqualsIgnoreSpace(splitTextToMatch[counter]))
                {
                    return false;
                }
                counter++;
            }

            return true;
        }

        private static bool EqualsIgnoreSpace(this string text, string textToMatch)
        {
            if (text == null || textToMatch == null)
            {
                return false;
            }
            return text.Trim().Equals(textToMatch.Trim(), StringComparison.InvariantCulture);
        }
    }
}