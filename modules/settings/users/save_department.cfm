<!--- 
	Author: Arowolo Abiodun
	Created: 2011/09/30
	Modified: 2011/09/30
	-> edit a page 
--->
<cfparam default="0" name="url.id"/>
<cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />

<cfset astcId = '__users_c_department' & url.id/>

<cfquery name="qP">
	SELECT * FROM core_department
    WHERE DepartmentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
</cfquery>

<cfoutput>

<f:Form id="#astcId#frm" action="modules/ajax/settings.cfm?cmd=SaveDepartment" EditId="#url.id#"> 
    <f:TextBox name="Name" label="Department" required value="#qP.Name#"/>
    <f:TextBox name="Email" label="Email" validate="email" value="#qP.Email#"/>  
</f:Form>

</cfoutput>