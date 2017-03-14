using System.Collections.Generic;
using AutoRest.Core;
using AutoRest.Core.Utilities;

namespace AutoRest.TypeScript.SuperAgent
{
    public class CodeNamerTs : CodeNamer
    {
        private readonly Dictionary<string, string> _typeNameAliases;

        public CodeNamerTs()
        {
            _typeNameAliases = new Dictionary<string, string>();
        }

        /// <summary>
        ///     Formats a string for naming a Type or Object using Pascal case by default.
        /// </summary>
        /// <param name="name"></param>
        /// <returns>The formatted string.</returns>/*
        /*public override string GetTypeName(string name)
        {
            if (_typeNameAliases.ContainsKey(name))
            {
                return _typeNameAliases[name];
            }

            var value =  base.GetTypeName(name);

            _typeNameAliases.Add(name, value);

            return value;
        }*/

        /// <summary>
        ///     Formats a string for identifying a namespace using Pascal case by default.
        /// </summary>
        /// <param name="name"></param>
        /// <returns>The formatted string.</returns>
        public override string GetNamespaceName(string name)
        {
            return base.GetNamespaceName(name);
        }

        public override string GetClientName(string name)
        {
            return base.GetClientName(name);
        }

        /// <summary>
        ///     Formats a string for naming a method using Pascal case by default.
        /// </summary>
        /// <param name="name"></param>
        /// <returns>The formatted string.</returns>
        public override string GetMethodName(string name)
        {
            return base.GetMethodName(name).ToCamelCase();
        }
    }
}
