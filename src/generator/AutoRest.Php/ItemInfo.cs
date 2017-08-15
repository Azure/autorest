namespace AutoRest.Php
{
    public struct ItemInfo<T>
    {
        public T Value { get; }

        public long Count { get; }

        public bool IsFirst => Count == 0;

        public bool IsLast { get; }

        public bool IsOnlyOne => IsFirst && IsLast;

        public ItemInfo(T value, long count, bool isLast)
        {
            Value = value;
            Count = count;
            IsLast = isLast;
        }
    }
}
