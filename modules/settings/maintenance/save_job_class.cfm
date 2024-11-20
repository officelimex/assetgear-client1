<!--- 
	Author: Arowolo Abiodun
	Created: 2011/09/30
	Modified: 2011/09/30
	-> edit a page 
--->
<cfparam default="0" name="url.id"/>
<cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />

<cfset jobId = '__maintenance_setting_c_job_class' & url.id/>

<cfquery name="qP">

	SELECT * FROM job_class
    WHERE JobClassId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
</cfquery>


<cfoutput>

<f:Form id="#jobId#frm" action="modules/ajax/settings.cfm?cmd=SaveJobClass" EditId="#url.id#"> 
    <f:TextBox name="Code" label="Code" required value="#qP.Code#"/> 
    <f:TextBox name="Class" label="Class" required value="#qP.Class#"/> 
</f:Form>

</cfoutput>