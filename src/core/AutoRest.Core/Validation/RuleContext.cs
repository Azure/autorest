
namespace AutoRest.Core.Validation
{
    /// <summary>
    /// Provides context for a rule, such as the ancestors in the validation tree, the root object
    ///   and information about the key or index that locate this object in the parent's list or dictionary
    /// </summary>
    public class RuleContext
    {
        /// <summary>
        /// Initializes a top level context for rules
        /// </summary>
        /// <param name="root"></param>
        public RuleContext(object root) : this(null)
        {
            this.Root = root;
            this.Value = root;
        }

        /// <summary>
        /// Initializes a rule context node in the linked list of contexts for the validation object graph 
        /// </summary>
        /// <param name="root"></param>
        public RuleContext(RuleContext parent)
        {
            this.Parent = parent;
            this.Root = parent?.Root;
        }

        /// <summary>
        /// Returns a new rule context that represents another level of traversal in the object graph
        ///   for list items
        /// </summary>
        /// <param name="value"></param>
        /// <param name="index"></param>
        /// <returns></returns>
        public RuleContext CreateChild(object value, int index)
        {
            return new RuleContext(this) { Index = index, Value = value };
        }

        /// <summary>
        /// Returns a new rule context that represents another level of traversal in the object graph
        ///   for dictionary elements or property values.
        /// </summary>
        /// <param name="value"></param>
        /// <param name="index"></param>
        /// <returns></returns>
        public RuleContext CreateChild(object value, string key)
        {
            return new RuleContext(this) { Key = key, Value = value };
        }

        /// <summary>
        /// The rule context of the parent object in the validation object tree
        /// </summary>
        public RuleContext Parent { get; set; }

        /// <summary>
        /// The root object in the graph that this rule is being applied to
        /// </summary>
        public object Root { get; private set; }

        /// <summary>
        /// The key value that the object is part of if it's in a dictionary
        /// </summary>
        public string Key { get; private set; }

        /// <summary>
        /// The numeric index that represents the object's location in a list, if it's in one
        /// </summary>
        public int? Index { get; private set; }

        /// <summary>
        /// The value of the object
        /// </summary>
        public object Value { get; private set; }
    }
}
