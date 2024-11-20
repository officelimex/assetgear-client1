<!--- Author:	Arowolo Abiodun M.
----- Created	26/02/2012
----- Updated	26/02/2012
----- Copyright	adexfe systems (c) 2009
----- About		xTab Coldfusion custom tag --->

<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start"> 
	<cfparam name="Attributes.TagName" type="string" default="Window"/>
    <cfparam name="Attributes.renderTo" type="string" />  
    <cfparam name="Attributes.tabid" type="string"/>
    
    $$('.#Attributes.renderTo#').adopt(tb.render()); 
    tb.showTab('#Attributes.tabid#'); 
</cfif> 
</cfoutput>