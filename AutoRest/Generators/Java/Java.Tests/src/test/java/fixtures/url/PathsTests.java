package fixtures.url;

import com.microsoft.rest.ServiceException;
import fixtures.url.models.UriColor;
import org.apache.commons.codec.binary.Base64;
import org.joda.time.DateTime;
import org.joda.time.DateTimeZone;
import org.joda.time.LocalDate;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

public class PathsTests {
    static AutoRestUrlTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestUrlTestServiceImpl("http://localhost.:3000");
    }

    @Test
    public void getBooleanTrue() throws Exception {
        client.getPaths().getBooleanTrue(true);
    }

    @Test
    public void getBooleanFalse() throws Exception {
        client.getPaths().getBooleanFalse(false);
    }

    @Test
    public void getIntOneMillion() throws Exception {
        client.getPaths().getIntOneMillion(1000000);
    }

    @Test
    public void getIntNegativeOneMillion() throws Exception {
        client.getPaths().getIntNegativeOneMillion(-1000000);
    }

    @Test
    public void getTenBillion() throws Exception {
        client.getPaths().getTenBillion(10000000000l);
    }

    @Test
    public void getNegativeTenBillion() throws Exception {
        client.getPaths().getNegativeTenBillion(-10000000000l);
    }

    @Test
    public void floatScientificPositive() throws Exception {
        client.getPaths().floatScientificPositive(1.034E+20);
    }

    @Test
    public void floatScientificNegative() throws Exception {
        client.getPaths().floatScientificNegative(-1.034E-20);
    }

    @Test
    public void doubleDecimalPositive() throws Exception {
        client.getPaths().doubleDecimalPositive(9999999.999);
    }

    @Test
    public void doubleDecimalNegative() throws Exception {
        client.getPaths().doubleDecimalNegative(-9999999.999);
    }

    @Test
    public void stringUrlEncoded() throws Exception {
        client.getPaths().stringUrlEncoded("begin!*'();:@ &=+$,/?#[]end");
    }

    @Test
    public void stringEmpty() throws Exception {
        client.getPaths().stringEmpty("");
    }

    @Test
    public void stringNull() throws Exception {
        try {
            client.getPaths().stringNull(null);
        } catch (ServiceException ex) {
            Assert.assertTrue(ex.getMessage().contains("Parameter stringPath is required"));
        }
    }

    @Test
    public void enumValid() throws Exception {
        client.getPaths().enumValid(UriColor.GREEN_COLOR);
    }

    @Test
    public void enumNull() throws Exception {
        try {
            client.getPaths().enumNull(null);
        } catch (ServiceException ex) {
            Assert.assertTrue(ex.getMessage().contains("Parameter enumPath is required"));
        }
    }

    @Test
    public void byteMultiByte() throws Exception {
        client.getPaths().byteMultiByte("啊齄丂狛狜隣郎隣兀﨩".getBytes("UTF-8"));
    }

    @Test
    public void byteEmpty() throws Exception {
        client.getPaths().byteEmpty("".getBytes("UTF-8"));
    }

    @Test
    public void byteNull() throws Exception {
        try {
            client.getPaths().byteNull(null);
        } catch (ServiceException ex) {
            Assert.assertTrue(ex.getMessage().contains("Parameter bytePath is required"));
        }
    }

    @Test
    public void dateValid() throws Exception {
        client.getPaths().dateValid(new LocalDate(2012, 1, 1));
    }

    @Test
    public void dateNull() throws Exception {
        try {
            client.getPaths().dateNull(null);
        } catch (ServiceException ex) {
            Assert.assertTrue(ex.getMessage().contains("Parameter datePath is required"));
        }
    }

    @Test
    public void dateTimeValid() throws Exception {
        client.getPaths().dateTimeValid(new DateTime(2012, 1, 1, 1, 1, 1, DateTimeZone.UTC));
    }

    @Test
    public void dateTimeNull() throws Exception {
        try {
            client.getPaths().dateTimeNull(null);
        } catch (ServiceException ex) {
            Assert.assertTrue(ex.getMessage().contains("Parameter dateTimePath is required"));
        }
    }
}
