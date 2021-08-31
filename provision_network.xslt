<?xml version="1.0" ?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output omit-xml-declaration="yes" indent="yes"/>
  <xsl:template match="node()|@*">
     <xsl:copy>
       <xsl:apply-templates select="node()|@*"/>
     </xsl:copy>
  </xsl:template>

   <xsl:template match="network">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:copy-of select="node()"/>
      <dns enable='yes'/>
      <forward mode='nat'/>
      <ip family='ipv4' address='${provision_ipaddr}' prefix='22'/>
    </xsl:copy>
   </xsl:template>

</xsl:stylesheet>
