<cfparam default="0" name="url.id"/>

<cfparam name="url.cid" default=""/>
<cfset dnId = "__transaction_c_all_delivery_note#url.cid#" & url.id/>

<cfoutput>
<cfimport taglib="../../../../assets/awaf/tags/xNavTab_1000/" prefix="nt" />
<cfimport taglib="../../../../assets/awaf/tags/xForm_1001/" prefix="f" />
<cfimport taglib="../../../../assets/awaf/tags/xEditTable/" prefix="et" />

<!---<cfquery name="qDN">
	SELECT * FROM whs_dn
    WHERE DeliveryNoteId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
</cfquery>--->
<cfset qDN = application.com.Transaction.GetDN(url.id)/>

<cfset qWI = application.com.Transaction.GetDNItems(url.id)/>
 
<cfset qCU = application.com.User.GetUsers()/>


<f:Form id="#dnId#frm" action="x"> 
<div>

<table width="100%" border="0">
  <tr>
    <td width="50%" valign="top">
		<f:Label name="MR ##" value="#qDN.MRId#"/>
        <f:Label name="Date" value="#dateformat(qDN.Date,'yyyy/mm/dd')#"/> 
    </td>
    <td class="horz-div" valign="top">
    	<f:Label name="Deliver to" value="#qDN.DeliverTo#"/>
        <f:Label name="Reference" value="#qDN.Reference#"/>
    </td>
  </tr>
  <tr>
    <td colspan="2" valign="top"><f:Label name="Remark" value="#qDN.Remark#" /></td>
    </tr> 
  <tr>
  	<td colspan="2">
    <br/>
<table class="table table-hover table-striped table-bordered">
<thead>
  <tr>
    <th>Description</th>
    <th width="1">Quantity</th>
  </tr>
</thead>
<tbody>
	<cfset tsum=0/>
  <cfloop query="qWI">
  <tr>
    <td>#qWI.Description#</td>
    <td>#qWI.Quantity#</td>
  </tr>
  </cfloop>
  
</tbody>
</table>  	 
    </td>
  </tr>
  <tr>
  	<td colspan="2">
 
    </td>
  </tr>
  <tr>
  	<td colspan="2">
    	
    </td>
  </tr>
</table>

</div>



</f:Form>

</cfoutput>