/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.core;

import static org.junit.Assert.*;

import javax.xml.datatype.DatatypeFactory;
import javax.xml.datatype.Duration;
import org.junit.Test;

public class TimeSpan8601ConverterTests {
    @Test
    public void formatShouldWork() throws Exception {
        DatatypeFactory dataTypeFactory = DatatypeFactory.newInstance();
        Duration duration = dataTypeFactory.newDurationDayTime(true, 0, 3, 10,
                2);
        String durationString = TimeSpan8601Converter.format(duration);

        assertEquals("P0DT3H10M2S", durationString);
    }

    @Test
    public void parseShouldWork() throws Exception {
        Duration duration = TimeSpan8601Converter.parse("P0DT3H10M2S");

        assertEquals(0, duration.getDays());
        assertEquals(3, duration.getHours());
        assertEquals(10, duration.getMinutes());
        assertEquals(2, duration.getSeconds());
    }
}
