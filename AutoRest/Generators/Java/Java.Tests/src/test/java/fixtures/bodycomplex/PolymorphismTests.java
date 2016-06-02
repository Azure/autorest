package fixtures.bodycomplex;

import okhttp3.logging.HttpLoggingInterceptor;
import fixtures.bodycomplex.models.Fish;
import fixtures.bodycomplex.models.Goblinshark;
import fixtures.bodycomplex.models.Salmon;
import fixtures.bodycomplex.models.Sawshark;
import fixtures.bodycomplex.models.Shark;
import org.joda.time.DateTime;
import org.joda.time.DateTimeZone;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.util.ArrayList;

public class PolymorphismTests {
    private static AutoRestComplexTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestComplexTestServiceImpl("http://localhost:3000");
        client.setLogLevel(HttpLoggingInterceptor.Level.BODY);
    }

    @Test
    public void getValid() throws Exception {
        Fish result = client.getPolymorphismOperations().getValid().getBody();
        Assert.assertEquals(Salmon.class, result.getClass());
        Salmon salmon = (Salmon) result;
        Assert.assertEquals("alaska", salmon.getLocation());
        Assert.assertEquals(1.0, salmon.getLength(), 0f);
        Assert.assertEquals(3, salmon.getSiblings().size());
        Assert.assertEquals(Shark.class, salmon.getSiblings().get(0).getClass());
        Shark sib1 = (Shark) (salmon.getSiblings().get(0));
        Assert.assertEquals(new DateTime(2012, 1, 5, 1, 0, 0, DateTimeZone.UTC), sib1.getBirthday());
        Assert.assertEquals(Sawshark.class, salmon.getSiblings().get(1).getClass());
        Sawshark sib2 = (Sawshark) (salmon.getSiblings().get(1));
        Assert.assertArrayEquals(
                new byte[]{(byte) 255, (byte) 255, (byte) 255, (byte) 255, (byte) 254},
                sib2.getPicture());
        Goblinshark sib3 = (Goblinshark) (salmon.getSiblings().get(2));
        Assert.assertEquals(1, sib3.getAge().longValue());
        Assert.assertEquals(5, sib3.getJawsize().longValue());
    }

    @Test
    public void putValid() throws Exception {
        Salmon body = new Salmon();
        body.setLocation("alaska");
        body.setIswild(true);
        body.setSpecies("king");
        body.setLength(1.0);
        body.setSiblings(new ArrayList<Fish>());

        Shark sib1 = new Shark();
        sib1.setAge(6);
        sib1.setBirthday(new DateTime(2012, 1, 5, 1, 0, 0, DateTimeZone.UTC));
        sib1.setLength(20.0);
        sib1.setSpecies("predator");
        body.getSiblings().add(sib1);

        Sawshark sib2 = new Sawshark();
        sib2.setAge(105);
        sib2.setBirthday(new DateTime(1900, 1, 5, 1, 0, 0, DateTimeZone.UTC));
        sib2.setLength(10.0);
        sib2.setPicture(new byte[] {(byte) 255, (byte) 255, (byte) 255, (byte) 255, (byte) 254});
        sib2.setSpecies("dangerous");
        body.getSiblings().add(sib2);

        Goblinshark sib3 = new Goblinshark();
        sib3.setAge(1);
        sib3.setBirthday(new DateTime(2015, 8, 8, 0, 0, 0, DateTimeZone.UTC));
        sib3.setLength(30.0);
        sib3.setSpecies("scary");
        sib3.setJawsize(5);
        body.getSiblings().add(sib3);

        client.getPolymorphismOperations().putValid(body);
    }

    @Test
    public void putValidMissingRequired() throws Exception {
        try {
            Salmon body = new Salmon();
            body.setLocation("alaska");
            body.setIswild(true);
            body.setSpecies("king");
            body.setLength(1.0);
            body.setSiblings(new ArrayList<Fish>());

            Shark sib1 = new Shark();
            sib1.setAge(6);
            sib1.setBirthday(new DateTime(2012, 1, 5, 1, 0, 0, DateTimeZone.UTC));
            sib1.setLength(20.0);
            sib1.setSpecies("predator");
            body.getSiblings().add(sib1);

            Sawshark sib2 = new Sawshark();
            sib2.setAge(105);
            sib2.setLength(10.0);
            sib2.setPicture(new byte[] {(byte) 255, (byte) 255, (byte) 255, (byte) 255, (byte) 254});
            sib2.setSpecies("dangerous");
            body.getSiblings().add(sib2);

            client.getPolymorphismOperations().putValidMissingRequired(body);
        } catch (IllegalArgumentException ex) {
            //expected
            Assert.assertTrue(ex.getMessage().contains("siblings.birthday is required and cannot be null."));
        }
    }
}
