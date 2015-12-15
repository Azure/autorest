package fixtures.bodyarray;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.exc.InvalidFormatException;
import com.microsoft.rest.DateTimeRfc1123;
import com.microsoft.rest.ServiceException;
import fixtures.bodyarray.models.ErrorException;
import fixtures.bodyarray.models.Product;
import org.joda.time.DateTime;
import org.joda.time.DateTimeZone;
import org.joda.time.LocalDate;
import org.joda.time.Period;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ArrayTests {
    private static AutoRestSwaggerBATArrayService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestSwaggerBATArrayServiceImpl("http://localhost.:3000");
    }

    @Test
    public void getNull() throws Exception {
        Assert.assertNull(client.getArray().getNull().getBody());
    }

    @Test
    public void getInvalid() throws Exception {
        try {
            List<Integer> result = client.getArray().getInvalid().getBody();
            Assert.assertTrue(false);
        } catch (JsonParseException exception) {
            // expected
            Assert.assertTrue(exception.getMessage().contains("Unexpected end-of-input"));
        }
    }

    @Test
    public void getEmpty() throws Exception {
        List<Integer> result = client.getArray().getEmpty().getBody();
        Assert.assertEquals(0, result.size());
    }

    @Test
    public void putEmpty() throws Exception {
        client.getArray().putEmpty(new ArrayList<String>());
    }

    @Test
    public void getBooleanTfft() throws Exception {
        List<Boolean> result = client.getArray().getBooleanTfft().getBody();
        Object[] exected = new Boolean[] {true, false, false, true};
        Assert.assertArrayEquals(exected, result.toArray());
    }

    @Test
    public void putBooleanTfft() throws Exception {
        client.getArray().putBooleanTfft(Arrays.asList(true, false, false, true));
    }

    @Test
    public void getBooleanInvalidNull() throws Exception {
        try {
            List<Boolean> result = client.getArray().getBooleanInvalidNull().getBody();
        } catch (ErrorException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getBooleanInvalidString() throws Exception {
        try {
            List<Boolean> result = client.getArray().getBooleanInvalidString().getBody();
        } catch (InvalidFormatException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("only \"true\" or \"false\" recognized"));
        }
    }

    @Test
    public void getIntegerValid() throws Exception {
        List<Integer> result = client.getArray().getIntegerValid().getBody();
        Object[] expected = new Integer[] {1, -1, 3, 300};
        Assert.assertArrayEquals(expected, result.toArray());
    }

    @Test
    public void putIntegerValid() throws Exception {
        client.getArray().putIntegerValid(Arrays.asList(1, -1, 3, 300));
    }

    @Test
    public void getIntInvalidNull() throws Exception {
        try {
            List<Integer> result = client.getArray().getIntInvalidNull().getBody();
        } catch (ErrorException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getIntInvalidString() throws Exception {
        try {
            List<Integer> result = client.getArray().getIntInvalidString().getBody();
        } catch (InvalidFormatException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("not a valid Integer value"));
        }
    }

    @Test
    public void getLongValid() throws Exception {
        List<Long> result = client.getArray().getLongValid().getBody();
        Object[] expected = new Long[] {1L, -1L, 3L, 300L};
        Assert.assertArrayEquals(expected, result.toArray());
    }

    @Test
    public void putLongValid() throws Exception {
        client.getArray().putLongValid(Arrays.asList(1L, -1L, 3L, 300L));
    }

    @Test
    public void getLongInvalidNull() throws Exception {
        try {
            List<Long> result = client.getArray().getLongInvalidNull().getBody();
        } catch (ErrorException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getLongInvalidString() throws Exception {
        try {
            List<Long> result = client.getArray().getLongInvalidString().getBody();
        } catch (InvalidFormatException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("not a valid Long value"));
        }
    }

    @Test
    public void getFloatValid() throws Exception {
        List<Double> result = client.getArray().getFloatValid().getBody();
        Object[] expected = new Double[] {0d, -0.01, -1.2e20};
        Assert.assertArrayEquals(expected, result.toArray());
    }

    @Test
    public void putFloatValid() throws Exception {
        client.getArray().putFloatValid(Arrays.asList(0d, -0.01d, -1.2e20d));
    }

    @Test
    public void getFloatInvalidNull() throws Exception {
        try {
            List<Double> result = client.getArray().getFloatInvalidNull().getBody();
        } catch (ErrorException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getFloatInvalidString() throws Exception {
        try {
            List<Double> result = client.getArray().getFloatInvalidString().getBody();
        } catch (InvalidFormatException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("not a valid Double value"));
        }
    }

    @Test
    public void getDoubleValid() throws Exception {
        List<Double> result = client.getArray().getDoubleValid().getBody();
        Object[] expected = new Double[] {0d, -0.01, -1.2e20};
        Assert.assertArrayEquals(expected, result.toArray());
    }

    @Test
    public void putDoubleValid() throws Exception {
        client.getArray().putDoubleValid(Arrays.asList(0d, -0.01d, -1.2e20d));
    }

    @Test
    public void getDoubleInvalidNull() throws Exception {
        try {
            List<Double> result = client.getArray().getDoubleInvalidNull().getBody();
        } catch (ErrorException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getDoubleInvalidString() throws Exception {
        try {
            List<Double> result = client.getArray().getDoubleInvalidString().getBody();
        } catch (InvalidFormatException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("not a valid Double value"));
        }
    }

    @Test
    public void getStringValid() throws Exception {
        List<String> result = client.getArray().getStringValid().getBody();
        Object[] expected = new String[] {"foo1", "foo2", "foo3"};
        Assert.assertArrayEquals(expected, result.toArray());
    }

    @Test
    public void putStringValid() throws Exception {
        client.getArray().putStringValid(Arrays.asList("foo1", "foo2", "foo3"));
    }

    @Test
    public void getStringWithNull() throws Exception {
        try {
            List<String> result = client.getArray().getStringWithNull().getBody();
        } catch (ErrorException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getStringWithInvalid() throws Exception {
        try {
            List<String> result = client.getArray().getStringWithInvalid().getBody();
        } catch (ErrorException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("InvalidFormatException"));
        }
    }

    @Test
    public void getDateValid() throws Exception {
        List<LocalDate> result = client.getArray().getDateValid().getBody();
        Object[] expected = new LocalDate[] {
                new LocalDate(2000, 12, 1),
                new LocalDate(1980, 1, 2),
                new LocalDate(1492, 10, 12)
        };
        Assert.assertArrayEquals(expected, result.toArray());
    }

    @Test
    public void putDateValid() throws Exception {
        client.getArray().putDateValid(Arrays.asList(
                new LocalDate(2000, 12, 1),
                new LocalDate(1980, 1, 2),
                new LocalDate(1492, 10, 12)
        ));
    }

    @Test
    public void getDateInvalidNull() throws Exception {
        try {
            List<LocalDate> result = client.getArray().getDateInvalidNull().getBody();
        } catch (ErrorException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getDateInvalidString() throws Exception {
        try {
            List<LocalDate> result = client.getArray().getDateInvalidChars().getBody();
        } catch (JsonMappingException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("Invalid format: \"date\""));
        }
    }

    @Test
    public void getDateTimeValid() throws Exception {
        List<DateTime> result = client.getArray().getDateTimeValid().getBody();
        Object[] expected = new DateTime[] {
                new DateTime(2000, 12, 1, 0, 0, 1, DateTimeZone.UTC),
                new DateTime(1980, 1, 2, 0, 11, 35, DateTimeZone.UTC),
                new DateTime(1492, 10, 12, 10, 15, 1, DateTimeZone.UTC)
        };
        Assert.assertArrayEquals(expected, result.toArray());
    }

    @Test
    public void putDateTimeValid() throws Exception {
        client.getArray().putDateTimeValid(Arrays.asList(
                new DateTime(2000, 12, 1, 0, 0, 1, DateTimeZone.UTC),
                new DateTime(1980, 1, 2, 0, 11, 35, DateTimeZone.UTC),
                new DateTime(1492, 10, 12, 10, 15, 1, DateTimeZone.UTC)
        ));
    }

    @Test
    public void getDateTimeInvalidNull() throws Exception {
        try {
            List<DateTime> result = client.getArray().getDateTimeInvalidNull().getBody();
        } catch (ErrorException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getDateTimeInvalidString() throws Exception {
        try {
            List<DateTime> result = client.getArray().getDateTimeInvalidChars().getBody();
        } catch (JsonMappingException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("Invalid format: \"date-time\""));
        }
    }

    @Test
    public void getDateTimeRfc1123Valid() throws Exception {
        List<DateTimeRfc1123> result = client.getArray().getDateTimeRfc1123Valid().getBody();
        Object[] expected = new DateTimeRfc1123[] {
                new DateTimeRfc1123(new DateTime(2000, 12, 1, 0, 0, 1, DateTimeZone.UTC)),
                new DateTimeRfc1123(new DateTime(1980, 1, 2, 0, 11, 35, DateTimeZone.UTC)),
                new DateTimeRfc1123(new DateTime(1492, 10, 12, 10, 15, 1, DateTimeZone.UTC))
        };
        Assert.assertArrayEquals(expected, result.toArray());
    }

    @Test
    public void putDateTimeRfc1123Valid() throws Exception {
        client.getArray().putDateTimeRfc1123Valid(Arrays.asList(
                new DateTimeRfc1123(new DateTime(2000, 12, 1, 0, 0, 1, DateTimeZone.UTC)),
                new DateTimeRfc1123(new DateTime(1980, 1, 2, 0, 11, 35, DateTimeZone.UTC)),
                new DateTimeRfc1123(new DateTime(1492, 10, 12, 10, 15, 1, DateTimeZone.UTC))
        ));
    }

    @Test
    public void getDurationValid() throws Exception {
        List<Period> result = client.getArray().getDurationValid().getBody();
        Object[] expected = new Period[] {
                new Period(0, 0, 0, 123, 22, 14, 12, 11),
                new Period(0, 0, 0, 5, 1, 0, 0, 0)
        };
        Assert.assertArrayEquals(expected, result.toArray());
    }

    @Test
    public void putDurationValid() throws Exception {
        client.getArray().putDurationValid(Arrays.asList(
                        new Period(0, 0, 0, 123, 22, 14, 12, 11),
                        new Period(0, 0, 0, 5, 1, 0, 0, 0)));
    }

    @Test
    public void getByteValid() throws Exception {
        List<byte[]> result = client.getArray().getByteValid().getBody();
        Object[] expected = new byte[][] {
                new byte[] {(byte) 0xFF, (byte) 0xFF, (byte) 0xFF, (byte) 0xFA},
                new byte[] {(byte) 0x01, (byte) 0x02, (byte) 0x03},
                new byte[] {(byte) 0x25, (byte) 0x29, (byte) 0x43}
        };
        Assert.assertArrayEquals(expected, result.toArray());
    }

    @Test
    public void putByteValid() throws Exception {
        client.getArray().putByteValid(Arrays.asList(
                new byte[] {(byte) 0xFF, (byte) 0xFF, (byte) 0xFF, (byte) 0xFA},
                new byte[] {(byte) 0x01, (byte) 0x02, (byte) 0x03},
                new byte[] {(byte) 0x25, (byte) 0x29, (byte) 0x43}
        ));
    }

    @Test
    public void getByteInvalidNull() throws Exception {
        try {
            List<byte[]> result = client.getArray().getByteInvalidNull().getBody();
        } catch (ErrorException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getComplexNull() throws Exception {
        try {
            List<Product> result = client.getArray().getComplexNull().getBody();
        } catch (ErrorException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getComplexEmpty() throws Exception {
        List<Product> result = client.getArray().getComplexEmpty().getBody();
        Assert.assertEquals(0, result.size());
    }

    @Test
    public void getComplexItemNull() throws Exception {
        List<Product> result = client.getArray().getComplexItemNull().getBody();
        Assert.assertEquals(3, result.size());
        Assert.assertNull(result.get(1));
    }

    @Test
    public void getComplexItemEmpty() throws Exception {
        List<Product> result = client.getArray().getComplexItemEmpty().getBody();
        Assert.assertEquals(3, result.size());
        Assert.assertNull(result.get(1).getStringProperty());
    }

    @Test
    public void getComplexValid() throws Exception {
        List<Product> result = client.getArray().getComplexValid().getBody();
        Assert.assertEquals(3, result.size());
        Assert.assertEquals(5, result.get(2).getInteger().intValue());
        Assert.assertEquals("6", result.get(2).getStringProperty());
    }

    @Test
    public void putComplexValid() throws Exception {
        List<Product> body = new ArrayList<Product>();
        Product p1 = new Product();
        p1.setInteger(1);
        p1.setStringProperty("2");
        body.add(p1);
        Product p2 = new Product();
        p2.setInteger(3);
        p2.setStringProperty("4");
        body.add(p2);
        Product p3 = new Product();
        p3.setInteger(5);
        p3.setStringProperty("6");
        body.add(p3);
        client.getArray().putComplexValid(body);
    }

    @Test
    public void getArrayNull() throws Exception {
        try {
            List<List<String>> result = client.getArray().getArrayNull().getBody();
        } catch (ErrorException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getArrayEmpty() throws Exception {
        List<List<String>> result = client.getArray().getArrayEmpty().getBody();
        Assert.assertEquals(0, result.size());
    }

    @Test
    public void getArrayItemNull() throws Exception {
        List<List<String>> result = client.getArray().getArrayItemNull().getBody();
        Assert.assertEquals(3, result.size());
        Assert.assertNull(result.get(1));
    }

    @Test
    public void getArrayItemEmpty() throws Exception {
        List<List<String>> result = client.getArray().getArrayItemEmpty().getBody();
        Assert.assertEquals(3, result.size());
        Assert.assertEquals(0, result.get(1).size());
    }

    @Test
    public void getArrayValid() throws Exception {
        List<List<String>> result = client.getArray().getArrayValid().getBody();
        Assert.assertArrayEquals(new String[]{"1", "2", "3"}, result.get(0).toArray());
        Assert.assertArrayEquals(new String[]{"4", "5", "6"}, result.get(1).toArray());
        Assert.assertArrayEquals(new String[] {"7", "8", "9"}, result.get(2).toArray());
    }

    @Test
    public void putArrayValid() throws Exception {
        List<List<String>> body = new ArrayList<List<String>>();
        body.add(Arrays.asList("1", "2", "3"));
        body.add(Arrays.asList("4", "5", "6"));
        body.add(Arrays.asList("7", "8", "9"));
        client.getArray().putArrayValid(body);
    }

    @Test
    public void getDictionaryNull() throws Exception {
        try {
            List<Map<String, String>> result = client.getArray().getDictionaryNull().getBody();
        } catch (ErrorException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getDictionaryEmpty() throws Exception {
        List<Map<String, String>> result = client.getArray().getDictionaryEmpty().getBody();
        Assert.assertEquals(0, result.size());
    }

    @Test
    public void getDictionaryItemNull() throws Exception {
        List<Map<String, String>> result = client.getArray().getDictionaryItemNull().getBody();
        Assert.assertEquals(3, result.size());
        Assert.assertNull(result.get(1));
    }

    @Test
    public void getDictionaryItemEmpty() throws Exception {
        List<Map<String, String>> result = client.getArray().getDictionaryItemEmpty().getBody();
        Assert.assertEquals(3, result.size());
        Assert.assertEquals(0, result.get(1).size());
    }

    @Test
    public void getDictionaryValid() throws Exception {
        List<Map<String, String>> result = client.getArray().getDictionaryValid().getBody();
        Assert.assertEquals("seven", result.get(2).get("7"));
        Assert.assertEquals("five", result.get(1).get("5"));
        Assert.assertEquals("three", result.get(0).get("3"));
    }

    @Test
    public void putDictionaryValid() throws Exception {
        List<Map<String, String>> body = new ArrayList<Map<String, String>>();
        Map<String, String> m1 = new HashMap<String, String>();
        m1.put("1", "one");
        m1.put("2", "two");
        m1.put("3", "three");
        body.add(m1);
        Map<String, String> m2 = new HashMap<String, String>();
        m2.put("4", "four");
        m2.put("5", "five");
        m2.put("6", "six");
        body.add(m2);
        Map<String, String> m3 = new HashMap<String, String>();
        m3.put("7", "seven");
        m3.put("8", "eight");
        m3.put("9", "nine");
        body.add(m3);
        client.getArray().putDictionaryValid(body);
    }
}
