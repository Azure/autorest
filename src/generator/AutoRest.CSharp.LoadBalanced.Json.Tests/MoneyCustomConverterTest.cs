using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;
using NUnit.Framework;

namespace AutoRest.CSharp.LoadBalanced.Json.Tests
{
    [TestFixture]
    public class MoneyCustomConverterTest
    {
        [Test, TestCaseSource(nameof(GetMoneySerializationTestCases))]
        public void MoneySerializationTest(TestObject testObject, string expectedJson)
        {
            Assert.AreEqual(JsonConvert.SerializeObject(testObject), expectedJson);
        }

        [Test, TestCaseSource(nameof(GetMoneySerializationTestCases))]
        public void MoneyDeserializationTest(TestObject testObject, string jsonText)
        {
            var deserializedObject = JsonConvert.DeserializeObject<TestObject>(jsonText);
            Assert.AreEqual(testObject.NotNullableMoney, deserializedObject.NotNullableMoney);
            Assert.AreEqual(testObject.NullableTextMyMoney, deserializedObject.NullableTextMyMoney);
            Assert.AreEqual(testObject.NullableMoney, deserializedObject.NullableMoney);
            Assert.AreEqual(testObject.NotNullableMoney, deserializedObject.NotNullableMoney);;
        }

        public static IEnumerable<object[]> GetMoneySerializationTestCases()
        {
            yield return new object[] { new TestObject
                    {
                        NotNullableTextMoney = 1,
                        NullableTextMyMoney = 2,
                        NullableMoney = 22,
                        NotNullableMoney = 122
                    }, "{\"notNullableTextMoney\":\"1\",\"nullableTextMyMoney\":\"2\",\"nullableMoney\":22.0,\"notNullableMoney\":122.0}" };
                    
            yield return new object[] { new TestObject
                    {
                        NotNullableTextMoney = 1.12M,
                        NullableTextMyMoney = 2.34M,
                        NullableMoney = 22.22M,
                        NotNullableMoney = 122.53M
                    }, "{\"notNullableTextMoney\":\"1.12\",\"nullableTextMyMoney\":\"2.34\",\"nullableMoney\":22.22,\"notNullableMoney\":122.53}" };

            yield return new object[] { new TestObject
                    {
                        NotNullableTextMoney = 0,
                        NullableTextMyMoney = null,
                        NullableMoney = 0,
                        NotNullableMoney = 0
                    }, "{\"notNullableTextMoney\":\"0\",\"nullableTextMyMoney\":null,\"nullableMoney\":0.0,\"notNullableMoney\":0.0}" };
        }

        public class TestObject
        {
            [JsonProperty("notNullableTextMoney"), JsonConverter(typeof(MoneyConverter), MoneyConverterOptions.SendAsText)]
            public decimal NotNullableTextMoney { get; set; }

            [JsonProperty("nullableTextMyMoney"), JsonConverter(typeof(MoneyConverter), MoneyConverterOptions.SendAsText | MoneyConverterOptions.IsNullable)]
            public decimal? NullableTextMyMoney { get; set; }

            [JsonProperty("nullableMoney"), JsonConverter(typeof(MoneyConverter), MoneyConverterOptions.IsNullable)]
            public decimal NullableMoney { get; set; }

            [JsonProperty("notNullableMoney"), JsonConverter(typeof(MoneyConverter))]
            public decimal NotNullableMoney { get; set; }
        }
    }
}
