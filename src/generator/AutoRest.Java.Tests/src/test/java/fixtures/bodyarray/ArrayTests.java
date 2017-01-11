package fixtures.bodyarray;

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
import java.util.UUID;

import fixtures.bodyarray.implementation.AutoRestSwaggerBATArrayServiceImpl;
import fixtures.bodyarray.models.ErrorException;
import fixtures.bodyarray.models.Product;

public class ArrayTests {
    private static AutoRestSwaggerBATArrayService client;

    @BeforeClass
    public static void setup() throws Exception {
        client = new AutoRestSwaggerBATArrayServiceImpl("http://localhost:3000");
    }

    @Test
    public void getNull() throws Exception {
        Assert.assertNull(client.arrays().getNull());
    }

    @Test
    public void getInvalid() throws Exception {
        try {
            List<Integer> result = client.arrays().getInvalid();
            Assert.assertTrue(false);
        } catch (RuntimeException exception) {
            // expected
            Assert.assertTrue(exception.getMessage().contains("Unexpected end-of-input"));
        }
    }

    @Test
    public void getEmpty() throws Exception {
        List<Integer> result = client.arrays().getEmpty();
        Assert.assertEquals(0, result.size());
    }

    @Test
    public void putEmpty() throws Exception {
        client.arrays().putEmpty(new ArrayList<String>());
    }

    @Test
    public void getBooleanTfft() throws Exception {
        List<Boolean> result = client.arrays().getBooleanTfft();
        Object[] exected = new Boolean[] {true, false, false, true};
        Assert.assertArrayEquals(exected, result.toArray());
    }

    @Test
    public void putBooleanTfft() throws Exception {
        client.arrays().putBooleanTfft(Arrays.asList(true, false, false, true));
    }

