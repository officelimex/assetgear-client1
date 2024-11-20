<cfoutput>


<cfquery name="qIR">
	SELECT
    ic.*,
    CONCAT(cu.Surname," ",cu.OtherNames) AS DoneBy
    FROM incident_report AS ic
    INNER JOIN core_user AS cu ON ic.CreatedById = cu.UserId
    WHERE ic.IncidentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
</cfquery>


<cfdocument  pagetype="a4" format="pdf" margintop="0" marginbottom="0" marginleft="0" marginright="0" backgroundvisible="yes">
<html>
<head>
<cfset bg = "##f3f3f3"/>
<cfset brd_c = "##e0e0e0"/>
<cfset brd_c2 = "##a5a5a5"/>
<cfset wt = ""/>
<cfswitch expression="cold"> 
	<cfcase value="Cold Work"><cfset wt = "cold.gif"/></cfcase>
    <cfcase value="Hot Work"><cfset wt = "fire.gif"/></cfcase>
    <cfcase value="Electrical Work"><cfset wt = "plug.gif"/></cfcase> 
</cfswitch>
<style type="text/css">	
	body{
		/*background: url(../../../assets/img/hse.png) no-repeat fixed center;
		background-position:center*/	
		}
	html,body{padding:0; margin:0;font: 11px Tahoma;}
	.tbl-pad-4 td{
	padding: 4px 4px 0px 0px
}
	.tbl{font-size: 10px;} 
	sub{font-size: 4px;}
	.newpage{ page-break-before:always}
	.tbl > tr > td{padding: 3px 5px;border-top:#brd_c# 1px solid;border-right:#brd_c# 1px solid;}
	.tbl td.left{border-left:#brd_c# 1px solid;}
	.tbl tr.bottom td,.tbl td.bottom{border-bottom:#brd_c# 1px solid;}
	.tbl td.no-right{border-right:none;}
	.tbl td.b-right{border-right:#brd_c# 1px solid;}
	.border > tr > td { border:#brd_c# 1px solid; border-collapse: collapse; }
	th {background-color:#bg#; }
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
        <cfset request.letterhead.title="INCIDENT REPORT"/>
        <cfset request.letterhead.Id="ICR ## #url.id#"/>
        <cfset request.letterhead.noline=true/>
        <!---cfset request.letterhead.logosize=40/--->
        <cfset request.letterhead.date = "Report Time: #dateformat(qIR.ReportTime,'dd/mm/yyyy')#&nbsp;&nbsp;#TimeFormat(qIR.ReportTime,'HH:MM')#&nbsp;"/>
        <cfinclude template="../../../include/letter_head.cfm"/>
        </cfdocumentitem> 
        <tr>
            <td>
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tbl">
                          	<!------><tr>
                            	<td colspan="5" class="cbg" style="text-align:center"><strong>PART 1    NOTIFICATION </strong> (To Be Completed By the Person Reporting  the Incident)</td>
                            </tr>
                            <tr>
                                <td width="25" align="center" valign="middle" class="left cbg">
                                	<img src="../../../assets/img/in1.png"/>
                                </td>
                                <td colspan="4" valign="top">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                     <tr>
                                         <td>
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tbl-pad-4">
                                              <tr>
                                                <td width="16%"><strong>REPORT TITLE:</strong> </td>
                                                <td width="67%" class="underline">&mdash; #qIR.Title#</td>
                                              </tr>
                                            </table><br>
                                         </td>
                                      </tr>
                                      <tr><td>&nbsp;</td></tr>
                                      <tr>
                                        <td>
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tbl-pad-4">
                                              <tr>
                                                  <td width="16%" align="left" ><strong>FULL DESCRIPTION:</strong></td>
                                                  <td width="67%" class="underline">#qIR.Description#</td>
                                                </tr>
                                            </table><br>
                                        </td>
                                      </tr>
                                      <tr><td>&nbsp;</td></tr>
                                      <tr>
                                        <td>
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tbl-pad-4">
                                              <tr>
                                                <td width="16%" align="left"><strong>IMMEDIATE ACTIONS TAKEN:</strong></td>
                                                <td width="67%" class="underline">#qIR.ActionTaken#&nbsp;</td>
                                              </tr>
                                            </table><br><br>
                                        </td>
                                      </tr>
                                      <tr><td>&nbsp;</td></tr>
                                      <tr>
                                        <td>
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tbl-pad-4">
                                              <cfset r1 = r2 = a1 = a2 = 0/>
                                              <cfif qIR.NotifyMng eq "Required">
                                                <cfset r1 = 1/>
                                              <cfelse>
                                                <cfset a1 = 1/>
                                              </cfif>
                                              <cfif qIR.NotifyGov eq "Required">
                                                <cfset r2 = 1/>
                                              <cfelse>
                                                <cfset a2 = 1/>
                                              </cfif>
                                              
                                              <tr>
                                                <th align="left" width="549"><strong>IMMEDIATE NOTIFICATION</strong></th>
                                                <th><strong>REQUIRED</strong></th>
                                                <th><strong>ACTIONED</strong></th>
                                              </tr>
                                              <tr>
                                                <td align="left" nowrap="nowrap" >Immediate Notification to management/ Investigation :</td>
                                                <td width="15%" align="middle" nowrap="nowrap" >
                                                    <img src="../../../assets/img/ptw_radio_#r1#.png" width="12" height="12" />
                                                </td>
                                                <td width="15%" align="middle" nowrap="nowrap" >
                                                    <img src="../../../assets/img/ptw_radio_#a1#.png" width="12" height="12" />
                                                </td>
                                              </tr>
                                              <tr>
                                                <td align="left" nowrap="nowrap">Notifiable to Government Authorities/Agencies? #qIR.NotificationSpecify# :</td>
                                                <td width="15%" align="middle" nowrap="nowrap" >
                                                    <img src="../../../assets/img/ptw_radio_#r2#.png" width="12" height="12" />
                                                </td>
                                                <td width="15%" align="middle" nowrap="nowrap"  >
                                                    <img src="../../../assets/img/ptw_radio_#a2#.png" width="12" height="12" />
                                                </td>
                                              </tr>
                                            </table><br><br>
                                        </td>
                                      </tr>                                      
                                      <tr><td>&nbsp;</td></tr>
                                      <tr valign="top">
                                      	<td>
                                              <cfset chk1 = chk2 = 0/>
                                              <cfif qIR.IsWorkRelated eq "Yes">
                                                <cfset chk1 = 1/>
                                              <cfelse>
                                                <cfset Chk2 = 1/>
                                              </cfif>
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="">
                                                  <tr>
                                                    <td width="30%" nowrap="nowrap"><strong>IS THIS WORK RELATED?</strong> </td>
                                                    <td width="5%" class="">Yes <img src="../../../assets/img/ptw_checkbox_#chk1#.png" width="9" height="9"></td>
                                                    <td width="10%" align="left" class=" pad-left-5">No <img src="../../../assets/img/ptw_checkbox_#chk2#.png" width="9" height="9"></td>
                                                    <td width="60%" nowrap="nowrap" class="underline">If not why? #qIR.IfNo#&nbsp;</td>
                                                  </tr>
                                              </table>
                                          </td>
                                      </tr>
                                      <tr><td>&nbsp;</td></tr>
                                      <tr valign="top">
                                         <td>
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                        <td height="18" colspan="2">
                                                            <cfset chk1 = chk2 = 0/>
                                                            <cfif qIR.IncidentType eq "Incident">
                                                            	<cfset chk1 = 1/>
                                                            <cfelse>
                                                            	<cfset Chk2 = 1/>
                                                            </cfif>
                                                            <strong>IS THIS AN INCIDENT OR A NEAR MISS?</strong> &nbsp; &nbsp;
                                                            Incident <img src="../../../assets/img/ptw_checkbox_#chk1#.png" width="9" height="9"> &nbsp;
                                                            Near Miss <img src="../../../assets/img/ptw_checkbox_#chk2#.png" width="9" height="9">
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                      </tr>
                                      <tr><td>&nbsp;</td></tr>
                                      <tr valign="top">
                                         <td>
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                    <td valign="top">
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                            <tr>
                                                                <td height="18" colspan="2"  style=" font-weight:bold">AFFECTED PERSONNEL / STAKEHOLDER CATEGORY</td>
                                                            </tr>
                                                            <cfset ftbpb = "#application.appName# employee & direct contract,#application.appName# third party personnel,Contractor,Subcontractor,Host community or community-related,Security unit or security-related,Member of public/visitor"/>
                                                            <cfloop list="#ftbpb#" index="it">
                                                                <tr>
                                                                    <td width="15" align="center" valign="middle">
                                                                        <cfset chk = getCheck(qIR.AffectedPersonel,it)/>
                                                                        <img src="../../../assets/img/ptw_checkbox_#chk#.png" width="9" height="9">
                                                                    </td>
                                                                    <td height="13" valign="middle">#it#</td>
                                                                </tr>
                                                            </cfloop> 
                                                            <tr>
                                                                <td colspan="2" align="left" width="15" style=" font-weight:bold"><br>OTHER AFFECTED PERSONNEL / STAKEHOLDER CATEGORY:</td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2" align="left" height="13"><div class="underline" style="width:95%">&nbsp; #qIR.OtherAffectedPersonel#</div></td>
                                                            </tr>
                                                        </table>
                                                        <br>
                                                    </td>
                                                    <td valign="top" width="40%">
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                            <tr>
                                                                <td height="18" colspan="2"  style=" font-weight:bold">AGENT(S) OF INCIDENT:</td>
                                                            </tr>
                                                            <cfset ppe = "Powered Equipment/Tools,Machinery & Fixed Plant,Mobile Plant,Transport,Non-Powered Equipment/Tool,Environment,Human Factors,Chemical Substance,Biological Agencies"/>
                                                            <cfloop list="#ppe#" index="it">
                                                                <tr>
                                                                    <td width="15" align="center" valign="middle">
                                                                        <cfset chk = getCheck(qIR.IncidentAgent,it)/>
                                                                        <img src="../../../assets/img/ptw_checkbox_#chk#.png" width="9" height="9">
                                                                    </td>
                                                                    <td height="13" valign="middle" nowrap="nowrap">#it#</td>
                                                                </tr>
                                                            </cfloop>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
										 </td>
                                      </tr>
                                      <tr><td>&nbsp;</td></tr>
                                      <tr valign="top">
                                         <td>
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr valign="top">
                                                    <td valign="top" width=""> 
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                            <tr>
                                                                <td height="18" colspan="2" nowrap="nowrap" style="font-weight:bold">WHO OR WHAT WAS AFFECTED?</td>
                                                            </tr>
                                                            <cfset ftbib = "People,Asset/Production,Environment,Reputation"/>
                                                            <cfloop list="#ftbib#" index="it">
                                                                <tr>
                                                                    <td width="15" align="center" valign="middle">
                                                                        <cfset chk = getCheck(qIR.AffectedParty,it)/>
                                                                        <img src="../../../assets/img/ptw_checkbox_#chk#.png" width="9" height="9">
                                                                    </td>
                                                                    <td height="13" valign="middle">#it#</td>
                                                                </tr>
                                                            </cfloop> 
                                                        	<tr>
                                                            	<td colspan="2" height="18"  ><br><strong>REPORTING PARTY DETAILS</strong></td>
                                                            </tr>
                                                        	<tr>
                                                            	<td colspan="2" ><div style="width:80%" class="underline"><br>#qIR.DoneBy#</div></td>
                                                            </tr>
                                                        </table><br/>
                                                    
                                                    </td>
                                                    <td valign="top" width="50%">
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                            <tr valign="top">
                                                                <td height="18" colspan="2"  ><strong>LOCATION WHERE THE INCIDENT OCCURRED</strong><br></td>
                                                            </tr>
                                                            <cfset ppe = "Field,Head Office,Others"/>
                                                            <cfloop list="#ppe#" index="it">
                                                                <tr>
                                                                    <td width="15" align="center" valign="middle">
                                                                        <cfset chk = getCheck(qIR.OccurredLocation,it)/>
                                                                        <img src="../../../assets/img/ptw_checkbox_#chk#.png" width="9" height="9">
                                                                    </td>
                                                                    <td height="13" valign="middle" nowrap="nowrap">#it#</td>
                                                                </tr>
                                                            </cfloop>
                                                            <tr valign="top">
                                                                <td height="18" colspan="2"  style="font-weight:bold"><br><br>NAME AND ADDRESS OF LOCATION AND EXACT WHEREABOUTS AT THE LOCATION<br></td>
                                                            </tr>
                                                            <tr valign="top">
                                                            	<td colspan="2" class="underline"><br>#qIR.OccurredAddress#</td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                         </td>
                                      </tr>
                                      <tr><td>&nbsp;</td></tr>
                                      <tr valign="top">
                                          <td style=" font-weight:bold" class="bottom">
                                                <cfset chk1 = chk2 = 0/>
                                                <cfif qIR.InjustDetailApplicable eq "Applicable">
                                                    <cfset chk1 = 1/>
                                                <cfelse>
                                                    <cfset Chk2 = 1/>
                                                </cfif>
                                                INJURY DETAILS - (To be completed by the person reporting the incident or the medic) &nbsp;&nbsp;&nbsp;
                                                Applicable <img src="../../../assets/img/ptw_checkbox_#chk1#.png" width="9" height="9"> &nbsp;
                                                Not Applicable <img src="../../../assets/img/ptw_checkbox_#chk2#.png" width="9" height="9">
                                            </td>
                                      </tr>
                                      <tr><td>&nbsp;</td></tr>
                                      <cfif qIR.InjustDetailApplicable eq "Applicable">
                                          <cfquery name="qID">
                                              SELECT * FROM incident_injury_details
                                              WHERE IncidentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
                                          </cfquery>
                                              
                                          <tr valign="top">
                                          	<td>
                                            	<table width="100%">
                                                	<tr valign="top">
                                                    	<td width="50%">
                                                			<span style="font-weight:bold">FULL NAME OF INJURED PARTY:</span> <p class="underline" style="width:95%">&nbsp;#qID.InjuredNames# </p>
                                                			<span style="font-weight:bold">FULL RESIDENTIAL ADDRESS: </span><p class="underline" style="width:95%">#qID.ResidentAddress#</p><br>
                                                
                                            			</td>
                                                        <td width="15%">
                                                            <p style=" font-weight:bold">
                                                                <cfset chk1 = chk2 = 0/>
                                                                <cfif qID.Gender eq "Male">
                                                                    <cfset chk1 = 1/>
                                                                <cfelse>
                                                                    <cfset Chk2 = 1/>
                                                                </cfif>
                                                                SEX </p>
                                                                <p><img src="../../../assets/img/ptw_checkbox_#chk1#.png" width="9" height="9"> Male &nbsp;</p>
                                                                <img src="../../../assets/img/ptw_checkbox_#chk2#.png" width="9" height="9"> Female 
                                                        
                                                        </td>
                                                        <td>
                                                            <p style=" font-weight:bold">OCCUPATION: #qID.Occupation#</p> 
                                                            <p style=" font-weight:bold">DATE OF BIRTH: #Dateformat(qID.DOB,"dd/mm/yyyy")#</p>
                                                            <p style="font-weight:bold">DATE HIRED: #Dateformat(qID.DateHired,"dd/mm/yyyy")#</div><br>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                          </tr>
                                          <tr><td colspan="2">&nbsp;</td></tr>
                                          <tr valign="top">
                                          	<td>
                                            	<table width="100%" cellpadding="0" cellspacing="0">
                                                        
                                                        
                                                        <tr valign="top">
                                                        	<td>
                                                            	<table>
                                                                	<tr valign="top">
                                                                    	<td>
                                                                        	<strong>DATE EMPLOYER NOTIFIED OF INJURY/ILLNESS</strong>:  <p class="underline" style="width:40%">#Dateformat(qID.NotificationDate,"dd/mm/yyyy")#</p>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        	<td rowspan="2">
                                                            	<strong style=";">EMPLOYMENT/STAKEHOLDER CATEGORY (of injured person)</strong>
                                                                <table width="100%">
                                                                    <cfset ftbib = "#application.appName# employee & direct contract,#application.appName# third party personnel,Contractor,Subcontractor,Host community or community-related,Security unit or security-related,Member of public/visitor"/>
                                                                    <cfloop list="#ftbib#" index="it">
                                                                        <tr>
                                                                            <td width="15%" align="center" valign="middle">
                                                                                <cfset chk = getCheck(qIR.AffectedPersonel,it)/>
                                                                                <img src="../../../assets/img/ptw_checkbox_#chk#.png" width="9" height="9">
                                                                            </td>
                                                                            <td height="13" valign="middle">#it#</td>
                                                                        </tr>
                                                                    </cfloop> 
                                                                    <tr>
                                                                    	<td>OTHERS</td>
                                                                        <td><div class="underline">&nbsp;#qIR.OtherAffectedPersonel#</div></td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr valign="top">
                                                        	<td>
                                                            	<strong style=";">HOW LONG IN PRESENT JOB:</strong>
                                                                <table width="100%">
                                                                    <cfset ftbib = "< 3Mths,3 to 6Mths,6mths to 2yrs, > 5 yrs "/>
                                                                    <cfloop list="#ftbib#" index="it">
                                                                        <tr>
                                                                            <td width="15%" align="center" valign="middle">
                                                                                <cfset chk = getCheck(qID.JobDuration,it)/>
                                                                                <img src="../../../assets/img/ptw_checkbox_#chk#.png" width="9" height="9">
                                                                            </td>
                                                                            <td height="13" valign="middle">#it#</td>
                                                                        </tr>
                                                                    </cfloop> 
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr><td colspan="2">&nbsp;</td></tr>
                                                        <tr valign="top">
                                                        	<td><strong style=";">EMPLOYEES PROJECT: </strong><br><div class="underline" style="width:90%">&nbsp;#qID.EmployeeProject#</div></td>
                                                            <td><strong style=";">EMPLOYEE HOME OFFICE: </strong><br><div class="underline" style="width:90%">&nbsp;#qID.EmployeeHomeOffice#</div></td>
                                                        </tr>
                                                        <tr><td colspan="2">&nbsp;</td></tr>
                                                        <tr valign="top">
                                                        	<td colspan="2">
                                                            	<strong style=";">EMPLOYEES PROJECT: </strong><br>
                                                                    <cfset ftbib = "First Aid Case,Medical Treatment Case,Restricted Workday Case,Lost Time Injury,Fatality"/>
                                                                    <cfloop list="#ftbib#" index="it" >
																		<cfset chk = getCheck(qID.InjuryType,it)/>
                                                                        <img src="../../../assets/img/ptw_checkbox_#chk#.png" width="9" height="9"> #it#
                                                                    </cfloop> 
                                                            </td>
                                                        </tr>
                                                        <tr><td colspan="2">&nbsp;</td></tr>
                                                        <tr valign="top">
                                                        	<td><strong style=";">NATURE OF INJURY OR ILLNESS(laceration,fracture,hearing loss) </strong><br><div class="underline" style="width:90%">&nbsp;#qID.NatureofInjury#</div></td>
                                                            <td><strong style=";">PART OF BODY INJURED (back, left wrist, right eye etc)  </strong><br><div class="underline" style="width:90%">&nbsp;#qID.InjuredBodyPart#</div></td>
                                                        </tr>
                                                        <tr><td colspan="2">&nbsp;</td></tr>
                                                        <tr valign="top">
                                                        	<td colspan="2">
                                                            	<strong style=";">WHAT WAS INJURED PERSON DOING JUST BEFORE THE INCIDENT? (Please be specific. Identify tools, equipment or material in use) </strong><br>
                                                                    <div class="underline" style="width:90%">&nbsp;#qID.ActivityBeforeInjury#</div>
                                                            </td>
                                                        </tr>
                                                        <tr><td colspan="2">&nbsp;</td></tr>
                                                        <tr valign="top">
                                                        	<td colspan="2">
                                                            	<strong style=";">WHAT HAPPENED? (How did the injury occur)</strong><br>
                                                                    <div class="underline" style="width:90%">&nbsp;#qID.InjuryEvent#</div>
                                                            </td>
                                                        </tr>
                                                        <tr><td colspan="2">&nbsp;</td></tr>
                                                        <tr valign="top">
                                                        	<td colspan="2">
                                                            	<strong style=";">WHAT OBJECT OR SUBSTANCE DIRECTLY HARMED THE EMPLOYEE? </strong><br>
                                                                    <div class="underline" style="width:90%">&nbsp;#qID.InjuryObject#</div>
                                                            </td>
                                                        </tr>
                                                        <tr><td colspan="2">&nbsp;</td></tr>
                                                        <tr valign="top">
                                                        	<td><strong style=";">WHERE WERE INJURIES TREATED?(name of clinic or location)</strong><br><div class="underline" style="width:90%">&nbsp;#qID.TreatmentLocation#</div></td>
                                                            <td><strong style=";">WHO PROVIDED TREATMENT? (NAME OF PHYSICIAN OR HEALTHCARE PROFESSIONAL) </strong><br><div class="underline" style="width:90%">&nbsp;#qID.TreatmentProvider#</div></td>
                                                        </tr>
                                                        <tr><td colspan="2">&nbsp;</td></tr>
                                                        <tr valign="top">
                                                        	<td colspan="2">
                                                            	<strong style=";">TREATMENT GIVEN? BY: (Full name of person providing medical treatment or first aid)</strong><br>
                                                                    <div class="underline" style="width:90%">&nbsp;#qID.TreatmentGiven#</div>
                                                            </td>
                                                        </tr>
                                                        <tr><td colspan="2">&nbsp;</td></tr>
                                                        <tr valign="top">
                                                        	<td colspan="2">
                                                            	<strong style=";">HAS INJURED EMPLOYEE RETURNED TO WORK?</strong><br>
                                                                    <cfset ftbib = "1. No. Still off work, 2. Yes. Has resumed, 3. Restricted work, 4. Regular work, 5. Fatality"/>
                                                                    <cfloop list="#ftbib#" index="it" >
																		<cfset chk = getCheck(qID.ReturnToWork,it)/>
                                                                        <img src="../../../assets/img/ptw_checkbox_#chk#.png" width="9" height="9"> #it#
                                                                    </cfloop> 
                                                            </td>
                                                        </tr>
                                                        <tr><td colspan="2">&nbsp;</td></tr>
                                                        <tr valign="top">
                                                        	<td colspan="2">
                                                            	<strong style=";">Return Comment</strong><br>
                                                                    <div class="underline" style="width:90%">&nbsp;#qID.ReturnComment#</div>
                                                            </td>
                                                        </tr>
                                                    </table>
                                            </td>
                                          </tr>
                                          
                                      </cfif>
                                      
                                    </table><br>

                                    
                                </td>
                             </tr> 
                            <tr class="newpage"><td></td></tr>
                          	<tr>
                            	<td colspan="5" class="cbg" style="text-align:center">
                                	<strong>PART 2 INCIDENT CLASSIFICATION & INVESTIGATION </strong>  
                                	<span style="font-size:8px">(To Be Completed By HSE Supervisor / Responsible Personnel Supervisor or Investigation Team)</span>
                                </td>
                            </tr>
                            <tr>
                                <td rowspan="1" align="center" valign="middle" class="left cbg"><img src="../../../assets/img/sec2.png"/></td>
                                <td colspan="4" align="" valign="middle"  style="page-break-inside:avoid !important;">
                                	
                                    <table width="100%">
                                    	<tr valign="top" class="border">
                                        	<td colspan="4" class="cbg">
                                            	<strong>ACTUAL SEVERITY</strong> - What were the actual consequences of this incident? If multiple consequences make multiple selections 
                                            </td>
                                        </tr>
                                        <tr style="font-size:8px" valign="top" class="border">
                                        	<td width="25%" class="b-right">
                                            	<strong>PEOPLE</strong><br/>
												<cfset p_ = "A - No impact or First Aid Case,B - Medical Treatment Case or Restricted Workday Case,C - Lost Workday Case,D - Disability/Permanent Injury,E - Fatality  "/>
                                                <cfloop list="#p_#" index="it">
                                                     <cfset chk = getCheck(qIR.ASeverityPeople,it)/><img src="../../../assets/img/ptw_checkbox_#chk#.png" width="9" height="9">&nbsp; #it# <br>
                                                </cfloop>
                                            </td>
                                        	<td class="b-right">
                                            	<strong>ENVIRONMENT</strong><br/>
												<cfset p_ = "A - No Impact,B - Localised,C - Moderate,D - Significant (local),E- Significant (widespread)"/>
                                                <cfloop list="#p_#" index="it">
                                                     <cfset chk = getCheck(qIR.ASeverityEnvironment,it)/><img src="../../../assets/img/ptw_checkbox_#chk#.png" width="9" height="9">&nbsp; #it# <br>
                                                </cfloop>
                                            </td>
                                        	<td width="" class="b-right">
                                            	<strong>ASSET / PRODUCTION</strong><br/>
												<cfset p_ = "A - Zero Effect or Slight Damage or Loss,B - Minor Damage or Loss,C - Local Damage or Loss,D - Major Damage or Loss,E - Extensive Damage or Loss"/>
                                                <cfloop list="#p_#" index="it">
                                                     <cfset chk = getCheck(qIR.ASeverityAsset,it)/><img src="../../../assets/img/ptw_checkbox_#chk#.png" width="9" height="9">&nbsp; #it# <br>
                                                </cfloop>
                                            </td>
                                        	<td width="">
                                            	<strong>REPUTATION</strong><br/>
												<cfset p_ = "A - No /Temporary Local Impact,B - Local Short Term Impact,C - Local Long Term Impact (manageable outcomes),D - Local Long Term Impact (unmanageable outcomes),E - International Impact"/>
                                                <cfloop list="#p_#" index="it">
                                                     <cfset chk = getCheck(qIR.ASeverityReputation,it)/><img src="../../../assets/img/ptw_checkbox_#chk#.png" width="9" height="9">&nbsp; #it# <br>
                                                </cfloop>
                                            </td>
                                        </tr>
                                    
                                    
                                    	<tr>
                                        	<td colspan="4" class="cbg">
                                            	<strong>POTENTIAL SEVERITY</strong> (worst credible outcome) Realistically, could this incident have had a worse outcome?  
                                            </td>
                                        </tr>
                                        <tr  style="font-size:8px" valign="top" class="bottom">
                                        	<td width="25%" class="b-right">
                                            	<strong>PEOPLE</strong><br/>
												<cfset p_ = "A - No impact or First Aid Case,B - Medical Treatment Case or Restricted Workday Case,C - Lost Workday Case,D - Disability/Permanent Injury,E - Fatality  "/>
                                                <cfloop list="#p_#" index="it">
                                                     <cfset chk = getCheck(qIR.PSeverityPeople,it)/><img src="../../../assets/img/ptw_checkbox_#chk#.png" width="9" height="9">&nbsp; #it# <br>
                                                </cfloop>
                                            </td>
                                        	<td width="" class="b-right">
                                            	<strong>ENVIRONMENT</strong><br/>
												<cfset p_ = "A - No Impact,B - Localised,C - Moderate,D - Significant (local),E- Significant (widespread)"/>
                                                <cfloop list="#p_#" index="it">
                                                     <cfset chk = getCheck(qIR.PSeverityEnvironment,it)/><img src="../../../assets/img/ptw_checkbox_#chk#.png" width="9" height="9">&nbsp; #it# <br>
                                                </cfloop>
                                            </td>
                                        	<td width="27%" class="b-right">
                                            	<strong>ASSET / PRODUCTION</strong><br/>
												<cfset p_ = "A - Zero Effect or Slight Damage or Loss,B - Minor Damage or Loss,C - Local Damage or Loss,D - Major Damage or Loss,E - Extensive Damage or Loss"/>
                                                <cfloop list="#p_#" index="it">
                                                     <cfset chk = getCheck(qIR.PSeverityAsset,it)/><img src="../../../assets/img/ptw_checkbox_#chk#.png" width="9" height="9">&nbsp; #it# <br>
                                                </cfloop>
                                            </td>
                                        	<td width="28%">
                                            	<strong>REPUTATION</strong><br/>
												<cfset p_ = "A - No /Temporary Local Impact,B - Local Short Term Impact,C - Local Long Term Impact (manageable outcomes),D - Local Long Term Impact (unmanageable outcomes),E - International Impact"/>
                                                <cfloop list="#p_#" index="it">
                                                     <cfset chk = getCheck(qIR.PSeverityReputation,it)/><img src="../../../assets/img/ptw_checkbox_#chk#.png" width="9" height="9">&nbsp; #it# <br>
                                                </cfloop>
                                            </td>
                                        </tr>
                                    </table>
                                    <br>
                                    <table width="100%">
                                    	<tr valign="top">
                                        	<td class="cbg">
                                            	<strong>ROOT CAUSE ANALYSIS</strong>
                                            </td>
                                        </tr>
                                        <tr valign="top">
                                        	<td>
                                                	<strong>STEP 1</strong><br>
                                                    Obtain and review physical evidence, employee, witness information and paper evidence pertinent to the investigation. <br>
                                                    <br>
                                                    Physical: 
                                                    <cfset p_ = "Photographs,Drawings,Equipment manuals, Others"/>
                                                    <cfloop list="#p_#" index="it">
                                                         <cfset chk = getCheck(qIR.PhysicalInvestigation,it)/><img src="../../../assets/img/ptw_checkbox_#chk#.png" width="9" height="9">#ucase(it)# &nbsp;&nbsp;
                                                    </cfloop><br>
                                                    Employee / Witnesses-statements: 
                                                    <cfset p_ = "Statements,Interviews"/>
                                                    <cfloop list="#p_#" index="it">
                                                         <cfset chk = getCheck(qIR.Witnesses,it)/><img src="../../../assets/img/ptw_checkbox_#chk#.png" width="9" height="9">#ucase(it)# &nbsp;&nbsp;
                                                    </cfloop><br>
                                                    Paper: 
                                                    <cfset p_ = "Policies, Programs, Training Records, Maintenance Records, Incident Reports, Others"/>
                                                    <cfloop list="#p_#" index="it">
                                                         <cfset chk = getCheck(qIR.Paper,it)/><img src="../../../assets/img/ptw_checkbox_#chk#.png" width="9" height="9">#ucase(it)#
                                                    </cfloop><br>

                                            </td>
                                        </tr>
                                    </table><br>
                                    <table width="100%">
                                        <tr valign="top">
                                        	<td>
                                                	<br><strong>STEP 2</strong><br>
                                                    CAUSES - The categories below identifies the major cause or causes of the accident/incident:<br>
                                                    <br>
													<cfset p_ = "POLICIES/PROCEDURES,PRODUCTIVITY FACTORS,TRAINING,ENVIRONMENT,FACILITIES/EQUIPMENT/PROCESSES,HAZARDS,BLOODBORNE PATHOGEN,WORK BEHAVIOURS,COMMUNICATION,PERSONAL PROTECTIVE EQUIPMENT"/>
                                                    <cfloop list="#p_#" index="it">
                                                         <cfset chk = getCheck(qIR.MajorCauses,it)/><img src="../../../assets/img/ptw_checkbox_#chk#.png" width="9" height="9">&nbsp;#it# &nbsp;&nbsp;
                                                    </cfloop>
                                                    
                                            </td>
                                        </tr>
                                        <tr><td>&nbsp;</td></tr>
                                    </table>
                                    <table width="100%">
                                    	<tr>
                                        	<td>
                                            	<strong>STEP 3</strong><br>
                                                Direct Cause, Contributing Cause, and Root Cause:
                                            </td>
                                        </tr>
                                    </table>
                                    <table width="100%" class="border">
                                        
                                        <tr valign="top">
                                            <td colspan="3"></td>
                                            <td width="32%" class="b-right">
                                                <strong>POLICIES/PROGRAMS</strong><br>
                                                <cfset p_ = "Not Developed or Inadequate,Developed and Communicated,Developed-Not Communicated,Developed--Not Followed/Enforced,Developed-Not Understood,Lack of Disciplinary Policy,Disciplinary Policy Not Enforced"/>
                                                <cfloop list="#p_#" index="it">
                                                     <cfset chk = getCheck(qIR.Policy,it)/><img src="../../../assets/img/ptw_checkbox_#chk#.png" width="9" height="9">&nbsp;#it# &nbsp;&nbsp;<br>
                                                </cfloop>
                                            </td>
                                            <td width="32%" class="b-right">
                                                <strong>COMMUNICATION</strong><br>
                                                <cfset p_ = "Insufficient Planning For Tasks,Lack of Worker Communication,Lack of Supervisor Instruction,Sufficient Supervisor Instruction,Confusion After Communication,Lack of Understanding of Task,Work Team Breakdown"/>
                                                <cfloop list="#p_#" index="it">
                                                     <cfset chk = getCheck(qIR.Communication,it)/><img src="../../../assets/img/ptw_checkbox_#chk#.png" width="9" height="9">&nbsp;#it# &nbsp;&nbsp;<br>
                                                </cfloop>
                                            </td>
                                            <td class="b-right">
                                                <strong>HAZARDS</strong><br>
                                                <cfset p_ = "A - Zero Effect or Slight Damage or Loss,B - Minor Damage or Loss,C - Local Damage or Loss,D - Major Damage or Loss,E - Extensive Damage or Loss"/>
                                                <cfloop list="#p_#" index="it">
                                                     <cfset chk = getCheck(qIR.Hazard,it)/><img src="../../../assets/img/ptw_checkbox_#chk#.png" width="9" height="9">&nbsp;#it# &nbsp;&nbsp;<br>
                                                </cfloop>
                                            </td>
                                        </tr>
                                    </table><br>
                                    
                                    <table width="100%" class="border">
                                        <tr valign="top">
                                            <td width="32%" class="b-right">
                                                <strong>BLOODBORNE PATHOGEN</strong><br>
                                                <cfset p_ = "Unaware of Air Borne Hazard,Aware of Air Borne Hazard,Personnel Contact/Exposure,Stuck With Contaminated Needle,Sharps Container Not Available,Improper Clean-up,Contaminated Waste Not Labelled"/>
                                                <cfloop list="#p_#" index="it">
                                                     <cfset chk = getCheck(qIR.BloodBorne,it)/><img src="../../../assets/img/ptw_checkbox_#chk#.png" width="9" height="9">&nbsp;#it# &nbsp;&nbsp;<br>
                                                </cfloop>
                                            </td>
                                            <td width="32%" class="b-right">
                                                <strong>PRODUCTIVITY FACTORS</strong><br>
                                                <cfset p_ = "Heavy Workload,Tight Schedule To Complete Task,Long/Unusual Working Hours,Falsely Perceived Need to Hurry,Staff Assistance Unavailable,Staff Assistance Inadequate,Changes in Process,Was Employee Ill?,Medication, Drugs, Alcohol Factors,Double Shift"/>
                                                <cfloop list="#p_#" index="it">
                                                     <cfset chk = getCheck(qIR.ProductivityFactors,it)/><img src="../../../assets/img/ptw_checkbox_#chk#.png" width="9" height="9">&nbsp;#it# &nbsp;&nbsp;<br>
                                                </cfloop>
                                            </td>
                                            <td class="b-right">
                                                <strong>WORK BEHAVIOUR</strong><br>
                                                <cfset p_ = "Shortcuts Taken,Deviations-Common, Allowed etc…,Special Infrequent Task,Tool/Equipment Used Improperly,History of Accidents/Incidents,Disregard/Refused to Follow Procedure,Staff Assistance Required,Horseplay,Repetitive or Physically Demanding,Going On/Coming Off Vacation"/>
                                                <cfloop list="#p_#" index="it">
                                                     <cfset chk = getCheck(qIR.WorkBehaviour,it)/><img src="../../../assets/img/ptw_checkbox_#chk#.png" width="9" height="9">&nbsp;#it# &nbsp;&nbsp;<br>
                                                </cfloop>
                                            </td>
                                        </tr>
                                    </table><br>
                                    <table width="100%" class="border">
                                        <tr valign="top">
                                            <td width="32%" class="b-right">
                                                <strong>TRAINING</strong><br>
                                                <cfset p_ = "Deficient Orientation Training,Deficient Job Specific Training,Insufficient Training for new Process or Task,Lack of Supervisor Follow-up or Reinforcement,Lack of Supervisor Training,Lack of Employee Training,Hazards Overlooked in Training,Communication of Rules/Policy"/>
                                                <cfloop list="#p_#" index="it">
                                                     <cfset chk = getCheck(qIR.Training,it)/><img src="../../../assets/img/ptw_checkbox_#chk#.png" width="9" height="9">&nbsp;#it# &nbsp;&nbsp;<br>
                                                </cfloop>
                                            </td>
                                            <td width="32%" class="b-right">
                                                <strong>ENVIRONMENT</strong><br>
                                                <cfset p_ = "Weather/Temperature Factors,Poor Housekeeping,Poor Lighting,Poor Visibility,Air Quality,Noise,Visibility of Labels/Warning Signs,Visible and Audible Alarms"/>
                                                <cfloop list="#p_#" index="it">
                                                     <cfset chk = getCheck(qIR.Environment,it)/><img src="../../../assets/img/ptw_checkbox_#chk#.png" width="9" height="9">&nbsp;#it# &nbsp;&nbsp;<br>
                                                </cfloop>
                                            </td>
                                            <td class="b-right">
                                                <strong>PERSONAL PROTECTIVE EQUIPMENT (PPE)</strong><br>
                                                <cfset p_ = "Available,Required,Required PPE Not Used/Worn,Trained On How To Use,Adequate Fit,PPE Not Used Adequately,Poor Condition,Adequate for Job Performed,Lack of Supervisor Enforcement"/>
                                                <cfloop list="#p_#" index="it">
                                                     <cfset chk = getCheck(qIR.Hazard,it)/><img src="../../../assets/img/ptw_checkbox_#chk#.png" width="9" height="9">&nbsp;#it# &nbsp;&nbsp;<br>
                                                </cfloop>
                                            </td>
                                        </tr>
                                    </table><br>
                                    
                                    <table width="100%" class="border">
                                        <tr valign="top">
                                            <td width="32%" class="b-right">
                                                <strong>FACILITIES/EQUIPMENT/PROCESS</strong><br>
                                                <cfset p_ = "Poor or Inadequate Facility/Process Design,Faulty Equipment or Design,Poor Workstation Design,Equipment Not Guarded,Equipment Repair Deficient,Lack of Preventative Maintenance,Employee Lack of Knowledge,Equipment/Process Failure,Inadequate Inspection Timelines"/>
                                                <cfloop list="#p_#" index="it">
                                                     <cfset chk = getCheck(qIR.Facility,it)/><img src="../../../assets/img/ptw_checkbox_#chk#.png" width="9" height="9">&nbsp;#it# &nbsp;&nbsp;<br>
                                                </cfloop>
                                            </td>
                                        </tr>
                                        
                                    </table>
                                    <table width="100%">
                                    	<tr>
                                        	<td>
                                            	<br><br><br><strong>Final Root Cause Analysis Statement: </strong><br>
                                                <div class="underline">#qIR.RootCauseStatement#&nbsp;</div>
                                            </td>
                                        </tr>
                                    </table>

                                </td>
                            </tr>
                            <tr class="newpage"><td></td></tr>
                            <tr valign="top">
                            	<td rowspan="2" width="8" align="center" valign="middle" class="left cbg bottom"><img src="../../../assets/img/sec3.png"/></td>
                            	<td colspan="7" class="cbg" align="center"><strong>PART 3</strong>	FURTHER PREVENTIVE / CORRECTIVE ACTIONS, REVIEW AND APPROVAL</td>
                            </tr>
                            <tr>
                            	<td colspan="6">
                                	<table width="100%">
                                    	<tr>
                                        	<td>
                                            	<strong>CORRECTIVE ACTION</strong>  (To Be Completed By HSE Supervisor / Responsible Personnel Supervisor or Investigation Team and approved by Responsible HOD)
                                            </td>
                                        </tr>
                                        <tr>
                                        	<td>
                                            	<cfquery name="qC" result="rt">
                                                	SELECT i.*,CONCAT(cu.Surname," ",cu.OtherNames) AS Personel
                                                    FROM incident_corrective_action AS i
                                                    INNER JOIN core_user AS cu ON i.PersonelResponsibleId= cu.UserId
													WHERE IncidentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
                                                </cfquery>
                                                <br>
                                                <table width="100%" cellpadding="0" cellspacing="0" class="border">
                                                    <tr class="bottom" >
                                                        <th class="b-right" width="40%" align="left" valign="middle">Action Item Description</th>
                                                        <th class="b-right"  width="30%" align="left">Person Responsible</th>
                                                        <th class="b-right"  width="20%" align="left">Completion Date</th>
                                                        <th width="10%" align="left">Status</th>
                                                    </tr>
                                                    <cfif rt.RecordCount gt 0 >
                                                        <cfloop query="qC">
                                                            <tr valign="top" class="bottom">
                                                                <td class="b-right" >#ActionItemDescription#</td>
                                                                <td class="b-right" >#Personel#</td>
                                                                <td class="b-right" >#DateFormat(CompletionDate,"dd/mm/yyyy")#</td>
                                                                <td>#Status#</td>
                                                            </tr>
                                                        </cfloop>
                                                    </cfif>
                                                </table>
                                                <br>
                                                
                                                <table width="100%" cellpadding="0" cellspacing="0" class="border">
                                                    <tr valign="top">
                                                    	<td width="60%">
                                                        	<table width="100%">
                                                            	<tr valign="top">
                                                                	<th align="left">INVESTIGATION TEAM (NAME)</th>
                                                                    <th>SIGNATURE</th>
                                                                </tr>
                                                                <cfquery name="qI">
                                                                    SELECT i.InvestigatorId,CONCAT(cu.Surname," ",cu.OtherNames) AS Investigator
                                                                    FROM incident_investigation_team AS i
                                                                    INNER JOIN core_user AS cu ON i.InvestigatorId = cu.UserId
                                                                    WHERE IncidentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
                                                                </cfquery>
                                                                <cfloop query="qI">
                                                                	<tr valign="top">
                                                                    	<td>#qI.Investigator#</td>
                                                                        <td align="center">
																			<cfset fl = getSignature(qI.InvestigatorId)/>
        																	<img src="../../../doc/photo/core_user/#qI.InvestigatorId#/#fl#" width="40"/>
                                                                        </td>
                                                                    </tr>
                                                                </cfloop>
                                                            </table>
                                                        </td>
                                                        <td>
                                                        	<table width="100%">
                                                            	<tr><th>HSE MS ELEMENTS INVOLVED:</th></tr>
                                                                <tr valign="top">
                                                                	<td>
                                                                    	<cfset p_ = "1. Leadership & Commitment,2. Policy & Strategic objectives,3.Organisation. resources and documentation,4. Evaluation & risk reduction measures,5. Planning,6. Implementation and Monitoring,7. Auditing & Reviewing"/>
                                                                        <cfloop list="#p_#" index="it">
                                                                             <cfset chk = getCheck(qIR.ElementInvolved,it)/><img src="../../../assets/img/ptw_checkbox_#chk#.png" width="9" height="9">&nbsp;&nbsp;&nbsp;&nbsp;#it#<br>
                                                                        </cfloop>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                                
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <!---<table width="100%">
                                                    <tr><th colspan="3">REVIEW AND APPROVALS (complete at the end of the investigation Phase)</th></tr>
                                                    <tr><td colspan="3">&nbsp;</td></tr>
                                                    <tr valign="bottom" class="bottom">
                                                        <td width="60"><strong>Prepared By:</strong> #qIR.DoneBy#</td>
                                                        <td width="30" align="center">
                                                            <cfset fl = getSignature(qIR.CreatedById)/>
                                                            <img src="../../../doc/photo/core_user/#qIR.CreatedById#/#fl#" width="40"/>
                                                        </td>
                                                        <td width="10" align="center">#DateFormat(qIR.CreatedDate,"dd/mm/yyyy")#</td>
                                                    </tr>
                                                    <tr valign="top">
                                                        <td width="60">Designation: #qIR.DoneBy#</td>
                                                        <td width="30" align="center"><strong>Signature</strong></td>
                                                        <td width="10" align="center"><strong>Date</strong></td>
                                                    </tr>
                                                </table>---><br>
                                                <table width="100%">
                                                    <tr><th colspan="3">REVIEW AND APPROVALS (complete at the end of the investigation Phase)</th></tr>
                                                    <tr><td colspan="3">&nbsp;</td></tr>
                                                    <cfset getid = #qIR.PerformingAuthorityId#/>
                                                    <cfif qIR.PerformingAuthorityId eq "">
                                                    	<cfset getid = 0/>
                                                    </cfif>
                                                    
													<cfset cb = application.com.User.getUser(val(getid))/>
                                                    <tr valign="bottom" class="bottom">
                                                        <td width="60"><strong>Prepared By:</strong> #cb.User#</td>
                                                        <td width="30" align="center">
                                                            <cfset fl = getSignature(getid)/>
                                                            <img src="../../../doc/photo/core_user/#getid#/#fl#" width="40"/>&nbsp;
                                                        </td>
                                                        <td width="10" align="center">#DateFormat(qIR.PADate,"dd/mm/yyyy")#&nbsp;</td>
                                                    </tr>
                                                    <tr valign="top">
                                                        <td width="60">Designation: #cb.DepartmentName#&nbsp;</td>
                                                        <td width="30" align="center"><strong>Signature</strong></td>
                                                        <td width="10" align="center"><strong>Date</strong></td>
                                                    </tr>
                                                    <cfif qIR.PerformingAuthorityComment neq "">
                                                    	<tr>
                                                        	<td colspan="3">
                                                            	<br><strong>Performing Authority Comment</strong>:&nbsp; &nbsp; #qIR.PerformingAuthorityComment#&nbsp; 
                                                            </td>
                                                        </tr>
                                                    </cfif>
                                                    <tr><td colspan="3">&nbsp;</td></tr>
                                                    <cfset getid = #qIR.FSAuthorityId#/>
                                                    <cfif qIR.FSAuthorityId eq "">
                                                    	<cfset getid = 0/>
                                                    </cfif>
                                                    <cfset cb = application.com.User.getUser(val(getid))/>
                                                    <tr valign="bottom" class="bottom">
                                                        <td width="60"><strong>Approved By:</strong> #cb.User#&nbsp;</td>
                                                        <td width="30" align="center">
                                                            <cfset fl = getSignature(getid)/>
                                                            <img src="../../../doc/photo/core_user/#getid#/#fl#" width="40"/>&nbsp;
                                                        </td>
                                                        <td width="10" align="center">#DateFormat(qIR.AuthorizedDate,"dd/mm/yyyy")#&nbsp;</td>
                                                    </tr>
                                                    <tr valign="top">
                                                        <td width="60">Designation: #cb.DepartmentName#&nbsp;</td>
                                                        <td width="30" align="center"><strong>Signature</strong></td>
                                                        <td width="10" align="center"><strong>Date</strong></td>
                                                    </tr>
                                                    <cfif qIR.FSComment neq "">
                                                    	<tr>
                                                        	<td colspan="3">
                                                            	<br><strong>FS Comment</strong>: &nbsp; &nbsp; #qIR.FSComment#&nbsp; 
                                                            </td>
                                                        </tr>
                                                    </cfif>
                                                </table><br>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                  </tr>
                  <tr>
                    <td></td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
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