<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:nmrn="http://schema.bipm.org/xml/imres/nmrr/nmi/1.0wd"
                xmlns:nmrdb="http://schema.bipm.org/xml/imres/nmrr/database/1.0wd"
                xmlns:nmrds="http://schema.bipm.org/xml/imres/nmrr/dataset/1.0wd"
                xmlns:nmrsw="http://schema.bipm.org/xml/imres/nmrr/software/1.0wd"
                xmlns:nmrsv="http://schema.bipm.org/xml/imres/nmrr/service/1.0wd"
                xmlns:nmrdp="http://schema.bipm.org/xml/imres/nmrr/portal/1.0wd"
                xmlns:imr="http://schema.bipm.org/xml/imres/1.0wd"
                xmlns:nmi="http://schema.bipm.org/xml/imres/nmi/1.0wd"
                xmlns:mdt="http://schema.bipm.org/xml/imres/data/1.0wd"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                exclude-result-prefixes="nmrn nmrdb nmrds nmrsw nmrsv nmrdp"
                version="1.0">
                
<!-- Stylesheet for converting mgi-resmd records to datacite records -->

   <xsl:output method="xml" encoding="UTF-8" indent="no" />
   <xsl:variable name="autoIndent" select="'  '"/>
   <xsl:preserve-space elements="*"/>

   <!--
     -  If true, insert carriage returns and indentation to produce a neatly 
     -  formatted output.  If false, any spacing between tags in the source
     -  document will be preserved.  
     -->
   <xsl:param name="prettyPrint" select="true()"/>

   <!--
     -  the per-level indentation.  Set this to a sequence of spaces when
     -  pretty printing is turned on.
     -->
   <xsl:param name="indent" select="'  '"/>


   <xsl:variable name="cr"><xsl:text>
