package fixtures.bodycomplex;

import org.joda.time.DateTime;
import org.joda.time.DateTimeZone;
import org.joda.time.LocalDate;
import org.joda.time.Period;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import fixtures.bodycomplex.models.BooleanWrapper;
import fixtures.bodycomplex.models.ByteWrapper;
import fixtures.bodycomplex.models.DateWrapper;
import fixtures.bodycomplex.models.DatetimeWrapper;
import fixtures.bodycomplex.models.Datetimerfc1123Wrapper;
import fixtures.bodycomplex.models.DoubleWrapper;
import fixtures.bodycomplex.models.DurationWrapper;
import fixtures.bodycomplex.models.FloatWrapper;
import fixtures.bodycomplex.models.IntWrapper;
import fixtures.bodycomplex.models.LongWrapper;
import fixtures.bodycomplex.models.StringWrapper;

public class PrimitiveTests {
    private static AutoRestComplexTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestComplexTestServiceImpl("http://localhost:3000");
    }

    @Test
    public void getInt() throws Exception {
        IntWrapper result = client.getPrimitiveOperations().getInt().getBody();
        Assert.assertEquals(Integer.valueOf(-1), result.getField1());
        Assert.assertEquals(Integer.valueOf(2), result.getField2());
    }

    @Test
    public void putInt() throws Exception {
        IntWrapper body = new IntWrapper();
        body.setField1(-1);
        body.setField2(2);
        client.getPrimitiveOperations().putInt(body);
    }

    @Test
    public void getLong() throws Exception {
        LongWrapper result = client.getPrimitiveOperations().getLong().getBody();
        Assert.assertEquals(Long.valueOf(1099511627775L), result.getField1());
        Assert.assertEquals(Long.valueOf(-999511627788L), result.getField2());
    }

    @Test
    public void putLong() throws Exception {
        LongWrapper body = new LongWrapper();
        body.setField1(1099511627775L);
        body.setField2(-999511627788L);
        client.getPrimitiveOperations().putLong(body);
    }

    @Test
    public void getFloat() throws Exception {
        FloatWrapper result = client.getPrimitiveOperations().getFloat().getBody();
        Assert.assertEquals(1.05, result.getField1(), 0f);
        Assert.assertEquals(-0.003, result.getField2(), 0f);
    }

    @Test
    public void putFloat() throws Exception {
        FloatWrapper body = new FloatWrapper();
        body.setField1(1.05);
        body.setField2(-0.003);
        client.getPrimitiveOperations().putFloat(body);
    }

    @Test
    public void getDouble() throws Exception {
        DoubleWrapper result = client.getPrimitiveOperations().getDouble().getBody();
        Assert.assertEquals(3e-100, result.getField1(), 0f);
        Assert.assertEquals(-0.000000000000000000000000000000000000000000000000000000005,
                result.getField56ZerosAfterTheDotAndNegativeZeroBeforeDotAndThisIsALongFieldNameOnPurpose(),
                0f);
    }

    @Test
    public void putDouble() throws Exception {
        DoubleWrapper body = new DoubleWrapper();
        body.setField1(3e-100);
        body.setField56ZerosAfterTheDotAndNegativeZeroBeforeDotAndThisIsALongFieldNameOnPurpose(-5e-57);
        client.getPrimitiveOperations().putDouble(body);
    }

    @Test
    public void getBool() throws Exception {
        BooleanWrapper result = client.getPrimitiveOperations().getBool().getBody();
        Assert.assertEquals(true, result.getFieldTrue());
        Assert.assertEquals(false, result.getFieldFalse());
    }

    @Test
    public void putBool() throws Exception {
        BooleanWrapper body = new BooleanWrapper();
        body.setFieldFalse(false);
        body.setFieldTrue(true);
        client.getPrimitiveOperations().putBool(body);
    }

    @Test
    public void getString() throws Exception {
        StringWrapper result = client.getPrimitiveOperations().getString().getBody();
        Assert.assertEquals("goodrequest", result.getField());
        Assert.assertEquals("", result.getEmpty());
        Assert.assertEquals(null, result.getNullProperty());
    }

    @Test
    public void putString() throws Exception {
        StringWrapper body = new StringWrapper();
        body.setField("goodrequest");
        body.setEmpty("");
        client.getPrimitiveOperations().putString(body);
    }

    @Test
    public void getDate() throws Exception {
        DateWrapper result = client.getPrimitiveOperations().getDate().getBody();
        Assert.assertEquals(new LocalDate(1, 1, 1), result.getField());
        Assert.assertEquals(new LocalDate(2016, 2, 29), result.getLeap());
    }

    @Test
    public void putDate() throws Exception {
        DateWrapper body = new DateWrapper();
        body.setField(new LocalDate(1, 1, 1));
        body.setLeap(new LocalDate(2016, 2, 29));
        client.getPrimitiveOperations().putDate(body);
    }

    @Test
    public void getDateTime() throws Exception {
        DatetimeWrapper result = client.getPrimitiveOperations().getDateTime().getBody();
        Assert.assertEquals(new DateTime(1, 1, 1, 0, 0, 0, DateTimeZone.UTC), result.getField());
        Assert.assertEquals(new DateTime(2015, 5, 18, 18, 38, 0, DateTimeZone.UTC), result.getNow());
    }

    @Test
    public void putDateTime() throws Exception {
        DatetimeWrapper body = new DatetimeWrapper();
        body.setField(new DateTime(1, 1, 1, 0, 0, 0, DateTimeZone.UTC));
        body.setNow(new DateTime(2015, 5, 18, 18, 38, 0, DateTimeZone.UTC));
        client.getPrimitiveOperations().putDateTime(body);
    }

    @Test
    public void getDateTimeRfc1123() throws Exception {
        Datetimerfc1123Wrapper result = client.getPrimitiveOperations().getDateTimeRfc1123().getBody();
        Assert.assertEquals(new DateTime(1, 1, 1, 0, 0, 0, DateTimeZone.UTC), result.getField());
        Assert.assertEquals(new DateTime(2015, 5, 18, 11, 38, 0, DateTimeZone.UTC), result.getNow());
    }

    @Test
    public void putDateTimeRfc1123() throws Exception {
        Datetimerfc1123Wrapper body = new Datetimerfc1123Wrapper();
        body.setField(new DateTime(1, 1, 1, 0, 0, 0, DateTimeZone.UTC));
        body.setNow(new DateTime(2015, 5, 18, 11, 38, 0, DateTimeZone.UTC));
        client.getPrimitiveOperations().putDateTimeRfc1123(body);
    }

    @Test
    public void getDuration() throws Exception {
        DurationWrapper result = client.getPrimitiveOperations().getDuration().getBody();
        Assert.assertEquals(new Period(0, 0, 0, 123, 22, 14, 12, 11), result.getField());
    }

    @Test
    public void putDuration() throws Exception {
        DurationWrapper body = new DurationWrapper();
        body.setField(new Period(0, 0, 0, 123, 22, 14, 12, 11));
        client.getPrimitiveOperations().putDuration(body);
    }

    @Test
    public void getByte() throws Exception {
        ByteWrapper result = client.getPrimitiveOperations().getByte().getBody();
        byte[] expected = new byte[] {
                (byte) 255, (byte) 254, (byte) 253, (byte) 252, (byte) 0,
                (byte) 250, (byte) 249, (byte) 248, (byte) 247, (byte) 246
        };
        Assert.assertArrayEquals(expected, result.getField());
    }

    @Test
    public void putByte() throws Exception {
        ByteWrapper body = new ByteWrapper();
        byte[] byteArray = new byte[] {
                (byte) 255, (byte) 254, (byte) 253, (byte) 252, (byte) 0,
                (byte) 250, (byte) 249, (byte) 248, (byte) 247, (byte) 246
        };
        body.setField(byteArray);
        client.getPrimitiveOperations().putByte(body);
    }
}
