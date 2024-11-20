<cfparam default="0" name="url.id"/>

<cfparam name="url.cid" default=""/>
<cfset mrId = "__transaction_c_material_received#url.cid#" & url.id/>

<cfoutput>
<cfimport taglib="../../../../assets/awaf/tags/xNavTab_1000/" prefix="nt" />
<cfimport taglib="../../../../assets/awaf/tags/xForm_1001/" prefix="f" />
<cfimport taglib="../../../../assets/awaf/tags/xEditTable/" prefix="et" />

<cfquery name="qMRI">
	SELECT * FROM whs_material_received
    WHERE MaterialReceivedId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
</cfquery>

<!---<cfquery name="qI">
    SELECT
    	ii.ItemIssueId,ii.IssueId,ii.ItemId,ii.Quantity,ii.UnitPrice,ii.`Status`,
    	CONVERT(CONCAT(it.Description,'~',ii.ItemId) USING utf8) Description
    FROM
    	whs_issue_item AS ii
    INNER JOIN whs_item AS it ON ii.ItemId = it.ItemId
    INNER JOIN whs_issue AS wi ON ii.IssueId = wi.IssueId
    where ii.IssueId =  <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Id#">
</cfquery> --->

<cfquery name="qID" cachedwithin="#CreateTime(1,0,0)#">
	SELECT ItemId, CONCAT("[",Code,"] ",Description,' ',VPN) Description FROM whs_item
	WHERE Obsolete = "No" AND Status <> "Deleted"
  ORDER BY Description ASC
</cfquery>

<cfquery name="qD">
	SELECT * FROM core_department
    ORDER BY Name
</cfquery>

<cfquery name="qWR">
	SELECT * FROM whs_mr
    ORDER BY Note
</cfquery>

<cfquery name="qCU">
	SELECT UserId,concat(Surname," ", OtherNames) as Names FROM core_user
</cfquery>
<cfset editable=false/>
<cfif url.id eq 0>
	<br/><cfset editable = true/>
</cfif>
<f:Form id="#mrId#frm" action="modules/ajax/warehouse.cfm?cmd=SaveMaterialReceived" EditId="#url.id#">
<div>

<table width="100%" border="0">
  <tr>
    <td width="50%" valign="top">
        <f:TextBox name="MRId" label="MR ##" value="#qMRI.MRId#" class="span5" Disabled="#!editable#"/>
        <f:CheckBox name="CloseMR" ListValue="true" ListDisplay="Close MR above"/>
    </td>
    <td class="horz-div" valign="top">
        <f:DatePicker name="Date" label="Date Received" required value="#dateformat(qMRI.Date,'yyyy/mm/dd')#"/>
        <f:TextBox name="Reference" value="#qMRI.Reference#"/>
    </td>
  </tr>
  <tr>
  	<td colspan="2">

        <et:Table allowInput="#editable#" allowUpdate="#editable#" height="240px" id="ItemReceived" bind="MRId" Event="keyup" data="modules/ajax/warehouse.cfm?cmd=getMaterialToReceive">
            <et:Headers>
                <et:Header title="Item description" size="5" type="int" disabled>
                    <et:Select ListValue="#Valuelist(qID.ItemId,'`')#" ListDisplay="#Valuelist(qID.Description,'`')#" delimiters="`"/>
                </et:Header>
                <et:Header title="Qty" size="1" type="int"/>
                <et:Header title="Currency" size="1" disabled>
                    <et:Select ListValue="NGN,USD"/>
                </et:Header>
                <et:Header title="Unit price" size="2" type="float"/>
                <et:Header title="Waybill / Invoice ##" required type="text" size="2"/>
                <et:Header title="" size="1"/>
            </et:Headers>
            <!---<et:Content Query="#qI#" Columns="Description,Quantity" type="int-select,int" PKField="ItemIssueId"/> --->
        </et:Table>

     </td>
  </tr>
</table>

</div>



</f:Form>

</cfoutput>
