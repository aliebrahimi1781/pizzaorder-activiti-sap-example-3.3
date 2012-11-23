<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" version="1.0" encoding="UTF-8"
        indent="yes" />
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>
    <xsl:template match="field">
        <xsl:element name="{@name}">
            <xsl:apply-templates />
        </xsl:element>
    </xsl:template>
    <xsl:template match="table">
        <xsl:element name="{@name}">
            <xsl:apply-templates />
        </xsl:element>
    </xsl:template>
    <xsl:template match="structure">
        <xsl:element name="{@name}">
            <xsl:apply-templates />
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>