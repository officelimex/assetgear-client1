<!--- Author:	Arowolo Abiodun M.
----- Created	26/02/2012
----- Updated	26/02/2012
----- Copyright	adexfe systems (c) 2009
----- About		xNav Coldfusion custom tag --->

<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start"> 
	<cfparam name="Attributes.TagName" type="string" default="NavTab"> 
	<cfparam name="Attributes.renderTo" type="string">
    <cfparam name="Attributes.align" type="string" default="">
 	
    <cfset request.nav.navitem = ArrayNew(1)/>
<div id="#Attributes.renderTo#"/>
<!---<div class="well" style="padding: 8px 0; margin-top:30px" id="#Attributes.renderTo#_nav"/>--->

<script type="text/javascript">
document.addEvent('domready', function() {
 	var nt#left(CreateUUID(),8)# = new aNavigateTab('#Attributes.renderTo#', { align:'#Attributes.align#',
  
<cfelse>
 
	}); 
});
</script>

</cfif>  
</cfoutput>