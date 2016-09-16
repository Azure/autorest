package fixtures.bodycomplex;

import org.joda.time.DateTime;
import org.joda.time.DateTimeZone;
import org.joda.time.LocalDate;
import org.joda.time.Period;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import fixtures.bodycomplex.implementation.AutoRestComplexTestServiceImpl;
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
        IntWrapper result = client.primitives().getInt();
        Assert.assertEquals(Integer.valueOf(-1), result.field1());
        Assert.assertEquals(Integer.valueOf(2), result.field2());
    }

    @Test
    public void putInt() throws Exception {
        IntWrapper body = new IntWrapper();
        body.withField1(-1);
        body.withField2(2);
        client.primitives().putInt(body);
    }

    @Test
    public void getLong() throws Exception {
        LongWrapper result = client.primitives().getLong();
        Assert.assertEquals(Long.valueOf(1099511627775L), result.field1());
        Assert.assertEquals(Long.valueOf(-999511627788L), result.field2());
    }

    @Test
    public void putLong() throws Exception {
        LongWrapper body = new LongWrapper();
        body.withField1(1099511627775L);
        body.withField2(-999511627788L);
        client.primitives().putLong(body);
    }

    @Test
    public void getFloat() throws Exception {
        FloatWrapper result = client.primitives().getFloat();
        Assert.assertEquals(1.05, result.field1(), 0f);
        Assert.assertEquals(-0.003, result.field2(), 0f);
    }

    @Test
    public void putFloat() throws Exception {
        FloatWrapper body = new FloatWrapper();
        body.withField1(1.05);
        body.withField2(-0.003);
        client.primitives().putFloat(body);
    }

    @Test
    public void getDouble() throws Exception {
        DoubleWrapper result = client.primitives().getDouble();
        Assert.assertEquals(3e-100, result.field1(), 0f);
        Assert.assertEquals(-0.000000000000000000000000000000000000000000000000000000005,
                result.field56ZerosAfterTheDotAndNegativeZeroBeforeDotAndThisIsALongFieldNameOnPurpose(),
                0f);
    }

    @Test
    public void putDouble() throws Exception {
        DoubleWrapper body = new DoubleWrapper();
        body.withField1(3e-100);
        body.withField56ZerosAfterTheDotAndNegativeZeroBeforeDotAndThisIsALongFieldNameOnPurpose(-5e-57);
        client.primitives().putDouble(body);
    }

    @Test
    public void getBool() throws Exception {
        BooleanWrapper result = client.primitives().getBool();
        Assert.assertEquals(true, result.fieldTrue());
        Assert.assertEquals(false, result.fieldFalse());
    }

    @Test
    public void putBool() throws Exception {
        BooleanWrapper body = new BooleanWrapper();
        body.withFieldFalse(false);
        body.withFieldTrue(true);
        client.primitives().putBool(body);
    }

    @Test
    public void getString() throws Exception {
        StringWrapper result = client.primitives().getString();
        Assert.assertEquals("goodrequest", result.field());
        Assert.assertEquals("", result.empty());
        Assert.assertEquals(null, result.nullProperty());
    }

    @Test
    public void putString() throws Exception {
        StringWrapper body = new StringWrapper();
        body.withField("goodrequest");
        body.withEmpty("");
        client.primitives().putString(body);
    }

    @Test
    public void getDate() throws Exception {
        DateWrapper result = client.primitives().getDate();
        Assert.assertEquals(new LocalDate(1, 1, 1), result.field());
        Assert.assertEquals(new LocalDate(2016, 2, 29), result.leap());
    }

    @Test
    public void putDate() throws Exception {
        DateWrapper body = new DateWrapper();
        body.withField(new LocalDate(1, 1, 1));
        body.withLeap(new LocalDate(2016, 2, 29));
        client.primitives().putDate(body);
    }

    @Test
    public void getDateTime() throws Exception {
        DatetimeWrapper result = client.primitives().getDateTime();
        Assert.assertEquals(new DateTime(1, 1, 1, 0, 0, 0, DateTimeZone.UTC), result.field());
        Assert.assertEquals(new DateTime(2015, 5, 18, 18, 38, 0, DateTimeZone.UTC), result.now());
    }

    @Test
    public void putDateTime() throws Exception {
        DatetimeWrapper body = new DatetimeWrapper();
        body.withField(new DateTime(1, 1, 1, 0, 0, 0, DateTimeZone.UTC));
        body.withNow(new DateTime(2015, 5, 18, 18, 38, 0, DateTimeZone.UTC));
        client.primitives().putDateTime(body);
    }

    @Test
    public void getDateTimeRfc1123() throws Exception {
        Datetimerfc1123Wrapper result = client.primitives().getDateTimeRfc1123();
        Assert.assertEquals(new DateTime(1, 1, 1, 0, 0, 0, DateTimeZone.UTC), result.field());
        Assert.assertEquals(new DateTime(2015, 5, 18, 11, 38, 0, DateTimeZone.UTC), result.now());
    }

    @Test
    public void putDateTimeRfc1123() throws Exception {
        Datetimerfc1123Wrapper body = new Datetimerfc1123Wrapper();
        body.withField(new DateTime(1, 1, 1, 0, 0, 0, DateTimeZone.UTC));
        body.withNow(new DateTime(2015, 5, 18, 11, 38, 0, DateTimeZone.UTC));
        client.primitives().putDateTimeRfc1123(body);
    }

    @Test
    public void getDuration() throws Exception {
        DurationWrapper result = client.primitives().getDuration();
        Assert.assertEquals(new Period(0, 0, 0, 123, 22, 14, 12, 11), result.field());
    }

    @Test
    public void putDuration() throws Exception {
        DurationWrapper body = new DurationWrapper();
        body.withField(new Period(0, 0, 0, 123, 22, 14, 12, 11));
        client.primitives().putDuration(body);
    }

    @Test
    public void getByte() throws Exception {
        ByteWrapper result = client.primitives().getByte();
        byte[] expected = new byte[] {
                (byte) 255, (byte) 254, (byte) 253, (byte) 252, (byte) 0,
                (byte) 250, (byte) 249, (byte) 248, (byte) 247, (byte) 246
        };
        Assert.assertArrayEquals(expected, result.field());
    }

    @Test
    public void putByte() throws Exception {
        ByteWrapper body = new ByteWrapper();
        byte[] byteArray = new byte[] {
                (byte) 255, (byte) 254, (byte) 253, (byte) 252, (byte) 0,
                (byte) 250, (byte) 249, (byte) 248, (byte) 247, (byte) 246
        };
        body.withField(byteArray);
        client.primitives().putByte(body);
    }
}
