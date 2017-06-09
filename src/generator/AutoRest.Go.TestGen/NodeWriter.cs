// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Utilities;
using AutoRest.Go.TestGen.Model;
using System;
using System.Globalization;
using System.Linq;
using System.Text;

namespace AutoRest.Go.TestGen
{
    /// <summary>
    /// Used to write the AST to a string.  Also performs some lexical
    /// analysis of tree structure (e.g. matching open/close delimiters).
    /// </summary>
    public class NodeWriter : INodeVisitor
    {
        private int _width;
        private string _indent;
        private int _lines;
        private StringBuilder _sb;
        private Node _prev;
        private int _indentLevel;

        public NodeWriter(int columnWidth, string indent, int lines)
        {
            if (columnWidth < 80)
            {
                throw new ArgumentException("columnWidth cannot be less than 80");
            }
            if (string.IsNullOrEmpty(indent))
            {
                throw new ArgumentException(nameof(indent));
            }
            if (lines < 0)
            {
                throw new ArgumentException("lines must be greater than zero");
            }

            _sb = new StringBuilder();
            _width = columnWidth;
            _indent = indent;
            _lines = lines;
        }

        public override string ToString()
        {
            return _sb.ToString();
        }

        public void Visit(BinaryOperator binaryOp)
        {
            if (binaryOp.Children.Count != 2)
            {
                throw new InvalidOperationException("binary operator requires two child nodes");
            }

            switch (binaryOp.Type)
            {
                case BinaryOperatorType.Assignment:
                    _sb.Append(" = ");
                    break;
                case BinaryOperatorType.DeclareAndAssign:
                    _sb.Append(" := ");
                    break;
                case BinaryOperatorType.NotEqualTo:
                    _sb.Append(" != ");
                    break;
                default:
                    throw new InvalidOperationException($"unsupported binary operator {binaryOp.Type}");
            }

            _prev = binaryOp;
        }

        public void Visit(Case caseStatement)
        {
            AddIndentation(-1);
            _sb.Append("case ");
            _prev = caseStatement;
        }

        public void Visit(CloseDelimiter delimiter)
        {
            switch (delimiter.Type)
            {
                case BinaryDelimiterType.Brace:
                    if (!(_prev is OpenDelimiter && ((OpenDelimiter)_prev).Type == BinaryDelimiterType.Brace) && !IsSliceLiteralTerminal(delimiter))
                    {
                        --_indentLevel;

                        // if we just added a line break due 
                        // to some node don't add another one
                        if (!(_prev is Terminal || _prev is Tag))
                        {
                            _sb.AppendLine();
                        }
                        AddIndentation();
                    }
                    _sb.Append('}');
                    break;
                case BinaryDelimiterType.Bracket:
                    _sb.Append(']');
                    break;
                case BinaryDelimiterType.Paren:
                    if (_prev is ImportEntry)
                    {
                        System.Diagnostics.Debug.Assert(_indentLevel == 1);
                        --_indentLevel;
                    }
                    _sb.Append(')');
                    break;
                default:
                    throw new InvalidOperationException($"unsupported open delimiter {delimiter.Type}");
            }

            _prev = delimiter;
        }

        public void Visit(Comment comment)
        {
            AddIndentation();

            int available =
                _width -    // Maximum desired width
                3;          // - //'s length plus one space

            _sb.AppendLine(string.Join(Environment.NewLine, comment.Text.WordWrap(available)
                .Select(s => string.Format(CultureInfo.InvariantCulture, "{0}{1}", "// ", s))));

            _prev = comment;
        }

        public void Visit(Default defaultStatement)
        {
            AddIndentation(-1);
            _sb.AppendLine("default:");
            AddIndentation();
            _prev = defaultStatement;
        }

        public void Visit(For forStatement)
        {
            AddIndentation();
            _sb.Append("for");
            _prev = forStatement;
        }

        public void Visit(Func func)
        {
            if (_prev is CloseDelimiter)
            {
                _sb.AppendLine();
            }

            AddIndentation();

            _sb.Append("func ");
            _prev = func;
        }

        public void Visit(Identifier identifier)
        {
            if (_prev is Terminal || (_prev is OpenDelimiter && ((OpenDelimiter)_prev).Type == BinaryDelimiterType.Brace) || IsIdentifierInStructDef(identifier))
            {
                AddIndentation();
            }
            else if (_prev is CloseDelimiter && ((CloseDelimiter)_prev).Type != BinaryDelimiterType.Bracket)
            {
                _sb.Append(' ');
            }

            _sb.Append(identifier.Name);
            _prev = identifier;
        }

        public void Visit(If ifStatement)
        {
            AddIndentation();
            _sb.Append("if ");
            _prev = ifStatement;
        }

