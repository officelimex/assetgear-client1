<cfparam default="0" name="url.id"/>
<cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />
<cfimport taglib="../../../assets/awaf/tags/xNavTab_1000/" prefix="nt" />

<cfset frId = "__asset_c_all_downtime#url.id#"/>

<cfquery name="qDownT" cachedwithin="#CreateTime(0,0,0)#">
    SELECT
	CONCAT(a.Description,' @ ',l.Name,' ',IFNULL(al.LocDescription,"")) AssetLocation
	,ad.*
	FROM
	asset_downtime AS ad
	INNER JOIN asset_location AS al ON ad.AssetLocationId = al.AssetLocationId
	INNER JOIN asset AS a ON al.AssetId = a.AssetId
	INNER JOIN location AS l ON al.LocationId = l.LocationId
	WHERE al.AssetLocationId = #url.id#
</cfquery>
<cfquery name="qDt">
	SELECT * FROM asset_downtime
	WHERE AssetLocationId = #url.id# AND Status = "Open"
</cfquery>


<cfoutput>
	<cfset Id1 = "#frId#_1"/>
	<cfset Id2 = "#frId#_2"/>
	
	<div id="#Id1#">
		<f:Form id="#frId#frm" action="controllers/Asset.cfc?method=SaveDowntime" EditId="#val(qDt.DownTimeId)#">
			<table width="100%">
				<tr>
					<td colspan="2">
						<f:TextArea name="DownTimeCause" required value="#qDt.DownTimeCause#" Label="Reason for Downtime" class="span12"/>
						<input name="DowntimeId" type="hidden" value="#qDt.DownTimeId#" />
						<input name="AssetLocationId" type="hidden" value="#url.id#" />
						<input name="Asset" type="hidden" value="#qDownT.AssetLocation#" />
					</td>
				</tr>
				<tr>
					<td valign="top" width="50%">
						<f:DatePicker name="StartPeriod" label="Downtime Start At" value="#qDt.StartPeriod#" required class="span12" type="datetime" />								
					</td>
					<td valign="top">
						<f:DatePicker name="EndPeriod" label="Downtime End At" value="#qDt.EndPeriod#" class="span12" type="datetime" />
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<f:TextArea name="Remark" value="#qDt.Remark#" Label="Remark" class="span12"/>
					</td>
				</tr>
				<tr>
					<td valign="top" colspan="2">
						<f:TextBox name="FailureReportId" label="Failure Report Id" value="#qDt.FailureReportId#" class="span4"/>
					</td>
				</tr>
			</table>
			
			<cfif url.id neq 0>
				<f:ButtonGroup>
					<f:Button value="Save" class="btn-primary" IsSave subpageId="downtime" ReloadURL="modules/maintenance/asset/view_downtime.cfm"/>
				</f:ButtonGroup>
			</cfif>
		</f:Form>
	</div>
	<div id="#Id2#">
		<CFQUERY name="qH">
			SELECT
			SUM(TIMESTAMPDIFF(hour,startperiod,EndPeriod)) as Periods, TIMESTAMPDIFF(hour,DATE_FORMAT(NOW() ,'%Y-01-01'),CURRENT_DATE()) AS TotalHour,
			StartPeriod,EndPeriod
			FROM asset_downtime 
			WHERE `Status` = "Close" AND AssetLocationId = #url.id# AND
			YEAR(StartPeriod) = year(now())
		</CFQUERY>
		<CFQUERY name="qHa">
			SELECT
			DownTimeCause,TIMESTAMPDIFF(hour,startperiod,EndPeriod) as periods, TIMESTAMPDIFF(hour,DATE_FORMAT(NOW() ,'%Y-01-01'),CURRENT_DATE()) AS TotalHour,
			StartPeriod,EndPeriod,FailureReportId
			FROM asset_downtime 
			WHERE  AssetLocationId = #url.id# AND
			YEAR(StartPeriod) = year(now())
		</CFQUERY>
		<cfset totalHours = qHa.TotalHour />
		<cfset dtYear = year(now()) />
		<cfset dtAvHr = val(qH.TotalHour) - val(qH.Periods) />
		<cfset avi = dtAvHr/val(qH.TotalHour) * 100 />
		
		
		
		<table class="table table-striped table-condensed table-hover">
			<thead>
				<tr>
					<th>Period:  #dtYear#</th>
					<th>Total Time: #qH.TotalHour# hrs</th>
					<th>Down Time: #qH.Periods# hrs</th>
					<th nowrap="nowrap">Up Time: #dtAvHr# hrs</th>
					<th nowrap="nowrap" style="text-align:right;">Availibility %: #NumberFormat(avi,"9.99")#</th>
				</tr>
			</thead>
		</table>
		<hr>
		<table class="table table-striped table-condensed table-hover">
			<thead>
				<tr>
					<th>DownTime Cause </th>
					<th>Start Period</th>
					<th>End Period</th>
					<th align="center">D.T. (hrs)</th>
					<th nowrap="nowrap" style="text-align:right;">F.R.##</th>
				</tr>
			</thead>
			<cfloop query="qHa">
				<tr>
					<td>#qHa.DownTimeCause#</td>
					<td>#dateFormat(qHa.StartPeriod, "short")# #timeFormat(qHa.StartPeriod, "short")#</td>
					<td>#dateFormat(qHa.EndPeriod, "short")# #timeFormat(qHa.EndPeriod, "short")#</td>
					<td style="text-align:center;">#qHa.Periods#</td>
					<td style="text-align:right;"><a href="modules/maintenance/asset/print_failure_report.cfm?id=#qHa.FailureReportId#" target="_blank">#qHa.FailureReportId#</a></td>
				</tr>
			</cfloop>
		</table>
	</div>

	<nt:NavTab renderTo="#frId#">
	<nt:Tab>
    	<nt:Item title="Data Form" isactive/>
        <nt:Item title="Report History"/>
    </nt:Tab>
    <nt:Content>
    	<nt:Item id="#Id1#" isactive/>
        <nt:Item id="#Id2#"/>
    </nt:Content>
</nt:NavTab>
	<!---<f:Form id="#frId#downtime" action="controllers/Asset.cfc?method=SaveDowntime" EditId="#url.id#">
		<br>	
		<table>
			<td width="100%" colspan="2">
				<f:Select name="AssetLocationId"
					label="Asset" required
					ListValue="#valuelist(qA.AssetLocationId,'`')#" autoselect
					delimiters="`" ListDisplay="#valuelist(qA.AssetLocation,'`')#"
					selected="" class="span12"/>
			</td>
			<tr>
				<td colspan="2">
					<f:TextArea name="DownTimeCause" required label="DownTime Cause" value="" class="span12" row="3"/>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<f:TextArea name="Remark" label="Remark" value="" class="span12" row="3"/>
				</td>
			</tr>
			<tr>
				<td>
					<f:DatePicker name="StartPeriod" label="Noticed date" value="" required class="span12" type="datetime" />
				</td>
				<td>
					<f:DatePicker name="EndPeriod" label="Noticed date" value=""  class="span12" type="datetime" />
				</td>
			</tr>
		</table>

			
		
        <cfif url.id eq 0>
			<f:ButtonGroup>
				<f:Button value="Create new DT." class="btn-primary" IsSave subpageId="downtime" ReloadURL="modules/maintenance/asset/view_downtime.cfm"/>
			</f:ButtonGroup>
		</cfif>
	</f:Form>--->

</cfoutput>
