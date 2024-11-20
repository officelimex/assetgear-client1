<!--- 
	Author: Arowolo Abiodun
	Created: 2011/11/19
	Modified: 2011/11/19
	-> edit a role 
--->
<cfparam default="0" name="url.id"/>
<cfset devId = "__role_c" & url.id/>

<cfset qR = application.com.Module.getRole(url.id)/>
<cfoutput>

<cfimport taglib="../../assets/awaf/tags/xForm_1001/" prefix="f" />
<f:Form id="#devId#frm" action="modules/ajax/developer.cfm?cmd=SaveRole" EditId="#url.id#"> 
    <f:TextBox name="title" label="Role title" required value="#qR.title#"/> 
    <f:TextArea name="desc" label="Description" required value="#qR.Description#"/> 
</f:Form>  
</cfoutput>
