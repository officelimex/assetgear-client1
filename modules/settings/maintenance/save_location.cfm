<!--- 
	Author: Arowolo Abiodun
	Created: 2011/09/30
	Modified: 2011/09/30
	-> edit a page 
--->
<cfparam default="0" name="url.id"/>
<cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />

<cfset locId = '__maintenance_setting_c_location' & url.id/>

<cfquery name="qP">
	SELECT * FROM location
    WHERE LocationId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>

</cfquery>
<cfset qPl = application.com.User.getLocation(9)/>

<cfset qol = application.com.User.getOfficeLocation()/>


<cfoutput>
<br/>

<f:Form id="#locId#frm" action="modules/ajax/settings.cfm?cmd=SaveLocation" EditId="#url.id#"> 
    <f:TextBox required name="Name" label="Name" value="#qP.Name#" class="span10"/> 
    <f:Select name="ParentLocationId" label="Parent Location" selected="" listvalue="#ValueList(qPl.LocationId,'`')#" ListDisplay="#ValueList(qPl.Name,'`')#" delimiters="`"/> 
    <!--- <f:Select required name="OfficeLocationId" label="Office Location" selected="" listvalue="#ValueList(qol.OfficeLocationId,'`')#" ListDisplay="#ValueList(qol.LocationName,'`')#" delimiters="`"/> ---> 
</f:Form>

</cfoutput>