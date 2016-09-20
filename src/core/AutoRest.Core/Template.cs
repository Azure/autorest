// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoRest.Core.Utilities;

namespace AutoRest.Core
{
    /// <summary>
    /// Base code generation template.
    /// </summary>
    public abstract class Template<T> : ITemplate
    {
        protected const int MaximumCommentColumn = 80;

        private string _indentation;
        private string _lastLiteral = String.Empty;

        /// <summary>
        /// Gets or sets the template model.
        /// </summary>
        public T Model { get; set; }

        /// <summary>
        /// Adds empty line to the template.
        /// </summary>
        public string EmptyLine
        {
            get { return TemplateConstants.EmptyLine + "\r\n"; }
        }

        /// <summary>
        /// Gets or sets settings.
        /// </summary>
        public Settings Settings { get; set; }

        /// <summary>
        /// Gets or sets the output stream.
        /// </summary>
        public TextWriter TextWriter { get; set; }

        /// <summary>
        /// Execute an individual request.
        /// </summary>
        public virtual Task ExecuteAsync()
        {
            return null;
        }

        /// <summary>
        /// Write the attribute string directly to the output
        /// </summary>
        /// <param name="attribute"></param>
        /// <param name="tuple1"></param>
        /// <param name="tuple2"></param>
        /// <param name="tuple3"></param>
        protected void WriteAttribute(string attribute,
                                     Tuple<string, int> tuple1,
                                     Tuple<string, int> tuple2,
                                     Tuple<Tuple<string, int>, Tuple<object, int>, bool> tuple3)
        {
            string value = string.Empty;

            if (attribute == "cref")
            {
                value = string.Format(CultureInfo.InvariantCulture, "{0}{1}{2}", tuple1?.Item1, tuple3?.Item2?.Item1.ToString(), tuple2?.Item1);
            }
            else
            {
                throw new NotImplementedException(attribute + " attributes are not yet implemented");
            }
            WriteLiteral(value);
        }

        /// <summary>
        /// Write the given value directly to the output
        /// </summary>
        /// <param name="value"></param>
        protected void WriteLiteral(string value)
        {
            if (value != null)
            {
                _lastLiteral = value;
            }
            WriteLiteralTo(TextWriter, value);
        }

        /// <summary>
        /// Write the given value directly to the output
        /// </summary>
        /// <param name="value"></param>
        protected void WriteLiteral(object value)
        {
            WriteLiteralTo(TextWriter, value);
        }

        /// <summary>
        /// Convert to string and html encode
        /// </summary>
        /// <param name="value"></param>
        protected void Write(object value)
        {
            WriteTo(TextWriter, value);
        }

        /// <summary>
        /// Html encode and write
        /// </summary>
        /// <param name="value"></param>
        protected void Write(string value)
        {
            // Add indentation for multi-line replacements
            if (!string.IsNullOrEmpty(value) && value.Contains("\n"))
            {
                _indentation = Indentation;
                WriteTo(TextWriter, IndentedStringBuilder.IndentMultilineString(value, _indentation));
            }
            else
            {
                WriteTo(TextWriter, value);
            }
        }

        /// <summary>
        /// Writes the specified <paramref name="value"/> to <paramref name="writer"/>.
        /// </summary>
        /// <param name="writer">The <see cref="System.IO.TextWriter"/> instance to write to.</param>
        /// <param name="value">The <see cref="object"/> to write.</param>
        /// <remarks>
        /// For all other types, the encoded result of <see cref="object.ToString"/> is written to the 
        /// <paramref name="writer"/>.
        /// </remarks>
        protected void WriteTo(TextWriter writer, object value)
        {
            if (value != null)
            {
                WriteTo(writer, Convert.ToString(value, CultureInfo.InvariantCulture));
            }
        }

