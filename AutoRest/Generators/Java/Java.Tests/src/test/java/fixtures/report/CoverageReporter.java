package fixtures.report;

import org.junit.Assert;

import java.util.Map;

public class CoverageReporter {
    static AutoRestReportService client = new AutoRestReportServiceImpl("http://localhost:3000");

    public static void main(String[] args) throws Exception {
        Map<String, Integer> report = client.getReport();
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
