<!--- 
	Author: Arowolo Abiodun
	Created: 2011/11/19
	Modified: 2011/11/19
	-> add new page
--->
<cfset devId = application.Module.developer.name & '_3'/>

<cfoutput>

<form id="#devId#frAddRole" action="modules/ajax/developer.cfm?cmd=SaveRole" method="post">
<table width="100%" border="0" cellspacing="2" cellpadding="2">
  <tr>
    <td width="20%" valign="top">Role:</td>
    <td width="80%"><input name="title" id="#devId#title" class="required" type="text"/>&nbsp;</td>
  </tr>
  <tr>
    <td valign="top">Description:</td>
    <td><textarea name="desc" id="#devId#desc" style="width:300px"></textarea>&nbsp;</td>
  </tr> 
</table>
</form> 
</cfoutput>
