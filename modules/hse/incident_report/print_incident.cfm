<cfquery name="qIR">
	SELECT
    ic.*,
    CONCAT(cu.Surname," ",cu.OtherNames) AS DoneBy
    FROM incident_report AS ic
    INNER JOIN core_user AS cu ON ic.CreatedById = cu.UserId
    WHERE ic.IncidentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
</cfquery>
<cfset request.letterhead.title="INCIDENT REPORT"/>
<cfset request.letterhead.Id="ICR ## #url.id#"/>
<cfset request.letterhead.noline=true/>
<!---cfset request.letterhead.logosize=40/--->
<cfset request.letterhead.date = "Report Time: #dateformat(qIR.ReportTime,'dd/mm/yyyy')#&nbsp;&nbsp;#TimeFormat(qIR.ReportTime,'HH:MM')#&nbsp;"/>
<cfimport taglib="../../../assets/awaf/tags/xUtil/" prefix="util" />
<cfoutput>
    <!DOCTYPE html>
    <html >
      <head>
        <meta charset="UTF-8">
        
        <title>titl</title>
        <link rel="stylesheet" type="text/css" href="../../../assets/bootstrap/css/bootstrap.min.css">
        
        
        
            <style>
          /* NOTE: The styles were added inline because Prefixfree needs access to your styles and they must be inlined if they are on local disk! */
          body {
      background: ##cccccc;
    }
    
    page[size="A4"] {
      background: white url(../../../assets/img/hse.png) no-repeat center;
      width: 21cm;
      height: 29.7cm;
      display: block;
      margin: 0 auto;
      margin-bottom: 0.5cm;
      box-shadow: 0 0 0.5cm rgba(0, 0, 0, 0.5);
	  page-break-after: always;
    }
    
    @media print {
      body, page[size="A4"] {
		  background: white url(../../../assets/img/hse.png) no-repeat center;
          margin: 0;
          box-shadow: 0;
		  page-break-after: always;
      }
    }
    .givegap {padding-bottom:8px !important}
	td.cbg{background-color:##f3f3f3;}
	.newpage{ page-break-before:always}
        </style>
    
        
      </head>
    
      <body>
    
        <page size="A4">
        	<cfinclude template="../../../include/letter_head.cfm"/>
            <br>
            <div class="col-sm-12 text-center"><strong>INCIDENT / NEAR MISS NOTIFICATION AND INVESTIGATION REPORT FORM</strong></div>
            <div class="row">
                	<div class="col-sm-12">
                    	<div class="panel panel-default">
                          <!-- Default panel contents -->
                          <div class="panel-heading"> <strong>PART 1    NOTIFICATION</strong>  (To Be Completed By the Person Reporting  the Incident)</div>
                          <div class="panel-body">
                            <p>
                                <table width="100%" style="font-size:12px">
                                	<tr valign="top">
                                    	<td width="25%" align="right" ><strong>REPORT TITLE:</strong></td>
                                        <td width="2%">&nbsp;</td>
                                        <td>#qIR.Title#</td>
                                    </tr>
                                    <tr><td colspan="3">&nbsp;</td></tr>
                                	<tr valign="top">
                                    	<td width="20%" align="right" ><strong>FULL DESCRIPTION:</strong></td>
                                        <td width="2%">&nbsp;</td>
                                        <td>#qIR.Description#</td>
                                    </tr>
                                    <tr><td colspan="3">&nbsp;</td></tr>
                                	<tr valign="top">
                                    	<td width="20%" align="right" ><strong>IMMEDIATE ACTIONS TAKEN:</strong></td>
                                        <td width="2%">&nbsp;</td>
                                        <td>#qIR.ActionTaken#</td>
                                    </tr>
                                    <tr><td colspan="3">&nbsp;</td></tr>
                                </table>
                                
                                <table width="100%" style="font-size:12px">
                                    
                                    <tr>
                                        <td width="27%"></td>
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
                                            
                                                <tr style="border-bottom:1px ##000000 solid">
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
                                            </table>
                                        </td>
                                    </tr>                                      
                                </table><br>
                                <table width="100%" style="font-size:12px">
                                	<tr valign="top">
                                    	<td width="25%" align="right" ><strong><strong>IS THIS WORK RELATED?</strong></strong></td>
                                        <td width="2%">&nbsp;</td>
                                        <td>
                                            <cfset chk1 = chk2 = 0/>
											<cfif qIR.IsWorkRelated eq "Yes">
                                                <cfset chk1 = 1/>
                                            <cfelse>
                                                <cfset Chk2 = 1/>
                                            </cfif>
                                             <table width="100%" border="0" cellspacing="0" cellpadding="0" class="">
                                                  <tr>
                                                     <td width="5%" class="">Yes <img src="../../../assets/img/ptw_checkbox_#chk1#.png" width="10" height="10"></td>
                                                     <td width="5%" align="left" class=" pad-left-5">No <img src="../../../assets/img/ptw_checkbox_#chk2#.png" width="10" height="10"></td>
                                                     <td width="60%" nowrap="nowrap" class="underline">IF NOT, WHY? #qIR.IfNo#&nbsp;</td>
                                                  </tr>
                                              </table>
                                        </td>
                                    </tr>
                                </table>
                                <table width="100%" style="font-size:12px">
                                	<tr valign="top">
                                    	<td width="25%" align="right" ><strong><strong>INCIDENT OR A NEAR MISS?</strong></strong></td>
                                        <td width="2%">&nbsp;</td>
                                        <td>
                                            <cfset chk1 = chk2 = 0/>
											<cfif qIR.IncidentType eq "Incident">
                                                <cfset chk1 = 1/>
                                            <cfelse>
                                                <cfset Chk2 = 1/>
                                            </cfif>
                                            Incident <img src="../../../assets/img/ptw_checkbox_#chk1#.png" width="10" height="10"> &nbsp;
                                            Near Miss <img src="../../../assets/img/ptw_checkbox_#chk2#.png" width="10" height="10">
                                        </td>
                                    </tr>
                                </table>
                                <table width="100%" style="font-size:11px">
                                	<tr><td colspan="2">&nbsp;</td></tr>
                                    <tr valign="top">
                                    	<td width="25%" align="right" >&nbsp;</td>
                                        <td width="2%">&nbsp;</td>
                                        <td>
                                            <table width="100%">
                                            	<tr valign="top">
                                                	<td width="53%">
                                                    	<strong>AFFECTED PERSONNEL / STAKEHOLDER CATEGORY</strong><br>
                                                        <cfset ftbpb = "#application.appName# employee & direct contract,#application.appName# third party personnel,Contractor,Subcontractor,Host community or community-related,Security unit or security-related,Member of public/visitor"/>
                                                        <cfloop list="#ftbpb#" index="it">
                                                            <cfset chk = getCheck(qIR.AffectedPersonel,it)/>
                                                            &nbsp;&nbsp;<img src="../../../assets/img/ptw_checkbox_#chk#.png" width="10" height="10">&nbsp;&nbsp;#it#<br>
                                                        </cfloop>
                                                        OTHERS: <u>#qIR.OtherAffectedPersonel# </u>
                                                    </td>
                                                	<td style="border-left:1px dotted ##4E4C4C">
                                                    	&nbsp;&nbsp;<strong>AGENT(S) OF INCIDENT</strong><br>
                                                        <cfset ppe = "Powered Equipment/Tools,Machinery & Fixed Plant,Mobile Plant,Transport,Non-Powered Equipment/Tool,Environment,Human Factors,Chemical Substance,Biological Agencies"/>
                                                        <cfloop list="#ppe#" index="it">
                                                            <cfset chk = getCheck(qIR.IncidentAgent,it)/>
                                                            &nbsp;&nbsp;&nbsp;&nbsp;<img src="../../../assets/img/ptw_checkbox_#chk#.png" width="10" height="10">&nbsp;&nbsp;#it#<br>
                                                        </cfloop>
                                                    </td>
                                                </tr>
                                                <tr><td colspan="2">&nbsp;</td></tr>
                                                <tr valign="top">
                                                	<td >
                                                    	<strong>LOCATION WHERE THE INCIDENT OCCURRED</strong><br>
                                                        <cfset ppe = "Field,Head Office,Others"/>
                                                        <cfloop list="#ppe#" index="it">
                                                            <cfset chk = getCheck(qIR.OccurredLocation,it)/>
                                                            &nbsp;&nbsp;<img src="../../../assets/img/ptw_checkbox_#chk#.png" width="10" height="10">&nbsp;&nbsp;#it#<br>
                                                        </cfloop>
                                                    </td>
                                                    <td style="border-left:1px dotted ##4E4C4C">
                                                    	&nbsp;&nbsp;<strong>WHO OR WHAT WAS AFFECTED?</strong><br>
                                                        <cfset ftbib = "People,Asset/Production,Environment,Reputation"/>
                                                        <cfloop list="#ftbib#" index="it">
                                                            <cfset chk = getCheck(qIR.AffectedParty,it)/>
                                                            &nbsp;&nbsp;&nbsp;&nbsp;<img src="../../../assets/img/ptw_checkbox_#chk#.png" width="10" height="10">&nbsp;&nbsp; #it#<br>
                                                        </cfloop>
                                                    	
                                                    </td>
                                                </tr>
                                                <tr><td colspan="2">&nbsp;</td></tr>
                                                <tr valign="top">
                                                	<td colspan="2">
                                                    	<strong>NAME AND ADDRESS OF LOCATION AND EXACT WHEREABOUTS AT THE LOCATION</strong><br>
                                                        #qIR.OccurredAddress# &nbsp;
                                                    </td>
                                                </tr>
                                                <tr><td colspan="2">&nbsp;</td></tr>
                                                <tr><td colspan="2"><strong>REPORTING PARTY DETAILS</strong></td></tr>
                                                <tr valign="top" style="border:##535151 1px solid; height:130px">
                                                	<td colspan="2">
                                                        #qIR.ReportingPartyDetails# &nbsp;
                                                    </td>
                                                </tr>
                                                <tr><td colspan="2">&nbsp;</td></tr>
                                                <cfif qIR.InjustDetailApplicable neq "Applicable">
                                                    <tr>
                                                        <td colspan="2">
                                                            <cfset chk1 = chk2 = 0/>
															<cfif qIR.InjustDetailApplicable eq "Applicable">
                                                                <cfset chk1 = 1/>
                                                            <cfelse>
                                                                <cfset Chk2 = 1/>
                                                            </cfif>
                                                            <strong>INJURY DETAILS</strong> - (To be completed by the person reporting the incident or the medic) &nbsp;&nbsp;&nbsp;
                                                            Not Applicable <img src="../../../assets/img/ptw_checkbox_#chk2#.png" width="10" height="10">
                                                        </td>
                                                    </tr>
                                                </cfif>
                                            </table>
                                        </td>
                                    </tr>
                                    
                                </table>
                                
                            
                            </p>
                          </div>
                        
                        </div>
                    </div>
              </div>
              <i  class="newpage"></i>
        </page>
        <cfif qIR.InjustDetailApplicable eq "Applicable">
            <cfquery name="qID">
                  SELECT * FROM incident_injury_details
                  WHERE IncidentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
            </cfquery>
            <page size="A4">
        	<cfinclude template="../../../include/letter_head.cfm"/>
            <br>
            <div class="col-sm-12 text-center"><strong>INCIDENT / NEAR MISS NOTIFICATION AND INVESTIGATION REPORT FORM</strong></div>
            <div class="row">
                	<div class="col-sm-12">
                    	<div class="panel panel-default">
                          <!-- Default panel contents -->
                          <div class="panel-heading"> 
                          		<cfset chk1 = chk2 = 0/>
								<cfif qIR.InjustDetailApplicable eq "Applicable">
                                    <cfset chk1 = 1/>
                                <cfelse>
                                    <cfset Chk2 = 1/>
                                </cfif>
                                <strong>INJURY DETAILS</strong> - (To be completed by the person reporting the incident or the medic) &nbsp;&nbsp;&nbsp;
                                Applicable <img src="../../../assets/img/ptw_checkbox_#chk1#.png" width="10" height="10">
                          </div>
                          <div class="panel-body">
                            <p>
                            	<table width="100%" style="font-size:12px">
                                	<tr valign="top">
                                    	<td width="25%" align="right" ><strong>NAMES OF INJURED PARTY :</strong></td>
                                        <td width="2%">&nbsp;</td>
                                        <td>#ucase(qID.InjuredNames)#</td>
                                    </tr>
                                    
                                	<tr valign="top">
                                    	<td width="25%" align="right" ><strong>RESIDENTIAL ADDRESS :</strong></td>
                                        <td width="2%">&nbsp;</td>
                                        <td>#qID.ResidentAddress#</td>
                                    </tr><tr valign="top">
                                	<tr valign="top">
                                    	<td width="25%" align="right" ><strong>EMPLOYEE HOME OFFICE :</strong></td>
                                        <td width="2%">&nbsp;</td>
                                        <td>#qID.EmployeeHomeOffice#</td>
                                    </tr><tr valign="top">
                                	<tr valign="top">
                                    	<td width="25%" align="right" ><strong>GENDER :</strong></td>
                                        <td width="2%">&nbsp;</td>
                                        <td>
                                        	<cfset chk1 = chk2 = 0/>
											<cfif qID.Gender eq "Male">
                                                <cfset chk1 = 1/>
                                            <cfelse>
                                                <cfset Chk2 = 1/>
                                            </cfif>
                                            
                                            <table align="left" width="100%">
                                            	<tr valign="top">
                                                	<td width="40%">
                                                        <img src="../../../assets/img/ptw_checkbox_#chk1#.png" width="10" height="10"> MALE &nbsp;&nbsp;
                                                        <img src="../../../assets/img/ptw_checkbox_#chk2#.png" width="10" height="10"> FEMALE 
                                                    </td>
                                                    <td width="20%"><strong>DATE OF BIRTH:</strong></td><td>#Dateformat(qID.DOB,"dd/mm/yyyy")#</td>
                                                    
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr><td colspan="3">&nbsp;</td></tr>
                                	<tr valign="top">
                                    	<td width="25%" align="right" ><strong></strong></td>
                                        <td width="2%">&nbsp;</td>
                                        <td>
                                        	<strong >EMPLOYMENT/STAKEHOLDER CATEGORY (of injured person)</strong><br>
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
                                    <tr><td colspan="3">&nbsp;</td></tr>
                                	<tr valign="top">
                                    	<td width="25%" align="right" ><strong>OCCUPATION :</strong></td>
                                        <td width="2%">&nbsp;</td>
                                        <td>#qID.Occupation#</td>
                                    </tr>
                                    <tr><td colspan="3">&nbsp;</td></tr>
                                	<tr valign="top">
                                    	<td width="25%" align="right" ><strong>EMPLOYEES PROJECT:</strong></td>
                                        <td width="2%">&nbsp;</td>
                                        <td>#qID.EmployeeProject#</td>
                                    </tr>
                                	<tr valign="top">
                                    	<td width="25%" align="right" ><strong>HOW LONG IN PRESENT JOB :</strong></td>
                                        <td width="2%">&nbsp;</td>
                                        <td>
											<cfset ftbib = "< 3Mths,3 to 6Mths,6mths to 2yrs, > 5 yrs "/>
                                            <cfloop list="#ftbib#" index="it">
                                                 <cfset chk = getCheck(qID.JobDuration,it)/>
                                                 <img src="../../../assets/img/ptw_checkbox_#chk#.png" width="9" height="9">&nbsp;&nbsp;#it#&nbsp;&nbsp;&nbsp;
                                            </cfloop>
                                        </td>
                                    </tr>
                                    <tr><td colspan="3">&nbsp;</td></tr>
                                    <tr valign="top">
                                    	<td width="25%" align="right" ></td>
                                        <td width="2%">&nbsp;</td>
                                        <td>
                                        	<strong>DATE EMPLOYER NOTIFIED OF INJURY/ILLNESS : </strong> 
                                        	#Dateformat(qID.NotificationDate,"dd/mm/yyyy")#
                                        </td>
                                    </tr>
                                    <tr><td colspan="3">&nbsp;</td></tr>
                                    <tr valign="top">
                                    	<td width="25%" align="right" ><strong>INJURY TYPE :</strong></td>
                                        <td width="2%">&nbsp;</td>
                                        <td>
                                        	<cfset ftbib = "First Aid Case,Medical Treatment Case,Restricted Workday Case,Lost Time Injury,Fatality"/>
                                            <cfloop list="#ftbib#" index="it" >
                                                <cfset chk = getCheck(qID.InjuryType,it)/>
                                                <img src="../../../assets/img/ptw_checkbox_#chk#.png" width="9" height="9"> #it#
                                            </cfloop> 
                                        </td>
                                    </tr>
                                    <tr><td colspan="3">&nbsp;</td></tr>
                                    <tr valign="top">
                                    	<td width="25%" align="right" ></td>
                                        <td width="2%">&nbsp;</td>
                                        <td>
                                        	<strong>NATURE OF INJURY OR ILLNESS(laceration,fracture,hearing loss) : </strong> <br>
                                        	<div class="givegap"> <ins>#qID.NatureofInjury#</ins>&nbsp;</div>
                                        </td>
                                    </tr>
                                    <tr valign="top">
                                    	<td width="25%" align="right" ></td>
                                        <td width="2%">&nbsp;</td>
                                        <td>
                                        	<strong>PART OF BODY INJURED (back, left wrist, right eye etc) : </strong> <br>
                                        	<div  class="givegap"> <ins>asdas#qID.InjuredBodyPart#</ins>&nbsp;</div>
                                        </td>
                                    </tr>
                                    <tr valign="top">
                                    	<td width="25%" align="right" ></td>
                                        <td width="2%">&nbsp;</td>
                                        <td>
                                        	<strong>WHAT WAS INJURED PERSON DOING JUST BEFORE THE INCIDENT? <br>(Please be specific. Identify tools, equipment or material in use) : </strong> <br>
                                        	<div class="givegap"> <ins>#qID.ActivityBeforeInjury#</ins>&nbsp;</div>
                                        </td>
                                    </tr>
                                    <tr valign="top">
                                    	<td width="25%" align="right" ></td>
                                        <td width="2%">&nbsp;</td>
                                        <td>
                                        	<strong>WHAT HAPPENED? (How did the injury occur) : </strong> <br>
                                        	<div class="givegap"> <ins>#qID.InjuryEvent#</ins>&nbsp;</div>
                                        </td>
                                    </tr>
                                    <tr valign="top">
                                    	<td width="25%" align="right" ></td>
                                        <td width="2%">&nbsp;</td>
                                        <td>
                                        	<strong>WHAT OBJECT OR SUBSTANCE DIRECTLY HARMED THE EMPLOYEE? : </strong> <br>
                                        	<div class="givegap"> <ins>#qID.InjuryObject#</ins>&nbsp;</div>
                                        </td>
                                    </tr>
                                    <tr valign="top">
                                    	<td width="25%" align="right" ></td>
                                        <td width="2%">&nbsp;</td>
                                        <td>
                                        	<strong>WHERE WERE INJURIES TREATED?(name of clinic or location) : </strong> <br>
                                        	<div class="givegap"> <ins>#qID.TreatmentLocation#</ins>&nbsp;</div>
                                        </td>
                                    </tr>
                                    <tr valign="top">
                                    	<td width="25%" align="right" ></td>
                                        <td width="2%">&nbsp;</td>
                                        <td>
                                        	<strong>WHO PROVIDED TREATMENT? (NAME OF PHYSICIAN OR HEALTHCARE PROFESSIONAL) : </strong> <br>
                                        	<div class="givegap"> <ins>#qID.TreatmentProvider#</ins>&nbsp;</div>
                                        </td>
                                    </tr>
                                    <tr valign="top">
                                    	<td width="25%" align="right" ></td>
                                        <td width="2%">&nbsp;</td>
                                        <td>
                                        	<strong>TREATMENT GIVEN? BY: (Full name of person providing medical treatment or first aid) : </strong> <br>
                                        	<div class="givegap"> <ins>#qID.TreatmentGiven#</ins>&nbsp;</div>
                                        </td>
                                    </tr>
                                    <tr valign="top">
                                    	<td width="25%" align="right" ><strong>HAS INJURED EMPLOYEE RETURNED TO WORK?</strong></td>
                                        <td width="2%">&nbsp;</td>
                                        <td>
                                        	<cfset ftbib = "1. No. Still off work, 2. Yes. Has resumed, 3. Restricted work, 4. Regular work, 5. Fatality"/>
                                            <cfloop list="#ftbib#" index="it" >
                                                <cfset chk = getCheck(qID.ReturnToWork,it)/>
                                                <img src="../../../assets/img/ptw_checkbox_#chk#.png" width="9" height="9"> #it#
                                            </cfloop> <br>
                                            <strong style=";">Return Comment</strong><br>
                                            <div class="givegap"> <ins>#qID.ReturnComment#</ins>&nbsp;</div>
                                        </td>
                                    </tr>
                                </table>
                            </p>
                          </div>
                        
                        </div>
                    </div>
              </div>
              <i  class="newpage"></i>
            </page>
        </cfif>
        <page size="A4">
        	<cfinclude template="../../../include/letter_head.cfm"/>
            <br>
            <div class="col-sm-12 text-center"><strong>INCIDENT / NEAR MISS NOTIFICATION AND INVESTIGATION REPORT FORM</strong></div>
            <div class="row">
                	<div class="col-sm-12">
                    	<div class="panel panel-default">
                          <!-- Default panel contents -->
                          <div class="panel-heading"> 
                          	<strong>PART 2    INCIDENT CLASSIFICATION & INVESTIGATION</strong>   <BR>
                            (To Be Completed By HSE Supervisor / Responsible Personnel Supervisor or Investigation Team)
                          </div>
                          <div class="panel-body">
                            <p>
                            	<table width="100%" style="font-size:12px">
                                    	<tr valign="top" class="border">
                                        	<td colspan="4" class="cbg">
                                            	<strong>ACTUAL SEVERITY</strong> - What were the actual consequences of this incident? If multiple consequences make multiple selections
                                            </td>
                                        </tr>
                                        <tr valign="top" class="border" style="font-size:11px,border:solid 1px ##585656">
                                        	<td width="24%" class="b-right">
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
                                    
                                    	<tr><td colspan="4">&nbsp;</td></tr>
                                        
                                    	<tr>
                                        	<td colspan="4" class="cbg">
                                            	<strong>POTENTIAL SEVERITY</strong> (worst credible outcome) Realistically, could this incident have had a worse outcome?  
                                            </td>
                                        </tr>
                                        <tr  style="font-size:11px" valign="top" class="bottom">
                                        	<td width="24%" class="b-right">
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
                                        <tr><td colspan="4">&nbsp;</td></tr>
                                    </table>
                                
                                <table width="100%" style="font-size:12px">
                                    	<tr valign="top">
                                        	<td class="cbg">
                                            	<strong>ROOT CAUSE ANALYSIS</strong>
                                            </td>
                                        </tr>
                                        <tr valign="top">
                                        	<td>
                                                	<br><strong>STEP 1</strong><br>
                                                    Obtain and review physical evidence, employee, witness information and paper evidence pertinent to the investigation. <br>
                                                    <br>
                                                    <p>
                                                        <strong>Physical:&nbsp;&nbsp;</strong> 
                                                        <cfset p_ = "Photographs,Drawings,Equipment manuals, Others"/>
                                                        <cfloop list="#p_#" index="it">
                                                             <cfset chk = getCheck(qIR.PhysicalInvestigation,it)/><img src="../../../assets/img/ptw_checkbox_#chk#.png" width="9" height="9">&nbsp;&nbsp;#ucase(it)# &nbsp;&nbsp;
                                                        </cfloop>
                                                    </p>
                                                    <p>
                                                        <strong>Employee / Witnesses-statements:&nbsp;&nbsp;</strong> 
                                                        <cfset p_ = "Statements,Interviews"/>
                                                        <cfloop list="#p_#" index="it">
                                                             <cfset chk = getCheck(qIR.Witnesses,it)/><img src="../../../assets/img/ptw_checkbox_#chk#.png" width="9" height="9">&nbsp;&nbsp;#ucase(it)# &nbsp;&nbsp;
                                                        </cfloop>
                                                    </p>
                                                    <strong>Paper:&nbsp;&nbsp;</strong> 
                                                    <cfset p_ = "Policies, Programs, Training Records, Maintenance Records, Incident Reports, Others"/>
                                                    <cfloop list="#p_#" index="it">
                                                         <cfset chk = getCheck(qIR.Paper,it)/><img src="../../../assets/img/ptw_checkbox_#chk#.png" width="9" height="9">&nbsp;&nbsp;#ucase(it)#
                                                    </cfloop><br>

                                            </td>
                                        </tr>
                                    </table>
                                    <table width="100%" style="font-size:12px">
                                        <tr valign="top">
                                            <td>
                                                <br>
                                                <strong>STEP 2</strong><br>
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
                                    <table width="100%" style="font-size:12px">
                                    	<tr>
                                        	<td>
                                            	<strong>STEP 3</strong><br>
                                                Direct Cause, Contributing Cause, and Root Cause:<br><br>
                                            </td>
                                        </tr>
                                    </table>
                                    <table width="100%" class="border" style="font-size:12px">
                                        
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
                                    </table>
                            </p>
                          </div>
                        </div>
                    </div>
            </div>
        </page>
        <page size="A4">
        	<cfinclude template="../../../include/letter_head.cfm"/>
            <br>
            <div class="col-sm-12 text-center"><strong>INCIDENT / NEAR MISS NOTIFICATION AND INVESTIGATION REPORT FORM</strong></div>
            <div class="row">
                	<div class="col-sm-12">
                    	<div class="panel panel-default">
                          <!-- Default panel contents -->
                          <div class="panel-body">
                              <p>
                                    <table width="100%" class="border" style="font-size:12px">
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
                                                <cfset p_ = "Heavy Workload,Tight Schedule To Complete Task,Long/Unusual Working Hours,Falsely Perceived Need to Hurry,Staff Assistance Unavailable,Staff Assistance Inadequate,Changes in Process,Was Employee Ill?,Medication/ Drugs/ Alcohol Factors,Double Shift"/>
                                                <cfloop list="#p_#" index="it">
                                                     <cfset chk = getCheck(qIR.ProductivityFactors,it)/><img src="../../../assets/img/ptw_checkbox_#chk#.png" width="9" height="9">&nbsp;#it# &nbsp;&nbsp;<br>
                                                </cfloop>
                                            </td>
                                            <td class="b-right">
                                                <strong>WORK BEHAVIOUR</strong><br>
                                                <cfset p_ = "Shortcuts Taken,Deviations-Common Allowed etc...,Special Infrequent Task,Tool/Equipment Used Improperly,History of Accidents/Incidents,Disregard/Refused to Follow Procedure,Staff Assistance Required,Horseplay,Repetitive or Physically Demanding,Going On/Coming Off Vacation"/>
                                                <cfloop list="#p_#" index="it">
                                                     <cfset chk = getCheck(qIR.WorkBehaviour,it)/><img src="../../../assets/img/ptw_checkbox_#chk#.png" width="9" height="9">&nbsp;#it# &nbsp;&nbsp;<br>
                                                </cfloop>
                                            </td>
                                        </tr>
                                    </table><br>
                                    <table width="100%" class="border" style="font-size:12px">
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
                                    
                                    <table width="100%" class="border" style="font-size:12px">
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
                                    <table width="100%" style="font-size:12px">
                                        <tr>
                                            <td>
                                                <br><br><br><strong>Final Root Cause Analysis Statement: </strong><br>
                                            </td>
                                        </tr>
                                        <tr valign="top">
                                            <td style="border:1px solid ##4B4848; height:90px; padding:4px">
                                                #qIR.RootCauseStatement#&nbsp;
                                            </td>
                                        </tr>
                                    </table>
                              </p>
                          </div>
                        </div>
                    </div>
            </div>
        </page>
        <page size="A4">
        	<cfinclude template="../../../include/letter_head.cfm"/>
            <br>
            <div class="col-sm-12 text-center"><strong>INCIDENT/NEAR MISS NOTIFICATION AND INVESTIGATION REPORT FORM</strong></div>
            <div class="row">
                	<div class="col-sm-12">
                    	<div class="panel panel-default">
                          <!-- Default panel contents -->
                          <div class="panel-heading"> <strong>PART 3 FURTHER PREVENTIVE/CORRECTIVE ACTIONS, REVIEW AND APPROVAL</strong></div>
                          <div class="panel-body">
                              <p>
                                	<table width="100%" style="font-size:12px">
                                    	<tr>
                                        	<td>
                                            	<strong>CORRECTIVE ACTION</strong>  (To Be Completed By HSE Supervisor / Responsible Personnel Supervisor or Investigation Team and approved by Responsible HOD)
                                            </td>
                                        </tr>
                                        <tr>
                                        	<td>
                                            	<!---<cfquery name="qC" result="rt">
                                                	SELECT i.*,CONCAT(cu.Surname," ",cu.OtherNames) AS Personel
                                                    FROM incident_corrective_action AS i
                                                    INNER JOIN core_user AS cu ON i.PersonelResponsibleId= cu.UserId
													WHERE IncidentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
                                                </cfquery>--->
                                                <br>
                                                <table width="100%" cellpadding="0" cellspacing="0" class="table table-bordered">
                                                    <tr class="bottom active" >
                                                        <th class="b-right" width="40%" align="left" valign="middle">ATTACHED DOCUMENTS</th>
                                                        <cfquery name="qFi">
                                                        	SELECT * FROM file
                                                            WHERE `Table`="incident_report" AND PK="#url.id#" AND `Type`="a"
                                                        </cfquery>
                                                    </tr>
                                                    <tr valign="top" class="bottom">
                                                        <td class="b-right" >
                                                            <cfset path = application.site.url/>        <!---expandpath("../../../")--->
                                                            <cfloop query="qFi">
                                                            	<cfset fp = path & "doc\attachment\" & Table & "\" & PK & "\" & File/>
																
																<cfif fileExists(fp)>
                                                                
                                                                	<cfset ext=ListLast(fp,".")/>
                                                                    <cfset getim = getImage(ext)/>
                                                                    <img src="#getim#" alt=""/>
                                                                    <a href="#fp#" target="_blank" >#File#</a>
                                                                </cfif>
                                                            </cfloop>
                                                            <!---<cfset FileExt=ListLast(YourFilename,".")>
															--->
                                                            
                                                        </td>
                                                    </tr>
                                                </table>
                                            	<cfquery name="qC" result="rt">
                                                	SELECT i.*,CONCAT(cu.Surname," ",cu.OtherNames) AS Personel
                                                    FROM incident_corrective_action AS i
                                                    INNER JOIN core_user AS cu ON i.PersonelResponsibleId= cu.UserId
													WHERE IncidentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
                                                </cfquery>
                                                <br>
                                                <table width="100%" cellpadding="0" cellspacing="0" class="table table-bordered">
                                                    <tr class="bottom active" >
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
                                                        	<table width="100%" class="table table-bordered">
                                                            	<tr valign="top" class="active">
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
                                                            	<tr><td>&nbsp;&nbsp;</td><th >HSE MS ELEMENTS INVOLVED:</th></tr>
                                                                <tr valign="top">
                                                                	<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                                                    <td>
                                                                    	<div  style="padding-right:8px !important">
																			<cfset p_ = "1. Leadership & Commitment,2. Policy & Strategic objectives,3.Organisation. resources and documentation,4. Evaluation & risk reduction measures,5. Planning,6. Implementation and Monitoring,7. Auditing & Reviewing"/>
                                                                            <cfloop list="#p_#" index="it">
                                                                                 <cfset chk = getCheck(qIR.ElementInvolved,it)/><img src="../../../assets/img/ptw_checkbox_#chk#.png" width="9" height="9">&nbsp;&nbsp;&nbsp;&nbsp;#it#<br>
                                                                            </cfloop>
                                                                        </div>
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
                                                        <td width="60"><strong>Prepared By:</strong> #cb.Surname# #cb.OtherNames#</td>
                                                        <td width="30" align="center">
                                                            <cfset fl = getSignature(getid)/>
															<cfif fl eq "">
																..........................................
															<cfelse>
																<img src="../../../doc/photo/core_user/#getid#/#fl#" width="40"/>&nbsp;
															</cfif>
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
                                                        <td width="60"><strong>Approved By:</strong> #cb.Surname# #cb.OtherNames#</td>
                                                        <td width="30" align="center">
                                                            <cfset fl = getSignature(getid)/>
                                                            <cfif fl eq "">
																..........................................
															<cfelse>
																<img src="../../../doc/photo/core_user/#getid#/#fl#" width="40"/>&nbsp;
															</cfif>
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
                              </p>
                          </div>
                        </div>
                    </div>
            </div>
        </page>
        <page>
        
        </page>
        <script src="../../../assets/bootstrap/js/jquery.min.js"></script>
        <script src="../../../assets/bootstrap/js/bootstrap.min.js"></script>
    
        
        
        
        
      </body>
    </html>
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
<cffunction name="getImage" access="private" returntype="string">
	<cfargument name="ext" type="string" required="yes"/>
    <cfset img = ""/>
    <cfswitch expression="#ext#">
        <cfcase value="pdf"><cfset img = "../../../assets/awaf/tags/xUploader_1000/img/pdf.png"/></cfcase>
        <cfcase value="xls,xlsx" delimiters=","><cfset img = "../../../assets/awaf/tags/xUploader_1000/img/xls.png"/></cfcase>
        <cfcase value="doc,docx" delimiters=","><cfset img = "../../../assets/awaf/tags/xUploader_1000/img/doc.png"/></cfcase>
        <cfcase value="txt"><cfset img = "../../../assets/awaf/tags/xUploader_1000/img/txt.png"/></cfcase>
        <cfcase value="ppt,pptx" delimiters=","><cfset img = "../../../assets/awaf/tags/xUploader_1000/img/ppt.png"/></cfcase>
        <cfdefaultcase><cfset img = "../../../assets/awaf/tags/xUploader_1000/img/na.png"/></cfdefaultcase>
    </cfswitch>
    <cfreturn img/>
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