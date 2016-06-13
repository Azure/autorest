package fixtures.bodycomplex;

import fixtures.bodycomplex.models.Fish;
import fixtures.bodycomplex.models.Salmon;
import fixtures.bodycomplex.models.Sawshark;
import fixtures.bodycomplex.models.Shark;
import org.joda.time.DateTime;
import org.joda.time.DateTimeZone;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.util.ArrayList;

public class PolymorphismrecursiveTests {
    private static AutoRestComplexTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestComplexTestServiceImpl("http://localhost:3000");
    }

    @Test
    public void getValid() throws Exception {
        Fish result = client.getPolymorphicrecursiveOperations().getValid().getBody();
        Salmon salmon = (Salmon) result;
        Shark sib1 = (Shark) (salmon.getSiblings().get(0));
        Salmon sib2 = (Salmon) (sib1.getSiblings().get(0));
        Shark sib3 = (Shark) (sib2.getSiblings().get(0));
        Assert.assertEquals(
                new DateTime(2012, 1, 5, 1, 0, 0, DateTimeZone.UTC),
                sib3.getBirthday());
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
        sib1.setSiblings(new ArrayList<Fish>());
        body.getSiblings().add(sib1);

        Sawshark sib2 = new Sawshark();
        sib2.setAge(105);
        sib2.setBirthday(new DateTime(1900, 1, 5, 1, 0, 0, DateTimeZone.UTC));
        sib2.setLength(10.0);
        sib2.setPicture(new byte[] {(byte) 255, (byte) 255, (byte) 255, (byte) 255, (byte) 254});
        sib2.setSpecies("dangerous");
        sib2.setSiblings(new ArrayList<Fish>());
        body.getSiblings().add(sib2);

        Salmon sib11 = new Salmon();
        sib11.setIswild(true);
        sib11.setLocation("atlantic");
        sib11.setSpecies("coho");
        sib11.setLength(2);
        sib11.setSiblings(new ArrayList<Fish>());
        sib1.getSiblings().add(sib11);
        sib1.getSiblings().add(sib2);

        Shark sib111 = new Shark();
        sib111.setAge(6);
        sib111.setBirthday(new DateTime(2012, 1, 5, 1, 0, 0, DateTimeZone.UTC));
        sib111.setSpecies("predator");
        sib111.setLength(20);
        sib11.getSiblings().add(sib111);

        Sawshark sib112 = new Sawshark();
        sib112.setAge(105);
        sib112.setBirthday(new DateTime(1900, 1, 5, 1, 0, 0, DateTimeZone.UTC));
        sib112.setLength(10.0);
        sib112.setPicture(new byte[] {(byte) 255, (byte) 255, (byte) 255, (byte) 255, (byte) 254});
        sib112.setSpecies("dangerous");
        sib11.getSiblings().add(sib112);

        client.getPolymorphicrecursiveOperations().putValid(body);
    }
}
