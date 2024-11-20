<!---
	Author: Arowolo Abiodun
	Created: 2011/09/30
	Modified: 2011/09/30
	-> edit a page
--->
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
<cfimport taglib="../../../assets/awaf/tags/xUtil/" prefix="util" />

<!--- Getting Data From Whs_item--->
<cfquery name="qWI">
	SELECT * FROM whs_item
    WHERE ItemId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/> AND 
		 Obsolete = "No" AND Status <> "Deleted"
</cfquery>

<cfquery name="qSL">
	SELECT * FROM shelf_location
    WHERE ShelfLocationId = <cfqueryparam cfsqltype="cf_sql_integer" value="#qWI.ShelfLocationId#">
</cfquery>

<cfquery name="qD">
	SELECT * FROM core_department
    WHERE DepartmentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#qWI.DepartmentIds#">
</cfquery>

<!--- Get for Asset Category --->
<cfquery name="qAC">
	SELECT * FROM asset_category
    WHERE AssetCategoryId = <cfqueryparam cfsqltype="cf_sql_integer" value="#qWI.AssetCategoryId#">
</cfquery>

<!--- Get for UM --->
<cfquery name="qUM">
	SELECT * FROM um
    WHERE UMId = <cfqueryparam cfsqltype="cf_sql_integer" value="#qWI.UMId#">
</cfquery>

<!--- Get Custom Fields --->
<cfquery name="qCu">
	SELECT *
    FROM custom_field
    WHERE `Table` = "whs_item"
    AND PK = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
</cfquery>

<cfquery name="qTran_" cachedwithin="#CreateTime(1,0,0)#">
    (SELECT
        isi.IssueId TransactionId, "Issued" Type, isi.ItemId, isi.Quantity,
        isu.DateIssued Date, isu.Remark Note,
        CONCAT(u.Surname," ",u.OtherNames) User
    FROM whs_issue_item isi
    INNER JOIN whs_issue isu ON isu.IssueId = isi.IssueId
    INNER JOIN core_user u ON u.UserId = isu.IssuedToUserId
    WHERE isi.ItemId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>)
        UNION ALL
    (SELECT
        mri.MaterialReceivedId TransactionId, "Received" Type, mri.ItemId, mri.Quantity,
        mrv.Date, mr.Note Note,
        CONCAT(u.Surname," ",u.OtherNames) User
    FROM whs_material_received_item mri
    INNER JOIN whs_material_received mrv ON mrv.MaterialReceivedId = mri.MaterialReceivedId
    LEFT JOIN whs_mr mr ON mr.MRId = mrv.MRId
    INNER JOIN core_user u ON u.UserId = mrv.ReceivedByUserId
    WHERE mri.ItemId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>)
    LIMIT 100
</cfquery>

<cfquery name="qTran" Dbtype="query">
    SELECT * FROM qTran_
    ORDER BY Date DESC
</cfquery>

<f:Form id="#whsId#frm" action="modules/ajax/warehouse.cfm?cmd=SaveWarehouseItem" EditId="#url.id#">
	<div id="#Id1#">
        <table border="0" width="100%">
            <tr>
               <td width="50%" valign="top">
                  <util:FileView type="p" table="whs_item" pk="#url.id#" source="doc/photo/" column="1" height="275px"/>
               </td>
               <td class="horz-div"  valign="top">

						<f:label name="Description" value="#qWI.Description#"/>
						<!---<cfset _asset = application.com.Asset.GetCategoryInGroup()/>--->
						<f:label name="Asset Category" value="#qAC.Name#"/>
						<f:label name="Department" value="#qD.Name#"/>
						<f:label name="Reference" value="#qWI.Reference#"/>
						<f:label name="Shelf Location" value="#qSL.Code#"/>
						<f:label name="VPN" value="#qWI.VPN#"/>
						<f:label name="UM" value="#qUM.Title#"/>
						<f:label name="Minimum In Store" value="#qWI.MinimumInStore#"/>
						<f:label name="Maximum In Store" value="#qWI.MaximumInStore#"/>

               </td>
           </tr>
        </table>
    </div>
    <div id="#Id2#">
<table class="table table-striped table-condensed table-hover"><thead><tr>
    <th>##</th><th>Asset</th>
  </tr></thead>
<cfset asid=qWI.AssetIds/>
<cfif qWI.AssetIds eq "">
	<cfset asid="0"/>
</cfif>
<cfquery name="qSP" cachedwithin="#CreateTime(1,0,0)#">
	SELECT * FROM asset
    WHERE AssetId IN (#asid#)
</cfquery>
<tbody>
<cfloop query="qSP">
  <tr><td>#qsp.currentrow#</td><td>#qSP.Description#</td></tr></cfloop>
  </tbody>

</table>
    </div>
    <div id="#Id3#">
        <div class="alert alert-info">Use this area to store equipment documents for easy access such as manuals, spreadsheets, or any other type of document.</div>
        <u:UploadFile id="Attachments" table="whs_item" pk="#url.id#" />
    </div>
    <div id="#Id4#">
        <div class="alert alert-info">Use this area to define custom fields that is specific to this Asset. </div>
        <util:ViewCustomFields table="whs_item" pk="#url.id#"/>
    </div>
    <div id="#Id5#">
    <table class="table table-striped table-condensed table-hover"><thead><tr>
        <th>Tran. ##</th>
        <th>Type</th>
        <th>User</th>
        <th>Remarks</th>
        <th>Date</th>
        <th>Quantity</th>
      </tr>
    </thead>
      <cfloop query="qTran">
      <tr><td>#qTran.TransactionId#</td>
        <td>#qTran.Type#</td>
        <td>#qTran.User#</td>
        <td>&nbsp;#qTran.Note#</td>
        <td>#dateformat(qTran.Date,'dd-mmm-yyyy')#</td>
        <td>#qTran.Quantity#</td>
      </tr>
      </cfloop>
    </table>
    </div>

     <nt:NavTab renderTo="#whsId#">
        <nt:Tab>
            <nt:Item title="General" isactive/>
            <nt:Item title="Use with"/>
            <nt:Item title="Attachments"/>
            <nt:Item title="Custom Field"/>
            <nt:Item title="Transactions"/>
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
