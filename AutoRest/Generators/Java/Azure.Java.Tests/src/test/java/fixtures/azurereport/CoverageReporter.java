package fixtures.azurereport;

import com.squareup.okhttp.OkHttpClient;
import retrofit.RestAdapter;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class CoverageReporter {
    static AutoRestReportServiceForAzure client = new AutoRestReportServiceForAzureImpl(
            "http://localhost:3000",
            new OkHttpClient(),
            new RestAdapter.Builder().setLogLevel(RestAdapter.LogLevel.NONE));

    public static void main(String[] args) throws Exception {
        Map<String, Integer> report = client.getReport();

        int total = report.size();
        int hit = 0;
        List<String> missing = new ArrayList<>();
        for (Map.Entry<String, Integer> entry : report.entrySet()) {
            if (entry.getValue() != 0) {
                hit++;
            } else {
                missing.add(entry.getKey());
            }
        }
        System.out.println(hit + " out of " + total + " tests hit. Missing tests:");
        for (String scenario : missing) {
            System.out.println(scenario);
        }
    }
}
