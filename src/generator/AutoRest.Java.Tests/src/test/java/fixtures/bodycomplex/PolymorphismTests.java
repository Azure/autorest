package fixtures.bodycomplex;

import org.joda.time.DateTime;
import org.joda.time.DateTimeZone;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.util.ArrayList;

import fixtures.bodycomplex.implementation.AutoRestComplexTestServiceImpl;
import fixtures.bodycomplex.models.Fish;
import fixtures.bodycomplex.models.Goblinshark;
import fixtures.bodycomplex.models.Salmon;
import fixtures.bodycomplex.models.Sawshark;
import fixtures.bodycomplex.models.Shark;

public class PolymorphismTests {
    private static AutoRestComplexTestService client;

    @BeforeClass
    public static void setup() {
        client = new AutoRestComplexTestServiceImpl("http://localhost:3000");
    }

    @Test
    public void getValid() throws Exception {
        Fish result = client.polymorphisms().getValid();
        Assert.assertEquals(Salmon.class, result.getClass());
        Salmon salmon = (Salmon) result;
        Assert.assertEquals("alaska", salmon.location());
        Assert.assertEquals(1.0, salmon.length(), 0f);
        Assert.assertEquals(3, salmon.siblings().size());
        Assert.assertEquals(Shark.class, salmon.siblings().get(0).getClass());
        Shark sib1 = (Shark) (salmon.siblings().get(0));
        Assert.assertEquals(new DateTime(2012, 1, 5, 1, 0, 0, DateTimeZone.UTC), sib1.birthday());
        Assert.assertEquals(Sawshark.class, salmon.siblings().get(1).getClass());
        Sawshark sib2 = (Sawshark) (salmon.siblings().get(1));
        Assert.assertArrayEquals(
                new byte[]{(byte) 255, (byte) 255, (byte) 255, (byte) 255, (byte) 254},
                sib2.picture());
        Goblinshark sib3 = (Goblinshark) (salmon.siblings().get(2));
        Assert.assertEquals(1, sib3.age().longValue());
        Assert.assertEquals(5, sib3.jawsize().longValue());
    }

    @Test
    public void putValid() throws Exception {
        Salmon body = new Salmon();
        body.withLocation("alaska");
        body.withIswild(true);
        body.withSpecies("king");
        body.withLength(1.0);
        body.withSiblings(new ArrayList<Fish>());

        Shark sib1 = new Shark();
        sib1.withAge(6);
        sib1.withBirthday(new DateTime(2012, 1, 5, 1, 0, 0, DateTimeZone.UTC));
        sib1.withLength(20.0);
        sib1.withSpecies("predator");
        body.siblings().add(sib1);

        Sawshark sib2 = new Sawshark();
        sib2.withAge(105);
        sib2.withBirthday(new DateTime(1900, 1, 5, 1, 0, 0, DateTimeZone.UTC));
        sib2.withLength(10.0);
        sib2.withPicture(new byte[] {(byte) 255, (byte) 255, (byte) 255, (byte) 255, (byte) 254});
        sib2.withSpecies("dangerous");
        body.siblings().add(sib2);

        Goblinshark sib3 = new Goblinshark();
        sib3.withAge(1);
        sib3.withBirthday(new DateTime(2015, 8, 8, 0, 0, 0, DateTimeZone.UTC));
        sib3.withLength(30.0);
        sib3.withSpecies("scary");
        sib3.withJawsize(5);
        body.siblings().add(sib3);

        client.polymorphisms().putValid(body);
    }

    @Test
    public void putValidMissingRequired() throws Exception {
        try {
            Salmon body = new Salmon();
            body.withLocation("alaska");
            body.withIswild(true);
            body.withSpecies("king");
            body.withLength(1.0);
            body.withSiblings(new ArrayList<Fish>());

            Shark sib1 = new Shark();
            sib1.withAge(6);
            sib1.withBirthday(new DateTime(2012, 1, 5, 1, 0, 0, DateTimeZone.UTC));
            sib1.withLength(20.0);
            sib1.withSpecies("predator");
            body.siblings().add(sib1);

            Sawshark sib2 = new Sawshark();
            sib2.withAge(105);
            sib2.withLength(10.0);
            sib2.withPicture(new byte[] {(byte) 255, (byte) 255, (byte) 255, (byte) 255, (byte) 254});
            sib2.withSpecies("dangerous");
            body.siblings().add(sib2);

            client.polymorphisms().putValidMissingRequired(body);
        } catch (IllegalArgumentException ex) {
            //expected
            Assert.assertTrue(ex.getMessage().contains("siblings.birthday is required and cannot be null."));
        }
    }
}
