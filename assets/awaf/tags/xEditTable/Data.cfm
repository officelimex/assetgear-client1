<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">
  
    <cfparam name="Attributes.TagName" type="string" default="Data"/>
    <cfparam name="Attributes.ListValue" type="string" default=""/> 
    <cfparam name="Attributes.ListDisplay" type="string" default="#Attributes.ListValue#"/>
    <cfparam name="Attributes.delimiters" type="string" default=","/>  
	<cfparam name="Attributes.Selected" type="string" default=""/>
 
    <cfset llen = listlen(Attributes.ListValue,Attributes.delimiters)/>
    <cfset dlen = listlen(Attributes.ListDisplay,Attributes.delimiters)/>
    <cfset e=0/>
    <cfassociate basetag="cf_Content"/>
    
 	,data:[
    <cfloop list="#Attributes.ListValue#" delimiters="#Attributes.delimiters#" index="i">
		<cfset e++/>
        
        <cfset d = ListGetAt(Attributes.ListDisplay,e,Attributes.delimiters)/>
        
    	[#SerializeJSON(i)#,#SerializeJSON(d)#]<cfif llen neq e>,</cfif>
    </cfloop>    
    ]
<cfelse>
</cfif> 
</cfoutput>