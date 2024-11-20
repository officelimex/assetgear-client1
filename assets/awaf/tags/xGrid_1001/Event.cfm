<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">

    <cfparam name="Attributes.TagName" type="string" default="Event"/>
    <cfparam name="Attributes.Command" type="string"/>
 
    <cfassociate basetag="cf_Grid" /> 
    
 	_g.addEvent('#Attributes.Command#click', function(tr,d,e)	{
  
          
<cfelse>
 	});
</cfif> 
</cfoutput>