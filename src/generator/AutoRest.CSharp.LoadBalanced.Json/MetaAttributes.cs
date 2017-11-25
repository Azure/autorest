using System;

namespace AutoRest.CSharp.LoadBalanced.Json
{
    public class SummaryAttribute : Attribute
    {
        public SummaryAttribute(string summary)
        {
            Summary = summary;
        }

        public string Summary { get; }
    }

    public class UrlAttribute : Attribute
    {
        public UrlAttribute(string url)
        {
            Url = url;
        }

        public string Url { get; }
    }

    public class VerbAttribute : Attribute
    {
        public VerbAttribute(string verb)
        {
            Verb = verb;
        }

        public string Verb { get; }
    }

    public class TagsAttribute : Attribute
    {
        public TagsAttribute(string tags)
        {
            Tags = tags;
        }

        public string Tags { get; }
    }
}