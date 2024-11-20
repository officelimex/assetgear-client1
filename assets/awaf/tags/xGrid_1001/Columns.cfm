<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">
  
    <cfparam name="Attributes.TagName" type="string" default="Columns"/> 
 	
    <cfassociate basetag="cf_Grid"/>
    
	<cfset request.grid.columns = ArrayNew(1)/>
    
 	columns: [     
     
<!--- close tag --->   
<cfelse>
    ], 
 
</cfif> 
</cfoutput>