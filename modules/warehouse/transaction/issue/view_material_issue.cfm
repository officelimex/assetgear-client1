<cfparam default="0" name="url.id"/>

<cfparam name="url.cid" default=""/>
<cfset mrId = "__transaction_c_material_issue#url.cid#" & url.id/>

<cfoutput>
<cfimport taglib="../../../../assets/awaf/tags/xNavTab_1000/" prefix="nt" />
<cfimport taglib="../../../../assets/awaf/tags/xForm_1001/" prefix="f" />
<cfimport taglib="../../../../assets/awaf/tags/xEditTable/" prefix="et" />

<cfquery name="qWI">
	SELECT 
    	i.*,
    	d.Name Department,
        CONCAT(u.Surname," ",u.OtherNames) IssuedToUser
    FROM whs_issue i    
    INNER JOIN core_department d ON d.DepartmentId = i.DepartmentId
    INNER JOIN core_user u ON u.UserId = i.IssuedToUserId
    WHERE i.IssueId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
</cfquery>

<cfquery name="qI">
    SELECT
    	ii.*,
    	it.Description, it.VPN,
        um.Code UM 
    FROM
    	whs_issue_item AS ii
    INNER JOIN whs_item AS it ON ii.ItemId = it.ItemId
    INNER JOIN um ON um.UMId = it.UMId
    INNER JOIN whs_issue AS wi ON ii.IssueId = wi.IssueId
    WHERE ii.IssueId =  <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Id#">
</cfquery> 

<cfquery name="qID" cachedwithin="#CreateTime(1,0,0)#">
	SELECT ItemId, CONVERT(CONCAT(Description,' ',VPN) USING utf8) Description FROM whs_item
    ORDER BY Description ASC
</cfquery>

<cfset qD = application.com.User.GetDepartments()/>
<cfset qCU = application.com.User.GetUsers()/>
<!---<cfquery name="qD">
	SELECT * FROM core_department
    ORDER BY Name 
</cfquery>--->

<cfquery name="qWR">
	SELECT * FROM whs_mr
    ORDER BY Note
</cfquery>

<!---<cfquery name="qCU">
	SELECT UserId,concat(Surname," ", OtherNames) as Names FROM core_user 
</cfquery>--->
<cfset editable=false/>
 
<f:Form id="#mrId#frm" action="x"> 
<div>

<table width="100%" border="0">
  <tr>
    <td width="50%" valign="top"> 
        <f:Label name="Work Order ##" value="#qWI.WorkOrderId#"/>
        <f:Label name="Reference" value="#qWI.Ref#"/>
        <f:Label name="Department" value="#qWI.Department#"/>
        
    </td>
    <td class="horz-div" valign="top"> 
        <f:Label name="Date Issued" required value="#dateformat(qWI.DateIssued,'yyyy/mm/dd')#"/>
		<f:Label name="Remark" value="#qWI.Remark#" />
        <f:Label name="Received by" value="#qWI.IssuedToUser#"/>
    </td>
  </tr> 
  <tr>
  	<td colspan="2"><br/>
<table class="table table-hover table-striped table-bordered">
<thead>
  <tr>
  	<th width="1">##</th>
    <th>Description</th>
    <th width="1">Quantity</th>
    <th nowrap="nowrap" width="65">Unit price</th>
    <th width="1">Subtotal</th>
  </tr>
</thead>
<tbody>
	<cfset tsum=0/>
  <cfloop query="qI">
  <tr>
  	<td>#qI.ItemId#</td>
    <td>#qI.Description# #qI.VPN#</td>
    <td>#qI.Quantity# #qI.UM#</td>
    <td style="text-align:right;">#numberformat(qI.Unitprice,'9,999.99')#</td>
    <td style="text-align:right;">
    <cfset lsum = qI.Unitprice*qI.Quantity/>
    <cfset tsum = tsum + lsum/>
    #numberformat(lsum,'9,999.99')#</td> 
  </tr>
  </cfloop>
  <tr>
    <td colspan="4"></td>
    <td style="text-align:right;">#numberformat(tsum,'9,999.99')#</td>
  </tr>
  
</tbody>
</table>  		
     
 
     </td>
  </tr>
</table>

</div>
 


</f:Form>

</cfoutput>