<!--- Author:	Arowolo Abiodun M.
----- Created	26/02/2012
----- Updated	26/02/2012
----- Copyright	adexfe systems (c) 2009
----- About		xTab Coldfusion custom tag --->

<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start"> 
	<cfparam name="Attributes.TagName" type="string" default="Window"/>
    <cfparam name="Attributes.title" type="string" default=""/>  
    <cfparam name="Attributes.id" type="string" default="_#CreateUUID()#"/>
    <cfparam name="Attributes.Height" type="string" default="300px"/>
    <cfparam name="Attributes.Width" type="string" default="550px"/>    
    <cfparam name="Attributes.url" type="string" />
    <cfparam name="Attributes.Buttons" type="array" default="#ArrayNew(1)#"/>
    
    <cfset request.nav.navitem[ArrayLen(request.nav.navitem)].window = Attributes/>
      
<cfelse>
</cfif> 
</cfoutput>