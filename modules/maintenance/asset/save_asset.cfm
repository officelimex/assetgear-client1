<cfparam default="0" name="url.id"/>

<cfparam name="url.cid" default=""/>
<cfset astId = "__asset_c_all_asset#url.cid##url.id#"/>

<cfset Id1 = "#astId#_1"/>
<cfset Id2 = "#astId#_2"/>
<cfset Id3 = "#astId#_3"/>
<cfset Id4 = "#astId#_4"/>
<cfset Id5 = "#astId#_5"/>
<cfset Id6 = "#astId#_6"/>
<cfset Id7 = "#astId#_7"/>
<cfset Id8 = "#astId#_8"/>

<cfoutput>
<cfimport taglib="../../../assets/awaf/tags/xNavTab_1000/" prefix="nt" />
<cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />
<cfimport taglib="../../../assets/awaf/tags/xUploader_1000/" prefix="u" />
<cfimport taglib="../../../assets/awaf/tags/xEditTable/" prefix="et" />

<cfset qA = application.com.Asset.GetAsset(url.id)/>
<cfset qALC = application.com.Asset.GetAssetLocationCategory()/>

<cfquery name="qPA">
	SELECT * FROM asset
  WHERE AssetId <> <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
	ORDER BY Description
</cfquery>

<cfquery name="qAL">
	SELECT
    	CONCAT(l.Name,'~',al.LocationId) Location,l.Name,
    	al.Status, al.LocDescription,al.Quantity, al.AssetId, al.AssetLocationId
    FROM asset_location al
    INNER JOIN location l ON al.LocationId = l.LocationId
    WHERE AssetId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
</cfquery>

<cfquery name="qEx">
    SELECT ExpirationId,AssetId,Title,DATE_FORMAT(Date,'%Y/%m/%d')Date,Reminder FROM expiration
    WHERE AssetId = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#url.id#"/>
</cfquery>

<cfquery name="qL">
  SELECT
  l.LocationId,CONCAT_WS(" @ ",l.Name,ll.Name) AS Name
  FROM location l
  LEFT JOIN location ll ON l.ParentLocationId = ll.LocationId
  ORDER BY l.Name
</cfquery>

<cfquery name="qD">
	SELECT * FROM core_department
</cfquery>

<cfquery name="qC">
	#application.com.User.SQL_COMPANY#
    ORDER BY Name
</cfquery>

<cfquery name="qMR" cachedwithin="#CreateTime(24,0,0)#">
	SELECT * FROM reading_type
</cfquery>
<cfquery name="qI" cachedwithin="#CreateTime(2,0,0)#">
	SELECT
    	CONCAT(Description,' ',VPN) Description, ItemId
    FROM whs_item
</cfquery>
<cfif url.id eq 0><br/></cfif>
<f:Form id="#astId#frm" action="modules/ajax/maintenance.cfm?cmd=SaveAsset" EditId="#url.id#">
<div id="#Id1#">
<table width="100%" border="0">
  <tr>
    <td width="50%" valign="top">
        <f:TextArea name="Description" value="#qA.Description#"/>

        <cfset _asset = application.com.Asset.GetCategoryInGroup()/>
        <cfset officeLoc = application.com.User.GetOfficeLocation()/>

        <f:Select name="AssetCategoryId" required label="Category" ListValue="#_asset.Value#" ListDisplay="#_asset.Description#" delimiters="`" Selected="#qA.AssetCategoryId#"/>

        <f:Select name="ParentAssetId" label="Parent Asset" ListValue="#Valuelist(qPA.AssetId,'`')#" ListDisplay="#Valuelist(qPA.Description,'`')#" Selected="#qA.ParentAssetId#" delimiters="`"/><!---help="Select if this is a part of an existing asset"--->
        <!---<f:TextBox name="Quantity" required validate="integer" value="#qA.Quantity#" class="span2" InlineHelp="NB:Qty can not be 0"/>--->
        <f:Select name="Class" ListValue="Major,Critical,Minor" required Selected="#qA.Class#" class="span4"/>
        <f:Select name="Status" required ListValue="Online,Offline,Out of Service,Transfered,Decommissioned" Selected="#qA.Status#" class="span6"/>
        <f:Select name="ReadingTypeId" class="span5" label="Meter Reading type" ListValue="#Valuelist(qMR.ReadingTypeId)#" ListDisplay="#Valuelist(qMR.Type)#" Selected="#qA.ReadingTypeId#"/>
        <!--- <f:Select name="LocationCategoryId" class="span9" required label="Category By Location" ListValue="#ValueList(qALC.LocationCategoryId)#" ListDisplay="#ValueList(qALC.LocationName)#" Selected="#qA.LocationCategoryId#"  /> --->
        <!--- <f:Select name="WorkingForId" required label="Company Working For" ListDisplay="#Valuelist(qC.Name)#" ListValue="#Valuelist(qC.CompanyId)#" selected="#qA.WorkingForId#" /> --->                      

    </td>
        <td class="horz-div" valign="top">
        <f:TextBox name="Model" value="#qA.Model#"/>
        <f:TextBox name="ModelNumber" label="Model Number" value="#qA.ModelNumber#"/>
        <f:TextBox name="SerialNumber" label="Serial ##" value="#qA.SerialNumber#"/>

        <f:Select name="Ownership" required ListValue="Owned,Leased,Rented,Client" Selected="#qA.Ownership#" class="span4"/>
        <f:CheckBox name="DepartmentIds" ListValue="#ValueList(qD.DepartmentId)#" selected="#qA.DepartmentIds#" ListDisplay="#ValueList(qD.Name)#" inline showlabel label="Department" />
        <!--- <f:Select name="OfficeLocationId" class="span9" required label="Office Location" ListValue="#ValueList(officeLoc.OfficeLocationId)#" ListDisplay="#ValueList(officeLoc.LocationName)#" Selected="#qA.OfficeLocationId#"/> --->

    </td>
  </tr>
