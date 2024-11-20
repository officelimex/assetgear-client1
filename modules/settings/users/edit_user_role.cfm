<!---
	Author: Arowolo Abiodun
	Created: 2011/09/30
	Modified: 2011/09/30
--->
<cfparam default="0" name="url.id"/>
<cfparam name="url.cid" default=""/>
<cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />

<cfset comId = '__users_c_all_users#url.cid#' & url.id/>
<cfif url.id eq 1>
	<cfabort showerror="You can't edit this user" />
</cfif>
<cfset qU = application.com.User.getUser(url.id)/>
<cfset qR = application.com.User.getRole()/>

<cfoutput>
	<br />
	<f:Form id="#comId#frm" action="modules/ajax/settings.cfm?cmd=SaveUserRole" EditId="#url.id#">
		<f:TextBox name="Email" label="Username" required value="#qU.Email#" validate="email"/>
		<f:Select name="Role" required listvalue="#qR.Code#" listdisplay="#qR.Title#" selected="#qU.Role#"/>
	</f:Form>

</cfoutput>
