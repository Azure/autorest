// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Linq;
using System.Globalization;
using System.IO;
using System.Text;
using System.Threading.Tasks;
using AutoRest.Core;

namespace AutoRest.Go
{
    /// <summary>
    /// Base code generation template.
    /// </summary>
    public abstract class Template<T> : AutoRest.Core.Template<T>
    {
        /// <summary>
        /// Inserts a block comment with specified prefix.
        /// </summary>
        /// <param name="prefix"></param>
        /// <param name="filler"></param>
        /// <param name="comment"></param>
        /// <returns></returns>
        protected virtual string BlockComment(string prefix, char filler, string comment)
        {
            if (string.IsNullOrWhiteSpace(comment))
            {
                return null;
            }

            var headerFooter = prefix.PadRight(MaximumCommentColumn, filler) + "\r\n";
            return headerFooter + prefix + "\r\n" + WrapComment(prefix + " ", comment) + "\r\n" + prefix + "\r\n" + headerFooter;
        }
    }
}