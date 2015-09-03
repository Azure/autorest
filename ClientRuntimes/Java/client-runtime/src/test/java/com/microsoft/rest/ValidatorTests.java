/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

import com.fasterxml.jackson.annotation.JsonProperty;
import org.junit.Assert;
import org.joda.time.LocalDate;
import org.junit.Test;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.junit.Assert.fail;

public class ValidatorTests {
    @Test
    public void validateInt() throws Exception {
        IntWrapper body = new IntWrapper();
        body.value = 2;
        body.nullable = null;
        Validator.validate(body); // pass
    }

    @Test
    public void validateInteger() throws Exception {
        IntegerWrapper body = new IntegerWrapper();
        body.value = 3;
        Validator.validate(body); // pass
        try {
            body.value = null;
            Validator.validate(body); // fail
            fail();
        } catch (ServiceException ex) {
            Assert.assertTrue(ex.getMessage().contains("value is required"));
        }
    }

    @Test
    public void validateString() throws Exception {
        StringWrapper body = new StringWrapper();
        body.value = "";
        Validator.validate(body); // pass
        try {
            body.value = null;
            Validator.validate(body); // fail
            fail();
        } catch (ServiceException ex) {
            Assert.assertTrue(ex.getMessage().contains("value is required"));
        }
    }

    @Test
    public void validateLocalDate() throws Exception {
        LocalDateWrapper body = new LocalDateWrapper();
        body.value = new LocalDate(1, 2, 3);
        Validator.validate(body); // pass
        try {
            body.value = null;
            Validator.validate(body); // fail
            fail();
        } catch (ServiceException ex) {
            Assert.assertTrue(ex.getMessage().contains("value is required"));
        }
    }

    @Test
    public void validateList() throws Exception {
        ListWrapper body = new ListWrapper();
        try {
            body.list = null;
            Validator.validate(body); // fail
            fail();
        } catch (ServiceException ex) {
            Assert.assertTrue(ex.getMessage().contains("list is required"));
        }
        body.list = new ArrayList<StringWrapper>();
        Validator.validate(body); // pass
        StringWrapper wrapper = new StringWrapper();
        wrapper.value = "valid";
        body.list.add(wrapper);
        Validator.validate(body); // pass
        body.list.add(null);
        Validator.validate(body); // pass
        body.list.add(new StringWrapper());
        try {
            Validator.validate(body); // fail
            fail();
        } catch (ServiceException ex) {
            Assert.assertTrue(ex.getMessage().contains("list.value is required"));
        }
    }

    @Test
    public void validateMap() throws Exception {
        MapWrapper body = new MapWrapper();
        try {
            body.map = null;
            Validator.validate(body); // fail
            fail();
        } catch (ServiceException ex) {
            Assert.assertTrue(ex.getMessage().contains("map is required"));
        }
        body.map = new HashMap<LocalDate, StringWrapper>();
        Validator.validate(body); // pass
        StringWrapper wrapper = new StringWrapper();
        wrapper.value = "valid";
        body.map.put(new LocalDate(1, 2, 3), wrapper);
        Validator.validate(body); // pass
        body.map.put(new LocalDate(1, 2, 3), null);
        Validator.validate(body); // pass
        body.map.put(new LocalDate(1, 2, 3), new StringWrapper());
        try {
            Validator.validate(body); // fail
            fail();
        } catch (ServiceException ex) {
            Assert.assertTrue(ex.getMessage().contains("map.value is required"));
        }
    }

    public class IntWrapper {
        @JsonProperty(required = true)
        public int value;
        public Object nullable;
    }

    public class IntegerWrapper {
        @JsonProperty(required = true)
        public Integer value;
    }

    public class StringWrapper {
        @JsonProperty(required = true)
        public String value;
    }

    public class LocalDateWrapper {
        @JsonProperty(required = true)
        public LocalDate value;
    }

    public class ListWrapper {
        @JsonProperty(required = true)
        public List<StringWrapper> list;
    }

    public class MapWrapper {
        @JsonProperty(required = true)
        public Map<LocalDate, StringWrapper> map;
    }

    public enum Color {
        RED,
        GREEN,
        Blue
    }

    public class EnumWrapper {
        @JsonProperty(required = true)
        Color color;
    }
}
