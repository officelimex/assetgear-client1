<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">
  
    <cfparam name="Attributes.TagName" type="string" default="Command"/>
    <cfparam name="Attributes.id" type="string"/>
    <cfparam name="Attributes.text" type="string" default=""/> 
    <cfparam name="Attributes.icon" type="string" default=""/>
    <cfparam name="Attributes.help" type="string" default=""/> 
    <cfparam name="Attributes.pin" type="boolean" default="false"/>
    <cfparam name="Attributes.class" type="string" default="btn btn-small "/>
    <cfparam name="Attributes.condition" type="string" default=""/>
 	<cfassociate basetag="cf_Commands" />
        
<!---    <cfif Attributes.Field eq "">
    	<cfthrow  message="Field for the Tag 'Column' was not Empty.">
    </cfif>--->
 
    <cfset lp = ""/>
    <cfset lp = ListAppend(lp,'id: "#Attributes.id#"')/>
	<cfif Attributes.text neq ""><cfset lp = ListAppend(lp,'text: "#Attributes.text#"')/></cfif>
    <cfif Attributes.icon neq ""><cfset lp = ListAppend(lp,'icon: "#Attributes.icon#"')/></cfif>
    <cfif Attributes.help neq ""><cfset lp = ListAppend(lp,'help: "#Attributes.help#"')/></cfif>
    <cfif Attributes.condition neq ""><cfset lp = ListAppend(lp,'condition: "#Attributes.condition#"')/></cfif>
    <cfset lp = ListAppend(lp,'pin: #Attributes.pin#')/>
	<cfset lp = ListAppend(lp,'class: "#Attributes.class#"')/>	
    {#lp#},             
    
    <cfset ArrayAppend(request.grid.commands,Attributes)/> 
 
</cfif> 
</cfoutput>