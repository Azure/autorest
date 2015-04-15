/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.core;

import java.util.Date;

import javax.xml.bind.annotation.adapters.XmlAdapter;

/*
 * JAXB adapter for RFC 1123 date element
 */
public class RFC1123DateAdapter extends XmlAdapter<String, Date> {

    @Override
    public Date unmarshal(String arg0) throws Exception {
        return new RFC1123DateConverter().parse(arg0);
    }

    @Override
    public String marshal(Date arg0) throws Exception {
        return new RFC1123DateConverter().format(arg0);
    }
}
