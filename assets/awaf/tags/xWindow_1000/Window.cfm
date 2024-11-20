<!--- Author:	Arowolo Abiodun M.
----- Created	26/02/2012
----- Updated	26/02/2012
----- Copyright	adexfe systems (c) 2009
----- About		xTab Coldfusion custom tag --->

<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start"> 
	<cfparam name="Attributes.TagName" type="string" default="Window"/>    
    <cfparam name="Attributes.Caption" type="string" default="Link"/> 
    <cfparam name="Attributes.title" type="string" default="#Attributes.Caption#"/>
    <cfparam name="Attributes.renderTo" type="string" default=""/> 
    <cfparam name="Attributes.URL" type="string"/>
    <cfparam name="Attributes.modal" type="string" default="true"/>
    <cfparam name="Attributes.Height" type="string" default="300px"/>
    <cfparam name="Attributes.Width" type="string" default="600px"/>
    
<cfset gR = createobject("component","assetgear.com.awaf.util.Random").init()/>
<cfset id1 = gR.RandValue(8,'alphabets')/>
<cfset request.window.id = gR.RandValue(7,'alphabets')/> 
<script language="Javascript" type="text/javascript"> 
	window.addEvent('domready', function(){
		$('#id1#').addEvent('click', function(){
			_w = new aWindow('#request.window.id#',{
				<cfif Attributes.renderTo neq "">
					renderTo:#Attributes.renderTo#,
				</cfif>
				title : '#Attributes.title#', modal:#Attributes.modal#,
				url : '#Attributes.URL#',
				size : {
					width : '#Attributes.Width#', height : '#Attributes.Height#'
				}
			}); 
<cfelse>
		}); 
	});
</script>
<span id="#id1#">#Attributes.Caption#</span>
</cfif> 
</cfoutput>