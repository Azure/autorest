package fixtures.bodyformdata;

import org.apache.commons.io.IOUtils;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.concurrent.TimeUnit;

import okhttp3.OkHttpClient;
import okhttp3.logging.HttpLoggingInterceptor;
import retrofit2.Retrofit;

public class FormdataTests {
    private static AutoRestSwaggerBATFormDataService client;

    @BeforeClass
    public static void setup() {
        OkHttpClient.Builder builder = new OkHttpClient.Builder().connectTimeout(1, TimeUnit.MINUTES).readTimeout(1, TimeUnit.MINUTES).writeTimeout(1, TimeUnit.MINUTES);
        client = new AutoRestSwaggerBATFormDataServiceImpl("http://localhost.:3000");
    }

    @Test
    public void uploadFile() throws Exception {
        String testString = "Upload file test case";
        InputStream result = client.getFormdataOperations().uploadFile(testString.getBytes("UTF-8"), "UploadFile.txt").getBody();
        Assert.assertEquals(testString, IOUtils.toString(result));
    }

    @Test
    public void uploadFileViaBody() throws Exception {
        File file = new File("E:\\pycharm-community-4.5.4.exe");
        InputStream result = client.getFormdataOperations().uploadFileViaBody(file).getBody();
        result.close();
    }
}
