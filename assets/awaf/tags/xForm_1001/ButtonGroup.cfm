<!--- Author:	Arowolo Abiodun M.
----- Created	17/02/2012
----- Updated	17/02/2012
----- Copyright	adexfe systems (c) 2009
----- About		Coldfusion custom tag for AWAF --->

<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">  

	<cfparam name="Attributes.renderTo" type="string" default="#request.form.formid#"/>   
 	 <div id="#Attributes.renderTo#_bg" style="position:absolute;bottom:0px;right:30px;padding:5px 0px 5px 5px;"></div>    
<script type="text/javascript" charset="utf-8">
	document.addEvent('domready', function() { 
	
<cfelse>  

});
</script>	 
</cfif> 
</cfoutput>