// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Text;

namespace Microsoft.Rest.CSharp.Compiler.Compilation
{
    public static class TemplateUtilities
    {
        public static string ApplyReplacements(string contents, IDictionary<string, string> replacements)
        {
            const int MaxReplacements = 1000;

            //
            // As long as tokens are defined as strings enclosed by '$' characters, it is more 
            // efficient to look for $...$ occurrences than it is to search for all occurrences
            // of every token in replacements. The only catch is that two matching '$' would 
            // effectively define a token.  This case is easily resolved by requiring escaping 
            // of '$' with another '$' (i.e. $$ -> '$').
            // 

            Debug.Assert(!replacements.ContainsKey("$$"), "\"$$\" must not be part of replacements dictionary");

            var buffer = new StringBuilder(contents);
            int tokenIndex;
            string token;

            var index = 0;
            var infiniteLoopGuard = 0;

            while ((tokenIndex = buffer.FindNextToken(index, out token)) != -1)
            {
                string replacement;
                if (token == "$$")
                {
                    // Unescape '$' and move one character forward
                    buffer.Replace("$$", "$", tokenIndex, 2);
                    index = tokenIndex + 1;
                }
                else if (replacements.TryGetValue(token, out replacement))
                {
                    // Replace token but do not modify 'startIndex' to allow for nested replacements
                    buffer.Replace(token, replacement, tokenIndex, token.Length);
                }
                else
                {
                    // Do not replace token and fully skip it
                    index = tokenIndex + token.Length;
                }

                if (++infiniteLoopGuard > MaxReplacements)
                {
                    // TODO: LOC: Infinite loop guard
                    throw new InvalidOperationException("Exceeded token replacement limit");
                }
            }

            return buffer.ToString();
        }

        #region Private & Helpers

        /// <summary>
        ///     Finds the next token in <paramref name="buffer" /> starting at <paramref name="startIndex" />.
        /// </summary>
        /// <returns>Start index of <paramref name="token" /> or -1</returns>
        private static int FindNextToken(this StringBuilder buffer, int startIndex, out string token)
        {
            var tokenStart = buffer.IndexOf('$', startIndex);

            if ((tokenStart != -1) && tokenStart + 1 < buffer.Length)
            {
                int tokenEnd = buffer.IndexOf('$', tokenStart + 1);

                if (tokenEnd != -1)
                {
                    token = buffer.ToString(tokenStart, tokenEnd - tokenStart + 1);
                    return tokenStart;
                }
            }

            token = null;
            return -1;
        }

        /// <summary>
        ///     <c>string.IndexOf</c> equivalent for <see cref="System.Text.StringBuilder" />
        /// </summary>
        private static int IndexOf(this StringBuilder buffer, char value, int startIndex)
        {
            for (var i = startIndex; i < buffer.Length; i++)
            {
                if (buffer[i] == value)
                {
                    return i;
                }
            }
            return -1;
        }

        #endregion
    }
}