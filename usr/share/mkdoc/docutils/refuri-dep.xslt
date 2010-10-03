<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="text"/>

  <xsl:template match="reference">
    <xsl:value-of select="@refuri"/>  
    <xsl:text>
</xsl:text>
  </xsl:template>    

  <xsl:template match="text()|@*">
  </xsl:template>

  <xsl:template match="*">
    <xsl:apply-templates/>
  </xsl:template>

</xsl:stylesheet>
