<cfparam default="0" name="url.id"/>

<cfparam name="url.cid" default=""/>
<cfset dnId = "__transaction_c_all_delivery_note#url.cid#" & url.id/>

<cfoutput>
<cfimport taglib="../../../../assets/awaf/tags/xNavTab_1000/" prefix="nt" />
<cfimport taglib="../../../../assets/awaf/tags/xForm_1001/" prefix="f" />
<cfimport taglib="../../../../assets/awaf/tags/xEditTable/" prefix="et" />

<cfset qDN = application.com.Transaction.GetDN(url.id)/>

<cfquery name="qWI">
    SELECT
        wdn.*,
        dni.Description,dni.Quantity
    FROM
    	whs_dn AS wdn
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
<f:Form id="#dnId#frm" action="modules/ajax/warehouse.cfm?cmd=SaveDN" EditId="#url.id#"> 
<div>

<table width="100%" border="0">
  <tr>
    <td width="50%" valign="top">
		<f:TextBox name="MRId" label="MR ##" required value="#qDN.MRId#" class="span4"/>
        <f:CheckBox name="CloseMR" ListValue="true" ListDisplay="Close MR above"/>
        <f:DatePicker name="Date" label="Delivery date" required value="#dateformat(qDN.Date,'yyyy/mm/dd')#"/> 
    </td>
    <td class="horz-div" valign="top">
    	<f:Textbox name="Remark" label="Remark" value="#qDN.Remark#"/>
    	<f:Select name="DeliverToUserId" label="Deliver to" autoselect required delimiters="`" ListValue="#Valuelist(qCU.UserId,'`')#" ListDisplay="#Valuelist(qCU.UserName,'`')#" Selected="#qDN.DeliverToUserId#"/>
        <f:TextBox name="Reference" label="Reference" value="#qDN.Reference#"/>
    </td>
  </tr> 
  <tr>
  	<td colspan="2">
       <et:Table allowInput height="170px" id="DNItem" bind="MRId" Event="keyup" data="modules/ajax/warehouse.cfm?cmd=getMaterialToDeliver">
            <et:Headers>
                <et:Header title="Description" size="10" type="text" />
                 <et:Header title="Qty" size="1" type="int"/>
                
                <et:Header title="" size="1"/>
            </et:Headers>
            <et:Content Query="#qWI#" Columns="Description,Quantity" type="text,int" PKField="DeliveryNoteId"/>  
        </et:Table>   
        
<!---        <et:Table allowInput="#editable#" allowUpdate="#editable#" height="240px" id="ItemReceived" bind="MRId" Event="keyup" data="modules/ajax/warehouse.cfm?cmd=getMaterialToReceive">
            <et:Headers>
                <et:Header title="Item description" size="5" type="int" disabled>
                    <et:Select ListValue="#Valuelist(qID.ItemId,'`')#" ListDisplay="#Valuelist(qID.Description,'`')#" delimiters="`"/>
                </et:Header>
                <et:Header title="Qty" size="1" type="int"/>
                <et:Header title="Currency" size="1" disabled>
                    <et:Select ListValue="NGN,USD"/>
                </et:Header>
                <et:Header title="Unit price" size="2" type="float"/>
                <et:Header title="Waybill / Invoice ##" size="2"/>
                <et:Header title="" size="1"/>
            </et:Headers>
            <!---<et:Content Query="#qI#" Columns="Description,Quantity" type="int-select,int" PKField="ItemIssueId"/> --->
        </et:Table>  --->
    </td>
  </tr>
  <tr>
  	<td colspan="2">
. 
    </td>
  </tr>
</table>

</div>



</f:Form>

</cfoutput>