        public void Visit(Import import)
        {
            if (import.Children.Count == 0)
            {
                throw new InvalidOperationException("import statement has no children");
            }

            _sb.Append("import ");
            _prev = import;
        }

        public void Visit(ImportEntry importEntry)
        {
            AddIndentation();

            if (importEntry.Alias != null)
            {
                _sb.Append($"{importEntry.Alias} ");
            }

            _sb.AppendLine($"\"{importEntry.Package}\"");
            _prev = importEntry;
        }

        public void Visit<T>(Literal<T> literal)
        {
            _sb.Append(literal.Format());
        }

        public void Visit(Nil nil)
        {
            _sb.Append("nil");
        }

        public void Visit(OpenDelimiter delimiter)
        {
            // TODO: verify sequence ends with matching close delimiter, or if
            // this is a slice that the first child is a closing square bracket.

            switch (delimiter.Type)
            {
                case BinaryDelimiterType.Brace:
                    if (_prev is CloseDelimiter || IsOpeningBraceInControlBlock(delimiter) || _prev is TypeName)
                    {
                        _sb.Append(' ');
                    }
                    _sb.Append('{');
                    if (!IsEmptyBraces(delimiter) && !IsStartOfSliceLiteral(delimiter))
                    {
                        _sb.AppendLine();
                        ++_indentLevel;
                    }
                    break;
                case BinaryDelimiterType.Bracket:
                    _sb.Append('[');
                    break;
                case BinaryDelimiterType.Paren:
                    _sb.Append('(');
                    if (_prev is Import)
                    {
                        _sb.AppendLine();
                        ++_indentLevel;
                    }
                    break;
                default:
                    throw new InvalidOperationException($"unsupported open delimiter {delimiter.Type}");
            }

            _prev = delimiter;
        }

        public void Visit(Package package)
        {
            _sb.AppendLine($"package {package.Name}");
            _sb.AppendLine();
            _prev = package;
        }

        public void Visit(Return returnStatement)
        {
            AddIndentation();
            _sb.Append("return ");
            _prev = returnStatement;
        }

        public void Visit(StructDef structDef)
        {
            _sb.Append(" struct");
            _prev = structDef;
        }

        public void Visit(Switch switchStatement)
        {
            AddIndentation();
            _sb.Append("switch ");
            _prev = switchStatement;
        }

        public void Visit(Tag tag)
        {
            _sb.Append(" `");
            _sb.Append(tag.Value);
            _sb.AppendLine("`");
            _prev = tag;
        }

        public void Visit(Terminal terminal)
        {
            // if this is the terminal in a struct literal don't add a new line
            if (!IsStructLiteralTerminal(_prev))
            {
                _sb.AppendLine();
            }
            _prev = terminal;
        }

        public void Visit(TypeDef typeDef)
        {
            if (_prev is CloseDelimiter)
            {
                _sb.AppendLine();
            }

            AddIndentation();
            _sb.Append("type ");
            _prev = typeDef;
        }

        public void Visit(TypeName typeName)
        {
            if (_prev is Terminal)
            {
                AddIndentation();
            }
            else if (_prev is CloseDelimiter || _prev is Identifier)
            {
                _sb.Append(' ');
            }

            _sb.Append(typeName.Value);
            _prev = typeName;
        }

        public void Visit(UnaryDelimiter delimiter)
        {
            switch (delimiter.Type)
            {
                case UnaryDelimiterType.Colon:
                    _sb.Append(":");
                    if (_prev is Case)
                    {
                        _sb.AppendLine();
                        AddIndentation();
                    }
                    break;
                case UnaryDelimiterType.Comma:
                    _sb.Append(',');
                    // if the comma is under a StructDef or struct literal then append a new line
                    var node = delimiter.Parent;
                    bool braceTrip = false;
                    while (node != null)
                    {
                        if (node is OpenDelimiter && ((OpenDelimiter)node).Type == BinaryDelimiterType.Brace)
                        {
                            braceTrip = true;
                        }

                        if (node is StructDef || (node is Identifier && braceTrip))
                        {
                            _sb.AppendLine();

                            // if this is the last line in a struct literal don't indent
                            if (!braceTrip || !(delimiter.Children[1] is Terminal))
                            {
                                AddIndentation();
                            }
                            break;
                        }
                        node = node.Parent;
                    }

                    // reached the end, not under StructDef so append a space
                    if (node == null)
                    {
                        _sb.Append(' ');
                    }

                    break;
                default:
                    throw new InvalidOperationException($"unsupported sequence delimiter {delimiter.Type}");
            }

            _prev = delimiter;
        }

