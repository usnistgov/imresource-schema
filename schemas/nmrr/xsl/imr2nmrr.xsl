<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:immi="http://schema.bipm.org/xml/imres/nmrr/nmi/1.0wd"
                xmlns:imdb="http://schema.bipm.org/xml/imres/nmrr/database/1.0wd"
                xmlns:imds="http://schema.bipm.org/xml/imres/nmrr/dataset/1.0wd"
                xmlns:imdp="http://schema.bipm.org/xml/imres/nmrr/portal/1.0wd"
                xmlns:imsv="http://schema.bipm.org/xml/imres/nmrr/service/1.0wd"
                xmlns:imsw="http://schema.bipm.org/xml/imres/nmrr/software/1.0wd"
                xmlns:IMR="http://schema.bipm.org/xml/imres/1.0wd"
                xmlns:NMI="http://schema.bipm.org/xml/imres/nmi/1.0wd"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                exclude-result-prefixes="IMR NMI immi imdb imds imdp imsv imsw"
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
     -  output namespace prefix
     -  ========================================================== -->

   <xsl:variable name="rns">
     <xsl:choose>
       <xsl:when test="/IMR:Resource[contains(@xsi:type,':MetrologyInstitute') or
            normalize-space(/*/resourceType)='Organization: Metrology Institute']">
         <xsl:text>immi</xsl:text>
       </xsl:when>
       <xsl:when test="IMR:Resource[contains(@xsi:type,':Database') or
                                (contains(@xsi:type,':MetrologyData') and 
                                 contains(resourceType,'Dataset: Database'))]">
         <xsl:text>imdb</xsl:text>
       </xsl:when>
       <xsl:when test="IMR:Resource[contains(@xsi:type,':Dataset') or
                                  (contains(@xsi:type,':MetrologyData') and 
                                   normalize-space(resourceType)='Dataset')]">
         <xsl:text>imds</xsl:text>
       </xsl:when>
       <xsl:when test="IMR:Resource[contains(@xsi:type,':Portal') or
                                  (contains(@xsi:type,':MetrologyData') and 
                                   normalize-space(resourceType)='InteractiveResource: DataPortal')]">
         <xsl:text>imdp</xsl:text>
       </xsl:when>
       <xsl:when test="IMR:Resource[contains(@xsi:type,':Service') or
                                  (contains(@xsi:type,':MetrologyData') and 
                                   normalize-space(resourceType)='Service')]">
         <xsl:text>imsv</xsl:text>
       </xsl:when>
       <xsl:when test="IMR:Resource[contains(@xsi:type,':Software') or
                                  (contains(@xsi:type,':MetrologyData') and 
                                   normalize-space(resourceType)='Software')]">
         <xsl:text>imsw</xsl:text>
       </xsl:when>
     </xsl:choose>
   </xsl:variable>

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

   <xsl:template match="IMR:Resource[contains(@xsi:type,':MetrologyInstitute') or
            normalize-space(resourceType)='Organization: Metrology Institute']">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>

      <immi:Resource status="{@status}" localid="{@localid}">
        
        <xsl:apply-templates select="resourceType">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="title">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="altTitle[@type='Abbreviation']">
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
        <xsl:apply-templates select="date">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>

        <xsl:value-of select="$sp"/>

      </immi:Resource>
   </xsl:template>

   <xsl:template match="IMR:Resource[contains(@xsi:type,':Database')]|
                        IMR:Resource[contains(@xsi:type,':MetrologyData') and 
                                    contains(resourceType,'Dataset: Database')]">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>

      <imdb:Resource status="{@status}" localid="{@localid}">
        
        <xsl:apply-templates select="resourceType">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="title">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="altTitle[@type='Subtitle']">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="altTitle[@type='Abbreviation']">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="publisher">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="sponsoringCountry">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="publicationYear">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="." mode="IDorURL">
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
        <xsl:apply-templates select="date">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="measures">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="access">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>

        <xsl:value-of select="$sp"/>

      </imdb:Resource>
   </xsl:template>

   <xsl:template match="IMR:Resource[contains(@xsi:type,':Dataset')]|
                        IMR:Resource[contains(@xsi:type,':MetrologyData') and 
                                     normalize-space(resourceType)='Dataset']">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>

      <imds:Resource status="{@status}" localid="{@localid}">

        <xsl:apply-templates select="resourceType">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="title">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="altTitle[@type='Subtitle']">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="altTitle[@type='Abbreviation']">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="publisher">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="sponsoringCountry">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="publicationYear">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="." mode="IDorURL">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="contact">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="creator">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="contributor">
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
        <xsl:apply-templates select="date">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="measures">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="access">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>

        <xsl:value-of select="$sp"/>

      </imds:Resource>
   </xsl:template>

   <xsl:template match="IMR:Resource[contains(@xsi:type,':Service')]|
                        IMR:Resource[contains(@xsi:type,':MetrologyData') and 
                                    contains(resourceType,'Service')]">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>

      <imsv:Resource status="{@status}" localid="{@localid}">
        
        <xsl:apply-templates select="resourceType">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="title">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="altTitle[@type='Subtitle']">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="altTitle[@type='Abbreviation']">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="publisher">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="sponsoringCountry">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="publicationYear">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="." mode="IDorURL">
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
        <xsl:apply-templates select="date">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="measures">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="access" mode="service">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>

        <xsl:value-of select="$sp"/>

      </imsv:Resource>
   </xsl:template>

   <xsl:template match="access" mode="service">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>

      <xsl:value-of select="$sp"/>

      <access>

        <xsl:apply-templates select="." mode="terms">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="via[contains(@xsi:type,':ServiceAPI')]">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>

        <xsl:value-of select="$sp"/>

      </access>
      
   </xsl:template>

   <xsl:template match="access" mode="terms">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>

      <xsl:apply-templates select="*[local-name()!='via']">
         <xsl:with-param name="sp" select="$sp"/>
         <xsl:with-param name="step" select="$step"/>
      </xsl:apply-templates>
   </xsl:template>

   <xsl:template match="IMR:Resource[contains(@xsi:type,':Software')]|
                        IMR:Resource[contains(@xsi:type,':MetrologyData') and 
                                     normalize-space(resourceType)='Software']">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>

      <imsw:Resource status="{@status}" localid="{@localid}">

        <xsl:apply-templates select="resourceType">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="title">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="altTitle[@type='Subtitle']">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="altTitle[@type='Abbreviation']">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="publisher">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="sponsoringCountry">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="publicationYear">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="." mode="IDorURL">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="contact">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="creator">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="contributor">
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
        <xsl:apply-templates select="date">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="measures">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="access" mode="software">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>

        <xsl:value-of select="$sp"/>

      </imsw:Resource>
   </xsl:template>

   <xsl:template match="access" mode="software">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>

      <xsl:value-of select="$sp"/>

      <access>

        <xsl:apply-templates select="." mode="terms">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="via[contains(@xsi:type,':Media') or
                                         contains(@xsi:type,':Download')]">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>

        <xsl:value-of select="$sp"/>

      </access>
      
   </xsl:template>

   <xsl:template match="IMR:Resource[contains(@xsi:type,':Portal')]|
                        IMR:Resource[contains(@xsi:type,':MetrologyData') and 
              normalize-space(resourceType)='InteractiveResource: Portal']">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>

      <imdp:Resource status="{@status}" localid="{@localid}">

        <xsl:apply-templates select="resourceType">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="title">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="altTitle[@type='Subtitle']">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="altTitle[@type='Abbreviation']">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="publisher">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="sponsoringCountry">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="publicationYear">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="." mode="IDorURL">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="contact">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="creator">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="contributor">
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
        <xsl:apply-templates select="date">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="measures">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="access" mode="portal">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>

        <xsl:value-of select="$sp"/>

      </imdp:Resource>
   </xsl:template>

   <xsl:template match="access" mode="portal">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>

      <xsl:value-of select="$sp"/>

      <access>

        <xsl:apply-templates select="." mode="terms">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>

        <xsl:value-of select="$sp"/>

      </access>
      
   </xsl:template>

   <xsl:template match="sponsoringCountry">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>

      <xsl:variable name="subsp" select="concat($sp,$step)"/>

      <xsl:value-of select="$sp"/>

      <sponsoringCountry>
        <xsl:value-of select="$subsp"/>
        <name><xsl:value-of select="."/></name>
        <xsl:value-of select="$subsp"/>
        <abbrev><xsl:value-of select="@abbrev"/></abbrev>
        <xsl:value-of select="$sp"/>
      </sponsoringCountry>
   </xsl:template>

   <xsl:template match="altTitle[@type='Abbreviation']">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>

      <xsl:value-of select="$sp"/>

      <abbreviation><xsl:value-of select="."/></abbreviation>
   </xsl:template>

   <xsl:template match="altTitle[@type='Subtitle']">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>

      <xsl:value-of select="$sp"/>

      <subtitle><xsl:value-of select="."/></subtitle>
   </xsl:template>

   <xsl:template match="*" mode="IDorURL">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>
      <xsl:variable name="subsp" select="concat($sp,$step)"/>

      <xsl:choose>
         <xsl:when test="identifier[@type='DOI']">
            <xsl:value-of select="$sp"/>
            <homePage xsi:type="{$rns}:DOI">
               <xsl:value-of select="$subsp"/>
               <doi><xsl:value-of select="identifier[@type='DOI']"/></doi>
               <xsl:value-of select="$sp"/>
            </homePage>
         </xsl:when>
         <xsl:when test="homeURL">
            <xsl:value-of select="$sp"/>
            <homePage xsi:type="{$rns}:HomePageURL">
               <xsl:value-of select="$subsp"/>
               <url><xsl:value-of select="homeURL"/></url>
               <xsl:value-of select="$sp"/>
            </homePage>
         </xsl:when>
      </xsl:choose>
   </xsl:template>

<!--
   <xsl:template match=""></xsl:template>
   <xsl:template match=""></xsl:template>
   <xsl:template match=""></xsl:template>
   -->

   <xsl:template match="description">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>

      <xsl:value-of select="$sp"/>

      <description><xsl:value-of select="."/></description>
   </xsl:template>

   <xsl:template match="date">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>

      <xsl:value-of select="$sp"/>

      <date><xsl:value-of select="."/></date>
   </xsl:template>

   <xsl:template match="via[contains(@xsi:type,':')]" priority="0">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>
      <xsl:param name="type">
         <xsl:value-of select="substring-after(@xsi:type,':')"/>
      </xsl:param>

<!--
      <xsl:variable name="method">
        <xsl:choose>
          <xsl:when test="$type='Media'">media</xsl:when>
          <xsl:when test="$type='ServiceAPI'">service API</xsl:when>
          <xsl:when test="$type='Download'">download</xsl:when>
          <xsl:otherwise><xsl:value-of select="$type"/></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
 -->
      <xsl:value-of select="$sp"/>

      <via xsi:type="{substring-after(@xsi:type,':')}">
        <xsl:apply-templates select="*[local-name()!='method' and 
                                       local-name()!='description']">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="description">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:value-of select="$sp"/>
      </via>
   </xsl:template>

   <xsl:template match="via[contains(@xsi:type,':Media')]">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>
      <xsl:param name="type">
         <xsl:value-of select="substring-after(@xsi:type,':')"/>
      </xsl:param>

      <xsl:value-of select="$sp"/>

      <via xsi:type="{$rns}:{$type}">
        <xsl:apply-templates select="*[local-name()!='method' and 
                                       local-name()!='description']">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="description">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:value-of select="$sp"/>
      </via>
   </xsl:template>

   <xsl:template match="mediaType">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>

      <xsl:param name="mtype">
         <xsl:choose>
           <xsl:when test=".='CD'">CD/CDROM</xsl:when>
           <xsl:when test=".='CDROM'">CD/CDROM</xsl:when>
           <xsl:when test=".='DVD'">DVD/DVDROM</xsl:when>
           <xsl:when test=".='DVDROM'">DVD/DVDROM</xsl:when>
           <xsl:when test=".='flash'">flash drive</xsl:when>
           <xsl:otherwise><xsl:value-of select="mediaType"/></xsl:otherwise>
         </xsl:choose>
      </xsl:param>

      <xsl:value-of select="$sp"/>
      <mediaType><xsl:value-of select="$mtype"/></mediaType>
   </xsl:template>

   <xsl:template match="creator">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>
      <xsl:variable name="subsp" select="concat($sp,$step)"/>

      <xsl:value-of select="$sp"/>

      <creator>
        <xsl:apply-templates select="name">
          <xsl:with-param name="sp" select="$subsp"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="affiliation">
          <xsl:with-param name="sp" select="$subsp"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="identifier[@identifierScheme='ORCID']">
          <xsl:with-param name="sp" select="$subsp"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:value-of select="$sp"/>
      </creator>
   </xsl:template>

   <xsl:template match="contributor">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>
      <xsl:variable name="subsp" select="concat($sp,$step)"/>

      <xsl:value-of select="$sp"/>

      <contributor type="{@type}">
        <xsl:apply-templates select="name">
          <xsl:with-param name="sp" select="$subsp"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="affiliation">
          <xsl:with-param name="sp" select="$subsp"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="identifier">
          <xsl:with-param name="sp" select="$subsp"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:value-of select="$sp"/>
      </contributor>
   </xsl:template>

   <xsl:template match="via[contains(@xsi:type,':Download')]">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>
      <xsl:variable name="subsp" select="concat($sp,$step)"/>

      <xsl:value-of select="$sp"/>

      <via xsi:type="">
        <xsl:apply-templates select="format">
          <xsl:with-param name="sp" select="$subsp"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="accessURL">
          <xsl:with-param name="sp" select="$subsp"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="description">
          <xsl:with-param name="sp" select="$subsp"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
      </via>
   </xsl:template>

   <xsl:template match="via[contains(@xsi:type,':ServiceAPI')]">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>
      <xsl:variable name="subsp" select="concat($sp,$step)"/>

      <xsl:value-of select="$sp"/>

      <via xsi:type="">
        <xsl:apply-templates select="description">
          <xsl:with-param name="sp" select="$subsp"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="documentationURL">
          <xsl:with-param name="sp" select="$subsp"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
      </via>
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
