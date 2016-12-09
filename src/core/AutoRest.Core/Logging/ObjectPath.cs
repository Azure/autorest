using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AutoRest.Core.Logging
{
    /// <summary>
    /// Represents a path into an object.
    /// </summary>
    public class ObjectPath
    {
        public ObjectPath() : this(Enumerable.Empty<string>())
        {
        }

        public ObjectPath(IEnumerable<string> path)
        {
            Path = path;
        }

        public ObjectPath Append(string key)
        {
            return new ObjectPath(Path.Concat(new[] { key }));
        }

        public IEnumerable<string> Path { get; }

        public string PathStringThomasStyle => "#->" + string.Join("->", Path);

        public string XPath => "#/" + string.Join("/", Path);
    }
}
