using System;
using System.Globalization;
using System.Linq;
using AutoRest.Core;
using AutoRest.Core.Utilities;

namespace AutoRest.NodeJS
{
    public class NodeJSTemplate<T> : Template<T>
    {
        public override string WrapComment(string prefix, string comment)
        {
            return base.WrapComment(prefix, comment);
        }
    }
}
