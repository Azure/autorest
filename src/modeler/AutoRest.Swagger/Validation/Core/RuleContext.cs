
using AutoRest.Core.Logging;
using AutoRest.Swagger.Model;
using AutoRest.Swagger.Model.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;

namespace AutoRest.Swagger.Validation.Core
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
        public RuleContext(ServiceDefinition root, Uri file) : this(null)
        {
            this.Root = root;
            this.Value = root;
            this.File = file;
            PopulateResourceTypes(root);
        }

        /// <summary>
        /// Initializes a rule context node in the linked list of contexts for the validation object graph 
        /// </summary>
        /// <param name="root"></param>
        public RuleContext(RuleContext parent)
        {
            this.Parent = parent;
            this.Root = parent?.Root;
            this.File = parent?.File;
            this.ResourceModels = parent?.ResourceModels;
            this.TrackedResourceModels = parent?.TrackedResourceModels;
            this.ProxyResourceModels = parent?.ProxyResourceModels;
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
        public ServiceDefinition Root { get; private set; }

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
        
        /// <summary>
        /// List of resources in serviceDefinition
        /// </summary>
        public IEnumerable<string> ResourceModels { get; private set; }

        /// <summary>
        /// List of tracked resources in serviceDefinition
        /// </summary>
        public IEnumerable<string> TrackedResourceModels { get; private set; }

        /// <summary>
        /// List of proxy resources in serviceDefinition
        /// </summary>
        public IEnumerable<string> ProxyResourceModels { get; private set; }

        public ObjectPath Path => 
            Parent == null
                ? ObjectPath.Empty
                : Key == null
                    ? Parent.Path.AppendIndex(Index.Value)
                    : Parent.Path.AppendProperty(Key);

        public Uri File { get; private set;  }

        /// <summary>
        /// Populates list of resources, tracked resources and proxy resources
        /// </summary>
        private void PopulateResourceTypes(ServiceDefinition serviceDefinition)
        {
            this.ResourceModels = ValidationUtilities.GetResourceModels(serviceDefinition).ToList();
            this.TrackedResourceModels = ValidationUtilities.GetTrackedResources(this.ResourceModels, serviceDefinition.Definitions).ToList();
            this.ProxyResourceModels = this.ResourceModels.Except(this.TrackedResourceModels).ToList();
        }

    }
}
