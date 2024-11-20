<!--- 
	Author: Arowolo Abiodun
	Created: 2011/09/30
	Modified: 2011/09/30
	-> edit a page 
--->
<cfparam default="0" name="url.id"/>
<cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />

<cfset astcId = '__asset_c_asset_category' & url.id/>

<cfquery name="qP">
	SELECT * FROM asset_category
    WHERE AssetCategoryId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
</cfquery>

<cfquery name="qAAC">
	SELECT * FROM asset_category
    WHERE AssetCategoryId <> <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
</cfquery>

<cfoutput>
 
<f:Form id="#astcId#frm" action="modules/ajax/maintenance.cfm?cmd=SaveAssetCategory" EditId="#url.id#"> 
    <f:TextBox name="Name" label="Category Name" required value="#qP.Name#"/>  
    <f:Select name="ParentAssetCategoryId" label="Parent Category" selected="#qP.ParentAssetCategoryId#" listvalue="#ValueList(qAAC.AssetCategoryId,'`')#" ListDisplay="#ValueList(qAAC.Name,'`')#" delimiters="`"/> 
</f:Form>

</cfoutput> 