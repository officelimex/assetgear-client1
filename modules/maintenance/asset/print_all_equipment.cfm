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
				<cfquery name="qE" cachedwithin="#CreateTime(0,0,0)#">
					#application.com.Asset.SQL_ASSET_DOWNTIME#
					ORDER BY a.Description ASC
				</cfquery>
				
				
				
				
				<table width="100%">
					<cfdocumentitem type = "header">
						<cfset request.letterhead.title="EQUIPMENT AVAILIBILITY REPORT"/>
						<cfset request.letterhead.Id="<small style='color:blue'><strong></strong> ALL CRITICAL EQUIPMENT</small>"/>
						<cfset request.letterhead.noline=true/>
						<cfset request.letterhead.date = "PERIOD: <sup><small style='font: 8px;color:blue'>#url.dtYear#</small></sup>"/>
						<cfinclude template="../../../include/letter_head.cfm"/>
					</cfdocumentitem>
				</table>

			
				
						
				<table class="tbl" width="100%" cellspacing="0" cellspadding="0" >
					<thead>
						<tr>
							<th align="left">#### </th>
							<th width="40%" align="left">Asset Description </th>
							<th style="text-align:left !important;">T.T. (hrs)</th>
							<th style="text-align:left !important;">D.T. (hrs)</th>
							<th style="text-align:left !important;">U.T. (hrs)</th>
							<th style="text-align:left !important;">Avail. (%)</th>
							<th style="text-align:left !important;">Status</th>
						</tr>
					</thead>
					<cfset i = 1 />
					<cfloop query="qE">
						<tr class="bottom" >
							<td>#i++#</td>
							<td><a href="print_equipment.cfm?id=#AssetLocationId#" style="text-decoration: none">#AssetDescriptions#</a> </td>
							<cfquery name="q2"> 
								SELECT
								SUM(TIMESTAMPDIFF(hour,startperiod,EndPeriod)) as DTPeriod, TIMESTAMPDIFF(hour,DATE_FORMAT(NOW() ,'%Y-01-01'),CURRENT_DATE()) AS TotalHour,
								StartPeriod,EndPeriod
								FROM asset_downtime 
								WHERE `Status` = "Close" AND AssetLocationId = #AssetLocationId# AND YEAR(StartPeriod) = year(now())
							</cfquery>

							<td style="text-align:left;">#numberFormat(q2.TotalHour,"9")#</td>
							<td style="text-align:left;">#numberFormat(q2.DTPeriod,"9")#</td>
							<td style="text-align:left;">#numberFormat(val(q2.TotalHour) - val(q2.DTPeriod),"9")#</td>
							<td style="text-align:left;">#numberFormat(numberFormat(((val(q2.TotalHour) - val(q2.DTPeriod))/val(q2.TotalHour))*100,"9.99"),"9.99")#</td>
							<td style="text-align:left;">
								<cfquery name="q3"> SELECT Status FROM asset_downtime WHERE AssetLocationId = "#qE.AssetLocationId#" AND Status = "Open" </cfquery>

								<cfif q3.RecordCount gt 0>
									<span style="color: crimson">Down</span>
								<cfelse>
									<span style="color: blue">Online</span>
								</cfif>
							</td>
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
