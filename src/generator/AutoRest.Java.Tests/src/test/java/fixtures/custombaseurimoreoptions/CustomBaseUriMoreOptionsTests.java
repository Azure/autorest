package fixtures.custombaseurimoreoptions;

import org.junit.BeforeClass;
import org.junit.Test;

import fixtures.custombaseurimoreoptions.implementation.AutoRestParameterizedCustomHostTestClientImpl;
import okhttp3.OkHttpClient;
import okhttp3.logging.HttpLoggingInterceptor;
import retrofit2.Retrofit;

public class CustomBaseUriMoreOptionsTests {
    private static AutoRestParameterizedCustomHostTestClient client;

    @BeforeClass
    public static void setup() {
        OkHttpClient.Builder clientBuilder = new OkHttpClient.Builder()
                .addInterceptor(new HttpLoggingInterceptor().setLevel(HttpLoggingInterceptor.Level.BODY));
        client = new AutoRestParameterizedCustomHostTestClientImpl(clientBuilder, new Retrofit.Builder());
        client.withSubscriptionId("test12");
    }

    // Positive test case
    @Test
    public void getEmpty() throws Exception {
        client.withDnsSuffix("host:3000");
        client.paths().getEmpty("http://lo", "cal", "key1", "v1");
    }
}
