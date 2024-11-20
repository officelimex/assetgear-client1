<cfparam default="0" name="url.id"/>

<cfparam name="url.cid" default=""/>
<cfset mrId = "__transaction_c_all_mr#url.cid#" & url.id/>

<cfoutput>
<cfimport taglib="../../../../assets/awaf/tags/xNavTab_1000/" prefix="nt" />
<cfimport taglib="../../../../assets/awaf/tags/xForm_1001/" prefix="f" />
<cfimport taglib="../../../../assets/awaf/tags/xEditTable/" prefix="et" />

<cfset qMR = application.com.Transaction.GetMR(url.id)/>
<cfset qWI = application.com.Transaction.GetMRItems(url.id)/>

<cfset qID = application.com.Item.GetItems()/>
<cfquery name="qD">
	SELECT * FROM core_department
    ORDER BY Name
</cfquery>

<cfif url.id eq 0>
	<br/>
</cfif>
<f:Form id="#mrId#frm" action="modules/ajax/warehouse.cfm?cmd=SaveMR&type=SI" EditId="#url.id#">
<div>
<table width="100%" border="0">
  <tr>
    <td width="50%" valign="top">
			  <f:Select name="Category" required ListValue="r,m" ListDisplay="Stock Replenishment,Material Requisition" Selected="#qMR.Category#" class="span9" onChange="#mrId#changeWI(this)"/>
        <f:DatePicker name="DateIssued" label="Date Issued" required value="#dateformat(qMR.Date,'yyyy/mm/dd')#"/>
        <f:DatePicker name="DateRequired" label="Date Required" required value="#dateformat(qMR.DateRequired,'yyyy/mm/dd')#"/>
				<f:Select name="DepartmentId" label="Department" required ListValue="#Valuelist(qD.DepartmentId)#" ListDisplay="#Valuelist(qD.Name)#" Selected="#qMR.DepartmentId#"/>
    </td>
    <td class="horz-div" valign="top">
        <f:Select name="Currency" required ListValue="NGN,USD" ListDisplay="Naira,Dollars" Selected="#qMR.Currency#" class="span4"/>
		<f:TextArea name="Note" required value="#qMR.Note#" class="span10"/>
				<div id="#mrId#frm1" style="display:none">
					<f:TextBox name="WorkOrderId" required label="Work Order ##" value="#qMR.WorkOrderId#" class="span4"/>
				</div>
    </td>
  </tr>
  <tr>
  	<td colspan="2">

        <et:Table allowInput height="180px" id="MRSIItem" bind="WorkOrderId" Event="keyup" data="modules/ajax/warehouse.cfm?cmd=getWorkOrder">
            <et:Headers>
                <et:Header title="Description" size="8" type="int">
                    <et:Select ListValue="#Valuelist(qID.ItemId,'`')#" ListDisplay="#Valuelist(qID.ItemDescription,'`')#" delimiters="`"/>
                </et:Header>
                <et:Header title="Qty" size="1" type="int"/>
                <et:Header title="Unit Cost" size="2" type="float"/>
                <et:Header title="" size="1"/>
            </et:Headers>
            <et:Content Query="#qWI#" Columns="ItemDescription,Quantity,UnitPrice" type="int-select,int,float" PKField="MRItemId"/>
        </et:Table>
    </td>
  </tr>
</table>

</div>

</f:Form>
	<script type="text/javascript">

		<cfif qMR.Category eq "m" >

			$(#mrId#frm1).setStyle('display','block');
		</cfif>
		function #mrId#changeWI(i){
			var p_= $(#mrId#frm1);
			if (i.value == 'r'){
				p_.setStyle('display','none');
			}else{
				p_.setStyle('display','block');
			}

		}
	</script>
</cfoutput>
