package fixtures.bodycomplex;

import fixtures.bodycomplex.models.*;
import org.joda.time.DateTime;
import org.joda.time.DateTimeZone;
import org.joda.time.LocalDate;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

public class PrimitiveTests {
    static AutoRestComplexTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestComplexTestServiceImpl("http://localhost.:3000");
    }

    @Test
    public void getInt() throws Exception {
        IntWrapper result = client.getPrimitive().getInt();
        Assert.assertEquals(Integer.valueOf(-1), result.getField1());
        Assert.assertEquals(Integer.valueOf(2), result.getField2());
    }

    @Test
    public void putInt() throws Exception {
        IntWrapper body = new IntWrapper();
        body.setField1(-1);
        body.setField2(2);
        client.getPrimitive().putInt(body);
    }

    @Test
    public void getLong() throws Exception {
        LongWrapper result = client.getPrimitive().getLong();
        Assert.assertEquals(Long.valueOf(1099511627775l), result.getField1());
        Assert.assertEquals(Long.valueOf(-999511627788l), result.getField2());
    }

    @Test
    public void putLong() throws Exception {
        LongWrapper body = new LongWrapper();
        body.setField1(1099511627775l);
        body.setField2(-999511627788l);
        client.getPrimitive().putLong(body);
    }

    @Test
    public void getFloat() throws Exception {
        FloatWrapper result = client.getPrimitive().getFloat();
        Assert.assertEquals(1.05, result.getField1(), 0f);
        Assert.assertEquals(-0.003, result.getField2(), 0f);
    }

    @Test
    public void putFloat() throws Exception {
        FloatWrapper body = new FloatWrapper();
        body.setField1(1.05);
        body.setField2(-0.003);
        client.getPrimitive().putFloat(body);
    }

    @Test
    public void getDouble() throws Exception {
        DoubleWrapper result = client.getPrimitive().getDouble();
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
        client.getPrimitive().putDouble(body);
    }

    @Test
    public void getBool() throws Exception {
        BooleanWrapper result = client.getPrimitive().getBool();
        Assert.assertEquals(true, result.getFieldTrue());
        Assert.assertEquals(false, result.getFieldFalse());
    }

    @Test
    public void putBool() throws Exception {
        BooleanWrapper body = new BooleanWrapper();
        body.setFieldFalse(false);
        body.setFieldTrue(true);
        client.getPrimitive().putBool(body);
    }

    @Test
    public void getString() throws Exception {
        StringWrapper result = client.getPrimitive().getString();
        Assert.assertEquals("goodrequest", result.getField());
        Assert.assertEquals("", result.getEmpty());
        Assert.assertEquals(null, result.getNullProperty());
    }

    @Test
    public void putString() throws Exception {
        StringWrapper body = new StringWrapper();
        body.setField("goodrequest");
        body.setEmpty("");
        client.getPrimitive().putString(body);
    }

    @Test
    public void getDate() throws Exception {
        DateWrapper result = client.getPrimitive().getDate();
        Assert.assertEquals(new LocalDate(1, 1, 1), result.getField());
        Assert.assertEquals(new LocalDate(2016, 2, 29), result.getLeap());
    }

    @Test
    public void putDate() throws Exception {
        DateWrapper body = new DateWrapper();
        body.setField(new LocalDate(1, 1, 1));
        body.setLeap(new LocalDate(2016, 2, 29));
        client.getPrimitive().putDate(body);
    }

    @Test
    public void getDateTime() throws Exception {
        DatetimeWrapper result = client.getPrimitive().getDateTime();
        Assert.assertEquals(new DateTime(1, 1, 1, 0, 0, 0, DateTimeZone.UTC), result.getField());
        Assert.assertEquals(new DateTime(2015, 5, 18, 18, 38, 0, DateTimeZone.UTC), result.getNow());
    }

    @Test
    public void putDateTime() throws Exception {
        DatetimeWrapper body = new DatetimeWrapper();
        body.setField(new DateTime(1, 1, 1, 0, 0, 0, DateTimeZone.UTC));
        body.setNow(new DateTime(2015, 5, 18, 18, 38, 0, DateTimeZone.UTC));
        client.getPrimitive().putDateTime(body);
    }

    @Test
    public void getByte() throws Exception {
        ByteWrapper result = client.getPrimitive().getByte();
        byte[] expected = new byte[] {
                (byte)255, (byte)254, (byte)253, (byte)252, (byte)0,
                (byte)250, (byte)249, (byte)248, (byte)247, (byte)246
        };
        Assert.assertArrayEquals(expected, result.getField());
    }

    @Test
    public void putByte() throws Exception {
        ByteWrapper body = new ByteWrapper();
        byte[] byteArray = new byte[] {
                (byte)255, (byte)254, (byte)253, (byte)252, (byte)0,
                (byte)250, (byte)249, (byte)248, (byte)247, (byte)246
        };
        body.setField(byteArray);
        client.getPrimitive().putByte(body);
    }
}
