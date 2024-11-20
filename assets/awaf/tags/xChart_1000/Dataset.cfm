<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">
  
    <cfparam name="Attributes.TagName" type="string" default="Dataset"/> 
 	<cfparam name="Attributes.seriesName" type="string"/>
    <cfparam name="Attributes.parentYAxis" type="string" default=""/><!--- P,S--->
    <cfparam name="Attributes.color" type="string" default=""/><!--- P,S--->
    <cfparam name="Attributes.numberPrefix" type="string" default=""/>
    <cfparam name="Attributes.showValues" type="string" default=""/> 
    <cfparam name="Attributes.numberPrefix" type="string" default=""/>
    <cfparam name="Attributes.numberSuffix" type="string" default=""/>
    
    <cfassociate basetag="cf_Chart"/>
    <cfset nval = ""/>
    <cfif Attributes.numberSuffix neq ""><cfset nval = "numberSuffix='#Attributes.numberSuffix#'"/></cfif>
    <cfif Attributes.numberPrefix neq ""><cfset nval = "numberPrefix='#Attributes.numberPrefix#'"/></cfif>
    <cfif Attributes.showValues neq ""><cfset nval = "showValues='#Attributes.showValues#'"/></cfif>
    <cfif Attributes.parentYAxis neq ""><cfset nval = "parentYAxis='#Attributes.parentYAxis#'"/></cfif>
    <cfif Attributes.color neq ""> 
    	<!---<cfset c = CreateObject("component","assetgear.com.awaf.util.color").RandColor()/>--->
        <cfset nval = nval & "color='#Attributes.color#'"/>
    </cfif>
    <cfif Attributes.numberPrefix neq ""><cfset nval = nval & "color='#Attributes.numberPrefix#'"/></cfif>
    
	<cfset request.chart.xmldata = request.chart.xmldata &  "<dataset seriesName='#Attributes.seriesName#' #nval#>"/>
    
<!--- close tag --->   
<cfelse>
    
    <cfset request.chart.xmldata = request.chart.xmldata & "</dataset>"/> 
 
</cfif> 
</cfoutput>