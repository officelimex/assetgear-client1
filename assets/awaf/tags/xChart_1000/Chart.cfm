<!--- Author:	Arowolo Abiodun M.
----- Created	20/07/2012
----- Updated	20/07/2012
----- Copyright	adexfe systems (c) 2009
----- About		Coldfusion custom tag for AWAF --->

<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">
    <cfparam name="Attributes.width" type="string"/>
    <cfparam name="Attributes.height" type="string"/>
    <cfparam name="Attributes.type" type="string"/><!--- FCF_     Column3D --->
    <cfparam name="Attributes.caption" type="string" default=""/>
    <cfparam name="Attributes.xAxisName" type="string" default=""/>
    <cfparam name="Attributes.yAxisName" type="string" default=""/>
    <cfparam name="Attributes.showValues" type="string" default="0"/>
    <cfparam name="Attributes.numberPrefix" type="string" default=""/>
    <cfparam name="Attributes.decimalPrecision" type="string" default="0"/>
    <cfparam name="Attributes.bgcolor" type="string" default="ffffff"/>
    <cfparam name="Attributes.bgAlpha" type="string" default=""/>
    <cfparam name="Attributes.showColumnShadow" type="string" default="0"/>
    <cfparam name="Attributes.showAlternateHGridColor" type="string" default="0"/>
    <cfparam name="Attributes.alternateHGridColor" type="string" default=""/><!--- f8f8f8---->
    <cfparam name="Attributes.alternateHGridAlpha" type="string" default=""/><!--- 60 --->
    <cfparam name="Attributes.canvasBorderThickness" type="string" default="0"/>
    <cfparam name="Attributes.canvasBorderColor" type="string" default="c5c5c5"/>
    <cfparam name="Attributes.divlinecolor" type="string" default="cfcfff"/><!--- c5c5c5---->
    <cfparam name="Attributes.PYAxisMaxValue" type="string" default=""/>
    <cfparam name="Attributes.PYAxisName" type="string" default=""/>
    <cfparam name="Attributes.SYAxisName" type="string" default=""/>
 	<cfparam name="Attributes.showNames" type="string" default=""/>
    <cfparam name="Attributes.caption" type="string" default=""/>

    <cfset request.chart.xmldata = "<graph Attributes.caption='#Attributes.caption#' nameTBDistance='10' caption='#Attributes.caption#' PYAxisMaxValue='#Attributes.PYAxisMaxValue#' xAxisName='#Attributes.xAxisName#'
	yAxisName='#Attributes.yAxisName#' showValues='#Attributes.showValues#' PYAxisName='#Attributes.PYAxisName#' SYAxisName='#Attributes.SYAxisName#'
   numberPrefix='#Attributes.numberPrefix#' decimalPrecision='#Attributes.decimalPrecision#' bgcolor='#Attributes.bgcolor#' bgAlpha='#Attributes.bgAlpha#'
   showColumnShadow='#Attributes.showColumnShadow#' divlinecolor='#Attributes.divlinecolor#' divLineAlpha='60' showAlternateHGridColor='#Attributes.showAlternateHGridColor#'
   alternateHGridColor='#Attributes.alternateHGridColor#' alternateHGridAlpha='#Attributes.alternateHGridAlpha#'
   canvasBorderThickness='#Attributes.canvasBorderThickness#' canvasBorderColor='#Attributes.canvasBorderColor#'"/>

   <cfif Attributes.showNames neq ""><cfset request.chart.xmldata = request.chart.xmldata & " showNames='#Attributes.showNames#'"/></cfif>

   <cfset request.chart.xmldata = request.chart.xmldata & ">"/>
<!--- close tag --->
<cfelse>

   	<cfset request.chart.xmldata = request.chart.xmldata & "</graph>"/>
    <!---<cfdump var="#request.chart.xmldata#"/>--->
	<cfset gR = createobject("component","assetgear.com.awaf.util.Random").init()/>
    <cfset id1 = gR.RandValue(8,'alphabets')/>
    <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="#Attributes.width#" height="#Attributes.height#" id="#id1#">
    	<param name="wmode" value="transparent">
        <param name="menu" value="false" />
        <param name="movie" value="#application.site.url#assets/awaf/FusionCharts/FCF_#Attributes.type#.swf" />
        <param name="FlashVars" value="&dataXML=#request.chart.xmldata#&chartWidth=#Attributes.width#&chartHeight=#Attributes.height#">
        <param name="quality" value="best"/>
        <embed wmode="transparent" menu="false" quality="best" src="#application.site.url#assets/awaf/FusionCharts/FCF_#Attributes.type#.swf" flashVars="&dataXML=#request.chart.xmldata#&chartWidth=#Attributes.width#&chartHeight=#Attributes.height#" quality="high" width="#Attributes.width#" height="#Attributes.height#" name="#Attributes.type#" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
    </object>

</cfif>
</cfoutput>