    @Test
    public void getBooleanInvalidNull() throws Exception {
        try {
            List<Boolean> result = client.arrays().getBooleanInvalidNull();
        } catch (ErrorException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getBooleanInvalidString() throws Exception {
        try {
            List<Boolean> result = client.arrays().getBooleanInvalidString();
        } catch (RuntimeException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("only \"true\" or \"false\" recognized"));
        }
    }

    @Test
    public void getIntegerValid() throws Exception {
        List<Integer> result = client.arrays().getIntegerValid();
        Object[] expected = new Integer[] {1, -1, 3, 300};
        Assert.assertArrayEquals(expected, result.toArray());
    }

    @Test
    public void putIntegerValid() throws Exception {
        client.arrays().putIntegerValid(Arrays.asList(1, -1, 3, 300));
    }

    @Test
    public void getIntInvalidNull() throws Exception {
        try {
            List<Integer> result = client.arrays().getIntInvalidNull();
        } catch (ErrorException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getIntInvalidString() throws Exception {
        try {
            List<Integer> result = client.arrays().getIntInvalidString();
        } catch (RuntimeException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("not a valid Integer value"));
        }
    }

    @Test
    public void getLongValid() throws Exception {
        List<Long> result = client.arrays().getLongValid();
        Object[] expected = new Long[] {1L, -1L, 3L, 300L};
        Assert.assertArrayEquals(expected, result.toArray());
    }

    @Test
    public void putLongValid() throws Exception {
        client.arrays().putLongValid(Arrays.asList(1L, -1L, 3L, 300L));
    }

    @Test
    public void getLongInvalidNull() throws Exception {
        try {
            List<Long> result = client.arrays().getLongInvalidNull();
        } catch (ErrorException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getLongInvalidString() throws Exception {
        try {
            List<Long> result = client.arrays().getLongInvalidString();
        } catch (RuntimeException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("not a valid Long value"));
        }
    }

    @Test
    public void getFloatValid() throws Exception {
        List<Double> result = client.arrays().getFloatValid();
        Object[] expected = new Double[] {0d, -0.01, -1.2e20};
        Assert.assertArrayEquals(expected, result.toArray());
    }

    @Test
    public void putFloatValid() throws Exception {
        client.arrays().putFloatValid(Arrays.asList(0d, -0.01d, -1.2e20d));
    }

    @Test
    public void getFloatInvalidNull() throws Exception {
        try {
            List<Double> result = client.arrays().getFloatInvalidNull();
        } catch (ErrorException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getFloatInvalidString() throws Exception {
        try {
            List<Double> result = client.arrays().getFloatInvalidString();
        } catch (RuntimeException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("not a valid Double value"));
        }
    }

    @Test
    public void getDoubleValid() throws Exception {
        List<Double> result = client.arrays().getDoubleValid();
        Object[] expected = new Double[] {0d, -0.01, -1.2e20};
        Assert.assertArrayEquals(expected, result.toArray());
    }

    @Test
    public void putDoubleValid() throws Exception {
        client.arrays().putDoubleValid(Arrays.asList(0d, -0.01d, -1.2e20d));
    }

    @Test
    public void getDoubleInvalidNull() throws Exception {
        try {
            List<Double> result = client.arrays().getDoubleInvalidNull();
        } catch (ErrorException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getDoubleInvalidString() throws Exception {
        try {
            List<Double> result = client.arrays().getDoubleInvalidString();
        } catch (RuntimeException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("not a valid Double value"));
        }
    }

    @Test
    public void getStringValid() throws Exception {
        List<String> result = client.arrays().getStringValid();
        Object[] expected = new String[] {"foo1", "foo2", "foo3"};
        Assert.assertArrayEquals(expected, result.toArray());
    }

    @Test
    public void putStringValid() throws Exception {
        client.arrays().putStringValid(Arrays.asList("foo1", "foo2", "foo3"));
    }

    @Test
    public void getStringWithNull() throws Exception {
        try {
            List<String> result = client.arrays().getStringWithNull();
        } catch (ErrorException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getStringWithInvalid() throws Exception {
        try {
            List<String> result = client.arrays().getStringWithInvalid();
        } catch (ErrorException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("InvalidFormatException"));
        }
    }

    @Test
    public void getUuidValid() throws Exception {
        List<UUID> result = client.arrays().getUuidValid();
        Object[] expected = new UUID[] {UUID.fromString("6dcc7237-45fe-45c4-8a6b-3a8a3f625652"),
                                         UUID.fromString("d1399005-30f7-40d6-8da6-dd7c89ad34db"),
                                         UUID.fromString("f42f6aa1-a5bc-4ddf-907e-5f915de43205")};
        Assert.assertArrayEquals(expected, result.toArray());
    }

    @Test
    public void putUuidValid() throws Exception {
        client.arrays().putUuidValid(Arrays.asList(UUID.fromString("6dcc7237-45fe-45c4-8a6b-3a8a3f625652"),
        UUID.fromString("d1399005-30f7-40d6-8da6-dd7c89ad34db"), UUID.fromString("f42f6aa1-a5bc-4ddf-907e-5f915de43205")));
    }

    @Test
    public void getUuidInvalidChars() throws Exception {
        try {
            List<UUID> result = client.arrays().getUuidInvalidChars();
            Assert.fail();
        } catch (RuntimeException ex) {
            // expected
            Assert.assertTrue(ex.getMessage(), ex.getMessage().contains("UUID has to be represented"));
        }
    }
    @Test
    public void getDateValid() throws Exception {
        List<LocalDate> result = client.arrays().getDateValid();
        Object[] expected = new LocalDate[] {
                new LocalDate(2000, 12, 1),
                new LocalDate(1980, 1, 2),
                new LocalDate(1492, 10, 12)
        };
        Assert.assertArrayEquals(expected, result.toArray());
    }

    @Test
    public void putDateValid() throws Exception {
        client.arrays().putDateValid(Arrays.asList(
                new LocalDate(2000, 12, 1),
                new LocalDate(1980, 1, 2),
                new LocalDate(1492, 10, 12)
        ));
    }

    @Test
    public void getDateInvalidNull() throws Exception {
        try {
            List<LocalDate> result = client.arrays().getDateInvalidNull();
        } catch (ErrorException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getDateInvalidString() throws Exception {
        try {
            List<LocalDate> result = client.arrays().getDateInvalidChars();
        } catch (RuntimeException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("Invalid format: \"date\""));
        }
    }

    @Test
    public void getDateTimeValid() throws Exception {
        List<DateTime> result = client.arrays().getDateTimeValid();
        Object[] expected = new DateTime[] {
                new DateTime(2000, 12, 1, 0, 0, 1, DateTimeZone.UTC),
                new DateTime(1980, 1, 2, 0, 11, 35, DateTimeZone.UTC),
                new DateTime(1492, 10, 12, 10, 15, 1, DateTimeZone.UTC)
        };
        Assert.assertArrayEquals(expected, result.toArray());
    }

    @Test
    public void putDateTimeValid() throws Exception {
        client.arrays().putDateTimeValid(Arrays.asList(
                new DateTime(2000, 12, 1, 0, 0, 1, DateTimeZone.UTC),
                new DateTime(1980, 1, 2, 0, 11, 35, DateTimeZone.UTC),
                new DateTime(1492, 10, 12, 10, 15, 1, DateTimeZone.UTC)
        ));
    }

    @Test
    public void getDateTimeInvalidNull() throws Exception {
        try {
            List<DateTime> result = client.arrays().getDateTimeInvalidNull();
        } catch (ErrorException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getDateTimeInvalidString() throws Exception {
        try {
            List<DateTime> result = client.arrays().getDateTimeInvalidChars();
        } catch (RuntimeException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("Invalid format: \"date-time\""));
        }
    }

    @Test
    public void getDateTimeRfc1123Valid() throws Exception {
        List<DateTime> result = client.arrays().getDateTimeRfc1123Valid();
        Object[] expected = new DateTime[] {
                new DateTime(2000, 12, 1, 0, 0, 1, DateTimeZone.UTC),
                new DateTime(1980, 1, 2, 0, 11, 35, DateTimeZone.UTC),
                new DateTime(1492, 10, 12, 10, 15, 1, DateTimeZone.UTC)
        };
        Assert.assertArrayEquals(expected, result.toArray());
    }

    @Test
    public void putDateTimeRfc1123Valid() throws Exception {
        client.arrays().putDateTimeRfc1123Valid(Arrays.asList(
                new DateTime(2000, 12, 1, 0, 0, 1, DateTimeZone.UTC),
                new DateTime(1980, 1, 2, 0, 11, 35, DateTimeZone.UTC),
                new DateTime(1492, 10, 12, 10, 15, 1, DateTimeZone.UTC)
        ));
    }

    @Test
    public void getDurationValid() throws Exception {
        List<Period> result = client.arrays().getDurationValid();
        Object[] expected = new Period[] {
                new Period(0, 0, 0, 123, 22, 14, 12, 11),
                new Period(0, 0, 0, 5, 1, 0, 0, 0)
        };
        Assert.assertArrayEquals(expected, result.toArray());
    }

    @Test
    public void putDurationValid() throws Exception {
        client.arrays().putDurationValid(Arrays.asList(
                        new Period(0, 0, 0, 123, 22, 14, 12, 11),
                        new Period(0, 0, 0, 5, 1, 0, 0, 0)));
    }

    @Test
    public void getByteValid() throws Exception {
        List<byte[]> result = client.arrays().getByteValid();
        Object[] expected = new byte[][] {
                new byte[] {(byte) 0xFF, (byte) 0xFF, (byte) 0xFF, (byte) 0xFA},
                new byte[] {(byte) 0x01, (byte) 0x02, (byte) 0x03},
                new byte[] {(byte) 0x25, (byte) 0x29, (byte) 0x43}
        };
        Assert.assertArrayEquals(expected, result.toArray());
    }

    @Test
    public void putByteValid() throws Exception {
        client.arrays().putByteValid(Arrays.asList(
                new byte[] {(byte) 0xFF, (byte) 0xFF, (byte) 0xFF, (byte) 0xFA},
                new byte[] {(byte) 0x01, (byte) 0x02, (byte) 0x03},
                new byte[] {(byte) 0x25, (byte) 0x29, (byte) 0x43}
        ));
    }

    @Test
    public void getByteInvalidNull() throws Exception {
        try {
            List<byte[]> result = client.arrays().getByteInvalidNull();
        } catch (ErrorException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getBase64Url() throws Exception {
        List<byte[]> result = client.arrays().getBase64Url();
        Assert.assertEquals(3, result.size());
        Assert.assertEquals("a string that gets encoded with base64url", new String(result.get(0)));
        Assert.assertEquals("test string", new String(result.get(1)));
        Assert.assertEquals("Lorem ipsum", new String(result.get(2)));
    }

    @Test
    public void getComplexNull() throws Exception {
        try {
            List<Product> result = client.arrays().getComplexNull();
        } catch (ErrorException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getComplexEmpty() throws Exception {
        List<Product> result = client.arrays().getComplexEmpty();
        Assert.assertEquals(0, result.size());
    }

    @Test
    public void getComplexItemNull() throws Exception {
        List<Product> result = client.arrays().getComplexItemNull();
        Assert.assertEquals(3, result.size());
        Assert.assertNull(result.get(1));
    }

    @Test
    public void getComplexItemEmpty() throws Exception {
        List<Product> result = client.arrays().getComplexItemEmpty();
        Assert.assertEquals(3, result.size());
        Assert.assertNull(result.get(1).stringProperty());
    }

    @Test
    public void getComplexValid() throws Exception {
        List<Product> result = client.arrays().getComplexValid();
        Assert.assertEquals(3, result.size());
        Assert.assertEquals(5, result.get(2).integer().intValue());
        Assert.assertEquals("6", result.get(2).stringProperty());
    }

    @Test
    public void putComplexValid() throws Exception {
        List<Product> body = new ArrayList<Product>();
        Product p1 = new Product();
        p1.withInteger(1);
        p1.withStringProperty("2");
        body.add(p1);
        Product p2 = new Product();
        p2.withInteger(3);
        p2.withStringProperty("4");
        body.add(p2);
        Product p3 = new Product();
        p3.withInteger(5);
        p3.withStringProperty("6");
        body.add(p3);
        client.arrays().putComplexValid(body);
    }

    @Test
    public void getArrayNull() throws Exception {
        try {
            List<List<String>> result = client.arrays().getArrayNull();
        } catch (ErrorException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getArrayEmpty() throws Exception {
        List<List<String>> result = client.arrays().getArrayEmpty();
        Assert.assertEquals(0, result.size());
    }

    @Test
    public void getArrayItemNull() throws Exception {
        List<List<String>> result = client.arrays().getArrayItemNull();
        Assert.assertEquals(3, result.size());
        Assert.assertNull(result.get(1));
    }

    @Test
    public void getArrayItemEmpty() throws Exception {
        List<List<String>> result = client.arrays().getArrayItemEmpty();
        Assert.assertEquals(3, result.size());
        Assert.assertEquals(0, result.get(1).size());
    }

    @Test
    public void getArrayValid() throws Exception {
        List<List<String>> result = client.arrays().getArrayValid();
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
        client.arrays().putArrayValid(body);
    }

    @Test
    public void getDictionaryNull() throws Exception {
        try {
            List<Map<String, String>> result = client.arrays().getDictionaryNull();
        } catch (ErrorException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getDictionaryEmpty() throws Exception {
        List<Map<String, String>> result = client.arrays().getDictionaryEmpty();
        Assert.assertEquals(0, result.size());
    }

    @Test
    public void getDictionaryItemNull() throws Exception {
        List<Map<String, String>> result = client.arrays().getDictionaryItemNull();
        Assert.assertEquals(3, result.size());
        Assert.assertNull(result.get(1));
    }

    @Test
    public void getDictionaryItemEmpty() throws Exception {
        List<Map<String, String>> result = client.arrays().getDictionaryItemEmpty();
        Assert.assertEquals(3, result.size());
        Assert.assertEquals(0, result.get(1).size());
    }

    @Test
    public void getDictionaryValid() throws Exception {
        List<Map<String, String>> result = client.arrays().getDictionaryValid();
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
        client.arrays().putDictionaryValid(body);
    }
}
