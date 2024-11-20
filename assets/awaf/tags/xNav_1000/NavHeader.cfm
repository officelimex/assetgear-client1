<!--- Author:	Arowolo Abiodun M.
----- Created	26/02/2012
----- Updated	26/02/2012
----- Copyright	adexfe systems (c) 2009
----- About		xTab Coldfusion custom tag --->

<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start"> 
	<cfparam name="Attributes.TagName" type="string" default="NavHeader"/>  
 	<cfparam name="Attributes.Title" type="string"/>  
<li class="nav-header">#Attributes.Title#</li>
</cfif>  
</cfoutput>