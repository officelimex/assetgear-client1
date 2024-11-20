<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">
   
    <cfparam name="Attributes.value" type="string"/> 
    <cfparam name="Attributes.caption" type="string" default="#Attributes.value#"/> 
    <cfparam name="Attributes.format" type="string" default="string"/>
    <cfparam name="Attributes.nowrap" type="boolean" default="false"/>
	<cfparam name="Attributes.delimiters" type="string" default="|"/>
    <cfif Attributes.format eq "money">
    	<cfparam name="Attributes.align" type="string" default="right"/>
    <cfelse>
    	<cfparam name="Attributes.align" type="string" default=""/>
    </cfif>
    
    <cfassociate basetag="cf_Columns" /> 
             
 	<cfset ArrayAppend(request.PlainGrid.columns,Attributes)/>
 
 	
</cfif> 
</cfoutput>