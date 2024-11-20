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
    <cfparam name="Attributes.Window" type="string" default=""/>
     
 	<cfset ArrayAppend(request.nav.navitem, Attributes)/> 
 
<li><a id="#Attributes.id#"><cfif Attributes.icon neq ""><i class="icon-#Attributes.icon#"></i> </cfif>#Attributes.title#</a></li>  
<cfelse>
 
</cfif> 
</cfoutput>