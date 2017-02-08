using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AutoRest.Core.Model
{
    public class XmlProperties
    {
        /// <summary>
        /// Replaces the name of the element/attribute used for the described schema property.
        /// When defined within the Items Object (items), it will affect the name of the individual XML elements within the list.
        /// When defined alongside type being array (outside the items), it will affect the wrapping element and only if wrapped is true.
        /// If wrapped is false, it will be ignored.
        /// </summary>
        public string Name { get; set; }

        /// <summary>
        /// The URL of the namespace definition.
        /// Value SHOULD be in the form of a URL.
        /// </summary>
        public string Namespace { get; set; }

        /// <summary>
        /// The prefix to be used for the name.
        /// </summary>
        public string Prefix { get; set; }

        /// <summary>
        /// Declares whether the property definition translates to an attribute instead of an element.
        /// </summary>
        public bool Attribute { get; set; }

        /// <summary>
        /// MAY be used only for an array definition.
        /// Signifies whether the array is wrapped (for example, `<books><book/><book/></books>`) or unwrapped (`<book/><book/>`).
        /// The definition takes effect only when defined alongside type being array (outside the items).
        /// </summary>
        public bool Wrapped { get; set; }
    }
}
