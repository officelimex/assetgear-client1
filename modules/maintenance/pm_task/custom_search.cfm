<cfoutput>
<cfimport taglib=" ../../../../../assets/awaf/tags/xForm_1001/" prefix="f" />
<cfimport taglib="../../../../../assets/awaf/tags/xEditTable/" prefix="et" />

<cfset CusId = "__pm_task_c_custom"/>
<cfset s_date = dateformat(now(),"yyyy/mm/01")/>
<cfset e_date = dateformat(s_date,"yyyy/mm/" & daysInMonth(s_date))/>

<br/><br/>
<f:Form id="#CusId#frm" action="modules/maintenance/pm_task/print_scheduled.cfm" target="_blank"> 
	<table border="0" width="100%">
		<tr>
			<td width="70%" valign="top">
				<f:TextBox name="assetname" label="Asset" value="" class="span10"/>
			</td>
			<td width="30%" valign="top" class="horz-div">

			</td> 
		</tr>
	</table> 

	<f:ButtonGroup>
		<f:Button value="Show Report" class="btn-primary" IsNewWindow/>
	</f:ButtonGroup>

</f:Form> 
</cfoutput>
