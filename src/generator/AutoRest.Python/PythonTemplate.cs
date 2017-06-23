using System;
using System.Globalization;
using System.Linq;
using AutoRest.Core;
using AutoRest.Core.Utilities;

namespace AutoRest.Python
{
    public abstract class PythonTemplate<T> : Template<T>
    {
        protected string ParameterWrapComment(string prefix, string comment)
        {
            if (string.IsNullOrWhiteSpace(comment))
            {
                return null;
            }

            // escape comment as needed
            comment = comment.Replace("\\", "\\\\");

            int available =
                (Settings.Instance?.MaximumCommentColumns ?? Settings.DefaultMaximumCommentColumns) - // Maximum desired width
                Indentation.Length - // - Space used for indent
                prefix.Length - // - Prefix //'s length
                1 - // - Extra space between prefix and text
                1; // - Extra space for parameter start

            return string.Join(Environment.NewLine + " ", comment.WordWrap(available).Select(s => $"{prefix}{s}"));
        }
    }
}
