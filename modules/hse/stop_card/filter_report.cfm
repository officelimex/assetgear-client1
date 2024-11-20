 
<cfoutput>
<cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />
<cfimport taglib="../../../assets/awaf/tags/xEditTable/" prefix="et" />

<cfset whsId = "__stop_card_c_report_issue"/>

<cfquery name="qD">
	SELECT * FROM core_department
</cfquery>
<br/><br/>
<f:Form id="#whsId#frm" action="modules/hse/stop_card/print_report.cfm" target="_blank"> 

	<table border="0" width="100%">
		<tr>
			<td width="50%" valign="top">
				<cfset s_date = dateformat(now(),"yyyy/mm/01")/>
                <cfset e_date = dateformat(s_date,"yyyy/mm/" & daysInMonth(s_date))/>
                <f:Select name="Acts" ListValue="SafeActs,UnsafeActs,UnsafeConditions" ListDisplay="Safe Acts,Unsafe Acts,Unsafe Conditions" Selected="" class="span6"/>
				<f:DatePicker name="StartDate" label="From" required value="#dateformat(s_date,'dd/mmm/yyyy')#"/>
                <f:DatePicker name="EndDate" label="To" value="#dateformat(e_date,'dd/mmm/yyyy')#" required/>
                <!---<f:Select name="WorkClassId" label="Work Class" ListValue="#Valuelist(qJC.JobClassId)#" ListDisplay="#Valuelist(qJC.Class)#" Selected="" /> --->
			</td>
			<td width="50%" valign="top" class="horz-div">
                <f:Select name="Priority" Label="Priority" ListValue="Low,Medium,High" Selected="" class="span6"/>
				<f:CheckBox name="DepartmentIds" ListValue="#ValueList(qD.DepartmentId)#" selected="" ListDisplay="#ValueList(qD.Name)#" inline showlabel label="Department" />
			</td> 
		</tr>
	</table> 

	<f:ButtonGroup>
		<f:Button value="Show Report" class="btn-primary" IsNewWindow/>
	</f:ButtonGroup>

</f:Form> 
</cfoutput>