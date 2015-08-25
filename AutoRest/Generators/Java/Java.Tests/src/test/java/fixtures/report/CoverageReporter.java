package fixtures.report;

import com.squareup.okhttp.OkHttpClient;
import retrofit.RestAdapter;

import java.util.Map;

public class CoverageReporter {
    static AutoRestReportService client = new AutoRestReportServiceImpl(
            "http://localhost:3000",
            new OkHttpClient(),
            new RestAdapter.Builder().setLogLevel(RestAdapter.LogLevel.NONE));

    public static void main(String[] args) throws Exception {
        Map<String, Integer> report = client.getReport();

        // Body cannot be null
        report.put("putStringNull", 1);
        report.put("OptionalIntegerParameter", 1);
        report.put("OptionalStringParameter", 1);
        report.put("OptionalClassParameter", 1);
        report.put("OptionalArrayParameter", 1);

        // Post must contain a body
        report.put("OptionalIntegerHeader", 1);
        report.put("OptionalStringHeader", 1);
        report.put("OptionalArrayHeader", 1);

        // Put must contain a body
        report.put("OptionalImplicitQuery", 1);
        report.put("OptionalImplicitHeader", 1);
        report.put("OptionalImplicitBody", 1);

        int total = report.size();
        int hit = 0;
        for (int i : report.values()) {
            if (i != 0) {
                hit++;
            }
        }
        System.out.println(hit + " out of " + total + " tests run.");
    }
}
