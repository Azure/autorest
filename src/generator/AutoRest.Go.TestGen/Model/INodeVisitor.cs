// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace AutoRest.Go.TestGen.Model
{
    /// <summary>
    /// Interface all node visitors must implement.
    /// </summary>
    public interface INodeVisitor
    {
        void Visit(BinaryOperator binaryOp);

        void Visit(Case caseStatement);

        void Visit(CloseDelimiter delimiter);

        void Visit(Comment comment);

        void Visit(Default defaultStatement);

        void Visit(For forStatement);

        void Visit(Func func);

        void Visit(Identifier identifier);

        void Visit(If ifStatement);

        void Visit(Import import);

        void Visit(ImportEntry importEntry);

        void Visit<T>(Literal<T> literal);

        void Visit(Nil nil);

        void Visit(OpenDelimiter delimiter);

        void Visit(Package package);

        void Visit(Return returnStatement);

        void Visit(StructDef structDef);

        void Visit(Switch switchStatement);

        void Visit(Tag tag);

        void Visit(Terminal terminal);

        void Visit(TypeDef typeDef);

        void Visit(TypeName typeName);

        void Visit(UnaryDelimiter delimiter);

        void Visit(UnaryOperator unaryOp);

        void Visit(VarDef varDef);
    }
}
