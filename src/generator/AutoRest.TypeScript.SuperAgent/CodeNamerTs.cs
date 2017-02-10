using AutoRest.Core;

namespace AutoRest.TypeScript.SuperAgent
{
    public class CodeNamerTs : CodeNamer
    {
        /// <summary>
        ///     Formats a string for naming a Type or Object using Pascal case by default.
        /// </summary>
        /// <param name="name"></param>
        /// <returns>The formatted string.</returns>
        public override string GetTypeName(string name)
        {
            return base.GetTypeName(name);
        }
    }
}
