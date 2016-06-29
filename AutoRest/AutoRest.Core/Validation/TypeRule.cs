using System.Collections.Generic;

namespace Microsoft.Rest.Generator
{
    public abstract class TypeRule<T> : Rule where T : class
    {
        protected TypeRule()
        {
        }

        public sealed override IEnumerable<ValidationMessage> GetValidationMessages(object entity)
        {
            var typedEntity = entity as T;
            if (typedEntity != null)
            {
                foreach (var exception in GetValidationMessages(typedEntity))
                {
                    yield return exception;
                }
            }
            yield break;
        }

        /// <summary>
        /// Overridable method that lets a child rule return objects to be passed to string.Format
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        public virtual IEnumerable<ValidationMessage> GetValidationMessages(T entity)
        {
            object[] formatParams;
            if (!IsValid(entity, out formatParams))
            {
                yield return CreateException(null, Exception, formatParams);
            }
            yield break;
        }

        /// <summary>
        /// Overridable method that lets a child rule return objects to be passed to string.Format
        /// </summary>
        /// <param name="entity"></param>
        /// <param name="formatParameters"></param>
        /// <returns></returns>
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1021:AvoidOutParameters", MessageId = "1#")]
        public virtual bool IsValid(T entity, out object[] formatParameters)
        {
            formatParameters = new object[0];
            return IsValid(entity);
        }

        /// <summary>
        /// Overridable method that lets a child rule specify if <paramref name="entity"/> passes validation
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        public virtual bool IsValid(T entity)
        {
            return true;
        }
    }
}
