using System;
using System.Collections.Generic;
using Newtonsoft.Json;
using NUnit.Framework;

namespace AutoRest.CSharp.LoadBalanced.Json.Tests
{
    [TestFixture]
    public class GuidCustomConverterTest
    {
        [Test, TestCaseSource(nameof(GetSerializationTestCases))]
        public void GuidSerializationTest(TestObject testObject, string expectedJson)
        {
            Assert.AreEqual(JsonConvert.SerializeObject(testObject), expectedJson);
        }

        [Test, TestCaseSource(nameof(GetSerializationTestCases))]
        public void GuidDeserializationTest(TestObject testObject, string jsonText)
        {
            var deserializedObject = JsonConvert.DeserializeObject<TestObject>(jsonText);
            Assert.AreEqual(testObject.MyGuid, deserializedObject.MyGuid);
            Assert.AreEqual(testObject.MyGuid2, deserializedObject.MyGuid2);
        }


        public static IEnumerable<object[]> GetSerializationTestCases()
        {
            yield return new object[]
                         {
                             new TestObject { MyGuid = Guid.Parse("8e457970-79ba-4f2f-bb8d-a236e58ce6cf") },
                             "{\"my\":\"8e457970-79ba-4f2f-bb8d-a236e58ce6cf\",\"my2\":null}"
                         };

            yield return new object[]
                         {
                             new TestObject { MyGuid2 = Guid.Parse("d95c0c7e-c945-48f1-bb6b-af118c637632") },
                             "{\"my\":\"00000000-0000-0000-0000-000000000000\",\"my2\":\"d95c0c7e-c945-48f1-bb6b-af118c637632\"}"
                         };
        }

        public class TestObject
        {
            [JsonProperty("my"), JsonConverter(typeof(GuidStringConverter))]
            public Guid MyGuid { get; set; }

            [JsonProperty("my2"), JsonConverter(typeof(GuidStringConverter))]
            public Guid? MyGuid2 { get; set; }
        }
    }
}
