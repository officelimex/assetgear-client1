<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">
  
    <cfparam name="Attributes.TagName" type="string" default="Category"/>
    <cfparam name="Attributes.name" type="string"/> 
    
    <cfassociate basetag="cf_Categories" /> 
   
<cfelse> 
 	<cfset request.chart.xmldata = request.chart.xmldata &  "<category name='#Attributes.name#'/>"/>
</cfif> 
</cfoutput>