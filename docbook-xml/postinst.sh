#!/bin/bash

if [ ! -e /etc/xml/docbook ]; then
    xmlcatalog --noout --create /etc/xml/docbook
fi

if [ ! -e /etc/xml/catalog ]; then
    xmlcatalog --noout --create /etc/xml/catalog
fi

VERS=( 4.1.2 4.2 4.3 4.4 ${VER} )

for VER in "${VERS[@]}"
do
    xmlcatalog --noout --add "public" \
        "-//OASIS//DTD DocBook XML V${VER}//EN" \
        "http://www.oasis-open.org/docbook/xml/${VER}/docbookx.dtd" \
        /etc/xml/docbook &&
    xmlcatalog --noout --add "public" \
        "-//OASIS//DTD DocBook XML CALS Table Model V${VER}//EN" \
        "file:///usr/share/xml/docbook/xml-dtd-${VER}/calstblx.dtd" \
        /etc/xml/docbook &&
    xmlcatalog --noout --add "public" \
        "-//OASIS//DTD XML Exchange Table Model 19990315//EN" \
        "file:///usr/share/xml/docbook/xml-dtd-${VER}/soextblx.dtd" \
        /etc/xml/docbook &&
    xmlcatalog --noout --add "public" \
        "-//OASIS//ELEMENTS DocBook XML Information Pool V${VER}//EN" \
        "file:///usr/share/xml/docbook/xml-dtd-${VER}/dbpoolx.mod" \
        /etc/xml/docbook &&
    xmlcatalog --noout --add "public" \
        "-//OASIS//ELEMENTS DocBook XML Document Hierarchy V${VER}//EN" \
        "file:///usr/share/xml/docbook/xml-dtd-${VER}/dbhierx.mod" \
        /etc/xml/docbook &&
    xmlcatalog --noout --add "public" \
        "-//OASIS//ELEMENTS DocBook XML HTML Tables V${VER}//EN" \
        "file:///usr/share/xml/docbook/xml-dtd-${VER}/htmltblx.mod" \
        /etc/xml/docbook &&
    xmlcatalog --noout --add "public" \
        "-//OASIS//ENTITIES DocBook XML Notations V${VER}//EN" \
        "file:///usr/share/xml/docbook/xml-dtd-${VER}/dbnotnx.mod" \
        /etc/xml/docbook &&
    xmlcatalog --noout --add "public" \
        "-//OASIS//ENTITIES DocBook XML Character Entities V${VER}//EN" \
        "file:///usr/share/xml/docbook/xml-dtd-${VER}/dbcentx.mod" \
        /etc/xml/docbook &&
    xmlcatalog --noout --add "public" \
        "-//OASIS//ENTITIES DocBook XML Additional General Entities V${VER}//EN" \
        "file:///usr/share/xml/docbook/xml-dtd-${VER}/dbgenent.mod" \
        /etc/xml/docbook &&
    xmlcatalog --noout --add "rewriteSystem" \
        "http://www.oasis-open.org/docbook/xml/${VER}" \
        "file:///usr/share/xml/docbook/xml-dtd-${VER}" \
        /etc/xml/docbook &&
    xmlcatalog --noout --add "rewriteURI" \
        "http://www.oasis-open.org/docbook/xml/${VER}" \
        "file:///usr/share/xml/docbook/xml-dtd-${VER}" \
        /etc/xml/docbook

    xmlcatalog --noout --add "delegatePublic" \
        "-//OASIS//ENTITIES DocBook XML" \
        "file:///etc/xml/docbook" \
        /etc/xml/catalog &&
    xmlcatalog --noout --add "delegatePublic" \
        "-//OASIS//DTD DocBook XML" \
        "file:///etc/xml/docbook" \
        /etc/xml/catalog &&
    xmlcatalog --noout --add "delegateSystem" \
        "http://www.oasis-open.org/docbook/" \
        "file:///etc/xml/docbook" \
        /etc/xml/catalog &&
    xmlcatalog --noout --add "delegateURI" \
        "http://www.oasis-open.org/docbook/" \
        "file:///etc/xml/docbook" \
        /etc/xml/catalog
