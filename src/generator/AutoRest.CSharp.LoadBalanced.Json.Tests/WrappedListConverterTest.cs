using System;
using System.Collections.Generic;
using Newtonsoft.Json;
using NUnit.Framework;

namespace AutoRest.CSharp.LoadBalanced.Json.Tests
{
    [TestFixture]
    public class WrappedListConverterTest
    {
        static Guid id1 = Guid.Parse("8e457970-79ba-4f2f-bb8d-a236e58ce6cf");
        static Guid id2 = Guid.Parse("d95c0c7e-c945-48f1-bb6b-af118c637632");
        static string json1 = "{\"my\":{\"someArrayOfGuids\":[\"8e457970-79ba-4f2f-bb8d-a236e58ce6cf\",\"d95c0c7e-c945-48f1-bb6b-af118c637632\"]},\"my2\":{\"otherArrayOfInts\":[122,334,4454,5555]}}";
        static string json2 = "{\"my2\":{\"otherArrayOfInts\":[122,334,4454,5555]},\"my\":{\"someArrayOfGuids\":[\"8e457970-79ba-4f2f-bb8d-a236e58ce6cf\",\"d95c0c7e-c945-48f1-bb6b-af118c637632\"]}}";

        [Test, TestCaseSource(nameof(GetSerializationTestCases))]
        public void ListSerializationTest(object testObject, string expectedJson)
        {
            Assert.AreEqual(JsonConvert.SerializeObject(testObject), expectedJson);
        }

        [Test, TestCaseSource(nameof(GetDeserializationTestCases))]
        public void ListDeserializationTest(dynamic testObject, string jsonText)
        {
            var settings = new JsonSerializerSettings {MetadataPropertyHandling = MetadataPropertyHandling.ReadAhead };

            var deserializedObject = JsonConvert.DeserializeObject(jsonText, testObject.GetType(), settings);

            Assert.AreEqual(deserializedObject.MyGuids.Count, testObject.MyGuids.Count);
            Assert.AreEqual(deserializedObject.MyInts.Count, testObject.MyInts.Count);

            for (var index = 0; index < testObject.MyGuids.Count; index++)
            {
                var guid = testObject.MyGuids[index];
                var deserializedGuid = deserializedObject.MyGuids[index];

                Assert.AreEqual(guid, deserializedGuid);
            }

            for (var index = 0; index < testObject.MyInts.Count; index++)
            {
                var number = testObject.MyInts[index];
                var deserializedNumber = deserializedObject.MyInts[index];

                Assert.AreEqual(number, deserializedNumber);
            }
        }

        public static IEnumerable<object[]> GetSerializationTestCases()
        {
            yield return new object[]
                         {
                             new TestObject
                             {
                                 MyGuids = new List<Guid> { id1, id2 },
                                 MyInts = new List<int> {122, 334, 4454, 5555}
                             },
                             json1
                         };

            yield return new object[]
                        {
                             new TestObject2
                             {
                                 MyGuids = new GuidList{ id1, id2 },
                                 MyInts = new IntList {122, 334, 4454, 5555}
                             },
                             json1
                        };
        }

        public static IEnumerable<object[]> GetDeserializationTestCases()
        {
            yield return new object[]
             {
                             new TestObject
                             {
                                 MyGuids = new List<Guid>{ id1, id2 },
                                 MyInts = new List<int> {122, 334, 4454, 5555}
                             },
                             json1
             };

            yield return new object[]
                       {
                             new TestObject
                             {
                                 MyGuids = new List<Guid>{ id1, id2 },
                                 MyInts = new List<int> {122, 334, 4454, 5555}
                             },
                            json2
                       };

            yield return new object[]
             {
                             new TestObject2
                             {
                                 MyGuids = new GuidList{ id1, id2 },
                                 MyInts = new IntList {122, 334, 4454, 5555}
                             },
                             json1
             };

            yield return new object[]
                       {
                             new TestObject2
                             {
                                 MyGuids = new GuidList{ id1, id2 },
                                 MyInts = new IntList {122, 334, 4454, 5555}
                             },
                             json2
                       };
        }

        public class TestObject
        {
            [JsonProperty("my"), JsonConverter(typeof(WrappedListConverter<Guid>), "someArrayOfGuids")]
            public IList<Guid> MyGuids { get; set; }

            [JsonProperty("my2"), JsonConverter(typeof(WrappedListConverter<int>), "otherArrayOfInts")]
            public IList<int> MyInts { get; set; }
        }

        [JsonConverter(typeof(WrappedListConverter<Guid>), "someArrayOfGuids")]
        public class GuidList: List<Guid>
        {
        }

        [JsonConverter(typeof(WrappedListConverter<int>), "otherArrayOfInts")]
        public class IntList : List<int>
        {
        }

        public class TestObject2
        {
            [JsonProperty("my")]
            public GuidList MyGuids { get; set; }

            [JsonProperty("my2")]
            public IntList MyInts { get; set; }
        }
    }
}
