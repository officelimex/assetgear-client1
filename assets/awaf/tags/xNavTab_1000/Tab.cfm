<!--- Author:	Arowolo Abiodun M.
----- Created	26/02/2012
----- Updated	26/02/2012
----- Copyright	adexfe systems (c) 200
----- About		xNav Coldfusion custom tag --->

<cfoutput> 
<cfif ThisTag.ExecutionMode EQ "Start"> 
	<cfparam name="Attributes.TagName" type="string" default="Tab"> 
		tabs:[
  
<cfelse>

		],
</cfif> 
</cfoutput>        