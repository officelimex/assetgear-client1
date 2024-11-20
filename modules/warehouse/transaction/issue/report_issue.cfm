<!--- 
	Author: Arowolo Abiodun
	Created: 2011/09/30
	Modified: 2011/09/30
	->  
--->
 
<cfoutput>
<cfimport taglib="../../../../assets/awaf/tags/xForm_1001/" prefix="f" />
<cfimport taglib="../../../../assets/awaf/tags/xEditTable/" prefix="et" />

<cfset whsId = "__transaction_c_report_issue"/>

<br/><br/>
<f:Form id="#whsId#frm" action="modules/warehouse/transaction/report/issue_report.cfm" target="_blank"> 

	<table border="0" width="100%">
		<tr>
			<td width="50%" valign="top">
				<cfset s_date = dateformat(now(),"yyyy/mm/01")/>
				<f:DatePicker name="StartDate" label="Start date" required value="#dateformat(s_date,'dd/mmm/yyyy')#"/>
			</td>
			<td width="50%" valign="top" class="horz-div">
				<cfset e_date = dateformat(s_date,"yyyy/mm/" & daysInMonth(s_date))/>
				<f:DatePicker name="EndDate" label="End date" required value="#dateformat(e_date,'dd/mmm/yyyy')#"/>
			</td> 
		</tr>
	</table> 

	<f:ButtonGroup>
		<f:Button value="Show Report" class="btn-primary" IsNewWindow/>
	</f:ButtonGroup>

</f:Form> 
</cfoutput>