</table>

</div>
<div id="#Id2#">
	<div class="alert alert-info">Use this area to define custom fields that is specific to this Asset. Double click on the {Custom field} or
label to edit</div>
    <table width="100%" border="0">
      <tr>
        <td width="50%" valign="top">
<cfquery name="qCF">
	SELECT * FROM custom_field
    WHERE `Table` = "asset"
    	AND `PK` = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
</cfquery>
        <cfloop from="1" to="4" index="i">
        	<cfif qCF.Field[i] eq "">
            	<f:CustomTextBox name="CustomField#i#" label="{Custom field}" value=""/>
            <cfelse>
            	<f:CustomTextBox name="CustomField#i#" label="#qCF.Field[i]#" value="#qCF.Value[i]#" CustomFieldId="#qCF.CustomFieldId[i]#"/>
            </cfif>
        </cfloop>
        </td>
        <td class="horz-div" valign="top">
        <cfloop from="5" to="8" index="i">
        	<cfif qCF.Field[i] eq "">
            	<f:CustomTextBox name="CustomField#i#" label="{Custom field}" value=""/>
            <cfelse>
            	<f:CustomTextBox name="CustomField#i#" label="#qCF.Field[i]#" CustomFieldId="#qCF.CustomFieldId[i]#" value="#qCF.Value[i]#"/>
            </cfif>
        </cfloop>
        </td>
      </tr>
    </table>
	<!---<f:CheckBox name="a" ListValue="yes" ListDisplay="Save Custom labels as default"/>--->
</div>
<!--- spare parts --->
<div id="#Id3#">
 	<div class="alert alert-info">Add spares from the warehouse to this Asset</div>
    <et:Table allowInput="true" allowUpdate="true" height="240px" id="ItemIds">
        <et:Headers>
            <et:Header title="Spare parts" size="11" type="int">
                <et:Select ListValue="#Valuelist(qI.ItemId,'`')#" ListDisplay="#Valuelist(qI.Description,'`')#" delimiters="`"/>
            </et:Header>
            <et:Header title="" size="1"/>
        </et:Headers>
        <!--- convert list to query --->
        <cfquery name="qAI">
            SELECT CONCAT(Description,' ',VPN,' ~',ItemId) Description, ItemId
            FROM whs_item
            WHERE ItemId IN (#qA.ItemIds#<cfif qA.ItemIds eq "">0</cfif>) AND
			Obsolete = "No" AND Status <> "Deleted"
        </cfquery>
        <et:Content Query="#qAI#" Columns="Description" type="int-select" PKField="ItemId"/>
    </et:Table>
</div>
<div id="#Id4#">
 	<div class="alert alert-info">Specify the locations and Quantity of this Asset </div>
    <et:Table allowInput="true" allowUpdate="true" height="190px" id="AssetLocation">
        <et:Headers>
            <et:Header title="Location" size="3" type="int">
            	<et:Select ListValue="#Valuelist(qL.LocationId,'`')#" ListDisplay="#Valuelist(qL.Name,'`')#" delimiters="`"/>
            </et:Header>
            <et:Header title="Location Description" type="text" size="4" />
            <et:Header title="Qty" size="2" type="int" />
            <et:Header title="Status" size="2">
            	<et:Select ListValue="Online,Offline,Transfered,Decommissioned"/>
            </et:Header>
            <et:Header title="" size="1"/>
        </et:Headers>
    	<et:Content Query="#qAL#" Columns="Location,LocDescription,Quantity,Status" type="int-select,text,int,text" PKField="AssetLocationId"/>
	</et:Table>
</div>
<div id="#Id5#">
 	<div class="alert alert-info">
    Use this area to define expirations for registration, MV(motor vehicle inspection), emissions, etc.<br />
The program will automatically inform you when they are nearing expirations</div>
    <et:Table allowInput height="190px" id="Expiration">
        <et:Headers>
            <et:Header title="Expiration name" size="7" />
            <et:Header title="Expiration date" size="2" type="date" hint="yyyy-mm-dd"/>
            <et:Header title="Reminder (days)" size="2" type="int"/>
            <et:Header title="" size="1"/>
        </et:Headers>
        <et:Content Query="#qEx#" Columns="Title,Date,Reminder" type="text,date,int"  PKField="ExpirationId"/>
    </et:Table>
</div>

<div id="#Id6#">
    <u:UploadFile accept="photo" id="Photos" height="335px" table="asset" pk="#url.id#" />
</div>
<div id="#Id7#">
 	<div class="alert alert-info">Use this area to store equipment documents for easy access such as manuals, spreadsheets, or any other type of document.</div>
    <u:UploadFile id="Attachments" table="asset" pk="#url.id#" />
</div>
<div id="#Id8#" align="center">
	<textarea id="Note" name="Note" style="width:94%; height:320px;">#qA.Note#</textarea>
</div>

<nt:NavTab renderTo="#astId#">
	<nt:Tab>
    	<nt:Item title="General" isactive/>
        <nt:Item title="Specifications"/>
        <nt:Item title="Spare parts"/>
        <nt:Item title="Locations"/>
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
        <nt:Item id="#Id7#"/>
        <nt:Item id="#Id8#"/>
    </nt:Content>
</nt:NavTab>

<cfif url.id eq 0>
    <f:ButtonGroup>
        <f:Button value="Create new Asset" class="btn-primary" IsSave
            subpageId="new_asset" ReloadURL="modules/maintenance/asset/save_asset.cfm"/>
    </f:ButtonGroup>
</cfif>

</f:Form>
</cfoutput>
