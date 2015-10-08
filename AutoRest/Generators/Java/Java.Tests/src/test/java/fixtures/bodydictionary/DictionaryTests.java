package fixtures.bodydictionary;

import com.microsoft.rest.ServiceException;
import fixtures.bodydictionary.AutoRestSwaggerBATdictionaryService;
import fixtures.bodydictionary.AutoRestSwaggerBATdictionaryServiceImpl;
import fixtures.bodydictionary.models.Widget;
import org.joda.time.DateTime;
import org.joda.time.DateTimeZone;
import org.joda.time.LocalDate;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.util.*;

import static org.junit.Assert.fail;

public class DictionaryTests {
    static AutoRestSwaggerBATdictionaryService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestSwaggerBATdictionaryServiceImpl("http://localhost.:3000");
    }

    @Test
    public void getNull() throws Exception {
        Assert.assertNull(client.getDictionary().getNull());
    }

    @Test
    public void getInvalid() throws Exception {
        try {
            client.getDictionary().getInvalid();
            fail();
        } catch (ServiceException exception) {
            // expected
            Assert.assertTrue(exception.getMessage().contains("JsonParseException"));
        }
    }

    @Test
    public void getEmpty() throws Exception {
        Map<String, Integer> result = client.getDictionary().getEmpty();
        Assert.assertEquals(0, result.keySet().size());
    }

    @Test
    public void putEmpty() throws Exception {
        client.getDictionary().putEmpty(new HashMap<String,String>());
    }

    @Test
    public void getNullValue() throws Exception {
        Map<String, String> result = client.getDictionary().getNullValue();
        Assert.assertNull(result.get("key1"));
    }

    @Test
    public void getNullKey() throws Exception {
        try {
            client.getDictionary().getNullKey();
            fail();
        } catch (ServiceException exception) {
            // expected
            Assert.assertTrue(exception.getMessage().contains("JsonParseException"));
        }
    }

    @Test
    public void getEmptyStringKey() throws Exception {
        Map<String, String> result = client.getDictionary().getEmptyStringKey();
        Assert.assertEquals("val1", result.get(""));
    }

    @Test
    public void getBooleanTfft() throws Exception {
        Map<String, Boolean>  result = client.getDictionary().getBooleanTfft();
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
        client.getDictionary().putBooleanTfft(testData);
    }

    @Test
    public void getBooleanInvalidNull() throws Exception {
        Map<String, Boolean> result = client.getDictionary().getBooleanInvalidNull();
        Assert.assertNull(result.get("1"));
    }

    @Test
    public void getBooleanInvalidString() throws Exception {
        try {
            Map<String, Boolean> result = client.getDictionary().getBooleanInvalidString();
        } catch (ServiceException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("InvalidFormatException"));
        }
    }

    @Test
    public void getIntegerValid() throws Exception {
        Map<String, Integer> result = client.getDictionary().getIntegerValid();
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
        client.getDictionary().putIntegerValid(testdata);
    }

    @Test
    public void getIntInvalidNull() throws Exception {
        Map<String, Integer> result = client.getDictionary().getIntInvalidNull();
        Assert.assertNull(result.get("1"));
    }

    @Test
    public void getIntInvalidString() throws Exception {
        try {
            Map<String, Integer> result = client.getDictionary().getIntInvalidString();
            fail();
        } catch (ServiceException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("InvalidFormatException"));
        }
    }

    @Test
    public void getLongValid() throws Exception {
        Map<String, Long> result = client.getDictionary().getLongValid();
        HashMap<String, Long> expected = new HashMap<String, Long>();
        expected.put("0", 1l);
        expected.put("1", -1l);
        expected.put("2", 3l);
        expected.put("3", 300l);
        Assert.assertEquals(expected, result);
    }

    @Test
    public void putLongValid() throws Exception {
        HashMap<String, Long> expected = new HashMap<String, Long>();
        expected.put("0", 1l);
        expected.put("1", -1l);
        expected.put("2", 3l);
        expected.put("3", 300l);
        client.getDictionary().putLongValid(expected);
    }

    @Test
    public void getLongInvalidNull() throws Exception {
        Map<String, Long> result = client.getDictionary().getLongInvalidNull();
        Assert.assertNull(result.get("1"));
    }

    @Test
    public void getLongInvalidString() throws Exception {
        try {
            Map<String, Long> result = client.getDictionary().getLongInvalidString();
            fail();
        } catch (ServiceException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("InvalidFormatException"));
        }
    }

    @Test
    public void getFloatValid() throws Exception {
        Map<String, Double> result = client.getDictionary().getFloatValid();
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
        client.getDictionary().putFloatValid(testdata);
    }

    @Test
    public void getFloatInvalidNull() throws Exception {
        Map<String, Double> result = client.getDictionary().getFloatInvalidNull();
        Assert.assertNull(result.get("1"));
    }

    @Test
    public void getFloatInvalidString() throws Exception {
        try {
            Map<String, Double> result = client.getDictionary().getFloatInvalidString();
            fail();
        } catch (ServiceException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("InvalidFormatException"));
        }
    }

    @Test
    public void getDoubleValid() throws Exception {
        Map<String, Double> result = client.getDictionary().getDoubleValid();
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
        client.getDictionary().putDoubleValid(testdata);
    }

    @Test
    public void getDoubleInvalidNull() throws Exception {
        Map<String, Double> result = client.getDictionary().getDoubleInvalidNull();
        Assert.assertNull(result.get("1"));
    }

    @Test
    public void getDoubleInvalidString() throws Exception {
        try {
            Map<String, Double> result = client.getDictionary().getDoubleInvalidString();
            fail();
        } catch (ServiceException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("InvalidFormatException"));
        }
    }

    @Test
    public void getStringValid() throws Exception {
        Map<String, String> result = client.getDictionary().getStringValid();
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
        client.getDictionary().putStringValid(testdata);
    }

    @Test
    public void getStringWithNull() throws Exception {
        Map<String, String> result = client.getDictionary().getStringWithNull();
        Assert.assertNull(result.get("1"));
    }

    @Test
    public void getStringWithInvalid() throws Exception {
        Map<String, String> result = client.getDictionary().getStringWithInvalid();
        Assert.assertEquals("123", result.get("1"));
    }

    @Test
    public void getDateValid() throws Exception {
        Map<String, LocalDate> result = client.getDictionary().getDateValid();
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
        client.getDictionary().putDateValid(testdata);
    }

    @Test
    public void getDateInvalidNull() throws Exception {
        Map<String, LocalDate> result = client.getDictionary().getDateInvalidNull();
        Assert.assertNull(result.get("1"));
    }

    @Test
    public void getDateInvalidString() throws Exception {
        try {
            Map<String, LocalDate> result = client.getDictionary().getDateInvalidChars();
            fail();
        } catch (ServiceException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getDateTimeValid() throws Exception {
        Map<String, DateTime> result = client.getDictionary().getDateTimeValid();
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
        client.getDictionary().putDateTimeValid(testdata);
    }

    @Test
    public void getDateTimeInvalidNull() throws Exception {
        Map<String, DateTime> result = client.getDictionary().getDateTimeInvalidNull();
        Assert.assertNull(result.get("1"));
    }

    @Test
    public void getDateTimeInvalidString() throws Exception {
        try {
            Map<String, DateTime> result = client.getDictionary().getDateTimeInvalidChars();
            fail();
        } catch (ServiceException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getByteValid() throws Exception {
        Map<String, byte[]> result = client.getDictionary().getByteValid();
        Map<String, byte[]> expected = new HashMap<String, byte[]>();
        expected.put("0", new byte[] {(byte)0xFF, (byte)0xFF, (byte)0xFF, (byte)0xFA});
        expected.put("1", new byte[] {(byte)0x01, (byte)0x02, (byte)0x03});
        expected.put("2", new byte[] {(byte)0x25, (byte)0x29, (byte)0x43});
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
        client.getDictionary().putByteValid(testdata);
    }

    @Test
    public void getByteInvalidNull() throws Exception {
        Map<String, byte[]> result = client.getDictionary().getByteInvalidNull();
        Assert.assertNull(result.get("1"));
    }

    @Test
    public void getComplexNull() throws Exception {
        Map<String, Widget> result = client.getDictionary().getComplexNull();
        Assert.assertNull(result);
    }

    @Test
    public void getComplexEmpty() throws Exception {
        Map<String, Widget> result = client.getDictionary().getComplexEmpty();
        Assert.assertEquals(0, result.size());
    }

    @Test
    public void getComplexItemNull() throws Exception {
        Map<String, Widget> result = client.getDictionary().getComplexItemNull();
        Assert.assertEquals(3, result.size());
        Assert.assertNull(result.get("1"));
    }

    @Test
    public void getComplexItemEmpty() throws Exception {
        Map<String, Widget> result = client.getDictionary().getComplexItemEmpty();
        Assert.assertEquals(3, result.size());
        Assert.assertNull(result.get("1").getInteger());
        Assert.assertNull(result.get("1").getStringProperty());
    }

    @Test
    public void getComplexValid() throws Exception {
        Map<String, Widget> result = client.getDictionary().getComplexValid();
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
        client.getDictionary().putComplexValid(body);
    }

    @Test
    public void getArrayNull() throws Exception {
        Map<String, List<String>> result = client.getDictionary().getArrayNull();
        Assert.assertNull(result);
    }

    @Test
    public void getArrayEmpty() throws Exception {
        Map<String, List<String>> result = client.getDictionary().getArrayEmpty();
        Assert.assertEquals(0, result.size());
    }

    @Test
    public void getArrayItemNull() throws Exception {
        Map<String, List<String>> result = client.getDictionary().getArrayItemNull();
        Assert.assertNull(result.get("1"));
    }

    @Test
    public void getArrayItemEmpty() throws Exception {
        Map<String, List<String>> result = client.getDictionary().getArrayItemEmpty();
        Assert.assertEquals(0, result.get("1").size());
    }

    @Test
    public void getArrayValid() throws  Exception {
        Map<String, List<String>> result = client.getDictionary().getArrayValid();
        Assert.assertArrayEquals(new String[] { "1", "2", "3"}, result.get("0").toArray());
        Assert.assertArrayEquals(new String[] { "4", "5", "6"}, result.get("1").toArray());
        Assert.assertArrayEquals(new String[] { "7", "8", "9"}, result.get("2").toArray());
    }

    @Test
    public void putArrayValid() throws Exception {
        Map<String, List<String>> body = new HashMap<String, List<String>>();
        body.put("0", Arrays.asList("1", "2", "3"));
        body.put("1", Arrays.asList("4", "5", "6"));
        body.put("2", Arrays.asList("7", "8", "9"));
        client.getDictionary().putArrayValid(body);
    }

    @Test
    public void getDictionaryNull() throws Exception {
        Assert.assertNull(client.getDictionary().getDictionaryNull());
    }

    @Test
    public void getDictionaryEmpty() throws Exception {
        Map<String, Map<String, String>> result = client.getDictionary().getDictionaryEmpty();
        Assert.assertEquals(0, result.size());
    }

    @Test
    public void getDictionaryItemNull() throws Exception {
        Map<String, Map<String, String>> result = client.getDictionary().getDictionaryItemNull();
        Assert.assertNull(result.get("1"));
    }

    @Test
    public void getDictionaryItemEmpty() throws Exception {
        Map<String, Map<String, String>> result = client.getDictionary().getDictionaryItemEmpty();
        Assert.assertEquals(0, result.get("1").size());
    }

    @Test
    public void getDictionaryValid() throws  Exception {
        Map<String, Map<String, String>> result = client.getDictionary().getDictionaryValid();
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
        client.getDictionary().putDictionaryValid(body);
    }
}
