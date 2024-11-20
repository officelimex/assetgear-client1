<!--- 
	Author: Arowolo Abiodun
	Created: 2011/09/30
	Modified: 2011/09/30
	-> edit a page 
--->
<cfparam default="0" name="url.id"/>
<cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />

<cfset usrId = '__users_c_unit' & url.id/>

<cfquery name="qP">
	SELECT * FROM core_unit
    WHERE UnitId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
</cfquery>

<cfquery name="qD">
	SELECT * FROM core_department
</cfquery>

<cfoutput>

<f:Form id="#usrId#frm" action="modules/ajax/settings.cfm?cmd=SaveUnit" EditId="#url.id#"> 
    <f:TextBox name="Name" label="Unit" required value="#qP.Name#"/> 
    <f:Select name="DepartmentId" required label="Department" selected="#qP.DepartmentId#" listvalue="#ValueList(qD.DepartmentId)#" ListDisplay="#ValueList(qD.Name)#"/>  
</f:Form>

</cfoutput>