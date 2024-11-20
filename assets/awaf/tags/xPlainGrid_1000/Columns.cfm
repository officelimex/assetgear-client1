<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">
  
    <cfparam name="Attributes.TagName" type="string" default="Columns"/> 
 	   
	<cfset request.PlainGrid.columns = ArrayNew(1)/>   
     
<!--- close tag --->   
<cfelse>
 
</cfif> 
</cfoutput>