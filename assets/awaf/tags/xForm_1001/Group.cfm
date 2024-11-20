<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">
    <cfparam name="Attributes.TagName" type="string" default="c"/>  
    <cfparam name="Attributes.title" type="string" default=""/> 
  
  <fieldset>
    <legend>#Attributes.title#</legend>
<cfelse>
</fieldset>     
</cfif> 
</cfoutput>