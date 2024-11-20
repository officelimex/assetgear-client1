<!--- Author:	Arowolo Abiodun M.
----- Created	26/02/2012
----- Updated	26/02/2012
----- Copyright	adexfe systems (c) 2009
----- About		xTab Coldfusion custom tag --->

<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start"> 
	<cfparam name="Attributes.TagName" type="string" default="Item"/> 
    <cfparam name="Attributes.id" type="string" default=""/> 
    <cfparam name="Attributes.title" type="string" default=""/> 
    <cfparam name="Attributes.isactive" type="boolean" default="false"/>
 
        	{title:'#Attributes.title#'<cfif Attributes.isactive>, isactive:true</cfif><cfif Attributes.id neq "">, id:'#Attributes.id#'</cfif>}, 
 
<cfelse>
 
</cfif> 
</cfoutput>