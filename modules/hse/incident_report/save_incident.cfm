<!---
	Author: Arowolo Abiodun
	Created: 2011/09/30
	Modified: 2011/09/30
	->
--->
<cfparam default="0" name="url.id"/>
<cfparam default="" name="url.cid"/>

<cfif url.id eq 0><br /></cfif>

<cfset icId = "__incident_report_c_all_incidents#url.cid#" & url.id/>

<cfset Id1 = "#icId#_1"/>
<cfset Id2 = "#icId#_2"/>
<cfset Id3 = "#icId#_3"/>
<cfset Id4 = "#icId#_4"/>
<cfset Id5 = "#icId#_5"/>

<cfoutput>
    <cfimport taglib="../../../assets/awaf/tags/xNavTab_1000/" prefix="nt" />
    <cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />
    <cfimport taglib="../../../assets/awaf/tags/xUploader_1000/" prefix="u" />
    <cfimport taglib="../../../assets/awaf/tags/xEditTable/" prefix="et" />


    <!--- QUERIES --->
    <cfset qPM = application.com.Permit.GetPermit(url.id)/>
    <cfquery name="qGT">
        SELECT
        	gt.*,
            Date_Format(gt.Date,'%d-%m-%y %r') Dates
        FROM
       		ptw_gas_test AS gt
        INNER JOIN ptw_permit AS pp ON gt.PermitId = pp.PermitId
        WHERE gt.PermitId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
	</cfquery>
  <cfquery name = "qIR" >
      SELECT * FROM incident_report
      WHERE IncidentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
  </cfquery>

