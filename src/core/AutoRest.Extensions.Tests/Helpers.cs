// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;

namespace AutoRest.Extensions.Tests
{
    public static class Helpers
    {
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

            var splitText = text.Split(new[] { "\n", "\r\n" }, StringSplitOptions.RemoveEmptyEntries);
            var splitTextToMatch = textToMatch.Split(new[] { "\n", "\r\n" }, StringSplitOptions.RemoveEmptyEntries);

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
            return text.Trim().Equals(textToMatch.Trim(), StringComparison.Ordinal);
        }
    }
}