</xsl:text></xsl:variable>

   <!-- ==========================================================
     -  General templates
     -  ========================================================== -->

   <xsl:template match="/">
      <xsl:apply-templates select="*">
         <xsl:with-param name="sp">
            <xsl:if test="$prettyPrint">
              <xsl:value-of select="$cr"/>
            </xsl:if>
         </xsl:with-param>
         <xsl:with-param name="step">
            <xsl:if test="$prettyPrint">
              <xsl:value-of select="$indent"/>
            </xsl:if>
         </xsl:with-param>
      </xsl:apply-templates>
   </xsl:template>

   <xsl:template match="nmrn:Resource">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>

      <imr:Resource xsi:type="nmi:MetrologyInstitute"
                    status="{@status}" localid="{@localid}">

        <xsl:apply-templates select="resourceType">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="title">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="abbreviation">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="homeURL">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="sponsoringCountry">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="contact">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="subject">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="description">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="date" mode="created">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>

        <xsl:value-of select="$sp"/>

      </imr:Resource>
   </xsl:template>

   <xsl:template match="nmrdb:Resource">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>

      <imr:Resource xsi:type="mdt:Database"
                    status="active" localid="{@localid}">
         <xsl:apply-templates select="." mode="dataResource">
           <xsl:with-param name="sp" select="concat($sp,$step)"/>
           <xsl:with-param name="step" select="$step"/>
         </xsl:apply-templates>
         <xsl:value-of select="$sp"/>
      </imr:Resource>
   </xsl:template>

   <xsl:template match="nmrds:Resource">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>

      <imr:Resource xsi:type="mdt:Dataset"
                    status="active" localid="{@localid}">
         <xsl:apply-templates select="." mode="dataResource">
           <xsl:with-param name="sp" select="concat($sp,$step)"/>
           <xsl:with-param name="step" select="$step"/>
         </xsl:apply-templates>
         <xsl:value-of select="$sp"/>
      </imr:Resource>
   </xsl:template>

   <xsl:template match="nmrdp:Resource">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>

      <imr:Resource xsi:type="mdt:Portal"
                    status="active" localid="{@localid}">
         <xsl:apply-templates select="." mode="dataResource">
           <xsl:with-param name="sp" select="concat($sp,$step)"/>
           <xsl:with-param name="step" select="$step"/>
         </xsl:apply-templates>
         <xsl:value-of select="$sp"/>
      </imr:Resource>
   </xsl:template>

   <xsl:template match="nmrsv:Resource">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>

      <imr:Resource xsi:type="mdt:Service"
                    status="active" localid="{@localid}">
         <xsl:apply-templates select="." mode="dataResource">
           <xsl:with-param name="sp" select="concat($sp,$step)"/>
           <xsl:with-param name="step" select="$step"/>
         </xsl:apply-templates>
         <xsl:value-of select="$sp"/>
      </imr:Resource>
   </xsl:template>

   <xsl:template match="nmrsw:Resource">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>

      <imr:Resource xsi:type="imr:Software"
                    status="active" localid="{@localid}">
         <xsl:apply-templates select="." mode="dataResource">
           <xsl:with-param name="sp" select="concat($sp,$step)"/>
           <xsl:with-param name="step" select="$step"/>
         </xsl:apply-templates>
         <xsl:value-of select="$sp"/>
      </imr:Resource>
   </xsl:template>

   <xsl:template match="*[local-name()='Resource']" mode="dataResource">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>

      <xsl:apply-templates select="resourceType">
        <xsl:with-param name="sp" select="$sp"/>
        <xsl:with-param name="step" select="$step"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="title">
        <xsl:with-param name="sp" select="$sp"/>
        <xsl:with-param name="step" select="$step"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="subtitle">
        <xsl:with-param name="sp" select="$sp"/>
        <xsl:with-param name="step" select="$step"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="abbreviation">
        <xsl:with-param name="sp" select="$sp"/>
        <xsl:with-param name="step" select="$step"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="homePage" mode="identifier">
        <xsl:with-param name="sp" select="$sp"/>
        <xsl:with-param name="step" select="$step"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="homePage" mode="homeURL">
        <xsl:with-param name="sp" select="$sp"/>
        <xsl:with-param name="step" select="$step"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="sponsoringCountry">
        <xsl:with-param name="sp" select="$sp"/>
        <xsl:with-param name="step" select="$step"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="creator">
        <xsl:with-param name="sp" select="$sp"/>
        <xsl:with-param name="step" select="$step"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="contributor">
        <xsl:with-param name="sp" select="$sp"/>
        <xsl:with-param name="step" select="$step"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="contact">
        <xsl:with-param name="sp" select="$sp"/>
        <xsl:with-param name="step" select="$step"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="subject">
        <xsl:with-param name="sp" select="$sp"/>
        <xsl:with-param name="step" select="$step"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="description">
        <xsl:with-param name="sp" select="$sp"/>
        <xsl:with-param name="step" select="$step"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="date">
        <xsl:with-param name="sp" select="$sp"/>
        <xsl:with-param name="step" select="$step"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="publisher">
        <xsl:with-param name="sp" select="$sp"/>
        <xsl:with-param name="step" select="$step"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="publicationYear">
        <xsl:with-param name="sp" select="$sp"/>
        <xsl:with-param name="step" select="$step"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="measures">
        <xsl:with-param name="sp" select="$sp"/>
        <xsl:with-param name="step" select="$step"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="access">
        <xsl:with-param name="sp" select="$sp"/>
        <xsl:with-param name="step" select="$step"/>
      </xsl:apply-templates>

   </xsl:template>

   <xsl:template match="sponsoringCountry">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>

      <xsl:value-of select="$sp"/>

      <xsl:element name="{local-name()}">
         <xsl:attribute name="abbrev">
           <xsl:value-of select="abbrev"/>
         </xsl:attribute>
         <xsl:value-of select="name"/>
      </xsl:element>
   </xsl:template>

   <xsl:template match="subtitle">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>

      <xsl:value-of select="$sp"/>

      <altTitle type="Subtitle"><xsl:value-of select="."/></altTitle>
   </xsl:template>

   <xsl:template match="abbreviation">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>

      <xsl:value-of select="$sp"/>

      <altTitle type="Abbreviation"><xsl:value-of select="."/></altTitle>
   </xsl:template>

   <xsl:template match="description">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>

      <xsl:value-of select="$sp"/>

      <description><xsl:value-of select="."/></description>
   </xsl:template>

   <xsl:template match="date" mode="created">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>

      <xsl:value-of select="$sp"/>

      <date type="Created"><xsl:value-of select="."/></date>
   </xsl:template>

   <xsl:template match="homePage" mode="identifier">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>

      <xsl:if test="doi">
         <xsl:value-of select="$sp"/>
         <identifier type="DOI"><xsl:value-of select="doi"/></identifier>
      </xsl:if>
   </xsl:template>

   <xsl:template match="creator[*]">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>

      <xsl:variable name="subsp" select="concat($sp,$step)"/>

      <xsl:value-of select="$sp"/>

      <creator>      

         <xsl:apply-templates select="name">
             <xsl:with-param name="sp" select="$subsp"/>
             <xsl:with-param name="step" select="$step"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="identifier">
             <xsl:with-param name="sp" select="$subsp"/>
             <xsl:with-param name="step" select="$step"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="affiliation">
             <xsl:with-param name="sp" select="$subsp"/>
             <xsl:with-param name="step" select="$step"/>
         </xsl:apply-templates>

         <xsl:value-of select="$sp"/>

      </creator>      
   </xsl:template>

   <xsl:template match="contributor[*]">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>

      <xsl:variable name="subsp" select="concat($sp,$step)"/>

      <xsl:value-of select="$sp"/>

      <contributor type="{@type}">      

         <xsl:apply-templates select="name">
             <xsl:with-param name="sp" select="$subsp"/>
             <xsl:with-param name="step" select="$step"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="identifier">
             <xsl:with-param name="sp" select="$subsp"/>
             <xsl:with-param name="step" select="$step"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="affiliation">
             <xsl:with-param name="sp" select="$subsp"/>
             <xsl:with-param name="step" select="$step"/>
         </xsl:apply-templates>

         <xsl:value-of select="$sp"/>

      </contributor>
   </xsl:template>

   <xsl:template match="creator/identifier|contributor/identifier">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>

      <identifier identifierScheme="ORCID">
      <xsl:value-of select="."/>
      </identifier>
   </xsl:template>

   <xsl:template match="homePage" mode="homeURL">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>

      <xsl:choose>
         <xsl:when test="doi">
            <xsl:value-of select="$sp"/>
            <homeURL>http://dx.doi.org/<xsl:value-of select="doi"/></homeURL>
         </xsl:when>
         <xsl:when test="url">
            <xsl:value-of select="$sp"/>
            <homeURL><xsl:value-of select="url"/></homeURL>
         </xsl:when>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="via">
     <xsl:message>Failed to match via</xsl:message>
   </xsl:template>

   <xsl:template match="via[contains(@xsi:type,':Download')]">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>
      <xsl:variable name="subsp" select="concat($sp,$step)"/>

      <xsl:value-of select="$sp"/>

      <xsl:element name="via">
        <xsl:attribute name="xsi:type">imr:Media</xsl:attribute>
        <xsl:for-each select="@*[name()!='xsi:type']">
          <xsl:copy/>
        </xsl:for-each>

        <xsl:value-of select="$subsp"/>
        <method>download</method>

        <xsl:apply-templates select="description">
          <xsl:with-param name="sp" select="$subsp"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="format">
          <xsl:with-param name="sp" select="$subsp"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="accessURL">
          <xsl:with-param name="sp" select="$subsp"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>

        <xsl:value-of select="$sp"/>

      </xsl:element>

   </xsl:template>

   <xsl:template match="via[contains(@xsi:type,':ServiceAPI')]">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>
      <xsl:variable name="subsp" select="concat($sp,$step)"/>

      <xsl:value-of select="$sp"/>

      <xsl:element name="via">
        <xsl:attribute name="xsi:type">imr:Media</xsl:attribute>
        <xsl:for-each select="@*[name()!='xsi:type']">
          <xsl:copy/>
        </xsl:for-each>

        <xsl:value-of select="$subsp"/>
        <method>service API</method>

        <xsl:apply-templates select="description">
          <xsl:with-param name="sp" select="$subsp"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="documentationURL">
          <xsl:with-param name="sp" select="$subsp"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>

        <xsl:value-of select="$sp"/>

      </xsl:element>

   </xsl:template>

   <xsl:template match="via[contains(@xsi:type,':Media')]">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>
      <xsl:variable name="subsp" select="concat($sp,$step)"/>

      <xsl:value-of select="$sp"/>

      <xsl:element name="via">
        <xsl:attribute name="xsi:type">imr:Media</xsl:attribute>
        <xsl:for-each select="@*[name()!='xsi:type']">
          <xsl:copy/>
        </xsl:for-each>

        <xsl:value-of select="$subsp"/>
        <method>media</method>

        <xsl:apply-templates select="description">
          <xsl:with-param name="sp" select="$subsp"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="mediaType">
          <xsl:with-param name="sp" select="$subsp"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="requestURL">
          <xsl:with-param name="sp" select="$subsp"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>

        <xsl:value-of select="$sp"/>
      </xsl:element>

   </xsl:template>

   <!-- default template -->
   <xsl:template match="*" priority="-1">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>

      <xsl:value-of select="$sp"/>

      <xsl:copy>
         <xsl:for-each select="@*">
            <xsl:copy/>
         </xsl:for-each>

         <xsl:apply-templates select="child::node()">
            <xsl:with-param name="sp" select="concat($sp,$step)"/>
            <xsl:with-param name="step" select="$step"/>
         </xsl:apply-templates>

         <xsl:if test="$prettyPrint and contains(text()[1],$cr)">
           <xsl:value-of select="$sp"/>
         </xsl:if>
      </xsl:copy>
      
   </xsl:template>

   <!--
     -  template for handling ignorable whitespace
     -->
   <xsl:template match="text()" priority="-1">
      <xsl:variable name="trimmed" select="normalize-space(.)"/>
      <xsl:if test="not($prettyPrint) or string-length($trimmed) &gt; 0">
         <xsl:copy/>
      </xsl:if>
   </xsl:template>

   <xsl:template match="text()" priority="-1" mode="trim">
      <xsl:if test="not($prettyPrint)">
         <xsl:choose>
            <xsl:when test="contains(.,$cr)">
               <xsl:value-of select="$cr"/>
               <xsl:call-template name="afterLastCR">
                  <xsl:with-param name="text" select="."/>
               </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
               <xsl:copy/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:if>
   </xsl:template>


</xsl:stylesheet>
