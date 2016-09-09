using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AutoRest.Core.Validation
{
    /// <summary>
    /// Provides context for a comparison, such as the ancestors in the validation tree, the root object
    ///   and information about the key or index that locate this object in the parent's list or dictionary
    /// </summary>
    public class ComparisonContext
    {
        /// <summary>
        /// Initializes a top level context for comparisons
        /// </summary>
        /// <param name="oldRoot"></param>
        public ComparisonContext(object oldRoot, object newRoot)
        {
            this.CurrentRoot = newRoot;
            this.PreviousRoot = oldRoot;
        }

        /// <summary>
        /// The original root object in the graph that is being compared
        /// </summary>
        public object CurrentRoot { get; set; }

        public object PreviousRoot { get; set; }

        /// <summary>
        /// If true, then checking should be strict, in other words, breaking changes are errors
        /// intead of warnings.
        /// </summary>
        public bool Strict { get; set; } = false;

        public DataDirection Direction { get; set; } = DataDirection.None;

        public string Path { get { return string.Join("/", _path.Reverse()); } }

        public void Push(string element) { _path.Push(element); }
        public void Pop() { _path.Pop(); }

        private Stack<string> _path = new Stack<string>();

        public void LogInfo(MessageTemplate template, params object[] formatArguments)
        {
            _messages.Add(new ComparisonMessage(template, this.Path, Logging.LogEntrySeverity.Info, formatArguments));
        }

        public void LogError(MessageTemplate template, params object[] formatArguments)
        {
            _messages.Add(new ComparisonMessage(template, this.Path, Logging.LogEntrySeverity.Error, formatArguments));
        }

        public void LogBreakingChange(MessageTemplate template, params object[] formatArguments)
        {
            _messages.Add(new ComparisonMessage(template, this.Path, this.Strict ? Logging.LogEntrySeverity.Error : Logging.LogEntrySeverity.Warning, formatArguments));
        }

        public IEnumerable<ComparisonMessage> Messages {  get { return _messages; } }

        private IList<ComparisonMessage> _messages = new List<ComparisonMessage>();
    }

    public enum DataDirection
    {
        None = 0,
        Request = 1,
        Response = 2,
        Both = 3
    }
}
