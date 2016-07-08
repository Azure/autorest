package fixtures.url;

import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.util.ArrayList;
import java.util.List;

import fixtures.url.implementation.AutoRestUrlTestServiceImpl;
import fixtures.url.models.ErrorException;
import fixtures.url.models.UriColor;

public class QueriesTests {
    private static AutoRestUrlTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestUrlTestServiceImpl("http://localhost:3000");
    }

    @Test
    public void getBooleanTrue() throws Exception {
        client.queries().getBooleanTrue();
    }

    @Test
    public void getBooleanFalse() throws Exception {
        client.queries().getBooleanFalse();
    }

    @Test
    public void getBooleanNull() throws Exception {
        client.queries().getBooleanNull(null);
    }

    @Test
    public void getIntOneMillion() throws Exception {
        client.queries().getIntOneMillion();
    }

    @Test
    public void getIntNegativeOneMillion() throws Exception {
        client.queries().getIntNegativeOneMillion();
    }

    @Test
    public void getIntNull() throws Exception {
        client.queries().getIntNull(null);
    }

    @Test
    public void getTenBillion() throws Exception {
        client.queries().getTenBillion();
    }

    @Test
    public void getNegativeTenBillion() throws Exception {
        client.queries().getNegativeTenBillion();
    }

    @Test
    public void getLongNull() throws Exception {
        client.queries().getLongNull(null);
    }

    @Test
    public void floatScientificPositive() throws Exception {
        client.queries().floatScientificPositive();
    }

    @Test
    public void floatScientificNegative() throws Exception {
        client.queries().floatScientificNegative();
    }

    @Test
    public void floatNull() throws Exception {
        client.queries().floatNull(null);
    }

    @Test
    public void doubleDecimalPositive() throws Exception {
        client.queries().doubleDecimalPositive();
    }

    @Test
    public void doubleDecimalNegative() throws Exception {
        client.queries().doubleDecimalNegative();
    }

    @Test
    public void doubleNull() throws Exception {
        client.queries().doubleNull(null);
    }

    @Test
    public void stringUrlEncoded() throws Exception {
        client.queries().stringUrlEncoded();
    }

    @Test
    public void stringEmpty() throws Exception {
        client.queries().stringEmpty();
    }

    @Test
    public void stringNull() throws Exception {
        try {
            client.queries().stringNull(null);
        } catch (ErrorException ex) {
            Assert.assertTrue(ex.getMessage().contains("Parameter stringPath is required"));
        }
    }

    @Test
    public void enumValid() throws Exception {
        client.queries().enumValid(UriColor.GREEN_COLOR);
    }

    @Test
    public void enumNull() throws Exception {
        try {
            client.queries().enumNull(null);
        } catch (ErrorException ex) {
            Assert.assertTrue(ex.getMessage().contains("Parameter enumPath is required"));
        }
    }

    @Test
    public void byteMultiByte() throws Exception {
        client.queries().byteMultiByte("啊齄丂狛狜隣郎隣兀﨩".getBytes("UTF-8"));
    }

    @Test
    public void byteEmpty() throws Exception {
        client.queries().byteEmpty();
    }

    @Test
    public void byteNull() throws Exception {
        try {
            client.queries().byteNull(null);
        } catch (ErrorException ex) {
            Assert.assertTrue(ex.getMessage().contains("Parameter bytePath is required"));
        }
    }

    @Test
    public void dateValid() throws Exception {
        client.queries().dateValid();
    }

    @Test
    public void dateNull() throws Exception {
        try {
            client.queries().dateNull(null);
        } catch (ErrorException ex) {
            Assert.assertTrue(ex.getMessage().contains("Parameter datePath is required"));
        }
    }

    @Test
    public void dateTimeValid() throws Exception {
        client.queries().dateTimeValid();
    }

    @Test
    public void dateTimeNull() throws Exception {
        try {
            client.queries().dateTimeNull(null);
        } catch (ErrorException ex) {
            Assert.assertTrue(ex.getMessage().contains("Parameter dateTimePath is required"));
        }
    }

    @Test
    public void arrayStringCsvValid() throws Exception {
        List<String> query = new ArrayList<>();
        query.add("ArrayQuery1");
        query.add("begin!*'();:@ &=+$,/?#[]end");
        query.add(null);
        query.add("");
        client.queries().arrayStringCsvValid(query);
    }

    @Test
    public void arrayStringCsvNull() throws Exception {
        client.queries().arrayStringCsvNull(null);
    }

    @Test
    public void arrayStringCsvEmpty() throws Exception {
        client.queries().arrayStringCsvEmpty(new ArrayList<String>());
    }

    @Test
    public void arrayStringSsvValid() throws Exception {
        List<String> query = new ArrayList<>();
        query.add("ArrayQuery1");
        query.add("begin!*'();:@ &=+$,/?#[]end");
        query.add(null);
        query.add("");
        client.queries().arrayStringSsvValid(query);
    }

    @Test
    public void arrayStringTsvValid() throws Exception {
        List<String> query = new ArrayList<>();
        query.add("ArrayQuery1");
        query.add("begin!*'();:@ &=+$,/?#[]end");
        query.add(null);
        query.add("");
        client.queries().arrayStringTsvValid(query);
    }

    @Test
    public void arrayStringPipesValid() throws Exception {
        List<String> query = new ArrayList<>();
        query.add("ArrayQuery1");
        query.add("begin!*'();:@ &=+$,/?#[]end");
        query.add(null);
        query.add("");
        client.queries().arrayStringPipesValid(query);
    }
}
