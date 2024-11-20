<cfoutput>
	<cfparam name="url.id" default="0"/>
	<cfparam name="url.dtYear" default="#dateFormat(now(),"yyyy")#" />
	<cfdocument pagetype="a4" format="pdf" margintop="0" marginbottom="0" marginleft="0" marginright="0" backgroundvisible="yes">
		<html>
			<head>
				<cfset bg = "##f3f3f3"/>
				<cfset brd_c = "##a5a5a5"/>
				<cfset brd_c2 = "##a5a5a5"/>
				<cfset wt = ""/>
				<!---<cfif qF.Status eq "Close">
					<cfset cl = "green"/>
				<cfelse>
					<cfset cl = "red"/>
				</cfif>--->
							<style type="text/css">

					html,body{padding:0; margin:0;font: 12px Tahoma;}
	.head_section td{font-size: 11px;padding:5px;}
	.head_section td.left{background-color:#bg#;border-left:#brd_c# 1px solid;}
	.head_section td.left,.head_section td.right{border-top:#brd_c# 1px solid;border-right:#brd_c# 1px solid;}
	.head_section td.bottom{border-bottom:#brd_c# 1px solid;}
	.sub_head{font-size:11px; background-color:#bg#;border-top:#brd_c# 1px solid; padding:5px;}
	.content{font-size:11px;padding:5px;}
	.tbl{
	font-size: 11px;
}
	.tbl th{font-weight: normal;background-color:#bg#;border-top:#brd_c2# 2px solid;border-right:#brd_c# 1px solid; text-align:left; padding:4px;}
	.tbl th.left{border-left:#brd_c# 1px solid;}
	.tbl td{
	padding: 3px 5px;
border-top:#brd_c# 1px solid;border-right:#brd_c# 1px solid;}
	.tbl td.left{border-left:#brd_c# 1px solid;}
	.tbl tr.bottom td{border-bottom:#brd_c# 1px solid;}
	.tbl td.no-right{border-right:none;}
	.tbl td.cbg{background-color:#bg#;}
	.tbl td.no-bottom{border-bottom:none !important;}
	.a-right{text-align:right !important;}
	.gray{color:gray;}
	th{text-align:left !important;}
				</style>
				<title></title>
			</head>
			<body>
				<cfquery name="qDownT" cachedwithin="#CreateTime(0,0,0)#">
					SELECT
					CONCAT(a.Description,' @ ',l.Name,' ',IFNULL(al.LocDescription,"")) AS AssetLocation
					,ad.*
					FROM asset_downtime AS ad
					INNER JOIN asset_location AS al ON ad.AssetLocationId = al.AssetLocationId
					INNER JOIN asset AS a ON al.AssetId = a.AssetId
					INNER JOIN location AS l ON al.LocationId = l.LocationId
					WHERE al.AssetLocationId = #url.id#
				</cfquery>
				<cfquery name="qDt">
					SELECT * FROM asset_downtime
					WHERE AssetLocationId = #url.id# AND Status = "Open"
				</cfquery>
				
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
				<cfset dtAvHr = val(qH.TotalHour) - val(qH.Periods) />
				<cfset avi = dtAvHr/val(qH.TotalHour) * 100 />
				
				<table width="100%">
					<cfdocumentitem type = "header">
						<cfset request.letterhead.title="EQUIPMENT AVAILIBILITY REPORT"/>
						<cfset request.letterhead.Id="<small> <sub style='font:10px'>" & qDownT.AssetLocation & "</sub> <br><a style='text-decoration:none' href='print_all_equipment.cfm' target='_blank'> <sub>View All Equipment</sub><small></a>"/>
						<cfset request.letterhead.noline=true/>
						<cfset request.letterhead.date = " "/>
						<cfinclude template="../../../include/letter_head.cfm"/>
					</cfdocumentitem>
				</table>

				<br><br>
				<table class="bal dwspc" width="100%" cellspacing="0" cellspadding="0" >
					<tr>
						<td width="18%" valign="bottom">&nbsp;PERIOD:  <sup><small style="font: 8px;color:blue">#url.dtYear#</small></sup></td>
						<td width="22%" valign="bottom"><span>TOTAL TIME: <sup><small style="font: 8px;color:blue">#qH.TotalHour# hrs</small></sup></span></td>
						<td width="25%" valign="bottom"><span>TOTAL UPTIME: <sup><small style="font: 8px;color:blue">#dtAvHr# hrs</small></sup></span></td>
						<td width="25%" valign="bottom"><span>TOTAL DOWNTIME: <sup><small style="font: 8px;color:blue">#qH.Periods# hrs</small></sup></span></td>

					</tr>
				</table> 
			
				<table width="100%" class="bal dwspc">
					<thead>
						<tr>
							<th nowrap="nowrap" style="text-align:left;">Availibility: #NumberFormat(avi,"9.99")# %</th>
						</tr>
					</thead>
				</table>
				<br>
				<table class="tbl" width="100%" cellspacing="0" cellspadding="0" >
					<thead>
						<tr>
							<th width="40%" align="left">DownTime Cause </th>
							<th align="left">Start Period</th>
							<th align="left">End Period</th>
							<th style="text-align:center !important;">D.T. (hrs)</th>
							<th style="text-align:right !important;" nowrap="nowrap" >F.R.##</th>
						</tr>
					</thead>
					<cfloop query="qHa">
						<tr class="bottom" >
							<td>#qHa.DownTimeCause#</td>
							<td>#dateFormat(qHa.StartPeriod, "dd-mm-yyyy")# #timeFormat(qHa.StartPeriod, "short")#</td>
							<td>#dateFormat(qHa.EndPeriod, "dd-mm-yyyy")# #timeFormat(qHa.EndPeriod, "short")#</td>
							<td style="text-align:center;">#qHa.Periods#</td>
							<td style="text-align:right;"><a style="text-decoration: none" href="print_failure_report.cfm?id=#qHa.FailureReportId#" target="_blank">#qHa.FailureReportId#&nbsp;</a></td>
						</tr>
					</cfloop>
				</table>


				<table width="100%" class="tbl">
					<tr>
						<td></td>
					</tr>
				</table>


			<table width="100%">

			<cfdocumentitem type="footer">
				<tr>
					<td >
						<table width="100%" border="0" style="font:9px Tahoma;">
							<tr>
								<td width="33%" align="center" style="padding-bottom:15px;"><table width="100%" border="0" cellpadding="0" cellspacing="0">
									<table width="100%">
										<tr class="nopadding">
											<td width="13%" align="right"><br/> <br/> <br/></td>
											<td width="87%" rowspan="2" valign="bottom">
												<!---<cfset fl = getSignature(qF.CreatedByUserId)/>
												&nbsp;&nbsp;&nbsp;<img src="../../../doc/photo/core_user/#qF.CreatedByUserId#/#fl#" height="30">---> 
												<span style="font-size:7px;">#dateformat(now(),'dd/mm/yyyy')#</span>
											</td>
										</tr>
										<tr>
											<td align="right" nowrap="nowrap">Sign / Date:</td>
										</tr>
										<tr>
											<td align="right">&nbsp;</td>
											<td><sup style="font-size:7px;">&nbsp;&nbsp; Names</sup></td>
										</tr>
									</table>
								</td>
								<td width="33%" align="center" style="padding-bottom:15px;"> </td>
								<td width="33%" align="center" style="padding-bottom:15px;">
									<table width="100%" border="0" cellpadding="0" cellspacing="0">
										<tr class="nopadding">
											<td width="53%" align="right"><br/> <br/> <br/> </td> 
											<td width="47%" valign="top">&nbsp;</td>
										</tr>
										<tr>
											<td align="right">Sign / Date:</td>
											<td>................................................</td>
										</tr>
										<tr>
											<td align="right">&nbsp;</td>
											<td><sup style="font-size:7px;">Head of Department: </sup></td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</cfdocumentitem>

			</body>
		</html>
	</cfdocument>

</cfoutput>

<cffunction name="getCheck" access="private" returntype="string">
	<cfargument name="lst1" type="string" required="yes"/>
    <cfargument name="vl" type="string" required="yes"/>

	<cfset var chk = 0/>
    <cfif ListFindNoCase(arguments.lst1,arguments.vl)>
        <cfset chk=1/>
    </cfif>

    <cfreturn chk/>
</cffunction>

<cffunction name="getSignature" access="private" returntype="string" hint="Get user signatire">
	<cfargument name="uid" hint="user id" required="yes" type="string"/>

    <cfquery name="qS1" cachedwithin="#CreateTime(1,0,0)#">
        SELECT * FROM `file`
        WHERE `Table` = 'core_user'
            AND `PK` = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.uid)#"/>
        LIMIT 0,1
    </cfquery>

    <cfreturn qS1.File/>
</cffunction>
