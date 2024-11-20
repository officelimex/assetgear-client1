<cfif ThisTag.ExecutionMode EQ "Start">
   
    <cfparam name="Attributes.align" type="string" default="right"/>
    <cfparam name="Attributes.content" type="string"/>  
    
    <cfassociate basetag="cf_PlainGrid" />	
<cfelse>
 	<cfset request.PlainGrid.Footer = Attributes/> 
</cfif>