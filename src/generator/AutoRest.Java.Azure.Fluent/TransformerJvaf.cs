// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using Newtonsoft.Json.Linq;
using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Core.Utilities.Collections;
using AutoRest.Extensions;
using AutoRest.Extensions.Azure;
using AutoRest.Java.Azure.Model;
using AutoRest.Java.Model;
using static AutoRest.Core.Utilities.DependencyInjection;
using AutoRest.Java.Azure.Fluent.Model;

namespace AutoRest.Java.Azure
{
    public class TransformerJvaf : TransformerJva, ITransformer<CodeModelJvaf>
    {
        public override CodeModelJv TransformCodeModel(CodeModel codeModel)
        {
            return base.TransformCodeModel(codeModel);
        }

        CodeModelJvaf ITransformer<CodeModelJvaf>.TransformCodeModel(CodeModel cm)
        {
            return TransformCodeModel(cm) as CodeModelJvaf;
        }
    }
}
