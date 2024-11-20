<!--- Author:	Arowolo Abiodun M.
----- Created	26/02/2012
----- Updated	26/02/2012
----- Copyright	adexfe systems (c) 2009
----- About		xTab Coldfusion custom tag --->

<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start"> 
	<cfparam name="Attributes.TagName" type="string" default="Button"/>
    <cfparam name="Attributes.id" type="string" default="_#CreateUUID()#"/>
    <cfparam name="Attributes.value" type="string" default="Save"/>
    <cfparam name="Attributes.class" type="string" default="btn-primary"/>
    <cfparam name="Attributes.formId" type="string" /> 
    
 	<cfset ArrayAppend(request.nav.navitem[ArrayLen(request.nav.navitem)].window.buttons, Attributes)/> 
         
<cfelse>
 
</cfif> 
</cfoutput>