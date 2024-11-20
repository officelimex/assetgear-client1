<!--- Author:	Arowolo Abiodun M.
----- Created	26/02/2012
----- Updated	26/02/2012
----- Copyright	adexfe systems (c) 2009
----- About		xTab Coldfusion custom tag --->

<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start"> 
	<cfparam name="Attributes.TagName" type="string" default="NavItem"/> 
    <cfparam name="Attributes.id" type="string" default="_#CreateUUID()#"/>
    <cfparam name="Attributes.icon" type="string" default=""/>
    <cfparam name="Attributes.title" type="string" default=""/>
    <cfparam name="Attributes.url" type="string" default=""/>
    <cfparam name="Attributes.type" type="string" default=""/><!---normal, divider--->
    <cfparam name="Attributes.isactive" type="boolean" default="false"/>
     
 	<cfset ArrayAppend(request.nav.navitem, Attributes)/> 
    <cfswitch expression="#Attributes.type#">
    	<cfcase value="divider">
        	{type:'divider'},
    	</cfcase>
        <cfcase value="header">
        	{title:'#Attributes.title#', type:'header'},
        </cfcase>
        <cfcase value="new window"> 
        	{title:'#Attributes.title#', type:'new window', url: '#Attributes.url#'},
        </cfcase>
        <cfdefaultcase>
        	{title:'#Attributes.title#'<cfif Attributes.isactive>, isactive:true</cfif><cfif len(trim(Attributes.url))>, url: '#Attributes.url#'</cfif>, id:'#Attributes.id#'}, 
        </cfdefaultcase>
    </cfswitch>
<cfelse>
 
</cfif> 
</cfoutput>