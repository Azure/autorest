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

public class DictionaryTests {
    static AutoRestSwaggerBATdictionaryService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestSwaggerBATdictionaryServiceImpl("http://localhost.:3000");
    }

    @Test
    public void getNull() throws Exception {
        try {
            client.getDictionary().getNull();
            Assert.assertTrue(false);
        } catch (ServiceException exception) {
            // expected
            Assert.assertTrue(exception.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getInvalid() throws Exception {
        try {
            client.getDictionary().getInvalid();
            Assert.assertTrue(false);
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
        try {
            Map<String, Boolean> result = client.getDictionary().getBooleanInvalidNull();
        } catch (ServiceException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
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
        try {
            Map<String, Integer> result = client.getDictionary().getIntInvalidNull();
        } catch (ServiceException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getIntInvalidString() throws Exception {
        try {
            Map<String, Integer> result = client.getDictionary().getIntInvalidString();
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
        try {
            Map<String, Long> result = client.getDictionary().getLongInvalidNull();
        } catch (ServiceException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getLongInvalidString() throws Exception {
        try {
            Map<String, Long> result = client.getDictionary().getLongInvalidString();
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
        expected.put("2", 1.2e20d);
        Assert.assertEquals(expected, result);
    }

    @Test
    public void putFloatValid() throws Exception {
        Map<String, Double> testdata = new HashMap<String, Double>();
        testdata.put("0", 0d);
        testdata.put("1", -0.01d);
        testdata.put("2", 1.2e20d);
        client.getDictionary().putFloatValid(testdata);
    }

    @Test
    public void getFloatInvalidNull() throws Exception {
        try {
            Map<String, Double> result = client.getDictionary().getFloatInvalidNull();
        } catch (ServiceException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getFloatInvalidString() throws Exception {
        try {
            Map<String, Double> result = client.getDictionary().getFloatInvalidString();
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
        expected.put("2", 1.2e20d);
        Assert.assertEquals(expected, result);
    }

    @Test
    public void putDoubleValid() throws Exception {
        //{"0": 0, "1": -0.01, "2": 1.2e20}
        Map<String, Double> testdata = new HashMap<String, Double>();
        testdata.put("0", 0d);
        testdata.put("1", -0.01d);
        testdata.put("2", 1.2e20d);
        client.getDictionary().putDoubleValid(testdata);
    }

    @Test
    public void getDoubleInvalidNull() throws Exception {
        try {
            Map<String, Double> result = client.getDictionary().getDoubleInvalidNull();
        } catch (ServiceException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getDoubleInvalidString() throws Exception {
        try {
            Map<String, Double> result = client.getDictionary().getDoubleInvalidString();
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
        try {
            Map<String, String> result = client.getDictionary().getStringWithNull();
        } catch (ServiceException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getStringWithInvalid() throws Exception {
        try {
            Map<String, String> result = client.getDictionary().getStringWithInvalid();
        } catch (ServiceException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("InvalidFormatException"));
        }
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
        try {
            Map<String, LocalDate> result = client.getDictionary().getDateInvalidNull();
        } catch (ServiceException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getDateInvalidString() throws Exception {
        try {
            Map<String, LocalDate> result = client.getDictionary().getDateInvalidChars();
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
        expected.put("1", new DateTime(1980, 1, 2, 0, 11, 35, DateTimeZone.UTC));
        expected.put("2", new DateTime(1492, 10, 12, 10, 15, 1, DateTimeZone.UTC));
        Assert.assertEquals(expected, result);
    }

    @Test
    public void putDateTimeValid() throws Exception {
        Map<String, DateTime> testdata = new HashMap<String, DateTime>();
        testdata.put("0", new DateTime(2000, 12, 1, 0, 0, 1, DateTimeZone.UTC));
        testdata.put("1", new DateTime(1980, 1, 2, 0, 11, 35, DateTimeZone.UTC));
        testdata.put("2", new DateTime(1492, 10, 12, 10, 15, 1, DateTimeZone.UTC));
        client.getDictionary().putDateTimeValid(testdata);
    }

    @Test
    public void getDateTimeInvalidNull() throws Exception {
        try {
            Map<String, DateTime> result = client.getDictionary().getDateTimeInvalidNull();
        } catch (ServiceException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getDateTimeInvalidString() throws Exception {
        try {
            Map<String, DateTime> result = client.getDictionary().getDateTimeInvalidChars();
        } catch (ServiceException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getByteValid() throws Exception {
        Map<String, Byte[]> result = client.getDictionary().getByteValid();
        Map<String, Byte[]> expected = new HashMap<String, Byte[]>();
        expected.put("0", new Byte[] {(byte)0xFF, (byte)0xFF, (byte)0xFF, (byte)0xFA});
        expected.put("1", new Byte[] {(byte)0x01, (byte)0x02, (byte)0x03});
        expected.put("2", new Byte[] {(byte)0x25, (byte)0x29, (byte)0x43});
        Assert.assertEquals(expected, result);
    }

    @Test
    public void putByteValid() throws Exception {
        Map<String, Byte[]> testdata = new HashMap<String, Byte[]>();
        testdata.put("0", new Byte[]{(byte) 0xFF, (byte) 0xFF, (byte) 0xFF, (byte) 0xFA});
        testdata.put("1", new Byte[]{(byte) 0x01, (byte) 0x02, (byte) 0x03});
        testdata.put("2", new Byte[]{(byte) 0x25, (byte) 0x29, (byte) 0x43});
        client.getDictionary().putByteValid(testdata);
    }

    @Test
    public void getByteInvalidNull() throws Exception {
        try {
            Map<String, Byte[]> result = client.getDictionary().getByteInvalidNull();
        } catch (ServiceException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }

    @Test
    public void getComplexNull() throws Exception {
        try {
            Map<String, Widget> result = client.getDictionary().getComplexNull();
        } catch (ServiceException ex) {
            // expected
            Assert.assertTrue(ex.getMessage().contains("JsonMappingException"));
        }
    }
}
