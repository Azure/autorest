using System;
using System.Collections.Generic;
using Newtonsoft.Json;
using NUnit.Framework;

namespace AutoRest.CSharp.LoadBalanced.Json.Tests
{
    [TestFixture]
    public class WrappedListConverterTest
    {
        [Test, TestCaseSource(nameof(GetSerializationTestCases))]
        public void ListSerializationTest(TestObject testObject, string expectedJson)
        {
            Assert.AreEqual(JsonConvert.SerializeObject(testObject), expectedJson);
        }

        [Test, TestCaseSource(nameof(GetSerializationTestCases))]
        public void ListDeserializationTest(TestObject testObject, string jsonText)
        {
            var deserializedObject = JsonConvert.DeserializeObject<TestObject>(jsonText);

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
                                 MyGuids = new List<Guid>
                                           {
                                               Guid.Parse("8e457970-79ba-4f2f-bb8d-a236e58ce6cf"),
                                               Guid.Parse("d95c0c7e-c945-48f1-bb6b-af118c637632")
                                           },
                                 MyInts = new List<int> {122, 334, 4454, 5555}
                             },
                             "{\"my\":{\"someArrayOfGuids\":[\"8e457970-79ba-4f2f-bb8d-a236e58ce6cf\",\"d95c0c7e-c945-48f1-bb6b-af118c637632\"]},\"my2\":{\"otherArrayOfInts\":[122,334,4454,5555]}}"
                         };
        }

        public class TestObject
        {
            [JsonProperty("my"), JsonConverter(typeof(WrappedListConverter<Guid>), "someArrayOfGuids")]
            public IList<Guid> MyGuids { get; set; }

            [JsonProperty("my2"), JsonConverter(typeof(WrappedListConverter<int>), "otherArrayOfInts")]
            public IList<int> MyInts { get; set; }
        }

    }
}