<style>
.pad35	{padding:35px;}
</style>

    <f:Form id="#icId#frm" action="modules/ajax/maintenance.cfm?cmd=SaveIncideReport" EditId="#url.id#">
        <div id="#Id1#">
        <table border="0" width="100%">
            <tr>
              <td colspan="2">
                <div  class="alert alert-info">To Be Completed By the Person Reporting  the Incident</div>
              </td>
            </tr>
            <tr>
                <td width="50%" valign="top">
                    <f:DatePicker name="ReportTime" label="Date/Time Reported" required value="#qIR.ReportTime#" type="datetime"/>
                    <f:TextBox name="Title" label="Reported Title" required value="#qIR.Title#" class="span11"/>
                    <f:TextArea name="Description" required label="Full Description" help="Describe what and how it happened" value="#qIR.Description#" class="span11" rows="4"/>
                </td>
                <td class="horz-div"  valign="top">
                    <f:TextArea name="ActionTaken" label="Immediate Actions Taken" value="#qIR.ActionTaken#" class="span11" rows="4"/>
                    <f:RadioBox name="NotifyMng" ShowLabel Label="Immediate Notification to Management/Investigation" ListValue="Required,Actioned" selected="#qIR.NotifyMng#" Inline/>
                    <f:RadioBox name="NotifyGov" ShowLabel Label="Notifiable to Government Authorities/Agencies?" ListValue="Required,Actioned" selected="#qIR.NotifyGov#" Inline/>
                    <f:TextBox name="NotificationSpecify" label="Specify"  value="#qIR.NotificationSpecify#" class="span11"/>
                </td>
           </tr>
 			<tr class="vert-div">
            	<td colspan="2" valign="top" align="center">&nbsp;
                	&nbsp;
                </td>
            </tr>       

        
        	
            <tr>
            	<td width="50%" valign="top">
                  <f:RadioBox name="IsWorkRelated" ShowLabel required Label="Is this work related?" ListValue="Yes,No" selected="#qIR.IsWorkRelated#" Inline/>
                  <f:TextBox name="IfNo" label="If not why?"  value="#qIR.IfNo#" class="span11"/>
                  <f:RadioBox ShowLabel Label="Incident Type" name="IncidentType" ListValue="Incident,Near Miss" selected="#qIR.IncidentType#" Inline/>
                  Who or what was affected? <br>
                  <f:CheckBox name="AffectedParty" ListValue="People,Asset/Production,Environment,Reputation"  selected="#qIR.AffectedParty#" delimiter="'"/>
              	  Affected personnel / stakeholder category <br /> 
                  <f:CheckBox name="AffectedPersonel" ListValue="#application.appName# employee & direct contract,#application.appName# third party personnel,Contractor,Subcontractor,Host community or community-related,Security unit or security-related,Member of public/visitor"  selected="#qIR.AffectedPersonel#" delimiter="'"/>
                  <f:TextBox name="OtherAffectedPersonel" label="Specify Others Affected"  value="#qIR.OtherAffectedPersonel#" class="span11"/>
                </td>
            	<td class="horz-div" valign="top">
                  <f:RadioBox ShowLabel Label="Incident Location" name="OccurredLocation" ListValue="Field,Head Office,Others " selected="#qIR.OccurredLocation#" Inline/>
                  <f:TextArea name="OccurredAddress" label="Location Description" value="#qIR.OccurredAddress#" class="span11" rows="3"/>
              	   Agent(s) of incident <br />
                  <f:CheckBox name="IncidentAgent" ListValue="Powered Equipment/Tools,Machinery & Fixed Plant,Mobile Plant,Transport,Non-Powered Equipment/Tool,Environment,Human Factors,Chemical Substance,Biological Agencies"  selected="#qIR.IncidentAgent#" delimiter="'"/>
                  <f:TextBox name="OtherAgents" label="Specify Other Agent"  value="#qIR.OtherAgents#" class="span11"/>
              </td>
            </tr>
            
        </table>
        </div>
        <div id="#Id2#" <cfif url.id neq 0>style="height:auto;"</cfif>>
        	<cfquery name="qInj">
            	SELECT * FROM incident_injury_details
                WHERE IncidentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
            </cfquery>
            <div  class="alert alert-info">
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;To be completed by the Person Reporting the Incident or the medic <br><br>
                <f:select name="InjustDetailApplicable" label="Injury Details" required Listvalue="Applicable,NotApplicable" listDisplay="Applicable,Not Applicable" onchange="#icId#changePT(this)"  Selected="#qIR.InjustDetailApplicable#"/>

            </div>
            <cfset displays = "none"/>
            <cfif qIR.InjustDetailApplicable eq "Applicable">
            	<cfset displays = "block"/>
            </cfif>
        	<table border="0" width="100%"  id="#icId#ic" style="display:#displays#;">
            	<tr>
                	<td>

                    </td>
                </tr>
                <tr>
                	<td width="50%" valign="top">
                  		<f:TextBox name="InjuredNames" label="Injured Names" required  value="#qInj.InjuredNames#" class="span11"/>
                  		<f:RadioBox ShowLabel Label="Gender" name="Gender" required ListValue="Male,Female " selected="#qInj.Gender#" Inline/>
            			<f:DatePicker name="DOB" label="Date of Birth" required value="#dateformat(qInj.DOB,'dd/mmm/yyyy')#"/>
                  		<f:TextBox name="Occupation" label="Occupation" required  value="#qInj.Occupation#" class="span11"/>
            			<f:DatePicker name="DateHired" label="Date Hired" required value="#dateformat(qInj.DateHired,'dd/mmm/yyyy')#"/>
                  		<f:TextArea name="ResidentAddress" label="Resident Address" value="#qInj.ResidentAddress#" class="span11" rows="3"/>
                  		<f:RadioBox ShowLabel Label="Present Job Duration" name="JobDuration" ListValue="< 3Mths,3 to 6Mths,6mths to 2yrs, > 5 yrs " selected="#qInj.JobDuration#" Inline/>
            			<f:DatePicker name="NotificationDate" label="Injury/Illness Notified Date" required value="#dateformat(qInj.NotificationDate,'dd/mmm/yyyy')#"/>
                  		<f:TextBox name="EmployeeProject" label="Employee Project"  value="#qInj.EmployeeProject#" class="span11"/>
                  		<f:TextArea name="EmployeeHomeOffice" label="Employee Home Office" value="#qInj.EmployeeHomeOffice#" class="span11" rows="3"/>
                    </td>
                	<td class="horz-div" valign="top">
                  		<f:TextBox name="TreatmentLocation" hint="i.e. Name of clinic or location" label="Treatment Location" required  value="#qInj.TreatmentLocation#" class="span11"/>
                  		<f:TextBox name="TreatmentProvider" hint="Name of physician or healthcare professional" label="Treated By" required  value="#qInj.TreatmentProvider#" class="span11"/>
                  		<f:TextBox name="TreatmentGiven" label="Treatment Given" required  value="#qInj.TreatmentGiven#" class="span11"/>
                  		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Injury Type <br>
                        <f:CheckBox name="InjuryType" ListValue="First Aid Case,Medical Treatment Case,Restricted Workday Case,Lost Time Injury,Fatality"  selected="#qInj.InjuryType#" delimiter="'"/>
                  		<f:TextBox name="NatureofInjury" label="Nature Of Injury"  value="#qInj.NatureofInjury#" class="span11"/>
                  		<f:TextBox name="InjuredBodyPart" label="Injured Body Part"  value="#qInj.InjuredBodyPart#" class="span11"/>
                  		<f:TextBox name="ActivityBeforeInjury" hint="(Please be specific. Identify tools or material in use)" label="Activity Before Injury"  value="#qInj.ActivityBeforeInjury#" class="span11"/>
                  		<f:TextArea name="InjuryEvent" label="What Happened" value="#qInj.InjuryEvent#" class="span11" rows="2"/>
                  		<f:TextBox name="InjuryObject" label="Object Involve" hint="What Object Harmed The Employee"  value="#qInj.InjuryObject#" class="span11"/>
                    </td>
                </tr>
                <tr class="vert-div">
                    <td colspan="2" valign="top" align="center">&nbsp;</td>
                </tr> 
                <tr>
                	<td colspan="2">
                  		<f:RadioBox ShowLabel Label="Has Employee Returned To Work" name="ReturnToWork" ListValue="1. No. Still off work, 2. Yes. Has resumed, 3. Restricted work, 4. Regular work, 5. Fatality" selected="#qInj.ReturnToWork#" Inline/>
                    </td>
                </tr>
                <tr>
                	<td colspan="2">
                  		<f:TextArea name="ReturnComment" label="Return Comment" help="Enter: Number of days off if 1, Date Returned if 2, No. days if 3 or 4, Date of Death if 5 (d/mm/yyyy). Else give your comment" value="#qInj.ReturnComment#" class="span11" rows="2"/>
                    </td>
                </tr>
            </table>
        
        </div>
        <div id="#Id3#" <cfif url.id neq 0>style="height:320px;"</cfif>>
        <table width="100%" border="0">
        	<tr class="vert-div">
            	<td colspan="4" align="center" valign="top" >
                	<small class="pull-left"><strong>CLASSIFICATION</strong> Complete both boxes using the classification table. (To Be Completed By HSE Supervisor/Responsible Personnel Supervisor or Investigation Team.)</small>
                </td>
            </tr>
        	<tr class="vert-div">
            	<td colspan="4" align="center" valign="top" class="alert alert-success">
                	<small class="pull-left"><strong>ACTUAL SEVERITY</strong> - What were the actual consequences of this incident? If multiple consequences make multiple selections </small><br>
                	
                </td>
            </tr>
            <tr>
            	<td colspan="2">
                	<table width="100%">
                    	<tr>
                            <td width="25%" valign="top">
                                <strong>PEOPLE</strong><br/>
                                <f:CheckBox name="ASeverityPeople" width="auto" height="auto" style="margin-left:50px !important" ListValue="A - No impact or First Aid Case,B - Medical Treatment Case or Restricted Workday Case,C - Lost Workday Case,D - Disability/Permanent Injury,E - Fatality  "  selected="#qIR.ASeverityPeople#" delimiter="'"/>
                            </td>
                            <td width="25%" valign="top" class="horz-div">
                                <strong>ENVIRONMENT</strong><br/>
                                <f:CheckBox name="ASeverityEnvironment" width="auto" height="auto" style="margin-left:50px !important" ListValue="A - No Impact,B - Localised,C - Moderate,D - Significant (local),E- Significant (widespread)"  selected="#qIR.ASeverityEnvironment#" delimiter="'"/>
                            </td>
                            <td width="25%" valign="top" class="horz-div">
                                <strong>ASSET/PRODUCTION</strong><br/>
                                <f:CheckBox name="ASeverityAsset" width="auto" height="auto" style="margin-left:50px !important" ListValue="A - Zero Effect or Slight Damage or Loss,B - Minor Damage or Loss,C - Local Damage or Loss,D - Major Damage or Loss,E - Extensive Damage or Loss"  selected="#qIR.ASeverityAsset#" delimiter="'"/>
                            </td>
                            <td width="25%" class="horz-div" valign="top">
                                <strong>REPUTATION</strong><br/>
                                <f:CheckBox name="ASeverityReputation" width="auto" height="auto" style="margin-left:50px !important" ListValue="A - No /Temporary Local Impact,B - Local Short Term Impact,C - Local Long Term Impact (manageable outcomes),D - Local Long Term Impact (unmanageable outcomes),E - International Impact"  selected="#qIR.ASeverityReputation#" delimiter="'"/>
                            </td>
                        
                        </tr>
                    </table>
                </td>
            </tr>
        	<tr class="vert-div">
            	<td colspan="4" align="center" valign="top" class="alert alert-success">
                	<small class="pull-left"><strong>POTENTIAL SEVERITY (worst credible outcome) </strong> Realistically, could this incident have had a worse outcome?</small><br>
                </td>
            </tr>
            <tr>
            	<td colspan="2">
                	<table width="100%">
                    	<tr>
                            <td width="25%" valign="top">
                                <strong>PEOPLE</strong><br/>
                                <f:CheckBox name="PSeverityPeople" width="auto" height="auto" style="margin-left:50px !important" ListValue="A - No impact or First Aid Case,B - Medical Treatment Case or Restricted Workday Case,C - Lost Workday Case,D - Disability/Permanent Injury,E - Fatality  "  selected="#qIR.PSeverityPeople#" delimiter="'"/>
                            </td>
                            <td width="25%" valign="top" class="horz-div">
                                <strong>ENVIRONMENT</strong><br/>
                                <f:CheckBox name="PSeverityEnvironment" width="auto" height="auto" style="margin-left:50px !important" ListValue="A - No Impact,B - Localised,C - Moderate,D - Significant (local),E- Significant (widespread)"  selected="#qIR.PSeverityEnvironment#" delimiter="'"/>
                            </td>
                            <td width="25%" valign="top" class="horz-div">
                                <strong>ASSET/PRODUCTION</strong><br/>
                                <f:CheckBox name="PSeverityAsset" width="auto" height="auto" style="margin-left:50px !important" ListValue="A - Zero Effect or Slight Damage or Loss,B - Minor Damage or Loss,C - Local Damage or Loss,D - Major Damage or Loss,E - Extensive Damage or Loss"  selected="#qIR.PSeverityAsset#" delimiter="'"/>
                            </td>
                            <td width="25%" class="horz-div" valign="top">
                                <strong>REPUTATION</strong><br/>
                                <f:CheckBox name="PSeverityReputation" width="auto" height="auto" style="margin-left:50px !important" ListValue="A - No /Temporary Local Impact,B - Local Short Term Impact,C - Local Long Term Impact (manageable outcomes),D - Local Long Term Impact (unmanageable outcomes),E - International Impact"  selected="#qIR.PSeverityReputation#" delimiter="'"/>
                            </td>
                        </tr>
                    </table>
                </td>
            
            </tr>
            <!---ROOT CAUSE ANALYSIS--->
        	<tr class="vert-div">
            	<td colspan="4" align="left" valign="top" class="alert alert-danger">
                	<strong>ROOT CAUSE ANALYSIS </strong><br>
                    <small class="pull-left">All incidents and near misses shall be investigated  For a potential severity classification of "C" or higher, Root Cause Analysis  shall be undertaken</small><br>
                </td>
            </tr>
        	<tr class="vert-div">
            	<td colspan="4" align="left" valign="top" class="alert alert-danger">
                	<strong>STEP 1 </strong><br>
                    <small class="pull-left">Obtain and review physical evidence, employee, witness information and paper evidence pertinent to the investigation.</small><br>
                </td>
            </tr>
            <tr>
            	<td colspan="2">
                	<table width="100%">
                    	<tr>
                            <td width="25%" valign="top">
                                <strong>Physical</strong><br/>
                                <f:CheckBox name="PhysicalInvestigation" width="auto" height="auto" style="margin-left:50px !important" ListValue="Photographs,Drawings,Equipment manuals, Others"  selected="#qIR.PhysicalInvestigation#" delimiter="'"/>
                            </td>
                            <td width="25%" valign="top" class="horz-div">
                                <strong>Employee/Witnesses</strong><br/>
                                <f:CheckBox name="Witnesses" width="auto" height="auto" style="margin-left:50px !important" ListValue="Statements,Interviews"  selected="#qIR.Witnesses#" delimiter="'"/>
                            </td>
                            <td width="25%" valign="top" class="horz-div">
                                <strong>Paper</strong><br/>
                                <f:CheckBox name="Paper" width="auto" height="auto" style="margin-left:50px !important" ListValue="Policies, Programs, Training Records, Maintenance Records, Incident Reports, Others"  selected="#qIR.Paper#" delimiter="'"/>
                            </td>
                        </tr>
                    </table>
                </td>
            
            </tr>
        	<tr class="vert-div">
            	<td colspan="4" align="left" valign="top" class="alert alert-danger">
                    <strong>STEP 2 - CAUSES </strong><br>
                    <small class="pull-left">Check the major cause or causes of the accident/incident:</small><br>
                </td>
            </tr>
        	<tr>
            	<td width="100%" valign="top">
                    <f:CheckBox name="MajorCauses"  width="auto" height="auto" style="margin-left:0px !important" inline ListValue="POLICIES/PROCEDURES,PRODUCTIVITY FACTORS,TRAINING,ENVIRONMENT,FACILITIES/EQUIPMENT/PROCESSES,HAZARDS,BLOODBORNE PATHOGEN,WORK BEHAVIOURS,COMMUNICATION,PERSONAL PROTECTIVE EQUIPMENT"  selected="#qIR.MajorCauses#" delimiter="'"/>
                </td>
            </tr>
        	<tr class="vert-div">
            	<td colspan="4" align="left" valign="top" class="alert alert-danger">
                	<strong>STEP 3 </strong><br>
                    <small class="pull-left">
                    	Use the following listing as an aid for identifying the factors that led to the accident. 
                        Don't be limited by the categories listed-add items as needed.  Check all that apply.
                    </small><br>
                </td>
            </tr>
            <tr>
            	<td colspan="2">
                	<table width="100%">
                    	<tr>
                            <td width="25%" valign="top">
                                <strong>POLICIES/PROGRAMS</strong><br/>
                                <f:CheckBox name="Policy" width="auto" height="auto" style="margin-left:0px !important" ListValue="Not Developed or Inadequate,Developed and Communicated,Developed-Not Communicated,Developed--Not Followed/Enforced,Developed-Not Understood,Lack of Disciplinary Policy,Disciplinary Policy Not Enforced"  selected="#qIR.Policy#" delimiter="'"/>
                            </td>
                            <td width="25%" valign="top" class="horz-div">
                                <strong>COMMUNICATION</strong><br/>
                                <f:CheckBox name="Communication" width="auto" height="auto" style="margin-left:0px !important" ListValue="Insufficient Planning For Tasks,Lack of Worker Communication,Lack of Supervisor Instruction,Sufficient Supervisor Instruction,Confusion After Communication,Lack of Understanding of Task,Work Team Breakdown"  selected="#qIR.Communication#" delimiter="'"/>
                            </td>
                            <td width="25%" valign="top" class="horz-div">
                                <strong>HAZARDS</strong><br/>
                                <f:CheckBox name="Hazard" width="auto" height="auto" style="margin-left:0px !important" ListValue="A - Zero Effect or Slight Damage or Loss,B - Minor Damage or Loss,C - Local Damage or Loss,D - Major Damage or Loss,E - Extensive Damage or Loss"  selected="#qIR.Hazard#" delimiter="'"/>
                            </td>

                            <td width="25%" class="horz-div" valign="top">
                                <strong>BLOODBORNE PATHOGEN</strong><br/>
                                <f:CheckBox name="BloodBorne" width="auto" height="auto" style="margin-left:0px !important" ListValue="Unaware of Air Borne Hazard,Aware of Air Borne Hazard,Personnel Contact/Exposure,Stuck With Contaminated Needle,Sharps Container Not Available,Improper Clean-up,Contaminated Waste Not Labelled"  selected="#qIR.BloodBorne#" delimiter="'"/>
                            </td>
                        </tr>
                    	<tr>
                            <td width="25%" valign="top">
                                <strong>PRODUCTIVITY FACTORS</strong><br/>
                                <f:CheckBox name="ProductivityFactors"  selected="#qIR.ProductivityFactors#" width="auto" height="auto" style="margin-left:0px !important" ListValue="Heavy Workload,Tight Schedule To Complete Task,Long/Unusual Working Hours,Falsely Perceived Need to Hurry,Staff Assistance Unavailable,Staff Assistance Inadequate,Changes in Process,Was Employee Ill?,Medication, Drugs, Alcohol Factors,Double Shift" delimiter="'"/>
                            </td>
                            <td width="25%" valign="top" class="horz-div">
                                <strong>WORK BEHAVIOUR</strong><br/>
                                <f:CheckBox name="WorkBehaviour" selected="#qIR.WorkBehaviour#" width="auto" height="auto" style="margin-left:0px !important" ListValue="Shortcuts Taken,Deviations-Common, Allowed etc…,Special Infrequent Task,Tool/Equipment Used Improperly,History of Accidents/Incidents,Disregard/Refused to Follow Procedure,Staff Assistance Required,Horseplay,Repetitive or Physically Demanding,Going On/Coming Off Vacation"  delimiter="'"/>
                            </td>
                            <td width="25%" valign="top" class="horz-div">
                                <strong>TRAINING</strong><br/>
                                <f:CheckBox name="Training" selected="#qIR.Training#" width="auto" height="auto" style="margin-left:0px !important" ListValue="Deficient Orientation Training,Deficient Job Specific Training,Insufficient Training for new Process or Task,Lack of Supervisor Follow-up or Reinforcement,Lack of Supervisor Training,Lack of Employee Training,Hazards Overlooked in Training,Communication of Rules/Policy"  delimiter="'"/>
                            </td>
                            <td width="25%" class="horz-div" valign="top">
                                <strong>ENVIRONMENT</strong><br/>
                                <f:CheckBox name="Environment" selected="#qIR.Environment#" width="auto" height="auto" style="margin-left:0px !important" ListValue="Weather/Temperature Factors,Poor Housekeeping,Poor Lighting,Poor Visibility,Air Quality,Noise,Visibility of Labels/Warning Signs,Visible and Audible Alarms"  delimiter="'"/>
                            </td>
                        </tr>
                        <tr>
                        	<td colspan="4">&nbsp;</td>
                        </tr>
                    	<tr>
                            <td width="25%" valign="top" colspan="2">
                                <strong>PERSONAL PROTECTIVE EQUIPMENT (PPE)</strong><br/>
                                <f:CheckBox name="PPE"  selected="#qIR.PPE#" width="auto" height="auto" style="margin-left:0px !important" ListValue="Available,Required,Required PPE Not Used/Worn,Trained On How To Use,Adequate Fit,PPE Not Used Adequately,Poor Condition,Adequate for Job Performed,Lack of Supervisor Enforcement" delimiter="'"/>
                            </td>
                            <td width="25%" valign="top" class="horz-div" colspan="2">
                                <strong>FACILITIES/EQUIPMENT/PROCESS</strong><br/>
                                <f:CheckBox name="Facility" selected="#qIR.Facility#" width="auto" height="auto" style="margin-left:0px !important" ListValue="Poor or Inadequate Facility/Process Design,Faulty Equipment or Design,Poor Workstation Design,Equipment Not Guarded,Equipment Repair Deficient,Lack of Preventative Maintenance,Employee Lack of Knowledge,Equipment/Process Failure,Inadequate Inspection Timelines"  delimiter="'"/>
                            </td>
                        </tr>
                    </table>
                </td>
           </tr>
           <tr>
           		<td colspan="2">
                	<f:TextArea name="RootCauseStatement" label="Final Root Cause Analysis Statement" value="#qIR.RootCauseStatement#" class="span11" rows="4"/>
                </td>
           </tr>
        </table>
        </div>
        <div id="#Id4#" <cfif url.id neq 0>style="height:320px;"</cfif>>
            <table width="100%">
            	<tr class="vert-div" >
                	<td colspan="2" align="left" class="alert alert-primary">
                    FURTHER PREVENTIVE/CORRECTIVE ACTIONS, REVIEW AND APPROVAL <br>
                    <small><strong>CORRECTIVE ACTION  </strong>(To Be Completed By HSE Supervisor / Responsible Personnel Supervisor or Investigation Team and approved by Responsible HOD)</small></td>
                </tr>
                <tr>
                	<td colspan="2">
                    	<cfquery name="qOI_">
                            SELECT * FROM incident_corrective_action
                            WHERE IncidentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
                        </cfquery>
                    	<cfquery name="qU">
                            SELECT UserId, CONCAT(Surname," ",OtherNames) AS Names FROM core_user
                            WHERE Approved = <cfqueryparam cfsqltype="cf_sql_varchar" value="Yes"/>
                        </cfquery>
                        <et:Table allowInput height="100%" id="CorrectiveId">
                            <et:Headers>
                                <et:Header title="Action Item Description" size="4" type="text" />
                                <et:Header title="Person Reponsible" size="3" type="int">
                                    <et:Select ListValue="#Valuelist(qU.UserId,'`')#" ListDisplay="#Valuelist(qU.Names,'`')#" delimiters="`"/>
                                </et:Header>
                                <et:Header title="Completion Date" size="2" type="date" hint="D/M/YYYY"/>
                                <et:Header title="Status" size="1" type="text">
                                    <et:Select ListValue="Open,Close"/>
                                </et:Header>
                                <et:Header title="" size="1"/>
                            </et:Headers>
                           <et:Content Query="#qOI_#" Columns="ActionItemDescription,PersonelResponsibleId,CompletionDate,Status" type="text,int-select,date,text" PKField="CorrectiveId"/>
                        </et:Table>
                    </td>
                </tr>
                <tr>
                	<td valign="top" width="50%">
                    	<br/>
                        <table width="100%">
                        	<tr>
                            	<td width="45%" valign="top">
                                    <div class="alert alert-info">Attached Document(s).</div>
                                    <u:UploadFile id="Attachments" table="incident_report" pk="#url.id#" />
                                </td>
                            	<td width="30%" valign="top" class="horz-div">
                                    <cfquery name="qI_">
                                        SELECT * FROM incident_investigation_team
                                        WHERE IncidentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
                                    </cfquery>
                                    
                                    <div class="alert alert-info">Investigation Team</div>
                                    
                                    <et:Table allowInput height="100%" id="incidentinvestigationteam">
                                        <et:Headers>
                                            <et:Header title="Name(s)" size="10" type="int">
                                                <et:Select ListValue="#Valuelist(qU.UserId,'`')#" ListDisplay="#Valuelist(qU.Names,'`')#" delimiters="`"/>
                                            </et:Header>
                                            <et:Header title="" size="1"/>
                                        </et:Headers>
                                       <et:Content Query="#qI_#" Columns="InvestigatorId" type="int-select" PKField="IncidentId"/>
                                    </et:Table>
                                </td>
                            	<td width="25%" class="horz-div">
                                	<div class="alert alert-info">Hse Ms Elements Involved </div>
                                    <f:CheckBox selected="#qIR.ElementInvolved#" label=" "    width="auto" height="auto" style="margin-left:5px !important" name="ElementInvolved" ListValue="1. Leadership & Commitment,2. Policy & Strategic objectives,3.Organisation. resources and documentation,4. Evaluation & risk reduction measures,5. Planning,6. Implementation and Monitoring,7. Auditing & Reviewing"  />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
        	</table>
        </div>
        
        <div id="#Id5#" <cfif url.id neq 0>style="height:auto;"</cfif>>
        	<table width="100%">
            	<tr>
                	<td colspan="2">
                        <div class="alert alert-primary">
                            Authorized signatures from incident report creator and field superintendent
                        </div>
                    </td>
                </tr>
                <cfquery name="qPA">
                    SELECT UserId,concat(Surname, " ", OtherNames) as Names, Email FROM core_user
                </cfquery>
                <cfquery name="qFS">
                    SELECT
                    cu.UserId, concat(Surname, " ", OtherNames) as Names
                    FROM core_user AS cu
                    INNER JOIN core_login AS cl ON cl.UserId = cu.UserId
                    WHERE cl.Role = <cfqueryparam cfsqltype="cf_sql_varchar" value="FS"/>
                </cfquery>
                <tr>
                	<td valign="top" class="span6">
    					
                        <f:Select name="PerformingAuthorityId" autoselect label="Performing Authority" ListValue="#Valuelist(qPA.UserId,'`')#" ListDisplay="#Valuelist(qPA.Names,'`')#" class="span11" Selected="#qIR.PerformingAuthorityId#" delimiters="`"/>
                  		<f:TextArea name="PerformingAuthorityComment" label="Performing Authority Comment" value="#qIR.PerformingAuthorityComment#" class="span11" rows="3"/>
                    </td>
                	<td valign="top" class="horz-div">
                        <cfif (request.userinfo.role eq "FS") && (qIR.FSAuthorityId eq "")>
                            <f:Select name="FSAuthorityId" autoselect label="FS Authority" ListValue="#Valuelist(qFS.UserId,'`')#" ListDisplay="#Valuelist(qFS.Names,'`')#" class="span11" Selected="#qIR.FSAuthorityId#" delimiters="`"/>
                            <f:TextArea name="FSComment" label="FS Comment" value="#qIR.FSComment#" class="span11" rows="3"/>
                        </cfif>
                        <cfif request.userinfo.role neq "FS">
                        	<cfif val(qIR.FSAuthorityId)>
                            	<cfquery name="q">
                                	SELECT CONCAT(Surname,' ',OtherNames) AS Names FROM
                                    core_user WHERE UserId = #qIR.FSAuthorityId#
                                </cfquery>	
                                <f:label name="Authorised By"  value="#q.Names#"/>
                            <cfelse>
                            	<f:label name="Not Yet Authorised By FS"  value="  "/>
                            </cfif>
                        </cfif>
                    </td>
                </tr>
            </table>
        </div>

        <nt:NavTab renderTo="#icId#">
        <nt:Tab>
            <nt:Item title="NOTIFICATION" isactive/>
            <nt:Item title="INJURY DETAILS"/>
            <nt:Item title="CLASSIFICATION & INVESTIGATION" />
            <nt:Item title="FURTHER PREVENTIVE/CORRE..."/>
            <nt:Item title="APPROVAL"/>
        </nt:Tab>
        <nt:Content>
            <nt:Item id="#Id1#"  isactive/>
            <nt:Item id="#Id2#"/>
            <nt:Item id="#Id3#"/>
            <nt:Item id="#Id4#"/>
            <nt:Item id="#Id5#"/>
        </nt:Content>
        </nt:NavTab>

		<cfif url.id eq 0>
            <f:ButtonGroup>
                <f:Button value="Create new Incident Report" class="btn-primary" IsSave subpageId="save_permit" ReloadURL="modules/maintenance/incident_report/save_incident.cfm"/>
            </f:ButtonGroup>
        </cfif>
    </f:Form>
<script>

</script>
<script>
	function #icId#changePT(d)	{
		var ic_ = $("#icId#ic");
		if(d.value == 'Applicable')	{
		 	ic_.setStyle('display','block');
		}
		else	{
		 	ic_.setStyle('display','none');
		}
	}
</script>
</cfoutput>