done

if [ ! -e /etc/xml/docbook-5.0 ]; then
    xmlcatalog --noout --create /etc/xml/docbook-5.0
fi &&

xmlcatalog --noout --add "public" \
  "-//OASIS//DTD DocBook XML 5.0//EN" \
  "file:///usr/share/xml/docbook/schema/dtd/5.0/docbook.dtd" \
  /etc/xml/docbook-5.0 &&
xmlcatalog --noout --add "system" \
  "http://www.oasis-open.org/docbook/xml/5.0/dtd/docbook.dtd" \
  "file:///usr/share/xml/docbook/schema/dtd/5.0/docbook.dtd" \
  /etc/xml/docbook-5.0 &&
xmlcatalog --noout --add "system" \
  "http://docbook.org/xml/5.0/dtd/docbook.dtd" \
  "file:///usr/share/xml/docbook/schema/dtd/5.0/docbook.dtd" \
  /etc/xml/docbook-5.0 &&

xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.0/rng/docbook.rng" \
  "file:///usr/share/xml/docbook/schema/rng/5.0/docbook.rng" \
  /etc/xml/docbook-5.0 &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.0/rng/docbook.rng" \
  "file:///usr/share/xml/docbook/schema/rng/5.0/docbook.rng" \
  /etc/xml/docbook-5.0 &&
xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.0/rng/docbookxi.rng" \
  "file:///usr/share/xml/docbook/schema/rng/5.0/docbookxi.rng" \
  /etc/xml/docbook-5.0 &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.0/rng/docbookxi.rng" \
  "file:///usr/share/xml/docbook/schema/rng/5.0/docbookxi.rng" \
  /etc/xml/docbook-5.0 &&
xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.0/rnc/docbook.rnc" \
  "file:///usr/share/xml/docbook/schema/rng/5.0/docbook.rnc" \
  /etc/xml/docbook-5.0 &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.0/rng/docbook.rnc" \
  "file:///usr/share/xml/docbook/schema/rng/5.0/docbook.rnc" \
  /etc/xml/docbook-5.0 &&
xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.0/rnc/docbookxi.rnc" \
  "file:///usr/share/xml/docbook/schema/rng/5.0/docbookxi.rnc" \
  /etc/xml/docbook-5.0 &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.0/rng/docbookxi.rnc" \
  "file:///usr/share/xml/docbook/schema/rng/5.0/docbookxi.rnc" \
  /etc/xml/docbook-5.0 &&

xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.0/xsd/docbook.xsd" \
  "file:///usr/share/xml/docbook/schema/xsd/5.0/docbook.xsd" \
  /etc/xml/docbook-5.0 &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.0/xsd/docbook.xsd" \
  "file:///usr/share/xml/docbook/schema/xsd/5.0/docbook.xsd" \
  /etc/xml/docbook-5.0 &&
xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.0/xsd/docbookxi.xsd" \
  "file:///usr/share/xml/docbook/schema/xsd/5.0/docbookxi.xsd" \
  /etc/xml/docbook-5.0 &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.0/xsd/docbookxi.xsd" \
  "file:///usr/share/xml/docbook/schema/xsd/5.0/docbookxi.xsd" \
  /etc/xml/docbook-5.0 &&
xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.0/xsd/xi.xsd" \
  "file:///usr/share/xml/docbook/schema/xsd/5.0/xi.xsd" \
  /etc/xml/docbook-5.0 &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.0/xsd/xi.xsd" \
  "file:///usr/share/xml/docbook/schema/xsd/5.0/xi.xsd" \
  /etc/xml/docbook-5.0 &&
xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.0/xsd/xlink.xsd" \
  "file:///usr/share/xml/docbook/schema/xsd/5.0/xlink.xsd" \
  /etc/xml/docbook-5.0 &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.0/xsd/xlink.xsd" \
  "file:///usr/share/xml/docbook/schema/xsd/5.0/xlink.xsd" \
  /etc/xml/docbook-5.0 &&
xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.0/xsd/xml.xsd" \
  "file:///usr/share/xml/docbook/schema/xsd/5.0/xml.xsd" \
  /etc/xml/docbook-5.0 &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.0/xsd/xml.xsd" \
  "file:///usr/share/xml/docbook/schema/xsd/5.0/xml.xsd" \
  /etc/xml/docbook-5.0 &&

xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.0/sch/docbook.sch" \
  "file:///usr/share/xml/docbook/schema/sch/5.0/docbook.sch" \
  /etc/xml/docbook-5.0 &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.0/sch/docbook.sch" \
  "file:///usr/share/xml/docbook/schema/sch/5.0/docbook.sch" \
  /etc/xml/docbook-5.0

xmlcatalog --noout --create /usr/share/xml/docbook/schema/dtd/5.0/catalog.xml &&

xmlcatalog --noout --add "public" \
  "-//OASIS//DTD DocBook XML 5.0//EN" \
  "docbook.dtd" /usr/share/xml/docbook/schema/dtd/5.0/catalog.xml &&
xmlcatalog --noout --add "system" \
  "http://www.oasis-open.org/docbook/xml/5.0/dtd/docbook.dtd" \
  "docbook.dtd" /usr/share/xml/docbook/schema/dtd/5.0/catalog.xml &&

xmlcatalog --noout --create /usr/share/xml/docbook/schema/rng/5.0/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.0/rng/docbook.rng" \
  "docbook.rng" /usr/share/xml/docbook/schema/rng/5.0/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.0/rng/docbook.rng" \
  "docbook.rng" /usr/share/xml/docbook/schema/rng/5.0/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.0/rng/docbookxi.rng" \
  "docbookxi.rng" /usr/share/xml/docbook/schema/rng/5.0/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.0/rng/docbookxi.rng" \
  "docbookxi.rng" /usr/share/xml/docbook/schema/rng/5.0/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.0/rng/docbook.rnc" \
  "docbook.rnc" /usr/share/xml/docbook/schema/rng/5.0/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.0/rng/docbook.rnc" \
  "docbook.rnc" /usr/share/xml/docbook/schema/rng/5.0/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.0/rng/docbookxi.rnc" \
  "docbookxi.rnc" /usr/share/xml/docbook/schema/rng/5.0/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.0/rng/docbookxi.rnc" \
  "docbookxi.rnc" /usr/share/xml/docbook/schema/rng/5.0/catalog.xml &&

xmlcatalog --noout --create /usr/share/xml/docbook/schema/sch/5.0/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.0/sch/docbook.sch" \
  "docbook.sch" /usr/share/xml/docbook/schema/sch/5.0/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.0/sch/docbook.sch" \
  "docbook.sch" /usr/share/xml/docbook/schema/sch/5.0/catalog.xml &&

xmlcatalog --noout --create /usr/share/xml/docbook/schema/xsd/5.0/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.0/xsd/docbook.xsd" \
  "docbook.xsd" /usr/share/xml/docbook/schema/xsd/5.0/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.0/xsd/docbook.xsd" \
  "docbook.xsd" /usr/share/xml/docbook/schema/xsd/5.0/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.0/xsd/docbookxi.xsd" \
  "docbookxi.xsd" /usr/share/xml/docbook/schema/xsd/5.0/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.0/xsd/docbookxi.xsd" \
  "docbookxi.xsd" /usr/share/xml/docbook/schema/xsd/5.0/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.0/xsd/xlink.xsd" \
  "xlink.xsd" /usr/share/xml/docbook/schema/xsd/5.0/catalog.xml &&
