namespace AutoRest.Php
{
    public struct ItemInfo
    {
        public bool IsFirst { get; }
        public bool IsLast { get; }

        public ItemInfo(bool isFirst, bool isLast)
        {
            IsFirst = isFirst;
            IsLast = isLast;
        }
    }
}
