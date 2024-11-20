<cfoutput>
<cfset qP = application.com.Permit.GetPermit(url.id)/>
<cfset qGT = application.com.Permit.GetGasTest(url.id)/>
<cfset qAL = application.com.Asset.GetAssetLocationInWorkOrder(qP.AssetLocationIds)/>
<cfset qL = application.com.WorkOrder.GetLabourers(qP.WorkOrderId)/>

<cfdocument pagetype="a4" format="pdf" margintop="0" marginbottom="0" marginleft="0" marginright="0" backgroundvisible="yes">
<html>
<head>
<cfset bg = "##f3f3f3"/>
<cfset brd_c = "##e0e0e0"/>
<cfset brd_c2 = "##a5a5a5"/>
<cfset wt = ""/>
<cfswitch expression="#qP.WorkType#"> 
	<cfcase value="Cold Work"><cfset wt = "cold.gif"/></cfcase>
    <cfcase value="Hot Work"><cfset wt = "fire.gif"/></cfcase>
    <cfcase value="Electrical Work"><cfset wt = "plug.gif"/></cfcase> 
</cfswitch>
<style type="text/css">	
	body{
	background: url(#application.site.url#assets/img/#wt#) no-repeat fixed center center;
}
	html,body{padding:0; margin:0;font: 11px Tahoma;}
	.tbl-pad-4 td{
	padding: 4px 4px 0px 0px
}
	.tbl{font-size: 8px;} 
	sub{font-size: 4px;}
	.tbl > tr > td{padding: 3px 5px;border-top:#brd_c# 1px solid;border-right:#brd_c# 1px solid;}
	.tbl td.left{border-left:#brd_c# 1px solid;}
	.tbl tr.bottom td,.tbl td.bottom{border-bottom:#brd_c# 1px solid;}
	.tbl td.no-right{border-right:none;}
	.tbl td.cbg{background-color:#bg#;}
	.tbl td.no-bottom{border-bottom:none !important;}
	.a-right{text-align:right !important;}
	.underline{border-bottom:##666 1px dotted; font-style:italic;}
	.sign > tr > td{padding: 5px 0 0px;}
	.pad-left-5	{padding-left:5px !important;}
	.pad-bottom-2	{padding-left:2px !important;}
	.pad-right-3	{padding-right:3px !important;}
	 .v-middle, .v-middle img	{vertical-align:middle;}
	 img{margin-top:1px;}
	 .cbg img{margin:0px;}
</style>
<title></title>
</head>
<body>
<table width="100%">
<cfdocumentitem type = "header">
<cfset request.letterhead.title="PERMIT TO WORK"/>
<cfset request.letterhead.Id="PTW ## #url.id#"/>
<cfset request.letterhead.noline=true/>
<!---cfset request.letterhead.logosize=40/--->
  <cfinclude template="../../../include/letter_head.cfm"/>
</cfdocumentitem> 
<tr>
<td><table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td><table width="100%" border="0" cellspacing="0" cellpadding="0" class="tbl">
      <tr>
        <td width="25" align="center" valign="middle" class="left cbg"><img src="#application.site.url#assets/img/sec1.png"/></td>
        <td colspan="4" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><table width="100%" border="0" cellspacing="0" cellpadding="0" class="tbl-pad-4">
              <tr>
                <td width="16%">FACILITY/INSTALLATION: </td>
                <td width="67%" class="underline">
                #replace(valuelist(qAL.Location),',',', ','all')# &mdash; #qP.Asset#
                </td>
                <!---<td width="7%" align="right" class="pad-left-5">LOCATION:</td>
                <td width="10%" nowrap="nowrap" class="underline">#replace(valuelist(qAL.Location),',',', ','all')#</td>--->
              </tr>
            </table></td>
          </tr>
          <tr>
            <td><table width="100%" border="0" cellspacing="0" cellpadding="0" class="tbl-pad-4">
              <tr>
                  <td width="15%" align="left" >WORK DESCRIPTION:</td>
                  <td width="85%" class="underline">#qP.Work#</td>
                </tr>
            </table></td>
          </tr>
          <tr>
            <td><table width="100%" border="0" cellspacing="0" cellpadding="0" class="tbl-pad-4">
              <tr>
                <td width="15%" align="left" nowrap="nowrap" >EQUIPMENT/TOOL/MATERIAL TO BE USED:</td>
                <td width="85%" class="underline">#qP.EquipmentToUse#&nbsp;</td>
              </tr>
            </table></td>
          </tr>
          <tr>
            <td><table width="100%" border="0" cellspacing="0" cellpadding="0" class="tbl-pad-4">
              <tr>
                <td width="149" align="left" nowrap="nowrap" >START DATE/TIME:</td>
                <td width="242" align="left" nowrap="nowrap" class="underline" >#Dateformat(qP.StartTime,'dd-mmm-yyyy')# #timeformat(qP.StartTime,'hh:mm tt')#</td>
                <td width="139" align="right" nowrap="nowrap" class="pad-left-5" >END DATE/TIME:</td>
                <td width="162" align="left" nowrap="nowrap" class="underline" >#Dateformat(qP.EndTime,'dd-mmm-yyyy')# #timeformat(qP.EndTime,'hh:mm tt')#</td>
                <td width="109" align="left" >&nbsp;</td>
                <td width="283" align="right" nowrap="nowrap" >NO. OF WORKERS</td>
                <td width="186" align="center" class="underline"><cfif qP.NumberOfWorkers eq 0>#qL.Recordcount#<cfelse>#qP.NumberOfWorkers#</cfif>&nbsp;</td>
              </tr>
            </table></td>
          </tr>
          <tr>
            <td><table width="100%" border="0" cellspacing="0" cellpadding="0" class="tbl-pad-4">
              <tr>
                <td width="10%" nowrap="nowrap">DEPARTMENT: </td>
                <td width="36%" class="underline">#ucase(qP.Department)#</td>
                <td width="15%" align="right" class="pad-left-5">CONTRACTOR:</td>
                <td width="39%" nowrap="nowrap" class="underline">#qP.Contractor#&nbsp;</td>
              </tr>
            </table></td>
          </tr>
        </table></td>
        </tr>
      <tr>
        <td rowspan="4" align="center" valign="middle" class="left cbg"><img src="#application.site.url#assets/img/sec2.png"/></td>
        <td colspan="2" rowspan="4" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td height="18" colspan="2">SAFETY PRECAUTIONS TO BE TAKEN AT WORK PLACE</td>
            </tr>
          <tr>
            <td width="15" align="center" valign="top">
            <cfset chk = getCheck(qP.SafetyRequirement1,'Job hazard analysis sheet attached')/>
<img src="#application.site.url#assets/img/ptw_checkbox_#chk#.png" width="9" height="9"></td>
            <td >Job Hazard analysis sheet attached </td>
          </tr>
        </table><br/>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td height="18" colspan="2" nowrap="nowrap">FACILITIES TO BE ISOLATED BY:</td>
      </tr>
      <cfset ftbib = "Spades or Blinds,Physical seperation,Closed valves,De-energising prim mover"/>
      <cfloop list="#ftbib#" index="it">
      <tr>
        <td width="15" align="center" valign="middle">
        <cfset chk = getCheck(qP.SafetyRequirement2,it)/>
        <img src="#application.site.url#assets/img/ptw_checkbox_#chk#.png" width="9" height="9"></td>
        <td height="13" valign="middle">#it#</td>
      </tr>
      </cfloop> 
    </table><br/>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td height="18" colspan="2" nowrap="nowrap">FACILITIES TO BE PREPARED BY:</td>
      </tr>
      <cfset ftbpb = "Depressurising,Draining / Venting,Steaming,Gas Test"/>
      <cfloop list="#ftbpb#" index="it">
      <tr>
        <td width="15" align="center" valign="middle">
        <cfset chk = getCheck(qP.SafetyRequirement3,it)/>
        <img src="#application.site.url#assets/img/ptw_checkbox_#chk#.png" width="9" height="9"></td>
        <td height="13" valign="middle">#it#</td>
      </tr>
      </cfloop> 
  </table>
    <br>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td height="18" colspan="2" nowrap="nowrap">WORK ARE TO BE PREPARED BY:</td>
      </tr>
      <cfset watbpb = "Temporary demarcation,Temporary road closure,Additional lighting,Scaffolding/Work platform"/>
      <cfloop list="#watbpb#" index="it">
      <tr>
        <td width="15" align="center" valign="middle">
        <cfset chk = getCheck(qP.SafetyRequirement4,it)/>
        <img src="#application.site.url#assets/img/ptw_checkbox_#chk#.png" width="9" height="9"></td>
        <td height="13" valign="middle">#it#</td>
      </tr>
      </cfloop> 
    </table>   
    </td>
    <td valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td height="18" colspan="2">PPE:</td>
      </tr>
      <cfset ppe = "Coverall,Safety helmet,Safety shoes,Safety goggles,Safety spectacles,Light fumes mask,Breathing apparatus,Plastic gloves,Dotted gloves,Hearing protection,Protective Apron,Rubber boots,Dust mask,Safety hamess,Work vest/life jacket,Self contained BA,Compressor air line"/>
      <cfloop list="#ppe#" index="it">
        <tr>
          <td width="15" align="center" valign="middle">
          <cfset chk = getCheck(qP.PPE,it)/>
          <img src="#application.site.url#assets/img/ptw_checkbox_#chk#.png" width="9" height="9"></td>
          <td height="13" valign="middle" nowrap="nowrap">#it#</td>
        </tr>
      </cfloop>
    </table></td>
  </tr>
</table><br/>
        Additional Precautions: <div class="underline">#qP.AdditionalPrecaution#</div>
        </td>
        <td colspan="2" align="center" valign="middle" height="20" class="cbg"><span class="cbg"><img src="#application.site.url#assets/img/ptw_sec4.png"/></span></td>
        </tr>
      <tr>
        <td width="40" align="center" valign="middle"><img src="#application.site.url#assets/img/ptw_pa.png"></td>
        <td valign="top">I confirm that the safety precautions specified will be observed
          <table class="sign" width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
            <td width="10%" >NAME:</td>
            <td colspan="3" class="underline">&nbsp;#qP.PA#</td>
            </tr>
          <tr>
            <td class="pad-right-3">DATE:</td>
            <td width="35%" nowrap="nowrap" class="underline">&nbsp;#dateformat(qP.PAApprovedDate,'dd/mm/yy')# #timeformat(qP.PAApprovedDate,'hh:mm tt')#</td>
            <td width="16%" class="pad-left-5">COMPANY:</td>
            <td width="39%" class="underline">&nbsp;#ucase(left(qP.PACompany,10))#</td>
          </tr>
          <tr>
            <td colspan="4" valign="middle"> 
            <cfset fl = getSignature(qP.PAApprovedByUserId)/>
            SIGNATURE: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="#application.site.url#doc/photo/core_user/#qP.PAApprovedByUserId#/#fl#" height="25"></td>
            </tr>
          </table></td>
      </tr>
      <tr>
        <td align="center" valign="middle"><img src="#application.site.url#assets/img/ptw_fs.png"></td>
        <td valign="top">I confirm that the safety precautions specified will be observed
          <table class="sign" width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
            <td width="10%" >NAME:</td>
            <td colspan="3" class="underline">&nbsp;#qP.FS#</td>
            </tr>
          <tr>
            <td class="pad-right-3">DATE:</td>
            <td width="35%" nowrap="nowrap" class="underline">&nbsp;#dateformat(qP.FSApprovedDate,'dd/mm/yy')# #timeformat(qP.FSApprovedDate,'hh:mm tt')#</td>
            <td width="16%" class="pad-left-5">COMPANY:</td>
            <td width="39%" class="underline">#ucase(application.appName)#</td>
          </tr>
          <tr>
            <td colspan="4" height="28" valign="middle"> 
            <cfset fl = getSignature(qP.FSApprovedByUserId)/>
            SIGNATURE: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="#application.site.url#doc/photo/core_user/#qP.FSApprovedByUserId#/#fl#" height="25">
            </td>
            </tr>
          </table></td>
      </tr>
      <tr>
        <td align="center" valign="middle"><img src="#application.site.url#assets/img/ptw_hs.png"></td>
        <td valign="top">I confirm that the safety precautions specified will be observed 
          <table class="sign" width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
            <td width="10%" >NAME:</td>
            <td colspan="3" class="underline">&nbsp;#qP.HS#</td>
            </tr>
          <tr>
            <td class="pad-right-3">DATE:</td>
            <td width="35%" nowrap="nowrap" class="underline">&nbsp;#dateformat(qP.HSApprovedDate,'dd/mm/yy')# #timeformat(qP.HSApprovedDate,'hh:mm tt')#</td>
            <td width="16%" class="pad-left-5">COMPANY:</td>
            <td width="39%" class="underline">#ucase(application.appName)#</td>
          </tr>
          <tr>
          <cfset fl = getSignature(qP.HSApprovedByUserId)/>
            <td colspan="4" height="28" valign="middle">SIGNATURE:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="#application.site.url#doc/photo/core_user/#qP.HSApprovedByUserId#/#fl#" height="25"></td>
            </tr>
          </table></td>
      </tr>
      <tr>
        <td rowspan="8" align="center" valign="middle" class="left cbg bottom"><img src="#application.site.url#assets/img/sec3.png"/></td>
        <td colspan="2" align="center">CERTIFICATES (INDICATE AS REQUIRED)</td>
        <td rowspan="2" align="center" valign="middle"><img src="#application.site.url#assets/img/ptw_ls.png"></td>
        <td rowspan="2" valign="top"> confirm that the safety precautions specified will be observed 
          <table class="sign" width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td width="10%" >NAME:</td>
              <td colspan="3" class="underline">&nbsp;#qP.LS#</td>
            </tr>
            <tr>
              <td class="pad-right-3">DATE:</td>
              <td width="35%" nowrap="nowrap" class="underline">&nbsp;#dateformat(qP.LSApprovedDate,'dd/mm/yy')# #timeformat(qP.LSApprovedDate,'hh:mm tt')#</td>
              <td width="16%" class="pad-left-5">COMPANY:</td>
              <td width="39%" class="underline">#ucase(application.appName)#</td>
            </tr>
            <tr>
              <cfset fl = getSignature(qP.LSApprovedByUserId)/>
              <td colspan="4" height="28" valign="middle">SIGNATURE:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img style="max-width:100px;" src="#application.site.url#doc/photo/core_user/#qP.LSApprovedByUserId#/#fl#" height="25"></td>
            </tr>
          </table></td>
      </tr>
      <tr>
        <td width="27%" rowspan="7" valign="top" class="bottom"><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <cfset hwp = "HOT WORK PRECAUTION,Wash down area with water,Cover area with sand,Cover area with foam blanket,Shield adjacent areas,Provide trained fire watch,Provide portable fire extinguishers,FIRE to provide additional fire cover,Test area for flammable atmosphere,Gas test prior to commencement of work,Gas test at intervals of..........,Continious gas monitoring,Suspend potentially dangerous activites"/>
          <cfloop list="#hwp#" index="it">
            <tr>
              <td width="15" align="center" valign="top"><cfset chk = getCheck(qP.hotwork,it)/>
        <img src="#application.site.url#assets/img/ptw_checkbox_#chk#.png" width="9" height="9"></td>
              <td valign="top" height="13">#it#</td>
            </tr>
          </cfloop>
<tr>
              <td colspan="2" align="left">Special Precautions: <em class="underline">#qP.Custom2#</em></td>
              </tr>
        </table><br/><br/>
          <strong>GAS TEST</strong><br/><br/>
          FLAMMABLE GAS TEST RECORDED (By an approved gas tester)<br/><br>The area was tested by me with the following results:
          
          <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>DATE</td> 
    <td>GAS%</td>
    <td>O<SUB>2</SUB>%</td>
    <td>H<sub>2</sub>S%</td>
  </tr><cfloop query="qGT">
  <tr>
    <td class="underline">#dateformat(qGT.Date,'dd/mm/yy')# #timeformat(qGT.Date,'hh:mm tt')#</td>
    <td class="underline">#qGT.Gas#</td>
    <td class="underline">#qGT.O2#</td>
    <td class="underline">#qGT.H2O#</td>
  </tr> </cfloop>
          </table>
          <p>GAS FREE? #qP.GasFree#</p>
          SIGNATURE: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="#application.site.url#doc/photo/core_user/#qP.PAApprovedByUserId#/#qS1.File#" height="25">
        </td>
        <td width="28%" rowspan="7" valign="top" class="bottom"><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <cfset cshibfs = "CONFINED SPACE ENTRY HAZARDS IDENTIFIED BY DACILITY SUPERVISOR,Oxygen deficiency,Oxygen enrichment,Chemical / Toxic substances,Flammable gases,Physical Harzard"/>
          <cfloop list="#cshibfs#" index="it">
            <tr>
              <td width="15" align="center" valign="top"><cfset chk = getCheck(qP.ConfinedSpace,it)/><img src="#application.site.url#assets/img/ptw_checkbox_#chk#.png" width="9" height="9"></td>
              <td valign="top" height="13">#it#</td>
            </tr>
          </cfloop>
          <tr>
            <td colspan="2" align="left"><br/>Specify: <em class="underline">#qP.Custom3#</em></td>
          </tr>
        </table><br/> 
          <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <cfset p_ = "PRECAUTIONS,Gas tests for flammable gas O<sub>2</sub> & H<sub>2</sub>O carried out,Hazadousor non-hazardous entry(form gas test),Continious gas test every ....... hours for flammable gas O<sub>2</sub> & H<sub>2</sub>O carried out,Positive breathing apparatus worn,Standby man with lifeline and positive breathing apparatus,Fumes present. Light fume respirator worn,Potentially dangerous activity adjacent the work area has been suspended,Max. number of persons in confined space,All flammable/toxic residues removed,Additional lightings flame proof,Special tools required,Improved natural ventilation,External Mechanical Ventilation Flame proof,Emergency exits/equipments available"/>
            <cfloop list="#p_#" index="it">
              <tr>
                <td width="15" align="center" valign="top"><cfset chk = getCheck(qP.Precaution,it)/><img src="#application.site.url#assets/img/ptw_checkbox_#chk#.png" width="9" height="9"></td>
                <td valign="top" height="13">#it#</td>
                </tr>
            </cfloop>
            </table>
          <p>&nbsp;</p></td>
      </tr>
      <tr >
        <td height="20" colspan="2" align="center" valign="middle" class="cbg"><img src="#application.site.url#assets/img/ptw_sec5.png"/></td>
        </tr>
      <tr>
        <td colspan="2">
          <div style="line-height:12px">REVALIDATION (By Facility Supervisor)
            <br/>Maximum validity renewal is 24 Hours</div>
          <table width="100%" class="tbl" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td align="center" class="left">Validated by</td>
              <td align="center">Date</td>
              <td colspan="2" align="center">Valid time</td>
              </tr>
<cfquery name="qPV">
    SELECT
	    prv.PermitRevalidateId, prv.PermitId, prv.ValidatedByUserId, prv.Date, prv.StartTime, prv.EndTime,
        CONCAT(u.Surname,' ',u.OtherNames) Name
    FROM
    ptw_permit_revalidated AS prv
    INNER JOIN core_user AS u ON prv.ValidatedByUserId = u.UserId
    WHERE prv.PermitId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
</cfquery>
<cfloop query="qPV">          
  <tr>
  <td nowrap class="left">#qPV.Name#</td>
  <td>#dateformat(Date,'yyyy/mm/dd')#</td>
  <td colspan="2">#timeformat(Starttime,'HH:MM')# - #timeformat(Endtime,'HH:MM')#</td>
  </tr>
</cfloop>
            </table>
          
        </td>
        </tr>
      <tr>
        <td rowspan="2" align="center" valign="middle"><img src="#application.site.url#assets/img/ptw_pa.png"></td>
        <td align="center" valign="middle" class="cbg"><img src="#application.site.url#assets/img/ptw_sec6.png"/></td>
      </tr>
      <tr>
        <td valign="top">
          <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td width="17" valign="middle">
              <cfset wcy = 0/><cfset wcn = 0/>
			  <cfif qP.Completed eq "yes">
              	<cfset wcy = 1/>
              <cfelseif qP.Completed eq "no">
              	<cfset wcn = 1/>
              </cfif>
              <img src="#application.site.url#assets/img/ptw_radio_#wcy#.png" width="12" height="12" /></td>
              <td valign="middle">Work has been completed and work site cleaned</td>
              </tr>
            <tr>
              <td valign="middle"><img src="#application.site.url#assets/img/ptw_radio_#wcn#.png" width="12" height="12" /></td>
              <td valign="middle">Work has been suspended / not completed </td>
              </tr>
            </table> 
          <table class="sign" width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td width="10%" >NAME:</td>
              <td class="underline">&nbsp;#qP.PAC#</td>
              <td rowspan="2" align="center" valign="middle">
              <cfset fl = getSignature(qP.PACloseByUserId)/>
              <img style="max-width:100px;" src="#application.site.url#doc/photo/core_user/#qP.PACloseByUserId#/#fl#" height="25"></td>
              </tr>
            <tr>
              <td class="pad-right-3">DATE:</td>
              <td width="35%" class="underline">&nbsp;#dateformat(qP.PACloseDate,'dd/mm/yy')# #timeformat(qP.PACloseDate,'hh:mm tt')#</td>
              </tr>
            </table>
          
        </td>
      </tr>
      <tr>
        <td rowspan="2" align="center" valign="middle" class="bottom"><img src="#application.site.url#assets/img/ptw_fs.png"></td>
        <td align="center" valign="middle" class="cbg"><img src="#application.site.url#assets/img/ptw_sec7.png"/></td>
        </tr>
      <tr>
        <td valign="top" class="bottom">I confirm that the work has been completed and work site cleared, PTW is therefore closed
          <table class="sign" width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td width="10%" >NAME:</td>
              <td class="underline">&nbsp;#qP.FSC#</td>
              <td rowspan="2" align="center" valign="middle">
              <cfset fl = getSignature(qP.FSCloseByUserId)/>
              <img style="max-width:100px;" src="#application.site.url#doc/photo/core_user/#qP.FSCloseByUserId#/#fl#" height="25">
              </td>
              </tr>
            <tr>
              <td class="pad-right-3">DATE:</td>
              <td width="35%" class="underline">&nbsp;#dateformat(qP.FSCloseDate,'dd/mm/yy')# #timeformat(qP.FSCloseDate,'hh:mm tt')#</td>
              </tr>
            </table>
        </td>
      </tr>
    </table></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    </tr>
</table></td>
</tr></table>
<!---<cfdocumentitem type="footer">
<tr><td ><table width="100%" border="0" style="font:9px Tahoma; border-top:1px solid gray; padding-left:15px;">
  <tr>
  <td>
  </td>
    <td align="right">Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#</td>
</tr></table></td></tr>
</cfdocumentitem>
</table>--->
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