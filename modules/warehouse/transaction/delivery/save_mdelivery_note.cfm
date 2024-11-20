<cfparam default="0" name="url.id"/>

<cfparam name="url.cid" default=""/>
<cfset dnId = "__transaction_c_all_mdelivery_note#url.cid#" & url.id/>

<cfoutput>
<cfimport taglib="../../../../assets/awaf/tags/xNavTab_1000/" prefix="nt" />
<cfimport taglib="../../../../assets/awaf/tags/xForm_1001/" prefix="f" />
<cfimport taglib="../../../../assets/awaf/tags/xEditTable/" prefix="et" />

<cfquery name="qDN">
  SELECT * FROM whs_mdn WHERE DeliveryNoteId = #url.id#
</cfquery>

<cfquery name="qWI">
    SELECT
        wdn.*,
        dni.Description,dni.Quantity
    FROM
    	whs_mdn AS wdn
    INNER JOIN whs_dn_item AS dni ON wdn.DeliveryNoteId = dni.DeliveryNoteId
    INNER JOIN whs_mr AS wm ON wdn.MRId = wm.MRId
    WHERE dni.DeliveryNoteId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Id#">
</cfquery>

<!---<cfquery name="qID">
	Select * From whs_item
</cfquery>--->


<cfset qCU = application.com.User.GetUsers()/>

<cfif url.id eq 0>
	<br/>
</cfif>
<f:Form id="#dnId#frm" action="modules/ajax/warehouse.cfm?cmd=SaveMDN" EditId="#url.id#">
<div>

<table width="100%" border="0">
  <tr>
    <td width="50%" valign="top">
  		<f:TextBox name="Requisition" label="Requisition" value="" class="span11"/>
  		<f:TextBox name="ItemFrom" label="Item From" required value="" class="span11"/>
  		<f:TextBox name="Destination" label="Destination" required value="" class="span11"/>
  		<f:TextBox name="RequestedBy" label="Requested By" required value="" class="span11"/>
  		<f:TextBox name="DeliverToUser" label="Deliver To" required value="" class="span11"/>
      <f:TextBox name="VehicleNo" label="Vehicle No" required value="" class="span11"/>
    </td>
    <td class="horz-div" valign="top">
      <f:TextBox name="ATTN" label="ATTN"  value="#qDN.ATTN#" class="span11"/>
      <f:DatePicker name="Date" label="Delivery date" required value=""/>
      <f:TextArea label="Remark" name="Remark" class="span11"  value=""/>
      <f:TextBox name="HauledBy" label="Hauled By" required value="" class="span11"/>
      <f:TextBox name="LoadedBy" label="Loaded By" required value="" class="span11"/>
      <f:DatePicker name="LoadedDate" label="Loaded date" required value=""/>
    </td>
  </tr>

  <tr>
  	<td colspan="2">
       <et:Table allowInput height="170px" id="DNItem">
            <et:Headers>
                <et:Header title="Description" size="8" type="text" />
                 <et:Header title="Qty" size="1" type="float"/>
                 <et:Header title="Unit" size="2" type="text">
                     <et:Select ListValue="Bag,Barrel,Box,Centimeter,Dozen,Drum,Each,Foot,Gram,Gallon,Inch,Job,Joint,Kilogram,Lenght,Liter,Mile,Meter,Metric Ton,Ounce,Packet,Pair,Pound,Roll,Set,Square Root,Yard"/>
                 </et:Header>
                <et:Header title="" size="1"/>
            </et:Headers>
            <et:Content Query="#qWI#" Columns="Description,Quantity,Unit" type="text,float,text" PKField="DeliveryNoteId"/>
        </et:Table>
    </td>
  </tr>
  <tr>
  	<td colspan="2">
      <br><br>
    </td>
  </tr>
</table>

</div>



</f:Form>

</cfoutput>
