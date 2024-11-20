<cfparam default="0" name="url.id"/>
<cfset whsId = "__material_c_warehouse_item" & url.id/>

<cfset Id1 = "#whsId#_1"/>
<cfset Id2 = "#whsId#_2"/>
<cfset Id3 = "#whsId#_3"/>
<cfset Id4 = "#whsId#_4"/>
<cfset Id5 = "#whsId#_5"/>

<cfoutput>
<cfimport taglib="../../../assets/awaf/tags/xNavTab_1000/" prefix="nt" />
<cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />
<cfimport taglib="../../../assets/awaf/tags/xUploader_1000/" prefix="u" />
<cfimport taglib="../../../assets/awaf/tags/xEditTable/" prefix="et" />

<cfset qWI = application.com.Item.GetItem(url.id)/>
<cfset qSL = application.com.Item.GetShelfLocations()/>
<cfset qUM = application.com.Item.GetAllUM()/>
<cfset qD = application.com.User.GetDepartments()/>
<cfquery name="qA" cachedwithin="#CreateTime(1,0,0)#">
	SELECT
   	Description, AssetId
   FROM asset
</cfquery>
<cfif url.id eq 0>
<br/>
</cfif>
<f:Form id="#whsId#frm" action="modules/ajax/warehouse.cfm?cmd=SaveWarehouseItem" EditId="#url.id#">
	<div id="#Id1#">
        <table border="0" width="100%">
            <tr>
                <td width="50%" valign="top">
                    <f:TextBox name="Code" label="Code" required value="#qWI.Code#"/>
                    <f:TextArea name="Description" label="Description" required value="#qWI.Description#"/>
                    <f:RadioBox name="Obsolete" inline showlabel label="Is Obsolete" required selected="#qWI.Obsolete#" ListValue="Yes,No"/>
                    <f:RadioBox name="Currency" inline showlabel label="Currency" required selected="#qWI.Currency#" ListValue="NGN,USD" ListDisplay="Naira,US Dollar" />
                    <cfset up=trim(NumberFormat(qWI.Unitprice,'9,999.99'))/>
                    <f:TextBox name="UnitPrice" label="Unit price" required value="#up#"/>
                    <f:CheckBox name="DepartmentIds" ListValue="#ValueList(qD.DepartmentId)#" selected="#qWI.DepartmentIds#" ListDisplay="#ValueList(qD.Name)#" inline showlabel label="Department" />
                </td>
                <td class="horz-div" width="50%" valign="top">
                    <cfset _asset = application.com.Asset.GetCategoryInGroup()/>
                    <f:Select name="AssetCategoryId" label="Asset Category" ListValue="#_asset.Value#" ListDisplay="#_asset.Description#" delimiters="`" selected="#qWI.AssetCategoryId#"/>
                    <f:Select name="ShelfLocationId" required label="Shelf Location" selected="#qWI.ShelfLocationId#" listvalue="#ValueList(qSL.ShelfLocationId)#" ListDisplay="#ValueList(qSL.Code)#" class="span4"/>
                    <f:TextBox name="VPN" label="Part Number" value="#qWI.VPN#"/>
                    <f:Select name="UMId" required label="Unit of Measurement" selected="#qWI.UMId#" listvalue="#ValueList(qUM.UMId)#" ListDisplay="#ValueList(qUM.Title)#" class="span5"/>
                    <f:TextBox name="MinimumInStore" label="Order Level" required value="#qWI.MinimumInStore#" class="span3"/>
                    <f:TextBox name="MaximumInStore" label="Maximum in stock" required value="#qWI.MaximumInStore#" class="span3"/>
                    <f:TextArea name="Reference" label="Reference" value="#qWI.Reference#"/>
                </td>
           </tr>
        </table>
    </div>

    <!--- associate asset with spare ---->
    <div id="#Id2#">
        <et:Table allowInput="true" allowUpdate="true" height="240px" id="AssetIds">
            <et:Headers>
                <et:Header title="Asset" size="11" type="int">
                    <et:Select ListValue="#Valuelist(qA.AssetId,'`')#" ListDisplay="#Valuelist(qA.Description,'`')#" delimiters="`"/>
                </et:Header>
                <et:Header title="" size="1"/>
            </et:Headers>
            <!--- convert list to query --->
            <cfquery name="qAI">
            	SELECT CONCAT(Description,'~',AssetId) Asset, AssetId
                FROM asset
                WHERE AssetId IN (#qWI.AssetIds#<cfif qWI.AssetIds eq "">0</cfif>)
            </cfquery>
            <et:Content Query="#qAI#" Columns="Asset" type="int-select" PKField="AssetId"/>
        </et:Table>
    </div>

    <div id="#Id3#">
        <div class="alert alert-info">Use this area to define custom fields that is specific to this Asset. Double click on the {Custom field} or
    label to edit</div>
        <table width="100%" border="0">
          <tr>
            <td width="50%" valign="top">
                <cfquery name="qCF">
                    SELECT * FROM custom_field
                    WHERE `Table` = "whs_item"
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
    </div>

    <div id="#Id4#">
        <u:UploadFile accept="photo" id="Photos" height="335px" table="whs_item" pk="#url.id#" />
    </div>
    <div id="#Id5#">
        <div class="alert alert-info">Use this area to store equipment documents for easy access such as manuals, spreadsheets, or any other type of document.</div>
        <u:UploadFile id="Attachments" table="whs_item" pk="#url.id#" />
    </div>


	<nt:NavTab renderTo="#whsId#">
		<nt:Tab>
			<nt:Item title="General" isactive/>
			<nt:Item title="Associate with Asset"/>
			<nt:Item title="Custom Fields"/>
			<nt:Item title="Photos"/>
			<nt:Item title="Attachments"/>
		</nt:Tab>
		<nt:Content>
			<nt:Item id="#Id1#" isactive/>
			<nt:Item id="#Id2#"/>
			<nt:Item id="#Id3#"/>
			<nt:Item id="#Id4#"/>
			<nt:Item id="#Id5#"/>
		</nt:Content>
	</nt:NavTab>


<cfif url.id eq 0>
	<f:ButtonGroup>
		<f:Button value="Create new Item" class="btn-primary" IsSave/>
	</f:ButtonGroup>
</cfif>
 </f:Form>

</cfoutput>