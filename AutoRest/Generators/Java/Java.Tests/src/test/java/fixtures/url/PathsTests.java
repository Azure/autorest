package fixtures.url;

import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import fixtures.url.models.UriColor;

public class PathsTests {
    private static AutoRestUrlTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestUrlTestServiceImpl("http://localhost:3000");
    }

    @Test
    public void getBooleanTrue() throws Exception {
        client.getPathsOperations().getBooleanTrue();
    }

    @Test
    public void getBooleanFalse() throws Exception {
        client.getPathsOperations().getBooleanFalse();
    }

    @Test
    public void getIntOneMillion() throws Exception {
        client.getPathsOperations().getIntOneMillion();
    }

    @Test
    public void getIntNegativeOneMillion() throws Exception {
        client.getPathsOperations().getIntNegativeOneMillion();
    }

    @Test
    public void getTenBillion() throws Exception {
        client.getPathsOperations().getTenBillion();
    }

    @Test
    public void getNegativeTenBillion() throws Exception {
        client.getPathsOperations().getNegativeTenBillion();
    }

    @Test
    public void floatScientificPositive() throws Exception {
        client.getPathsOperations().floatScientificPositive();
    }

    @Test
    public void floatScientificNegative() throws Exception {
        client.getPathsOperations().floatScientificNegative();
    }

    @Test
    public void doubleDecimalPositive() throws Exception {
        client.getPathsOperations().doubleDecimalPositive();
    }

    @Test
    public void doubleDecimalNegative() throws Exception {
        client.getPathsOperations().doubleDecimalNegative();
    }

    @Test
    public void stringUrlEncoded() throws Exception {
        client.getPathsOperations().stringUrlEncoded();
    }

    @Test
    public void stringEmpty() throws Exception {
        client.getPathsOperations().stringEmpty();
    }

    @Test
    public void stringNull() throws Exception {
        try {
            client.getPathsOperations().stringNull(null);
        } catch (IllegalArgumentException ex) {
            Assert.assertTrue(ex.getMessage().contains("Parameter stringPath is required"));
        }
    }

    @Test
    public void enumValid() throws Exception {
        client.getPathsOperations().enumValid(UriColor.GREEN_COLOR);
    }

    @Test
    public void enumNull() throws Exception {
        try {
            client.getPathsOperations().enumNull(null);
        } catch (IllegalArgumentException ex) {
            Assert.assertTrue(ex.getMessage().contains("Parameter enumPath is required"));
        }
    }

    @Test
    public void byteMultiByte() throws Exception {
        client.getPathsOperations().byteMultiByte("啊齄丂狛狜隣郎隣兀﨩".getBytes("UTF-8"));
    }

    @Test
    public void byteEmpty() throws Exception {
        client.getPathsOperations().byteEmpty();
    }

    @Test
    public void byteNull() throws Exception {
        try {
            client.getPathsOperations().byteNull(null);
        } catch (IllegalArgumentException ex) {
            Assert.assertTrue(ex.getMessage().contains("Parameter bytePath is required"));
        }
    }

    @Test
    public void dateValid() throws Exception {
        client.getPathsOperations().dateValid();
    }

    @Test
    public void dateNull() throws Exception {
        try {
            client.getPathsOperations().dateNull(null);
        } catch (IllegalArgumentException ex) {
            Assert.assertTrue(ex.getMessage().contains("Parameter datePath is required"));
        }
    }

    @Test
    public void dateTimeValid() throws Exception {
        client.getPathsOperations().dateTimeValid();
    }

    @Test
    public void dateTimeNull() throws Exception {
        try {
            client.getPathsOperations().dateTimeNull(null);
        } catch (IllegalArgumentException ex) {
            Assert.assertTrue(ex.getMessage().contains("Parameter dateTimePath is required"));
        }
    }
    /*
    @Test
    public void arrayCsvInPath() throws Exception {
        List<String> arrayPath = new ArrayList<>();
        arrayPath.add("ArrayPath1");
        arrayPath.add("begin!*'();:@ &=+$,/?#[]end");
        arrayPath.add(null);
        arrayPath.add("");
        client.getPathsOperations().arrayCsvInPath(arrayPath);
    }
    */
}
