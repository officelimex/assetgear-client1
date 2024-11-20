<cfparam default="0" name="url.id"/>

<cfparam name="url.cid" default=""/>
<cfset dnId = "__transaction_c_all_delivery_note#url.cid#" & url.id/>

<cfoutput>
<cfimport taglib="../../../assets/awaf/tags/xNavTab_1000/" prefix="nt" />
<cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />
<cfimport taglib="../../../assets/awaf/tags/xEditTable/" prefix="et" />

<cfquery name="qDN">
	SELECT * FROM whs_dn
    WHERE DeliveryNoteId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
</cfquery>

<cfquery name="qWI">
    SELECT
        wdn.*,
        dni.Description,dni.Quantity
    FROM
    	whs_dn AS wdn
    INNER JOIN whs_dn_item AS dni ON wdn.DeliveryNoteID = dni.DeliveryNoteId
    INNER JOIN whs_mr AS wm ON wdn.MRId = wm.MRId
    WHERE dni.DeliveryNoteId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Id#">
</cfquery>

<cfquery name="qID">
	Select 
    	* 
    From
    	whs_item
</cfquery>

<!---<cfquery name="qD">
	SELECT * FROM core_department
    ORDER BY Name 
</cfquery>

<cfquery name="qWO">
	SELECT * FROM work_order
    ORDER BY Description 
</cfquery>--->

<cfquery name="qCU">
	SELECT * FROM core_user 
</cfquery>

<cfif url.id eq 0>
	<br/>
</cfif>
<f:Form id="#dnId#frm" action="modules/ajax/warehouse.cfm?cmd=SaveDN" EditId="#url.id#"> 
<div>

<table width="100%" border="0">
  <tr>
    <td width="50%" valign="top">
		<f:TextBox name="MRId" label="Requistion ##" required value="#qDN.MRId#"/>
        <!---<f:TextBox name="TotalValue" label="Total Value" required value="#qDN.TotalValue#" class="span2"/>
        <f:Select name="IsAcknowledge" required ListValue="1,0" ListDisplay="Yes,No" Selected="#qDN.IsAcknowledge#" class="span4"/>--->
        
        <f:TextBox name="Destination" required value="#qDN.Destination#" class="span10"/>
        <f:TextBox name="ItemFrom" label="Item From" required value="#qDN.ItemFrom#" class="span10"/>
    </td>
    <td class="horz-div" valign="top"> 
        <f:TextBox name="ReceivedBy" label="Received By" required value="#qDN.ReceivedBy#" class="span10"/>
        <f:TextBox name="VerifiedBy" label="Verified By" required value="#qDN.VerifiedBy#" class="span10"/>
        <f:TextBox name="VehicleNo" label="Vehicle No" required value="#qDN.VehicleNo#" class="span10"/>
    </td>
  </tr> 
  <tr>
  	<td colspan="2">
       <et:Table allowInput height="170px" id="DNItem">
            <et:Headers>
                <et:Header title="Description" size="10" type="text" />
                 <et:Header title="Qty" size="1" type="int"/>
                
                <et:Header title="" size="1"/>
            </et:Headers>
            <et:Content Query="#qWI#" Columns="Description,Quantity" type="text,int" PKField="DeliveryNoteId"/>  
        </et:Table>   
    </td>
  </tr>
  <tr>
  	<td colspan="2">
. 
    </td>
  </tr>
  <tr>
  	<td colspan="2">
    	<f:Textbox name="Remark" label="Remark" value="#qDN.Remark#" class="span11" />
    </td>
  </tr>
</table>

</div>



</f:Form>

</cfoutput>