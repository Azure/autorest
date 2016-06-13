package fixtures.bodydictionary;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.exc.InvalidFormatException;
import fixtures.bodydictionary.models.Widget;
import org.joda.time.DateTime;
import org.joda.time.DateTimeZone;
import org.joda.time.LocalDate;
import org.joda.time.Period;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.junit.Assert.fail;

public class DictionaryTests {
    private static AutoRestSwaggerBATdictionaryService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestSwaggerBATdictionaryServiceImpl("http://localhost:3000");
    }

    @Test
    public void getNull() throws Exception {
        Assert.assertNull(client.getDictionaryOperations().getNull().getBody());
    }

    @Test
    public void getInvalid() throws Exception {
        try {
            client.getDictionaryOperations().getInvalid();
            fail();
        } catch (JsonParseException exception) {
            // expected
            Assert.assertTrue(exception.getMessage().contains("Unexpected character (','"));
        }
    }

    @Test
    public void getEmpty() throws Exception {
        Map<String, Integer> result = client.getDictionaryOperations().getEmpty().getBody();
        Assert.assertEquals(0, result.keySet().size());
    }

    @Test
    public void putEmpty() throws Exception {
        client.getDictionaryOperations().putEmpty(new HashMap<String, String>());
    }

    @Test
    public void getNullValue() throws Exception {
        Map<String, String> result = client.getDictionaryOperations().getNullValue().getBody();
        Assert.assertNull(result.get("key1"));
    }

    @Test
    public void getNullKey() throws Exception {
        try {
            client.getDictionaryOperations().getNullKey();
            fail();
        } catch (JsonParseException exception) {
            // expected
            Assert.assertTrue(exception.getMessage().contains("Unexpected character ('n'"));
        }
    }

    @Test
    public void getEmptyStringKey() throws Exception {
        Map<String, String> result = client.getDictionaryOperations().getEmptyStringKey().getBody();
        Assert.assertEquals("val1", result.get(""));
    }

    @Test
    public void getBooleanTfft() throws Exception {
        Map<String, Boolean>  result = client.getDictionaryOperations().getBooleanTfft().getBody();
        Map<String, Boolean> expected = new HashMap<String, Boolean>();
        expected.put("0", true);
        expected.put("1", false);
        expected.put("2", false);
        expected.put("3", true);
        Assert.assertEquals(expected, result);
    }

    @Test
    public void putBooleanTfft() throws Exception {
        Map<String, Boolean> testData = new HashMap<String, Boolean>();
        testData.put("0", true);
        testData.put("1", false);
        testData.put("2", false);
        testData.put("3", true);
        client.getDictionaryOperations().putBooleanTfft(testData);
    }

    @Test
    public void getBooleanInvalidNull() throws Exception {
        Map<String, Boolean> result = client.getDictionaryOperations().getBooleanInvalidNull().getBody();
        Assert.assertNull(result.get("1"));
    }

    @Test
    public void getBooleanInvalidString() throws Exception {
        try {
            Map<String, Boolean> result = client.getDictionaryOperations().getBooleanInvalidString().getBody();
        } catch (InvalidFormatException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("only \"true\" or \"false\" recognized"));
        }
    }

    @Test
    public void getIntegerValid() throws Exception {
        Map<String, Integer> result = client.getDictionaryOperations().getIntegerValid().getBody();
        Map<String, Integer> expected = new HashMap<String, Integer>();
        expected.put("0", 1);
        expected.put("1", -1);
        expected.put("2", 3);
        expected.put("3", 300);
        Assert.assertEquals(expected, result);
    }

    @Test
    public void putIntegerValid() throws Exception {
        Map<String, Integer> testdata = new HashMap<String, Integer>();
        testdata.put("0", 1);
        testdata.put("1", -1);
        testdata.put("2", 3);
        testdata.put("3", 300);
        client.getDictionaryOperations().putIntegerValid(testdata);
    }

    @Test
    public void getIntInvalidNull() throws Exception {
        Map<String, Integer> result = client.getDictionaryOperations().getIntInvalidNull().getBody();
        Assert.assertNull(result.get("1"));
    }

    @Test
    public void getIntInvalidString() throws Exception {
        try {
            Map<String, Integer> result = client.getDictionaryOperations().getIntInvalidString().getBody();
            fail();
        } catch (InvalidFormatException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("not a valid Integer value"));
        }
    }

    @Test
    public void getLongValid() throws Exception {
        Map<String, Long> result = client.getDictionaryOperations().getLongValid().getBody();
        HashMap<String, Long> expected = new HashMap<String, Long>();
        expected.put("0", 1L);
        expected.put("1", -1L);
        expected.put("2", 3L);
        expected.put("3", 300L);
        Assert.assertEquals(expected, result);
    }

    @Test
    public void putLongValid() throws Exception {
        HashMap<String, Long> expected = new HashMap<String, Long>();
        expected.put("0", 1L);
        expected.put("1", -1L);
        expected.put("2", 3L);
        expected.put("3", 300L);
        client.getDictionaryOperations().putLongValid(expected);
    }

    @Test
    public void getLongInvalidNull() throws Exception {
        Map<String, Long> result = client.getDictionaryOperations().getLongInvalidNull().getBody();
        Assert.assertNull(result.get("1"));
    }

    @Test
    public void getLongInvalidString() throws Exception {
        try {
            Map<String, Long> result = client.getDictionaryOperations().getLongInvalidString().getBody();
            fail();
        } catch (InvalidFormatException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("not a valid Long value"));
        }
    }

    @Test
    public void getFloatValid() throws Exception {
        Map<String, Double> result = client.getDictionaryOperations().getFloatValid().getBody();
        Map<String, Double> expected = new HashMap<String, Double>();
        expected.put("0", 0d);
        expected.put("1", -0.01d);
        expected.put("2", -1.2e20d);
        Assert.assertEquals(expected, result);
    }

    @Test
    public void putFloatValid() throws Exception {
        Map<String, Double> testdata = new HashMap<String, Double>();
        testdata.put("0", 0d);
        testdata.put("1", -0.01d);
        testdata.put("2", -1.2e20d);
        client.getDictionaryOperations().putFloatValid(testdata);
    }

    @Test
    public void getFloatInvalidNull() throws Exception {
        Map<String, Double> result = client.getDictionaryOperations().getFloatInvalidNull().getBody();
        Assert.assertNull(result.get("1"));
    }

    @Test
    public void getFloatInvalidString() throws Exception {
        try {
            Map<String, Double> result = client.getDictionaryOperations().getFloatInvalidString().getBody();
            fail();
        } catch (InvalidFormatException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("not a valid Double value"));
        }
    }

    @Test
    public void getDoubleValid() throws Exception {
        Map<String, Double> result = client.getDictionaryOperations().getDoubleValid().getBody();
        Map<String, Double> expected = new HashMap<String, Double>();
        expected.put("0", 0d);
        expected.put("1", -0.01d);
        expected.put("2", -1.2e20d);
        Assert.assertEquals(expected, result);
    }

    @Test
    public void putDoubleValid() throws Exception {
        //{"0": 0, "1": -0.01, "2": 1.2e20}
        Map<String, Double> testdata = new HashMap<String, Double>();
        testdata.put("0", 0d);
        testdata.put("1", -0.01d);
        testdata.put("2", -1.2e20d);
        client.getDictionaryOperations().putDoubleValid(testdata);
    }

    @Test
    public void getDoubleInvalidNull() throws Exception {
        Map<String, Double> result = client.getDictionaryOperations().getDoubleInvalidNull().getBody();
        Assert.assertNull(result.get("1"));
    }

    @Test
    public void getDoubleInvalidString() throws Exception {
        try {
            Map<String, Double> result = client.getDictionaryOperations().getDoubleInvalidString().getBody();
            fail();
        } catch (InvalidFormatException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("not a valid Double value"));
        }
    }

    @Test
    public void getStringValid() throws Exception {
        Map<String, String> result = client.getDictionaryOperations().getStringValid().getBody();
        Map<String, String> expected = new HashMap<String, String>();
        expected.put("0", "foo1");
        expected.put("1", "foo2");
        expected.put("2", "foo3");
        Assert.assertEquals(expected, result);
    }

    @Test
    public void putStringValid() throws Exception {
        Map<String, String> testdata = new HashMap<String, String>();
        testdata.put("0", "foo1");
        testdata.put("1", "foo2");
        testdata.put("2", "foo3");
        client.getDictionaryOperations().putStringValid(testdata);
    }

    @Test
    public void getStringWithNull() throws Exception {
        Map<String, String> result = client.getDictionaryOperations().getStringWithNull().getBody();
        Assert.assertNull(result.get("1"));
    }

    @Test
    public void getStringWithInvalid() throws Exception {
        Map<String, String> result = client.getDictionaryOperations().getStringWithInvalid().getBody();
        Assert.assertEquals("123", result.get("1"));
    }

    @Test
    public void getDateValid() throws Exception {
        Map<String, LocalDate> result = client.getDictionaryOperations().getDateValid().getBody();
        Map<String, LocalDate> expected = new HashMap<String, LocalDate>();
        expected.put("0", new LocalDate(2000, 12, 1));
        expected.put("1", new LocalDate(1980, 1, 2));
        expected.put("2", new LocalDate(1492, 10, 12));
        Assert.assertEquals(expected, result);
    }

    @Test
    public void putDateValid() throws Exception {
        Map<String, LocalDate> testdata = new HashMap<String, LocalDate>();
        testdata.put("0", new LocalDate(2000, 12, 1));
        testdata.put("1", new LocalDate(1980, 1, 2));
        testdata.put("2", new LocalDate(1492, 10, 12));
        client.getDictionaryOperations().putDateValid(testdata);
    }

    @Test
    public void getDateInvalidNull() throws Exception {
        Map<String, LocalDate> result = client.getDictionaryOperations().getDateInvalidNull().getBody();
        Assert.assertNull(result.get("1"));
    }

    @Test
    public void getDateInvalidString() throws Exception {
        try {
            Map<String, LocalDate> result = client.getDictionaryOperations().getDateInvalidChars().getBody();
            fail();
        } catch (JsonMappingException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("Invalid format: \"date\""));
        }
    }

    @Test
    public void getDateTimeValid() throws Exception {
        Map<String, DateTime> result = client.getDictionaryOperations().getDateTimeValid().getBody();
        Map<String, DateTime> expected = new HashMap<String, DateTime>();
        expected.put("0", new DateTime(2000, 12, 1, 0, 0, 1, DateTimeZone.UTC));
        expected.put("1", new DateTime(1980, 1, 2, 0, 11, 35, DateTimeZone.forOffsetHours(1))
                            .withZone(DateTimeZone.UTC));
        expected.put("2", new DateTime(1492, 10, 12, 10, 15, 1, DateTimeZone.forOffsetHours(-8))
                            .withZone(DateTimeZone.UTC));
        Assert.assertEquals(expected, result);
    }

    @Test
    public void putDateTimeValid() throws Exception {
        Map<String, DateTime> testdata = new HashMap<String, DateTime>();
        testdata.put("0", new DateTime(2000, 12, 1, 0, 0, 1, DateTimeZone.UTC));
        testdata.put("1", new DateTime(1980, 1, 2, 0, 11, 35, DateTimeZone.forOffsetHours(1)));
        testdata.put("2", new DateTime(1492, 10, 12, 10, 15, 1, DateTimeZone.forOffsetHours(-8)));
        client.getDictionaryOperations().putDateTimeValid(testdata);
    }

    @Test
    public void getDateTimeInvalidNull() throws Exception {
        Map<String, DateTime> result = client.getDictionaryOperations().getDateTimeInvalidNull().getBody();
        Assert.assertNull(result.get("1"));
    }

    @Test
    public void getDateTimeInvalidString() throws Exception {
        try {
            Map<String, DateTime> result = client.getDictionaryOperations().getDateTimeInvalidChars().getBody();
            fail();
        } catch (JsonMappingException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("Invalid format: \"date-time\""));
        }
    }

    @Test
    public void getDateTimeRfc1123Valid() throws Exception {
        Map<String, DateTime> result = client.getDictionaryOperations().getDateTimeRfc1123Valid().getBody();
        Map<String, DateTime> expected = new HashMap<String, DateTime>();
        expected.put("0", new DateTime(2000, 12, 1, 0, 0, 1, DateTimeZone.UTC));
        expected.put("1", new DateTime(1980, 1, 2, 0, 11, 35, DateTimeZone.UTC));
        expected.put("2", new DateTime(1492, 10, 12, 10, 15, 1, DateTimeZone.UTC));
        Assert.assertEquals(expected, result);
    }

    @Test
    public void putDateTimeRfc1123Valid() throws Exception {
        Map<String, DateTime> testdata = new HashMap<String, DateTime>();
        testdata.put("0", new DateTime(2000, 12, 1, 0, 0, 1, DateTimeZone.UTC));
        testdata.put("1", new DateTime(1980, 1, 2, 0, 11, 35, DateTimeZone.UTC));
        testdata.put("2", new DateTime(1492, 10, 12, 10, 15, 1, DateTimeZone.UTC));
        client.getDictionaryOperations().putDateTimeRfc1123Valid(testdata);
    }

    @Test
    public void getDurationValid() throws Exception {
        Map<String, Period> result = client.getDictionaryOperations().getDurationValid().getBody();
        Map<String, Period> expected = new HashMap<String, Period>();
        expected.put("0", new Period(0, 0, 0, 123, 22, 14, 12, 11));
        expected.put("1", new Period(0, 0, 0, 5, 1, 0, 0, 0));
        Assert.assertEquals(expected, result);
    }

    @Test
    public void putDurationValid() throws Exception {
        Map<String, Period> testdata = new HashMap<String, Period>();
        testdata.put("0", new Period(0, 0, 0, 123, 22, 14, 12, 11));
        testdata.put("1", new Period(0, 0, 0, 5, 1, 0, 0, 0));
        client.getDictionaryOperations().putDurationValid(testdata);
    }

    @Test
    public void getByteValid() throws Exception {
        Map<String, byte[]> result = client.getDictionaryOperations().getByteValid().getBody();
        Map<String, byte[]> expected = new HashMap<String, byte[]>();
        expected.put("0", new byte[] {(byte) 0xFF, (byte) 0xFF, (byte) 0xFF, (byte) 0xFA});
        expected.put("1", new byte[] {(byte) 0x01, (byte) 0x02, (byte) 0x03});
        expected.put("2", new byte[] {(byte) 0x25, (byte) 0x29, (byte) 0x43});
        Assert.assertArrayEquals(expected.get("0"), result.get("0"));
        Assert.assertArrayEquals(expected.get("1"), result.get("1"));
        Assert.assertArrayEquals(expected.get("2"), result.get("2"));
    }

    @Test
    public void putByteValid() throws Exception {
        Map<String, byte[]> testdata = new HashMap<String, byte[]>();
        testdata.put("0", new byte[]{(byte) 0xFF, (byte) 0xFF, (byte) 0xFF, (byte) 0xFA});
        testdata.put("1", new byte[]{(byte) 0x01, (byte) 0x02, (byte) 0x03});
        testdata.put("2", new byte[]{(byte) 0x25, (byte) 0x29, (byte) 0x43});
        client.getDictionaryOperations().putByteValid(testdata);
    }

    @Test
    public void getByteInvalidNull() throws Exception {
        Map<String, byte[]> result = client.getDictionaryOperations().getByteInvalidNull().getBody();
        Assert.assertNull(result.get("1"));
    }

    @Test
    public void getComplexNull() throws Exception {
        Map<String, Widget> result = client.getDictionaryOperations().getComplexNull().getBody();
        Assert.assertNull(result);
    }

    @Test
    public void getComplexEmpty() throws Exception {
        Map<String, Widget> result = client.getDictionaryOperations().getComplexEmpty().getBody();
        Assert.assertEquals(0, result.size());
    }

    @Test
    public void getComplexItemNull() throws Exception {
        Map<String, Widget> result = client.getDictionaryOperations().getComplexItemNull().getBody();
        Assert.assertEquals(3, result.size());
        Assert.assertNull(result.get("1"));
    }

    @Test
    public void getComplexItemEmpty() throws Exception {
        Map<String, Widget> result = client.getDictionaryOperations().getComplexItemEmpty().getBody();
        Assert.assertEquals(3, result.size());
        Assert.assertNull(result.get("1").getInteger());
        Assert.assertNull(result.get("1").getStringProperty());
    }

    @Test
    public void getComplexValid() throws Exception {
        Map<String, Widget> result = client.getDictionaryOperations().getComplexValid().getBody();
        Assert.assertEquals(3, result.size());
        Assert.assertEquals(1, result.get("0").getInteger().intValue());
        Assert.assertEquals("4", result.get("1").getStringProperty());
    }

    @Test
    public void putComplexValid() throws Exception {
        Map<String, Widget> body = new HashMap<String, Widget>();
        Widget w1 = new Widget();
        w1.setInteger(1);
        w1.setStringProperty("2");
        body.put("0", w1);
        Widget w2 = new Widget();
        w2.setInteger(3);
        w2.setStringProperty("4");
        body.put("1", w2);
        Widget w3 = new Widget();
        w3.setInteger(5);
        w3.setStringProperty("6");
        body.put("2", w3);
        client.getDictionaryOperations().putComplexValid(body);
    }

    @Test
    public void getArrayNull() throws Exception {
        Map<String, List<String>> result = client.getDictionaryOperations().getArrayNull().getBody();
        Assert.assertNull(result);
    }

    @Test
    public void getArrayEmpty() throws Exception {
        Map<String, List<String>> result = client.getDictionaryOperations().getArrayEmpty().getBody();
        Assert.assertEquals(0, result.size());
    }

    @Test
    public void getArrayItemNull() throws Exception {
        Map<String, List<String>> result = client.getDictionaryOperations().getArrayItemNull().getBody();
        Assert.assertNull(result.get("1"));
    }

    @Test
    public void getArrayItemEmpty() throws Exception {
        Map<String, List<String>> result = client.getDictionaryOperations().getArrayItemEmpty().getBody();
        Assert.assertEquals(0, result.get("1").size());
    }

    @Test
    public void getArrayValid() throws  Exception {
        Map<String, List<String>> result = client.getDictionaryOperations().getArrayValid().getBody();
        Assert.assertArrayEquals(new String[] {"1", "2", "3" }, result.get("0").toArray());
        Assert.assertArrayEquals(new String[] {"4", "5", "6" }, result.get("1").toArray());
        Assert.assertArrayEquals(new String[] {"7", "8", "9" }, result.get("2").toArray());
    }

    @Test
    public void putArrayValid() throws Exception {
        Map<String, List<String>> body = new HashMap<String, List<String>>();
        body.put("0", Arrays.asList("1", "2", "3"));
        body.put("1", Arrays.asList("4", "5", "6"));
        body.put("2", Arrays.asList("7", "8", "9"));
        client.getDictionaryOperations().putArrayValid(body);
    }

    @Test
    public void getDictionaryNull() throws Exception {
        Assert.assertNull(client.getDictionaryOperations().getDictionaryNull().getBody());
    }

    @Test
    public void getDictionaryEmpty() throws Exception {
        Map<String, Map<String, String>> result = client.getDictionaryOperations().getDictionaryEmpty().getBody();
        Assert.assertEquals(0, result.size());
    }

    @Test
    public void getDictionaryItemNull() throws Exception {
        Map<String, Map<String, String>> result = client.getDictionaryOperations().getDictionaryItemNull().getBody();
        Assert.assertNull(result.get("1"));
    }

    @Test
    public void getDictionaryItemEmpty() throws Exception {
        Map<String, Map<String, String>> result = client.getDictionaryOperations().getDictionaryItemEmpty().getBody();
        Assert.assertEquals(0, result.get("1").size());
    }

    @Test
    public void getDictionaryValid() throws  Exception {
        Map<String, Map<String, String>> result = client.getDictionaryOperations().getDictionaryValid().getBody();
        Map<String, String> map1 = new HashMap<String, String>();
        map1.put("1", "one");
        map1.put("2", "two");
        map1.put("3", "three");
        Map<String, String> map2 = new HashMap<String, String>();
        map2.put("4", "four");
        map2.put("5", "five");
        map2.put("6", "six");
        Map<String, String> map3 = new HashMap<String, String>();
        map3.put("7", "seven");
        map3.put("8", "eight");
        map3.put("9", "nine");
        Map<String, Map<String, String>> expected = new HashMap<String, Map<String, String>>();
        expected.put("0", map1);
        expected.put("1", map2);
        expected.put("2", map3);
        Assert.assertEquals(expected, result);
    }

    @Test
    public void putDictionaryValid() throws Exception {
        Map<String, String> map1 = new HashMap<String, String>();
        map1.put("1", "one");
        map1.put("2", "two");
        map1.put("3", "three");
        Map<String, String> map2 = new HashMap<String, String>();
        map2.put("4", "four");
        map2.put("5", "five");
        map2.put("6", "six");
        Map<String, String> map3 = new HashMap<String, String>();
        map3.put("7", "seven");
        map3.put("8", "eight");
        map3.put("9", "nine");
        Map<String, Map<String, String>> body = new HashMap<String, Map<String, String>>();
        body.put("0", map1);
        body.put("1", map2);
        body.put("2", map3);
        client.getDictionaryOperations().putDictionaryValid(body);
    }
}
