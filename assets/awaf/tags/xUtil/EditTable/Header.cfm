<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">
  
    <cfparam name="Attributes.TagName" type="string" default="Header"/>
    <cfparam name="Attributes.title" type="string" default=""/>
    <cfparam name="Attributes.size" type="numeric" default="3"/><!--- as in span[?]---> 
 	
    <cfassociate basetag="cf_Header"/>
    
 	{'title': '#Attributes.title#', 'size': #Attributes.size#}
<cfelse>
    ,
 
</cfif> 
</cfoutput>