xmlcatalog --noout --add "uri" \
   "http://www.oasis-open.org/docbook/xml/5.0/xsd/xlink.xsd" \
   "xlink.xsd" /usr/share/xml/docbook/schema/xsd/5.0/catalog.xml &&
xmlcatalog --noout --add "uri" \
   "http://docbook.org/xml/5.0/xsd/xml.xsd" \
   "xml.xsd" /usr/share/xml/docbook/schema/xsd/5.0/catalog.xml &&
xmlcatalog --noout --add "uri" \
   "http://www.oasis-open.org/docbook/xml/5.0/xsd/xml.xsd" \
   "xml.xsd" /usr/share/xml/docbook/schema/xsd/5.0/catalog.xml

if [ ! -e /etc/xml/catalog ]; then
    xmlcatalog --noout --create /etc/xml/catalog
fi &&
xmlcatalog --noout --add "delegatePublic" \
  "-//OASIS//DTD DocBook XML 5.0//EN" \
  "file:///usr/share/xml/docbook/schema/dtd/5.0/catalog.xml" \
  /etc/xml/catalog &&
xmlcatalog --noout --add "delegateSystem" \
  "http://docbook.org/xml/5.0/dtd/" \
  "file:///usr/share/xml/docbook/schema/dtd/5.0/catalog.xml" \
  /etc/xml/catalog &&
xmlcatalog --noout --add "delegateURI" \
  "http://docbook.org/xml/5.0/dtd/" \
  "file:///usr/share/xml/docbook/schema/dtd/5.0/catalog.xml" \
  /etc/xml/catalog &&
xmlcatalog --noout --add "delegateURI" \
  "http://docbook.org/xml/5.0/rng/"  \
  "file:///usr/share/xml/docbook/schema/rng/5.0/catalog.xml" \
  /etc/xml/catalog &&
xmlcatalog --noout --add "delegateURI" \
  "http://docbook.org/xml/5.0/sch/"  \
  "file:///usr/share/xml/docbook/schema/sch/5.0/catalog.xml" \
  /etc/xml/catalog &&
xmlcatalog --noout --add "delegateURI" \
  "http://docbook.org/xml/5.0/xsd/"  \
  "file:///usr/share/xml/docbook/schema/xsd/5.0/catalog.xml" \
  /etc/xml/catalog

if [ ! -e /etc/xml/docbook-5.1 ]; then
  xmlcatalog --noout --create /etc/xml/docbook-5.1
fi &&

xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.1/rng/docbook.rng" \
  "file:///usr/share/xml/docbook/schema/rng/5.1/docbook.rng" \
  /etc/xml/docbook-5.1 &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.1/rng/docbook.rng" \
  "file:///usr/share/xml/docbook/schema/rng/5.1/docbook.rng" \
  /etc/xml/docbook-5.1 &&
xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.1/rng/docbookxi.rng" \
  "file:///usr/share/xml/docbook/schema/rng/5.1/docbookxi.rng" \
  /etc/xml/docbook-5.1 &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.1/rng/docbookxi.rng" \
  "file:///usr/share/xml/docbook/schema/rng/5.1/docbookxi.rng" \
  /etc/xml/docbook-5.1 &&
xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.1/rnc/docbook.rnc" \
  "file:///usr/share/xml/docbook/schema/rng/5.1/docbook.rnc" \
  /etc/xml/docbook-5.1 &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.1/rng/docbook.rnc" \
  "file:///usr/share/xml/docbook/schema/rng/5.1/docbook.rnc" \
  /etc/xml/docbook-5.1 &&
xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.1/rnc/docbookxi.rnc" \
  "file:///usr/share/xml/docbook/schema/rng/5.1/docbookxi.rnc" \
  /etc/xml/docbook-5.1 &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.1/rng/docbookxi.rnc" \
  "file:///usr/share/xml/docbook/schema/rng/5.1/docbookxi.rnc" \
  /etc/xml/docbook-5.1 &&

xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.1/sch/docbook.sch" \
  "file:///usr/share/xml/docbook/schema/sch/5.1/docbook.sch" \
  /etc/xml/docbook-5.1 &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.1/sch/docbook.sch" \
  "file:///usr/share/xml/docbook/schema/sch/5.1/docbook.sch" \
  /etc/xml/docbook-5.1

xmlcatalog --noout --create /usr/share/xml/docbook/schema/rng/5.1/catalog.xml &&

xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.1/schemas/rng/docbook.schemas/rng" \
  "docbook.schemas/rng" /usr/share/xml/docbook/schema/rng/5.1/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.1/schemas/rng/docbook.schemas/rng" \
  "docbook.schemas/rng" /usr/share/xml/docbook/schema/rng/5.1/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.1/schemas/rng/docbookxi.schemas/rng" \
  "docbookxi.schemas/rng" /usr/share/xml/docbook/schema/rng/5.1/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.1/schemas/rng/docbookxi.schemas/rng" \
  "docbookxi.schemas/rng" /usr/share/xml/docbook/schema/rng/5.1/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.1/schemas/rng/docbook.rnc" \
  "docbook.rnc" /usr/share/xml/docbook/schema/rng/5.1/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.1/schemas/rng/docbook.rnc" \
  "docbook.rnc" /usr/share/xml/docbook/schema/rng/5.1/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.1/schemas/rng/docbookxi.rnc" \
  "docbookxi.rnc" /usr/share/xml/docbook/schema/rng/5.1/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.1/schemas/rng/docbookxi.rnc" \
  "docbookxi.rnc" /usr/share/xml/docbook/schema/rng/5.1/catalog.xml
xmlcatalog --noout --create /usr/share/xml/docbook/schema/sch/5.1/catalog.xml &&

xmlcatalog --noout --add "uri" \
  "http://docbook.org/xml/5.1/schemas/sch/docbook.schemas/sch" \
  "docbook.schemas/sch" /usr/share/xml/docbook/schema/sch/5.1/catalog.xml &&
xmlcatalog --noout --add "uri" \
  "http://www.oasis-open.org/docbook/xml/5.1/schemas/sch/docbook.schemas/sch" \
  "docbook.schemas/sch" /usr/share/xml/docbook/schema/sch/5.1/catalog.xml

if [ ! -e /etc/xml/catalog ]; then
  xmlcatalog --noout --create /etc/xml/catalog
fi &&
xmlcatalog --noout --add "delegatePublic" \
  "-//OASIS//DTD DocBook XML 5.1//EN" \
  "file:///usr/share/xml/docbook/schema/dtd/5.1/catalog.xml" \
  /etc/xml/catalog &&
xmlcatalog --noout --add "delegateSystem" \
  "http://docbook.org/xml/5.1/dtd/" \
  "file:///usr/share/xml/docbook/schema/dtd/5.1/catalog.xml" \
  /etc/xml/catalog &&
xmlcatalog --noout --add "delegateURI" \
  "http://docbook.org/xml/5.1/dtd/" \
  "file:///usr/share/xml/docbook/schema/dtd/5.1/catalog.xml" \
  /etc/xml/catalog &&
xmlcatalog --noout --add "delegateURI" \
  "http://docbook.org/xml/5.1/rng/"  \
  "file:///usr/share/xml/docbook/schema/rng/5.1/catalog.xml" \
  /etc/xml/catalog &&
xmlcatalog --noout --add "delegateURI" \
  "http://docbook.org/xml/5.1/sch/"  \
  "file:///usr/share/xml/docbook/schema/sch/5.1/catalog.xml" \
  /etc/xml/catalog &&
xmlcatalog --noout --add "delegateURI" \
  "http://docbook.org/xml/5.1/xsd/"  \
  "file:///usr/share/xml/docbook/schema/xsd/5.1/catalog.xml" \
  /etc/xml/catalog