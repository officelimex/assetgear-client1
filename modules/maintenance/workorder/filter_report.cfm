 
<cfoutput>
<cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />
<cfimport taglib="../../../assets/awaf/tags/xEditTable/" prefix="et" />

<cfset whsId = "__transaction_c_report_issue"/>

<cfset qJC = application.com.WorkOrder.GetJobClass()/>
<cfquery name="qD">
	SELECT * FROM core_department
</cfquery>
<br/><br/>
<f:Form id="#whsId#frm" action="modules/maintenance/workorder/print_work_report.cfm" target="_blank"> 

	<table border="0" width="100%">
		<tr>
			<td width="50%" valign="top">
				<cfset s_date = dateformat(now(),"yyyy/mm/01")/>
                <cfset e_date = dateformat(s_date,"yyyy/mm/" & daysInMonth(s_date))/>
				<f:DatePicker name="StartDate" label="From" required value="#dateformat(s_date,'dd/mmm/yyyy')#"/>
                <f:DatePicker name="EndDate" label="To" value="#dateformat(e_date,'dd/mmm/yyyy')#" required/>
                <f:Select name="WorkClassId" label="Work Class" ListValue="#Valuelist(qJC.JobClassId)#" ListDisplay="#Valuelist(qJC.Class)#" Selected="" /> 
                <f:Select name="JobType" Label="Job Type" ListValue="Planned,Unplanned" Selected="" class="span6"/>
			</td>
			<td width="50%" valign="top" class="horz-div">
                <f:Select name="Status" ListValue="Open,Close,Suspended,Part on hold" Selected="" class="span6"/>
				<f:CheckBox name="DepartmentIds" ListValue="#ValueList(qD.DepartmentId)#" selected="" ListDisplay="#ValueList(qD.Name)#" inline showlabel label="Department" />
			</td> 
		</tr>
	</table> 

	<f:ButtonGroup>
		<f:Button value="Show Report" class="btn-primary" IsNewWindow/>
	</f:ButtonGroup>

</f:Form> 
</cfoutput>