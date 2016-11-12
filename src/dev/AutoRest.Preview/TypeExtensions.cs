using System;
using System.CodeDom;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using Microsoft.CSharp;

namespace AutoRest.Preview
{
    public static class TypeExtensions
    {

        public static string GetSimpleName(this Type type)
        {
            var compiler = new CSharpCodeProvider();
            var result = compiler.GetTypeOutput(new CodeTypeReference(type));
            result = Regex.Replace(result, @"[_A-Za-z0-9]+\.", "");
            result = Regex.Replace(result, @"Nullable<(.+?)>", @"$1?");
            return result;
        }

        public static string CreateSummary(this Type type, int indentLevel)
        {
            var sb = new StringBuilder();
            sb.Append("class ");
            sb.Append(type.Name);
            sb.AppendLine();
            sb.AppendLine("{");

            var props = type.GetProperties();
            var methods = type.GetMethods().Where(m => !m.IsSpecialName).ToArray();

            // properties
            if (props.Length > 0)
            {
                sb.Append(' ', indentLevel);
                sb.AppendLine("// properties");
                foreach (var member in props)
                {
                    sb.Append(' ', indentLevel);
                    sb.Append(member.PropertyType.GetSimpleName());
                    sb.Append(' ');
                    sb.Append(member.Name);
                    sb.AppendLine(";");
                }
            }

            if (methods.Length > 0 && props.Length > 0)
                sb.AppendLine();

            // methods
            if (methods.Length > 0)
            {
                sb.Append(' ', indentLevel);
                sb.AppendLine("// methods");
                foreach (var member in methods)
                {
                    sb.Append(' ', indentLevel);
                    sb.Append(member.ReturnType.GetSimpleName());
                    sb.Append(' ');
                    sb.Append(member.Name);
                    sb.Append('(');
                    sb.Append(string.Join(", ", member.GetParameters().Select(p => p.ParameterType.GetSimpleName() + " " + p.Name)));
                    sb.Append(')');
                    sb.AppendLine(";");
                }
            }

            sb.AppendLine("}");

            return sb.ToString();
        }
    }
}
