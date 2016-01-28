using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Rest.Generator.Utilities;

namespace Microsoft.Rest.Generator.Python
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
                MaximumCommentColumn - // Maximum desired width
                Indentation.Length - // - Space used for indent
                prefix.Length - // - Prefix //'s length
                1 - // - Extra space between prefix and text
                1; // - Extra space for parameter start

            return string.Join(Environment.NewLine + " ", comment.WordWrap(available)
                .Select(s => string.Format(CultureInfo.InvariantCulture, "{0}{1}", prefix, s)));
        }
    }
}
