package aap;

import com.intuit.karate.cucumber.CucumberRunner;
import com.intuit.karate.cucumber.KarateStats;
import cucumber.api.CucumberOptions;
import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;
import org.apache.commons.io.FileUtils;
import org.junit.Assert;
import org.junit.Test;

import java.io.File;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import static org.hamcrest.CoreMatchers.is;

// important: do not use @RunWith(Karate.class) ! Because we are using CucumberRunner below
@CucumberOptions(tags = {"~@Ignore", "~@WIP"})
public class AAPTest {

    @Test
    public void testParallel() {
        String karateOutputPath = "build/test-results/surefire-reports";
        KarateStats stats = CucumberRunner.parallel(getClass(), 5, karateOutputPath);
        generateReport(karateOutputPath);
        Assert.assertThat("There are scenario failures", stats.getFailCount(), is(0));
    }

    private static void generateReport(String karateOutputPath) {
        Collection<File> jsonFiles = FileUtils.listFiles(new File(karateOutputPath), new String[] {"json"}, true);
        List<String> jsonPaths = new ArrayList(jsonFiles.size());
        jsonFiles.forEach(file -> jsonPaths.add(file.getAbsolutePath()));
        Configuration config = new Configuration(new File("build/reports"), "aap");
        ReportBuilder reportBuilder = new ReportBuilder(jsonPaths, config);
        reportBuilder.generateReports();
    }

}
