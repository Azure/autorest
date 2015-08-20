package fixtures.bodyarray;

import com.microsoft.rest.ServiceCallback;
import com.microsoft.rest.ServiceException;
import fixtures.bodyarray.models.Product;
import fixtures.bodyboolean.AutoRestBoolTestService;
import fixtures.bodyboolean.AutoRestBoolTestServiceImpl;
import fixtures.bodyboolean.Bool;
import org.joda.time.DateTime;
import org.joda.time.DateTimeZone;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import org.joda.time.LocalDate;

import java.sql.Time;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.TimeZone;
import org.apache.commons.codec.binary.Base64;

public class ArrayTests {
    static AutoRestSwaggerBATArrayService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestSwaggerBATArrayServiceImpl("http://localhost.:3000");
    }

    @Test
    public void getNull() throws Exception {
        try {
            client.getArray().getNull();
            Assert.assertTrue(false);
        } catch (ServiceException exception) {
            // expected
            Assert.assertTrue(exception.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getInvalid() throws Exception {
        try {
            client.getArray().getInvalid();
            Assert.assertTrue(false);
        } catch (ServiceException exception) {
            // expected
            Assert.assertTrue(exception.getMessage().contains("JsonParseException"));
        }
    }

    @Test
    public void getEmpty() throws Exception {
        List<Integer> result = client.getArray().getEmpty();
        Assert.assertEquals(0, result.size());
    }

    @Test
    public void putEmpty() throws Exception {
        client.getArray().putEmpty(new ArrayList<String>());
    }

    @Test
    public void getBooleanTfft() throws Exception {
        List<Boolean> result = client.getArray().getBooleanTfft();
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
            List<Boolean> result = client.getArray().getBooleanInvalidNull();
        } catch (ServiceException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getBooleanInvalidString() throws Exception {
        try {
            List<Boolean> result = client.getArray().getBooleanInvalidString();
        } catch (ServiceException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("InvalidFormatException"));
        }
    }

    @Test
    public void getIntegerValid() throws Exception {
        List<Integer> result = client.getArray().getIntegerValid();
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
            List<Integer> result = client.getArray().getIntInvalidNull();
        } catch (ServiceException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getIntInvalidString() throws Exception {
        try {
            List<Integer> result = client.getArray().getIntInvalidString();
        } catch (ServiceException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("InvalidFormatException"));
        }
    }

    @Test
    public void getLongValid() throws Exception {
        List<Long> result = client.getArray().getLongValid();
        Object[] expected = new Long[] {1l, -1l, 3l, 300l};
        Assert.assertArrayEquals(expected, result.toArray());
    }

    @Test
    public void putLongValid() throws Exception {
        client.getArray().putLongValid(Arrays.asList(1l, -1l, 3l, 300l));
    }

    @Test
    public void getLongInvalidNull() throws Exception {
        try {
            List<Long> result = client.getArray().getLongInvalidNull();
        } catch (ServiceException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getLongInvalidString() throws Exception {
        try {
            List<Long> result = client.getArray().getLongInvalidString();
        } catch (ServiceException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("InvalidFormatException"));
        }
    }

    @Test
    public void getFloatValid() throws Exception {
        List<Double> result = client.getArray().getFloatValid();
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
            List<Double> result = client.getArray().getFloatInvalidNull();
        } catch (ServiceException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getFloatInvalidString() throws Exception {
        try {
            List<Double> result = client.getArray().getFloatInvalidString();
        } catch (ServiceException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("InvalidFormatException"));
        }
    }

    @Test
    public void getDoubleValid() throws Exception {
        List<Double> result = client.getArray().getDoubleValid();
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
            List<Double> result = client.getArray().getDoubleInvalidNull();
        } catch (ServiceException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getDoubleInvalidString() throws Exception {
        try {
            List<Double> result = client.getArray().getDoubleInvalidString();
        } catch (ServiceException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("InvalidFormatException"));
        }
    }

    @Test
    public void getStringValid() throws Exception {
        List<String> result = client.getArray().getStringValid();
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
            List<String> result = client.getArray().getStringWithNull();
        } catch (ServiceException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getStringWithInvalid() throws Exception {
        try {
            List<String> result = client.getArray().getStringWithInvalid();
        } catch (ServiceException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("InvalidFormatException"));
        }
    }

    @Test
    public void getDateValid() throws Exception {
        List<LocalDate> result = client.getArray().getDateValid();
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
            List<LocalDate> result = client.getArray().getDateInvalidNull();
        } catch (ServiceException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getDateInvalidString() throws Exception {
        try {
            List<LocalDate> result = client.getArray().getDateInvalidChars();
        } catch (ServiceException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getDateTimeValid() throws Exception {
        List<DateTime> result = client.getArray().getDateTimeValid();
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
            List<DateTime> result = client.getArray().getDateTimeInvalidNull();
        } catch (ServiceException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getDateTimeInvalidString() throws Exception {
        try {
            List<DateTime> result = client.getArray().getDateTimeInvalidChars();
        } catch (ServiceException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getByteValid() throws Exception {
        List<Byte[]> result = client.getArray().getByteValid();
        Object[] expected = new Byte[][] {
                new Byte[] {(byte)0xFF, (byte)0xFF, (byte)0xFF, (byte)0xFA},
                new Byte[] {(byte)0x01, (byte)0x02, (byte)0x03},
                new Byte[] {(byte)0x25, (byte)0x29, (byte)0x43}
        };
        Assert.assertArrayEquals(expected, result.toArray());
    }

    @Test
    public void putByteValid() throws Exception {
        client.getArray().putByteValid(Arrays.asList(
                new Byte[] {(byte)0xFF, (byte)0xFF, (byte)0xFF, (byte)0xFA},
                new Byte[] {(byte)0x01, (byte)0x02, (byte)0x03},
                new Byte[] {(byte)0x25, (byte)0x29, (byte)0x43}
        ));
    }

    @Test
    public void getByteInvalidNull() throws Exception {
        try {
            List<Byte[]> result = client.getArray().getByteInvalidNull();
        } catch (ServiceException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getComplexNull() throws Exception {
        try {
            List<Product> result = client.getArray().getComplexNull();
        } catch (ServiceException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }
}
