<cfparam default="0" name="url.id"/>

<cfparam name="url.cid" default=""/>
<cfset mrId = "__transaction_c_material_returned#url.cid#" & url.id/>

<cfoutput>
<cfimport taglib="../../../../assets/awaf/tags/xNavTab_1000/" prefix="nt" />
<cfimport taglib="../../../../assets/awaf/tags/xForm_1001/" prefix="f" />
<cfimport taglib="../../../../assets/awaf/tags/xEditTable/" prefix="et" />

<cfquery name="qWRe">
	SELECT
		r.*,
		CONCAT(u.Surname," ",u.OtherNames) returnedByUser
	FROM whs_return r
	INNER JOIN core_user u ON u.UserId = r.returnedByUserId
	WHERE r.returnId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
</cfquery>

<cfquery name="qI">
	SELECT
		ir.*,
		it.Description, it.VPN,it.Code,
		um.Code UM
	FROM whs_return_item AS ir
	INNER JOIN whs_item AS it ON ir.ItemId = it.ItemId
	INNER JOIN um ON um.UMId = it.UMId
	INNER JOIN whs_return AS wr ON ir.ReturnId = wr.ReturnId
	WHERE wr.ReturnId =  <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Id#">
</cfquery>

<cfquery name="qID">
	SELECT *
    FROM whs_item
</cfquery>

<cfset qD = application.com.User.GetDepartments()/>
<cfset qCU = application.com.User.GetUsers()/>

<f:Form id="#mrId#frm" action="x">
<div>

<table width="100%" border="0">
	<tr>
		<td width="50%" valign="top">
			<f:Label name="Issue ##" value="#qWRe.IssueId#" />
			<f:Label name="Date returned" value="#dateformat(qWRe.Datereturned,'dd-mmm-yyyy')#"/>
		</td>
		<td class="horz-div" valign="top">
			<f:Label name="Remark" value="#qWRe.Note#"/>
			<f:Label name="Returned By" value="#qWRe.returnedByUser#"/>
		</td>
	</tr>
	<tr>
	<td colspan="2"><br />

<table class="table table-hover table-striped table-bordered">
<thead>
  <tr>
  	<th width="1px">##</th>
    <th>Description</th>
    <th width="1px">Quantity</th>
  </tr>
</thead>
<tbody>
  <cfloop query="qI">
  <tr>
  	<td>#qI.ItemId#</td>
    <td>[#qI.Code#] #qI.Description# #qI.VPN#</td>
    <td>#qI.Quantity# #qI.UM#</td>
  </tr>
  </cfloop>
</tbody>
</table>

     </td>
  </tr>
</table>

</div>
</f:Form>

</cfoutput>
