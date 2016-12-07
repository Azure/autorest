// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Globalization;
using System.Linq;
using System.Text;

namespace AutoRest.Core.Utilities
{
    /// <summary>
    /// Custom string builder with indentation support.
    /// </summary>
    public class IndentedStringBuilder
    {
        public const string FourSpaces = "    ";
        public const string TwoSpaces = "  ";
        private int _indentationCount;
        private readonly StringBuilder _builder;
        private readonly string _indentation;

        /// <summary>
        /// Gets current indentation.
        /// </summary>
        private string CurrentIndentation
        {
            get { return string.Concat(Enumerable.Repeat(_indentation, _indentationCount)); }
        }

        /// <summary>
        /// Initializes a new instance of IndentedStringBuilder.
        /// </summary>
        /// <param name="indentation">String to use as an indentation.</param>
        public IndentedStringBuilder(string indentation)
        {
            _indentation = indentation;
            _builder = new StringBuilder();
            _indentationCount = 0;
        }

        /// <summary>
        /// Initializes a new instance of IndentedStringBuilder with Fourspaces as indentation.
        /// </summary>
        public IndentedStringBuilder():this(FourSpaces)
        {
        }

        /// <summary>
        /// Adds a level of indentation.
        /// </summary>
        /// <returns>Current instance of IndentedStringBuilder.</returns>
        public IndentedStringBuilder Indent()
        {
            _indentationCount++;
            return this;
        }

        /// <summary>
        /// Removes a level of indentation.
        /// </summary>
        /// <returns>Current instance of IndentedStringBuilder.</returns>
        public IndentedStringBuilder Outdent()
        {
            _indentationCount--;
            if (_indentationCount < 0)
            {
                _indentationCount = 0;
            }
            return this;
        }

        /// <summary>
        /// Appends text.
        /// </summary>
        /// <param name="text">Text to append.</param>
        /// <returns>Current instance of IndentedStringBuilder.</returns>
        public IndentedStringBuilder Append(string text)
        {
            _builder.Append(IndentMultilineString(text, CurrentIndentation));
            return this;
        }

        /// <summary>
        /// Appends formatted text.
        /// </summary>
        /// <param name="format">A composite format string.</param>
        /// <param name="args">An array of objects to format. </param>
        /// <returns>Current instance of IndentedStringBuilder.</returns>
        public IndentedStringBuilder AppendFormat(string format, params object[] args)
        {
            if (args != null)
            {
                for (int i = 0; i < args.Length; i++)
                {
                    if (args[i] is string)
                    {
                        args[i] = IndentMultilineString((string)args[i], CurrentIndentation);
                    }
                }
            }
            _builder.AppendFormat(CultureInfo.InvariantCulture, format, args);
            return this;
        }

        /// <summary>
        /// Appends a new line.
        /// </summary>
        /// <returns>Current instance of IndentedStringBuilder.</returns>
        public IndentedStringBuilder AppendLine()
        {
            _builder.AppendLine();
            return this;
        }

        /// <summary>
        /// Appends text and adds a new line.
        /// </summary>
        /// <param name="text">Text to append.</param>
        /// <returns>Current instance of IndentedStringBuilder.</returns>
        public IndentedStringBuilder AppendLine(string text)
        {
            AppendLine("{0}", text);
            return this;
        }

        /// <summary>
        /// Appends formatted text and adds a new line.
        /// </summary>
        /// <param name="format">A composite format string.</param>
        /// <param name="args">An array of objects to format. </param>
        /// <returns>Current instance of IndentedStringBuilder.</returns>
        public IndentedStringBuilder AppendLine(string format, params object[] args)
        {
            Append(CurrentIndentation);
            AppendFormat(format, args);
            AppendLine();
            return this;
        }

        /// <summary>
        /// Returns the accumulated string.
        /// </summary>
        /// <returns>The accumulated string.</returns>
        public override string ToString()
        {
            return _builder.ToString();
        }

        /// <summary>
        /// Indents multiline string.
        /// </summary>
        /// <param name="value"></param>
        /// <param name="indentation"></param>
        /// <returns></returns>
        public static string IndentMultilineString(string value, string indentation)
        {
            if (!string.IsNullOrEmpty(value) && value.Contains("\n"))
            {
                var formattedText = new StringBuilder(value);
                return formattedText
                    .Replace("\r\n", "{{#rn}}")
                    .Replace("\n", "{{#n}}")
                    .Replace("{{#rn}}", "\r\n" + indentation)
                    .Replace("{{#n}}", "\n" + indentation).ToString();
            }
            else
            {
                return value;
            }
        }
    }
}