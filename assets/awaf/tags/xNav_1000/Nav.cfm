<!--- Author:	Arowolo Abiodun M.
----- Created	26/02/2012
----- Updated	26/02/2012
----- Copyright	adexfe systems (c) 2009
----- About		xNav Coldfusion custom tag --->

<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start"> 
	<cfparam name="Attributes.TagName" type="string" default="Nav"> 
	<cfparam name="Attributes.renderTo" type="string">
 	
    <cfset request.nav.navitem = ArrayNew(1)/>

<div class="well" style="padding:8px 0;margin-top:10px; overflow-y:auto;" id="#Attributes.renderTo#_nav"></div>

<script type="text/javascript">
document.addEvent('domready', function() { 
	$("#Attributes.renderTo#_nav").setStyle('height',window.getSize().y	- 175+'px');
 	var n#left(CreateUUID(),8)# = new aNavigate('#Attributes.renderTo#', {
		items:[
<cfelse>
		]
	}); 
});
</script>

</cfif> 
</cfoutput>