/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.core.utils;

import java.util.ArrayList;

import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public abstract class XmlUtility {
    public static Element getElementByTagNameNS(Node element, String namespace,
            String name) {
        NodeList elements = element.getChildNodes();
        CharSequence colon = ":";
        if (elements != null) {
            for (int i = 0; i < elements.getLength(); i++) {
                if (elements.item(i).getNodeType() == Node.ELEMENT_NODE
                    && (elements.item(i).getAttributes().getNamedItemNS("http://www.w3.org/2001/XMLSchema-instance", "nil") == null
                    || !"true".equals(elements.item(i).getAttributes().getNamedItemNS("http://www.w3.org/2001/XMLSchema-instance", "nil")))) {
                    Element currentElement = (Element) elements.item(i);
                    String nodeName = currentElement.getNodeName();
                    String nodeNameOnly = nodeName;
                    if (nodeName.contains(colon)) {
                        String[] nodeNameSplit = nodeName.split(":");
                        nodeNameOnly = nodeNameSplit[1];
                    }
                    
                    if ((currentElement.getNamespaceURI() == null
                        || currentElement.getNamespaceURI().equals(namespace))
                        && nodeNameOnly.equals(name)) {
                        return currentElement;
                    }
                }
            }
        }

        return null;
    }

    public static ArrayList<Element> getElementsByTagNameNS(Node element,
            String namespace, String name) {
        ArrayList<Element> childElements = new ArrayList<Element>();

        NodeList elements = element.getChildNodes();
        if (elements != null) {
            for (int i = 0; i < elements.getLength(); i++) {
                if (elements.item(i).getNodeType() == Node.ELEMENT_NODE) {
                    Element currentElement = (Element) elements.item(i);
                    if ((currentElement.getNamespaceURI() == null
                        || currentElement.getNamespaceURI().equals(namespace))
                        && currentElement.getNodeName().equals(name)) {

                        childElements.add(currentElement);
                    }
                }
            }
        }

        return childElements;
    }

    public static Element getElementByTagName(Node element, String name) {
        NodeList elements = element.getChildNodes();
        if (elements != null) {
            for (int i = 0; i < elements.getLength(); i++) {
                if (elements.item(i).getNodeType() == Node.ELEMENT_NODE) {
                    Element currentElement = (Element) elements.item(i);
                    if (currentElement.getNodeName().equals(name)) {

                        return currentElement;
                    }
                }
            }
        }

        return null;
    }
}
