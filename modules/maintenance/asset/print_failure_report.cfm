<cfoutput>

<cfdocument pagetype="a4" format="pdf" margintop="0" marginbottom="0" marginleft="0" marginright="0" backgroundvisible="yes">
<html>
<head>
<cfset bg = "##f3f3f3"/>
<cfset brd_c = "##a5a5a5"/>
<cfset brd_c2 = "##a5a5a5"/>
<cfset wt = ""/>
<style type="text/css">

	html,body{padding:0; margin:0;font: 11px Tahoma;}
	.tbl-pad-4 td{
        padding: 4px 4px 0px 0px
    }
	.tbl{font-size: 12px;margin-left: 12px;margin-right: 12px;}
    .bal{margin-left: 12px; margin-right: 12px}
    .dwspc {margin-bottom: 5px}.upspc {margin-bottom: 5px}
	sub{font-size: 4px;}
	.tbl > tr > td{vertical-align:top; padding-left: 2px; padding-top:2px;border:#brd_c# 1px solid;}
	.tbl td.left{border-left:#brd_c# 1px solid;}
	.tbl tr.bottom td,.tbl td.bottom{border-bottom:#brd_c# 1px solid;}
	.tbl td.no-right{border-right:none;}
	.tbl td.no-left{border-left:none !important;}
	.tbl td.cbg{background-color:#bg#;}
	.tbl .no-bottom{border-bottom:none !important;}
	.tbl .no-top{border-top:none !important;}
	.a-right{text-align:right !important;}
	.underline{border-bottom:##666 1px dotted; font-style:italic;}
	.sign > tr > td{padding: 5px 0 0px;}
	.pad-left-5	{padding-left:5px !important;}
	.pad-bottom-2	{padding-left:2px !important;}
	.pad-right-3	{padding-right:3px !important;}
	.pt5	{padding-top:5px !important;}
	.pt8	{padding-top:8px !important;}
	.plb5	{padding-top:4px;padding-left:5px;padding-bottom:12px !important;}
	 .v-middle, .v-middle img	{vertical-align:middle;}
	 img{margin-top:1px;}
    
	 .cbg img{margin:0px;}
     .red{color:red;}
     .green{color:green;}
     small{text-transform:uppercase; font-size:7px;}
</style>
<title></title>
</head>
<body>

<cfquery name="qF">
    SELECT
        fr.*,
        al.AssetLocationId,al.LocDescription,
        a.Description Asset, a.Status AssetStatus,a.*,
        ac1.Name Cat1,
        ac2.Name Cat2,
        l1.Name Loc1,
        l2.Name Loc2,
        u1.Surname cSurname, u1.OtherNames cOtherNames,
        wo.Description WorkDescription
    FROM
        asset_failure_report fr
    LEFT JOIN work_order wo ON wo.WorkOrderId = fr.WorkOrderId
    LEFT JOIN asset_location al ON al.AssetLocationId = fr.AssetLocationId
    LEFT JOIN asset a ON a.AssetId = al.AssetId
        LEFT JOIN asset_category ac1 ON ac1.AssetCategoryId = a.AssetCategoryId
        LEFT JOIN asset_category ac2 ON ac2.AssetCategoryId = ac1.ParentAssetCategoryId
    LEFT JOIN location l1 ON l1.LocationId = al.LocationId
        LEFT JOIN location l2 ON l2.LocationId = l1.ParentLocationId
    INNER JOIN core_user u1 ON u1.UserId = fr.CreatedByUserId
    WHERE fr.AssetFailureReportId = #val(url.id)#
</cfquery>
<cfquery name="qIn">
    SELECT * FROM failure_report_integration 
    WHERE AssetFailureReportId = #val(url.id)#
    ORDER BY IntegrateTable
</cfquery>
<cfquery name="qIn">
    SELECT * FROM failure_report_integration WHERE AssetFailureReportId = #val(url.Id)#
</cfquery>
<cfif qF.AssetId eq ""><cfset qF.AssetId = 0/></cfif>
    <cfquery name="qC">
        SELECT * FROM custom_field
        WHERE `Table` = "asset" AND `PK` = #qF.AssetId#
    </cfquery>
    <cfif qF.Status eq "Close">
        <cfset cl = "green"/>
    <cfelse>
        <cfset cl = "red"/>
    </cfif>
        <cfset resolvetime = now()/>
        <cfif qF.ResolvedDate neq "">
            <cfset resolvetime = qF.ResolvedDate />
        </cfif>
        <cfscript>
        	totalMinutes = datediff("n", qF.Date, resolvetime);
			days = int(totalMinutes /(24 * 60)) ;
			minutesRemaining = totalMinutes - (days * 24 * 60);
			hours = int(minutesRemaining / 60);
			minutes = minutesRemaining mod 60;
			dys="";hrs="";mins="";
			if(days neq 0) dys = days & ' days ';
			if(hours neq 0) hrs = hours & ' hours ';
			if(minutes neq 0) mins = minutes & ' minutes';
			delay = dys & hrs & mins;
        </cfscript>

<table width="100%">
  
    <cfdocumentitem type = "header">
        <cfset request.letterhead.title="ASSET FAILURE REPORT"/>
        <cfset request.letterhead.Id="AFR ## #url.id# <p style='font-size:10px; margin-top:4px'>REPORT STATUS:<i class='#cl#'>#ucase(qF.Status)# </i></p>"/>
        <cfset request.letterhead.noline=true/>
        <cfset request.letterhead.date=dateformat(qF.CreatedDate,'dd-mmm-yyyy')/>
        <cfinclude template="../../../include/letter_head.cfm"/>
    </cfdocumentitem>
</table>

        <!---cfset delay = dateDiff("h",qF.Date,resolvetime) /--->
    
        
    <table class="bal dwspc" width="100%" cellspacing="0" cellspadding="0" >
        <tr>
            <td width="30%" valign="bottom">FAILURE ON:  #ucase(qF.FailureOn)#</td>
            <td valign="bottom"><span>RISK LEVEL: #ucase(qF.RiskLevel)#</span></td>
            <td colspan="2" width="50%" align="right" class="#cl#" valign="bottom"><strong>DOWN TIME</strong> #delay#</td>
        </tr>
    </table> 

    <table class="tbl" width="100%" cellspacing="0" cellpadding="0">
        <tr colspan="3">
	       <td><small class="green">Report Title</small><div class="plb5">#qF.ReportTitle#</div></td>
	   </tr>
        <cfif qF.FailureOn eq "Fix Asset">
            <tr>
               <td width="35%">
                   <table width="100%">
                       
                       <tr>
                           <td><small class="green">ASSET</small><div class="plb5">#qF.Asset#</div></td>
                       </tr>
                       <tr>
                           <td>
                               <small class="green">ASSET LOCATION Location</small>
                               <div class="plb5"><cfif qF.Loc2 neq "">#qF.Loc2# > </cfif>#qF.Loc1# #qF.LocDescription#</div>
                           </td>
                       </tr>
                   </table>
               </td>
               <td width="35%">
                   <table width="100%">
                       <tr>
                           <td><small class="green">CATEGORY</small><div class="plb5"><cfif qF.Cat2 neq "">#qF.Cat2# / </cfif> #qF.Cat1#</div></td>
                       </tr>
                       <tr>
                           <td><small class="green">OWNERSHIP</small><div class="plb5">#qF.Ownership#</div></td>
                       </tr>
                   </table>
               </td>
               <td>
                   <table width="100%">
                       <tr>
                           <td><small class="green">ASSET SPECIFICATIONS</small><div class="plb5">#qF.Asset#</div></td>
                       </tr>
                       <tr>
                           <td>
                               <table width="100%">
                                    <tr>
                                        <td><small class="green">STATUS</small> </td>
                                        <td>#qF.AssetStatus#</td>
                                    </tr>
                                    <cfif qF.Model neq "">
                                        <tr>
                                            <td><small class="green">MODEL</small></td>
                                            <td>#qF.Model#</td>
                                        </tr>
                                    </cfif>
                                    <cfif qF.ModelNumber neq "" OR qF.SerialNumber neq "">
                                        <tr>
                                            <td><small class="green">MODEL ##</small></td>
                                            <td>#qF.ModelNumber# #qF.SerialNumber#</td>
                                        </tr>
                                    </cfif>
                                    <cfloop query="qC">
                                        <tr>
                                            <td><small class="green">#Field#</small></td><td>#Value#</td>
                                        </tr>
                                    </cfloop>
                                </table>
                           </td>
                       </tr>
                   </table>
               </td>
            </tr>
                   
        <cfelse>
                    
            <tr class="">
                <td colspan="3"><small class="green">FAILED SERVICE</small> <div class="plb5">#qF.ServiceDescription#</div></td>
            </tr>
                   
        </cfif>
        <tr>
            <td colspan="3">
                <table width="100%">
                   
                    <tr>
                        <td width="25%">
                            <small class="green">NOTICED DATE</small><div class="plb5">#DateFormat(qF.Date,"dd-mm-yyyy")# <small>#timeFormat(qF.Date,"h:mm tt")#</small></div>
                            <small class="green">RESOLVE TIME LINE </small><div class="plb5">#qF.ResolveTimeLine# <small>FROM #DateFormat(qF.ResolveStartTime,"dd-mm-yyyy")# #timeFormat(qF.ResolveStartTime,"h:mm tt")#</small></div>
                            <small class="green">RESOLVED DATE</small><div class="plb5">#DateFormat(qF.ResolvedDate,"dd-mm-yyyy")# <small>#timeFormat(qF.ResolvedDate,"h:mm tt")#</small></div>

                        </td>
                        <td width="45%" class="left" valign="top"><small class="green">INITIATOR'S COMMENT</small><div class="plb5">#qF.InitiatorsComment#</div></td>
                        <td class="left" valign="top">
                            <small class="green">INTEGRATE WITH</small>
                            <div class="plb5">
                                <table width="100%">
                                    <cfloop query="qIn">
                                        <cfif IntegrateTable eq "Work Order">
                                            <cfset a = "../workorder/print_workorder.cfm?id=" />
                                        <cfelse>
                                            <cfset a = "../../hse/incident_report/print_incident.cfm?&id=" />
                                        </cfif>
                                        <tr>
                                            <td>#IntegrateTable# ##</td><td align="right" target="_blank"><a style="text-decoration: none" href="#a##PK#">#PK# &nbsp;</a></td>
                                        </tr>
                                    </cfloop>
                                </table>
                            </div>
                        </td> 
                    </tr>
                </table>
            </td>
            
        </tr>
    </table>
    <table class="tbl" width="100%" cellspacing="0" cellpadding="0">
        <tr>
            <td colspan="3">
                <small class="green">SUSPECTED CAUSE</small>
                <cfset _rc = "Design/Manufacturer,Shipping,Storage,Installation,Maintenance,Wear/Aging,Natural Disaster,Animals/Birds,Not Obvious,Others"/>
                <div class="plb5">
                    <cfloop list="#_rc#" item="it">
                        <cfset chk = getCheck(qF.SuspectedCause,it)/>
                        <img src="../../../assets/img/ptw_checkbox_#chk#.png" width="10" height="10"> #it# &nbsp;
                    </cfloop>
                </div>
                <cfif qF.DescriptionOfSuspectedCause neq "">
                    <small class="green">DESCRIPTION OF SUSPECTED CAUSE</small><div class="plb5">#qF.DescriptionOfSuspectedCause#</div>
                </cfif>
                <cfif qF.OtherCauses neq "">
                    <small class="green">OTHER CAUSE</small><div class="plb5">#qF.OtherCauses#</div>
                </cfif>
                <small class="green">#ucase("Measure(s) taken When Noticed")#</small>
                <cfset _rc1 = "Equipment Replacement,Overhaul,Reduce Service Duration,Equipment Substitution,Upgrade,Beyond My Control,Others"/>
                <div class="plb5">
                    <cfloop list="#_rc1#" item="it">
                        <cfset chk = getCheck(qF.PreventiveMeasure,it)/>
                        <img src="../../../assets/img/ptw_checkbox_#chk#.png" width="10" height="10"> #it# &nbsp;
                    </cfloop>
                </div>
                <cfif qF.OtherPreventiveMeasure neq "">
                    <small class="green">OTHER MEASURES TAKEN</small><div class="plb5">#qF.OtherPreventiveMeasure#</div>
                </cfif>
    
            </td>
        </tr>
    </table>
    <table class="tbl" width="100%" cellspacing="0" cellpadding="0">
        <tr>
            <td colspan="3">
                <small class="green">ACTION TAKEN</small>
                <cfset _rc2 = "Report Equipment Behaviour,Equipment Shutdown/Isolation,Fault Findings,Carried out Repairs,Function Tested,Others"/>
                <div class="plb5">
                    <cfloop list="#_rc2#" item="it">
                        <cfset chk = getCheck(qF.PreventiveMeasure,it)/>
                        <img src="../../../assets/img/ptw_checkbox_#chk#.png" width="10" height="10"> #it# &nbsp;
                    </cfloop>
                </div>
                <cfif qF.OtherActionTaken neq "">
                    <small class="green">OTHER ACTION TAKEN</small><div class="plb5">#qF.OtherActionTaken#</div>
                </cfif>
                <cfif qF.Recommendation neq "">
                    <small class="green">RECOMMENDATION(S)</small><div class="plb5">#qF.Recommendation#</div>
                </cfif>
                
                
            </td>    
        </tr>
    </table>
    <table class="tbl" width="100%" cellspacing="0" cellpadding="0">
        <tr>
            <td colspan="3">
                <table width="100%">
                    <tr>
                        <td width="50%">
                            <small class="green">#ucase("What effect does it have on operations")#</small>
                            <div class="plb5">#qF.Effect#</div>
                        </td>
                        <td >
                            <small class="green">#ucase("Reason for delay in resolving issues (If any)")#</small>
                            <div class="plb5">#qF.ReasonForDelay#</div>
                        </td>
                    </tr>
                </table> 
            </td>   
        </tr>
    </table>
    <table class="tbl" width="100%" cellspacing="0" cellpadding="0">
        <tr>
            <td colspan="3">
                <small class="green">ROOT CAUSE</small>
                <cfset _rc6 = "Human Error,Asset Lifespan,Asset Fatigue,Installation Error,Mechanical Error,Electrical Error,Natural Disaster:Rain,Natural Disaster:Lightening,Natural Disaster:Flood,Natural Disaster:Stome,Others"/>
                <div class="plb5">
                    <cfloop list="#_rc6#" item="it">
                        <cfset chk = getCheck(qF.RootCause,it)/>
                        <img src="../../../assets/img/ptw_checkbox_#chk#.png" width="10" height="10"> #it# &nbsp;
                    </cfloop>
                </div>
                <cfif qF.OtherRootCause neq "">
                    <small class="green">OTHER ROOT CAUSES</small><div class="plb5">#qF.OtherRootCause#</div>
                </cfif>
                <cfif qF.WorkDone neq "">
                    <small class="green">WORK DONE</small><div class="plb5">#qF.WorkDone#</div>
                </cfif>
                <cfif qF.DownTimeCosting neq "">
                    <small class="green">COST OF DOWNTIME</small><div class="plb5">#qF.DownTimeCosting#</div>
                </cfif>
                <cfif qF.SupervisorComment neq "">
                    <small class="green">SUPERVISOR'S COMMENT</small><div class="plb5">#qF.SupervisorComment#</div>
                </cfif>
            </td>        
        </tr>
            
    </table>
    
 
    <table width="100%" class="tbl">
        <tr>
            <td></td>
        </tr>
    </table>

   
<table width="100%">

<cfdocumentitem type="footer">
<tr><td ><table width="100%" border="0" style="font:9px Tahoma;">
  <tr>
    <td width="33%" align="center" style="padding-bottom:15px;"><table width="100%" border="0" cellpadding="0" cellspacing="0">
      <tr class="nopadding">
        <td width="13%" align="right"><br/>
          <br/>
          <br/></td>
        <td width="87%" rowspan="2" valign="bottom">
        <cfset fl = getSignature(qF.CreatedByUserId)/>
        &nbsp;&nbsp;&nbsp;<img src="../../../doc/photo/core_user/#qF.CreatedByUserId#/#fl#" height="30"> <span style="font-size:7px;">#dateformat(qF.Date,'dd/mm/yyyy')#</span></td>
      </tr>
      <tr>
        <td align="right" nowrap="nowrap">Sign / Date:</td>
        </tr>
      <tr>
        <td align="right">&nbsp;</td>
        <td><sup style="font-size:7px;">&nbsp;&nbsp; #qF.cSurname# #qF.cOtherNames#</sup></td>
      </tr>
    </table>
    </td>
    <td width="33%" align="center" style="padding-bottom:15px;">

    </td>
    <td width="33%" align="center" style="padding-bottom:15px;"><table width="100%" border="0" cellpadding="0" cellspacing="0">
      <tr class="nopadding">
        <td width="53%" align="right"><br/>
          <br/>
          <br/></td>
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
    </table></td>
  </tr>
</table>
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
