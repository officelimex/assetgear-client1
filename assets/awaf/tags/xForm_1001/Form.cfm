<!--- Author:	Arowolo Abiodun M.
----- Created	21/02/2012
----- Updated	21/02/2012
----- Copyright	adexfe systems (c) 2009
----- About		xForm Coldfusion custom tag --->
<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">  
     
	<cfparam name="Attributes.Id" type="string"> 
    <cfparam name="Attributes.action" type="string"> 
    <cfparam name="Attributes.class" type="string" default="form-horizontal">
    <cfparam name="Attributes.EditId" type="string" default="0">
    
    <cfset request.form.formid = Attributes.Id/>
    
    <form id="#Attributes.Id#" action="#Attributes.action#" method="post" enctype="multipart/form-data" class="#Attributes.class#">    
	<input name="id" type="hidden" value="#Attributes.EditId#"/>
    
<!--- close tag --->   
<cfelse>
	</form>
</cfif> 
</cfoutput>