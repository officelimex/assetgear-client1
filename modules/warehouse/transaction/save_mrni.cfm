<cfparam default="0" name="url.id"/>

<cfparam name="url.cid" default=""/>
<cfset mrId = "__transaction_c_all_mrni#url.cid#" & url.id/>

<cfoutput>
<cfimport taglib="../../../assets/awaf/tags/xNavTab_1000/" prefix="nt" />
<cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />
<cfimport taglib="../../../assets/awaf/tags/xEditTable/" prefix="et" />

<cfquery name="qWhs">
	SELECT * FROM whs_mr
    WHERE MRId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
</cfquery>

<cfquery name="qWI">
    SELECT 
		mri.*, mri.VPN Description
	FROM 
		whs_mr_item mri
    WHERE mri.MRId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Id#">
</cfquery> 

<cfquery name="qID">
	Select 
    	* 
    From
    	whs_item
</cfquery>

<cfquery name="qD">
	SELECT * FROM core_department
    ORDER BY Name 
</cfquery> 

<cfif url.id eq 0>
	<br/>
</cfif>
<f:Form id="#mrId#frm" action="modules/ajax/warehouse.cfm?cmd=SaveMR&type=NI" EditId="#url.id#"> 
<div>
<table width="100%" border="0">
  <tr>
    <td width="50%" valign="top"> 
        <f:TextBox name="Note" required value="#qWhs.Note#" class="span10"/>
        <f:DatePicker name="DateIssued" label="Date Issued" required value="#dateformat(qWhs.Date,'yyyy/mm/dd')#"/>
        <f:DatePicker name="DateRequired" label="Date Required" required value="#dateformat(qWhs.DateRequired,'yyyy/mm/dd')#"/>
        <f:TextBox name="ServiceRequestId" label="Service Request ##" value="#qWhs.ServiceRequestId#" class="span5"/>
    </td>
    <td class="horz-div" valign="top"> 
        <f:Select name="Currency" required ListValue="NGN,USD" ListDisplay="Naira,Dollars" Selected="#qWhs.Currency#" class="span4"/>        
        <f:Select name="DepartmentId" label="Department" required ListValue="#Valuelist(qD.DepartmentId)#" ListDisplay="#Valuelist(qD.Name)#" Selected="#qWhs.DepartmentId#"/>
        <f:TextBox name="WorkOrderId" label="Work Order ##" value="#qWhs.WorkOrderId#" class="span5"/>
    </td>
  </tr> 
  <tr>
  	<td colspan="2"> 
     
        <et:Table allowInput height="130px" id="MRNIItem" bind="WorkOrderId,ServiceRequestId" Event="keyup,keyup" 
        	data="modules/ajax/warehouse.cfm?cmd=getWorkOrderNI&WO=#qWhs.WorkOrderId#,modules/ajax/warehouse.cfm?cmd=getServiceRequestItem&SR=#qWhs.ServiceRequestId#">
            <et:Headers>
               <et:Header title="Description" size="8" />
               <et:Header title="Qty" size="1" type="int"/>
               <et:Header title="Unit Cost" size="2" type="float"/>
                
                <et:Header title="" size="1"/>
            </et:Headers>
            <et:Content Query="#qWI#" Columns="Description,Quantity,UnitPrice" type="text,int,int" PKField="MRItemId"/>  
        </et:Table>    
    </td>
  </tr>
</table>

</div>



</f:Form>

</cfoutput>