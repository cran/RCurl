<?xml version="1.0"?>

<!-- Copyright the Omegahat Project for Statistical Computing, 2000 -->
<!-- Author: Duncan Temple Lang -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:bib="http://www.bibliography.org"
                xmlns:c="http://www.C.org"
                xmlns:rs="http://www.omegahat.org/RS"
                xmlns:s="http://cm.bell-labs.com/stat/S4"
		exclude-result-prefixes="s"
               version="1.0">


<xsl:import href="/Users/duncan/docbook-xsl-1.65.1/html/docbook.xsl" />

<xsl:output method="html"
            encoding="ISO-8859-1"
            indent="yes"/>

<xsl:param name="shade.verbatim" select="1"/>

<!-- 
 <xsl:include href="/Users/duncan/Projects/org/omegahat/Docs/XSL/table.xsl" />
 <xsl:include href="/Users/duncan/Projects/org/omegahat/Docs/XSL/elements.xsl" />
 <xsl:include href="/Users/duncan/Projects/org/omegahat/Docs/XSL/java.xsl" />
 <xsl:include href="/Users/duncan/Projects/org/omegahat/Docs/XSL/xml.xsl" /> 
 <xsl:include href="/Users/duncan/Projects/org/omegahat/Docs/XSL/env.xsl" /> 

 -->

 <xsl:include href="/Users/duncan/Projects/org/omegahat/Docs/XSL/c.xsl" />
 <xsl:include href="/Users/duncan/Projects/org/omegahat/Docs/XSL/SLanguage.xsl" />
<!--  <xsl:include href="/Users/duncan/Projects/org/omegahat/Docs/XSL/Rstyle.xsl" /> -->
 <xsl:include href="/Users/duncan/Projects/org/omegahat/Docs/XSL/html.xsl" />

 <xsl:include href="/Users/duncan/Projects/org/omegahat/Docs/XSL/curl.xsl" /> 

</xsl:stylesheet>
