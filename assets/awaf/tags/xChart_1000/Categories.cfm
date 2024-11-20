<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">
  
    <cfparam name="Attributes.TagName" type="string" default="Categories"/> 
 	
    <cfassociate basetag="cf_Chart"/>
    
	<cfset request.chart.xmldata = request.chart.xmldata &  "<categories>"/> 
    
<!--- close tag --->   
<cfelse>
    
    <cfset request.chart.xmldata = request.chart.xmldata & "</categories>"/> 
 
</cfif> 
</cfoutput>