        public void Visit(UnaryOperator unaryOp)
        {
            switch (unaryOp.Type)
            {
                case UnaryOperatorType.Ampersand:
                    _sb.Append('&');
                    break;
                case UnaryOperatorType.Star:
                    if (_prev is Identifier)
                    {
                        _sb.Append(' ');
                    }
                    _sb.Append('*');
                    break;
                default:
                    throw new InvalidOperationException($"unsupported unary operator {unaryOp.Type}");
            }

            _prev = unaryOp;
        }

        public void Visit(VarDef varDef)
        {
            if (_prev is CloseDelimiter)
            {
                _sb.AppendLine();
            }

            AddIndentation();
            _sb.Append("var ");
            _prev = varDef;
        }

        private void AddIndentation(int offset = 0)
        {
            for (int i = 0; i < _indentLevel + offset; ++i)
            {
                _sb.Append(_indent);
            }
        }

        /// <summary>
        /// Determines if this delimiter starts an empty braces sequence (e.g. {}).
        /// </summary>
        /// <param name="delimiter">The OpenDelimiter object to inspect.</param>
        /// <returns>True if this is node is empty braces.</returns>
        private bool IsEmptyBraces(OpenDelimiter delimiter)
        {
            if (delimiter.Type != BinaryDelimiterType.Brace)
            {
                return false;
            }

            return delimiter.Children[0] is CloseDelimiter;
        }

        /// <summary>
        /// Determines if this delimiter is part of a slice literal (e.g. []string{"foo"}).
        /// </summary>
        /// <param name="delimiter">The OpenDelimiter object to inspect.</param>
        /// <returns>True if this node is part of a slice literal.</returns>
        private bool IsStartOfSliceLiteral(OpenDelimiter delimiter)
        {
            if (delimiter.Type != BinaryDelimiterType.Brace)
            {
                return false;
            }

            Node n = delimiter.Parent;
            int trips = 0;
            while (n != null)
            {
                if (n is Identifier)
                {
                    ++trips;
                }
                else if (n is CloseDelimiter && ((CloseDelimiter)n).Type == BinaryDelimiterType.Bracket)
                {
                    ++trips;
                }
                else if (n is OpenDelimiter && ((OpenDelimiter)n).Type == BinaryDelimiterType.Bracket)
                {
                    ++trips;
                }

                if (trips == 3)
                {
                    return true;
                }

                n = n.Parent;
            }

            return false;
        }

        /// <summary>
        /// Determines if this terminal is the last line in a struct literal.
        /// </summary>
        /// <param name="node">The Node object to inspect.</param>
        /// <returns>True if this node is the terminal node of a struct literal.</returns>
        private bool IsStructLiteralTerminal(Node node)
        {
            return node is UnaryDelimiter && ((UnaryDelimiter)node).Type == UnaryDelimiterType.Comma;
        }

        /// <summary>
        /// Determines if this closing delimiter is the end of a slice literal (e.g. []string{"foo"}).
        /// </summary>
        /// <param name="delimiter">The CloseDelimiter object to inspect.</param>
        /// <returns>True if this is the closing delimiter of a slice literal.</returns>
        private bool IsSliceLiteralTerminal(CloseDelimiter delimiter)
        {
            if (delimiter.Type != BinaryDelimiterType.Brace)
                return false;

            Node n = delimiter.Parent;

            int trip = 0;
            while (n != null)
            {
                if (trip == 4)
                {
                    return true;
                }
                else if (n is OpenDelimiter)
                {
                    ++trip;
                }
                else if (n is Identifier)
                {
                    ++trip;
                }
                else if (n is CloseDelimiter && ((CloseDelimiter)n).Type == BinaryDelimiterType.Bracket)
                {
                    ++trip;
                }
                else if (n is OpenDelimiter && ((OpenDelimiter)n).Type == BinaryDelimiterType.Bracket)
                {
                    ++trip;
                }

                n = n.Parent;
            }

            return false;
        }

        /// <summary>
        /// Determines if this delimiter is part of a control block.
        /// </summary>
        /// <param name="delimiter">The OpenDelimiter object to inspect.</param>
        /// <returns>True if this delimiter is part of a control block.</returns>
        private bool IsOpeningBraceInControlBlock(OpenDelimiter delimiter)
        {
            if (delimiter.Type != BinaryDelimiterType.Brace)
                return false;

            Node n = delimiter.Parent;
            while (n != null)
            {
                if (n is If || n is For || n is Switch)
                {
                    return true;
                }

                n = n.Parent;
            }

            return false;
        }

        /// <summary>
        /// Determines if this identifier is part of a struct definition.
        /// </summary>
        /// <param name="identifier">The Identifier object to inspect.</param>
        /// <returns>True if this identifier is part of a struct definition.</returns>
        private bool IsIdentifierInStructDef(Identifier identifier)
        {
            Node n = identifier.Parent;
            while (n != null)
            {
                if (n is StructDef)
                {
                    return true;
                }

                n = n.Parent;
            }

            return false;
        }
    }
}
