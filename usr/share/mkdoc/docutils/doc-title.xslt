<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="text"/>

	<xsl:template match="document">
		<xsl:if test="@title">
			<xsl:value-of select="@source"/>  
			<xsl:text>	</xsl:text><!-- \t -->
			<xsl:value-of select="@title"/>  
			<xsl:text>
			</xsl:text><!-- \r\n -->
		</xsl:if>
  </xsl:template>    

  <xsl:template match="text()|@*">
  </xsl:template>

  <xsl:template match="*">
    <xsl:apply-templates/>
  </xsl:template>

</xsl:stylesheet>