        /// <summary>
        /// Writes the specified <paramref name="value"/> with HTML encoding to <paramref name="writer"/>.
        /// </summary>
        /// <param name="writer">The <see cref="System.IO.TextWriter"/> instance to write to.</param>
        /// <param name="value">The <see cref="string"/> to write.</param>
        protected void WriteTo(TextWriter writer, string value)
        {
            WriteLiteralTo(writer, value);
        }

        /// <summary>
        /// Writes the specified <paramref name="value"/> without HTML encoding to the <paramref name="writer"/>.
        /// </summary>
        /// <param name="writer">The <see cref="System.IO.TextWriter"/> instance to write to.</param>
        /// <param name="value">The <see cref="object"/> to write.</param>
        protected void WriteLiteralTo(TextWriter writer, object value)
        {
            WriteLiteralTo(writer, Convert.ToString(value, CultureInfo.InvariantCulture));
        }

        /// <summary>
        /// Writes the specified <paramref name="value"/> without HTML encoding to <see cref="TextWriter"/>.
        /// </summary>
        /// <param name="writer">The text writer.</param>
        /// <param name="value">The <see cref="string"/> to write.</param>
        protected void WriteLiteralTo(TextWriter writer, string value)
        {
            if (writer == null)
            {
                throw new ArgumentNullException("writer");
            }

            if (!string.IsNullOrEmpty(value))
            {
                writer.Write(value);
            }
        }

        /// <summary>
        /// Embeds sub-template content into a template.
        /// </summary>
        /// <typeparam name="TU">Template type</typeparam>
        /// <typeparam name="TV">Template model type</typeparam>
        /// <param name="template">Template</param>
        /// <param name="templateModel">Template model</param>
        /// <returns></returns>
        protected string Include<TU, TV>(TU template, TV templateModel) where TU : Template<TV>, new()
        {
            template.Model = templateModel;
            template.Settings = Settings;
            return template.ToString();
        }

        /// <summary>
        /// Inserts a wrapped header from settings with specified prefix.
        /// </summary>
        /// <param name="prefix"></param>
        /// <returns></returns>
        protected virtual string Header(string prefix)
        {
            var comment = WrapComment(prefix, Settings.Header);
            if(!string.IsNullOrEmpty(comment))
            {
                return comment + Environment.NewLine;
            }
            return comment;
        }

        /// <summary>
        /// Inserts a wrapped comment with specified prefix.
        /// </summary>
        /// <param name="prefix"></param>
        /// <param name="comment"></param>
        /// <returns></returns>
        protected virtual string WrapComment(string prefix, string comment)
        {
            if (string.IsNullOrWhiteSpace(comment))
            {
                return null;
            }

            int available =
                MaximumCommentColumn - // Maximum desired width
                Indentation.Length - // - Space used for indent
                prefix.Length - // - Prefix //'s length
                1; // - Extra space between prefix and text
            return string.Join(Environment.NewLine, comment.WordWrap(available)
                .Select(s => string.Format(CultureInfo.InvariantCulture, "{0}{1}", prefix, s)));
        }

        protected string Indentation
        {
            get
            {
                int lineStart = 0;
                for (int i = _lastLiteral.Length - 1; i >= 0; i--)
                {
                    if (_lastLiteral[i] == '\r' || _lastLiteral[i] == '\n')
                    {
                        lineStart = i + 1;
                        break;
                    }
                }
                string latestLine = _lastLiteral.Substring(lineStart, _lastLiteral.Length - lineStart);
                return new string(latestLine.TakeWhile(char.IsWhiteSpace).ToArray());
            }
        }

        /// <summary>
        /// Returns a string that represents the current template.
        /// </summary>
        /// <returns>Returns a string that represents the current template.</returns>
        public override string ToString()
        {
            var sb = new StringBuilder();
            if (Model != null)
            {
                var existingOutput = TextWriter;
                using (TextWriter = new StringWriter(sb, CultureInfo.InvariantCulture))
                {
                    ExecuteAsync().ConfigureAwait(false).GetAwaiter().GetResult();
                }
                TextWriter = existingOutput;
            }

            return sb.ToString();
        }
    }
}