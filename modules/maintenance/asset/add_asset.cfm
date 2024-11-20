<cfparam default="0" name="url.id"/>


<cfset astId = "__asset_c_add_asset" & url.id/>

<cfset Id1 = "#astId#_1"/>
<cfset Id2 = "#astId#_2"/>
<cfset Id3 = "#astId#_3"/>
<cfset Id4 = "#astId#_4"/>
<cfset Id5 = "#astId#_5"/>
<cfset Id6 = "#astId#_6"/>


<cfoutput>
<cfimport taglib="../../../assets/awaf/tags/xNavTab_1000/" prefix="nt" />
<cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />
<cfimport taglib="../../../assets/awaf/tags/xUploader_1000/" prefix="u" />
<cfimport taglib="../../../assets/awaf/tags/xEditTable/" prefix="et" />

<cfquery name="qA">
	SELECT * FROM asset
    WHERE AssetId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
</cfquery>

<cfquery name="qPA">
	SELECT * FROM asset
    WHERE AssetId <> <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
        ORDER BY asset.Name
</cfquery>

<!---cfquery name="qAC">
	SELECT * FROM asset_category
    WHERE ParentAssetCategoryId IS NOT NULL
</cfquery--->

<cfquery name="qAL">
	SELECT * FROM asset_location
</cfquery>

<cfquery name="qD">
	SELECT * FROM core_department
</cfquery>

<cfquery name="qMR">
	SELECT * FROM reading_type
</cfquery>
<br/>
<f:Form id="#astId#frm" action="modules/ajax/maintenance.cfm?cmd=CreateAsset" EditId="#url.id#">
<div id="#Id1#">
<table width="100%" border="0">
  <tr>
    <td width="50%" valign="top">
    <f:TextArea name="Description" value="#qA.Description#"/>

     	<cfset assetVal = ""/>
        <cfset assetDesc = ""/>

<cfset _asset = application.com.Asset.GetCategoryInGroup()/>

    <f:Select name="AssetCategoryId" required label="Category" delimiters="`" ListValue="#_asset.Value#" ListDisplay="#_asset.Description#" Selected="#qA.AssetCategoryId#"/>
    <!---f:Select name="AssetLocationId" required label="Location" ListValue="#Valuelist(qAL.AssetLocationId)#" ListDisplay="#Valuelist(qAL.Name)#" Selected="#qA.AssetLocationId#"/---->
    <f:Select name="ParentAssetId" label="Parent Asset" ListValue="#Valuelist(qPA.AssetId,'`')#" delimiters="`" ListDisplay="#Valuelist(qPA.Description,'`')#" Selected="#qA.ParentAssetId#"/><!---help="Select if this is a part of an existing asset"--->

    <f:Select name="Status" required ListValue="Online,Offline,Out of Service,Transfered" Selected="#qA.Status#" class="span6"/>
	<f:Select name="ReadingTypeId" class="span5" label="Meter Reading type" ListValue="#Valuelist(qMR.ReadingTypeId)#" ListDisplay="#Valuelist(qMR.Type)#" Selected="#qA.ReadingTypeId#"/>
    </td>
    <td class="horz-div" valign="top">
    <f:TextBox name="Model" value="#qA.Model#"/>
    <f:TextBox name="ModelNumber" label="Model Number" value="#qA.Model#"/>
    <f:TextBox name="SerialNumber" label="Serial ##" value="#qA.SerialNumber#"/>
    <f:Select name="Class" ListValue="Major,Critical,Minor" required Selected="#qA.Class#" class="span4"/>
    <f:Select name="Ownership" required ListValue="Owned,Leased,Rented,Client" Selected="#qA.Ownership#" class="span4"/>
    <f:CheckBox name="DepartmentIds" ListValue="#ValueList(qD.DepartmentId)#" ListDisplay="#ValueList(qD.Name)#" inline showlabel label="Department" />
    </td>
  </tr>
</table>

</div>
<div id="#Id2#">
	<div class="alert alert-info">Use this area to define custom fields that is specific to this Asset. Double click on the label to edit</div>
    <table width="100%" border="0">
      <tr>
        <td width="50%" valign="top">
        <cfloop from="1" to="4" index="i">
            <f:CustomTextBox name="CustomField#i#" label="{Custom field}" value=""/>
        </cfloop>
        </td>
        <td class="horz-div" valign="top">
        <cfloop from="5" to="8" index="i">
            <f:CustomTextBox name="CustomField#i#" label="{Custom field}" value=""/>
        </cfloop>
        </td>
      </tr>
    </table>
	<!---<f:CheckBox name="a" ListValue="yes" ListDisplay="Save Custom labels as default"/>--->
</div>
<div id="#Id3#">
 	<div class="alert alert-info">
    Use this area to define expirations for registration, MV(motor vehicle inspection), emissions, etc.<br />
The program will automatically inform you when they are nearing expirations</div>
    <et:Table allowInput height="290px">
        <et:Headers>
            <et:Header title="Expiration name" size="7"/>
            <et:Header title="Expiration date" size="2"/>
            <et:Header title="Reminder (days)" size="2"/>
            <et:Header title="" size="1"/>
        </et:Headers>
    </et:Table>
</div>
<div id="#Id4#">
	<u:UploadFile id="Photos" renderto="#Id4#" destination="maintenance/doc/photo/"/>
</div>
<div id="#Id5#">
 	<div class="alert alert-info">Use this area to store equipment documents for easy access such as manuals, spreadsheets, or any other type of document.</div>
    <u:UploadFile id="Attachments" renderto="#Id5#" destination="maintenance/doc/attachment/"/>
</div>
<div id="#Id6#" align="center">
	<textarea id="Note" name="Note" style="width:94%; height:320px;">#qA.Note#</textarea>
</div>

<nt:NavTab renderTo="#astId#">
	<nt:Tab>
    	<nt:Item title="General" isactive/>
        <nt:Item title="Specifications"/>
        <nt:Item title="Expirations"/>
        <nt:Item title="Photos"/>
        <nt:Item title="Attachments"/>
        <nt:Item title="Note"/>
    </nt:Tab>
    <nt:Content>
    	<nt:Item id="#Id1#" isactive/>
        <nt:Item id="#Id2#"/>
    	<nt:Item id="#Id3#"/>
        <nt:Item id="#Id4#"/>
        <nt:Item id="#Id5#"/>
        <nt:Item id="#Id6#"/>
    </nt:Content>
</nt:NavTab>

<f:ButtonGroup>
	<f:Button value="Create new Asset" class="btn-primary" IsSave/>
</f:ButtonGroup>

</f:Form>
</cfoutput>
