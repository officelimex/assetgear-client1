<!--- Author:	Arowolo Abiodun M.
----- Created	26/02/2012
----- Updated	26/02/2012
----- Copyright	adexfe systems (c) 2009
----- About		xTab Coldfusion custom tag --->
 
<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">  
    <cfparam name="Attributes.TagName" type="string" default="TabRequest"/>
    <cfparam name="Attributes.id" type="string"/>
    <cfparam name="Attributes.title" type="string"/>
    <cfparam name="Attributes.url" type="string"/>
     
	tb.newTab('#Attributes.id#', '#Attributes.title#','#Attributes.url#'); 

</cfif>
</cfoutput>