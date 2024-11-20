<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">
  
    <cfparam name="Attributes.TagName" type="string" default="Column"/>
    <cfparam name="Attributes.Id" type="string" default=""/> 
    <cfparam name="Attributes.caption" type="string" default="#Attributes.Id#"/>
    <cfparam name="Attributes.field" type="string" default="#Attributes.Id#"/> 
    <cfparam name="Attributes.searchable" type="boolean" default="false"/>
    <cfparam name="Attributes.sortable" type="boolean" default="false"/>
    <cfparam name="Attributes.hide" type="boolean" default="false"/> 
    <cfparam name="Attributes.template" type="string" default=""/> 
    <cfparam name="Attributes.nowrap" type="boolean" default="false"/>
    
    <cfassociate basetag="cf_Columns" /> 
 
<!---    <cfif Attributes.Field eq "">
    	<cfthrow  message="Field for the Tag 'Column' was not Empty.">
    </cfif>--->
 
    <cfset lp = ""/>
	<cfif Attributes.Id neq ""><cfset lp = ListAppend(lp,'id: "#Attributes.Id#"')/></cfif>
    <cfif Attributes.caption neq ""><cfset lp = ListAppend(lp,'caption: "#Attributes.caption#"')/></cfif>
    <cfif Attributes.field neq ""><cfset lp = ListAppend(lp,'field: "#Attributes.field#"')/></cfif>
    <cfif Attributes.searchable eq true><cfset lp = ListAppend(lp,'searchable: #Attributes.searchable#')/></cfif>
    <cfif Attributes.sortable eq true><cfset lp = ListAppend(lp,'sortable: #Attributes.sortable#')/></cfif>
    <cfif Attributes.hide eq true><cfset lp = ListAppend(lp,'hide: #Attributes.hide#')/></cfif>
    <cfif Attributes.template neq ""><cfset lp = ListAppend(lp,'template: "#Attributes.template#"')/></cfif>
    <cfif Attributes.nowrap><cfset lp = ListAppend(lp,'nowrap:#Attributes.nowrap#')/></cfif>
    {#lp#},             
 	<cfset ArrayAppend(request.grid.columns,Attributes)/>
 
 	
</cfif> 
</cfoutput>