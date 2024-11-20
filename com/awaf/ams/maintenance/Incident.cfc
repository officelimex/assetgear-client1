<cfcomponent>
	<cffunction name="init" access="public" returntype="Incident">

		<cfset this.ALL_INCIDENT = '

		'/>

		<cfset this.ALL_INCIDENT_COUNT = '

		'/>

    <cfreturn this/>
	</cffunction>

    <cffunction name="SaveIncideReport" access="public" returntype="numeric" output="true">
    	<cfargument name="form" type="struct" required="yes" hint="Incident Report"/>
		<cfif form.InjustDetailApplicable eq "">
        	<cfset form.InjustDetailApplicable = "NotApplicable"/>
        </cfif>
        <cfif form.ReportTime eq "">
        	<cfset form.ReportTime = now()/>
        </cfif>
        <cfparam name="form.FSAuthorityId" default="" />
        <cfparam name="form.FSComment" default="" />

  		<cftransaction action="begin">
            <cfquery result="rt">
                <cfif form.id eq 0>
                    INSERT INTO
                <cfelse>
                    UPDATE
                </cfif>
                incident_report SET
					<!---Tab 1--->
                    ReportTime = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateFormat(form.ReportTime,'yyyy/mm/dd')# #TimeFormat(form.ReportTime,'HH:MM')#"/>,
                    Title=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Title#"/>,
                    Description=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Description#"/>,
                    ActionTaken=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ActionTaken#"/>,
                    NotifyMng=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NotifyMng#"/>,
                    NotifyGov=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NotifyGov#"/>,
                    NotificationSpecify=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NotificationSpecify#"/>,
                    IsWorkRelated=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.IsWorkRelated#"/>,
                    IfNo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.IfNo#"/>,
                    IncidentType=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.IncidentType#"/>,
                    OccurredLocation=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OccurredLocation#"/>,
                    OccurredAddress=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OccurredAddress#"/>,
                    AffectedParty=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AffectedParty#"/>,
                    AffectedPersonel=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AffectedPersonel#"/>,
                    OtherAffectedPersonel=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OtherAffectedPersonel#"/>,
                    IncidentAgent=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.IncidentAgent#"/>,
                    OtherAgents=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OtherAgents#"/>,
                    <!---Tab 2--->
                    ReportingPersonelId=<cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.userid#"/>,
                    InjustDetailApplicable=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.InjustDetailApplicable#"/>,
                    <!---Tab 3--->
                    ASeverityPeople=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ASeverityPeople#"/>,
                    ASeverityEnvironment=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ASeverityEnvironment#"/>,
                    ASeverityAsset=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ASeverityAsset#"/>,
                    ASeverityReputation=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ASeverityReputation#"/>,
                    PSeverityPeople=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PSeverityPeople#"/>,
                    PSeverityEnvironment=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PSeverityEnvironment#"/>,
                    PSeverityAsset=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PSeverityAsset#"/>,
                    PSeverityReputation=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PSeverityReputation#"/>,
                    PhysicalInvestigation=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PhysicalInvestigation#"/>,
                    Witnesses=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Witnesses#"/>,
                    Paper=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Paper#"/>,
                    MajorCauses=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MajorCauses#"/>,
                    Policy=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Policy#"/>,
                    Communication=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Communication#"/>,
                    Hazard=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Hazard#"/>,
                    BloodBorne=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.BloodBorne#"/>,
                    ProductivityFactors=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ProductivityFactors#"/>,
                    WorkBehaviour=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.WorkBehaviour#"/>,
                    Training=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Training#"/>,
                    Environment=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Environment#"/>,
                    PPE=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PPE#"/>,
                    Facility=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Facility#"/>,
                    RootCauseStatement=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RootCauseStatement#"/>,
                    ElementInvolved=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ElementInvolved#"/>,

                    <cfif form.id EQ 0>
                    	CreatedById=<cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.userid#"/>,
                    </cfif>

                    PerformingAuthorityId=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.PerformingAuthorityId#"/>,
                    PerformingAuthorityComment=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PerformingAuthorityComment#"/>,
                    FSAuthorityId=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.FSAuthorityId#"/>,
                    FSComment=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FSComment#"/>,
										<cfif PerformingAuthorityId neq "">
											PADate = <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(now(),'yyyy/mm/dd')#"/>,
										</cfif>
										<cfif FSAuthorityId neq "">
											AuthorizedDate  = <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(now(),'yyyy/mm/dd')#"/>,
										</cfif>
                    CreatedDate=<cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(now(),'yyyy/mm/dd')#"/>

			  <cfif form.id != 0>
          WHERE IncidentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#"/>
        </cfif>
						</cfquery>
						<cfset _new = false/>
						<cfif form.id == 0>
							<cfset _new = true/>
              <cfset form.id = rt.GENERATED_KEY/>
            </cfif>
            <!---Save Incident Injury Details--->
            <cfif form.InjustDetailApplicable eq "Applicable">
                <cfquery name="q" result="rt">
                    SELECT * FROM incident_injury_details
                    WHERE IncidentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#"/>
                </cfquery>
                <cfquery>
                    <cfif rt.recordcount gt 0 >
                        UPDATE
                     <cfelse>
                        INSERT INTO
                    </cfif>
                    incident_injury_details SET
                    IncidentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#"/>,
                    InjuredNames=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.InjuredNames#"/>,
                    ResidentAddress=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ResidentAddress#"/>,
                    Gender=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Gender#"/>,
                    Occupation=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Occupation#"/>,
                    DOB=<cfqueryparam cfsqltype="cf_sql_date" value="#form.DOB#"/>,
                    DateHired=<cfqueryparam cfsqltype="cf_sql_date" value="#form.DateHired#"/>,
                    NotificationDate=<cfqueryparam cfsqltype="cf_sql_date" value="#form.NotificationDate#"/>,
                   <!--- EmployementCategory=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EmployementCategory#"/>,--->
                    JobDuration=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.JobDuration#"/>,
                    EmployeeProject=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EmployeeProject#"/>,
                    EmployeeHomeOffice=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EmployeeHomeOffice#"/>,
                    InjuryType=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.InjuryType#"/>,
                    NatureofInjury=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NatureofInjury#"/>,
                    InjuredBodyPart=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.InjuredBodyPart#"/>,
                    ActivityBeforeInjury=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ActivityBeforeInjury#"/>,
                    InjuryEvent=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.InjuryEvent#"/>,
                    InjuryObject=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.InjuryObject#"/>,
                    TreatmentLocation=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TreatmentLocation#"/>,
                    TreatmentProvider=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TreatmentProvider#"/>,
                    TreatmentGiven=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TreatmentGiven#"/>,
                    ReturnToWork=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ReturnToWork#"/>,
                    ReturnComment=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ReturnComment#"/>
                    <cfif rt.RecordCount gt 0>
                        WHERE IncidentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#"/>
                    </cfif>

                </cfquery>
            <cfelse>
            	<cfquery>
                	DELETE FROM incident_injury_details WHERE IncidentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#"/>
                </cfquery>
            </cfif>


					<cfparam name="form.incidentinvestigationteam" default=""/>
					<cfparam name="form.CorrectiveId" default=""/>
					<cfparam name="form.Attachments" default=""/>
					<cfset h = createobject('component','assetgear.com.awaf.util.helper').Init()/>
					<cfset f = CreateObject("component","assetgear.com.awaf.util.file").init()/>
					<cfset h.SaveFromTempTable(form.incidentinvestigationteam,
						"incident_investigation_team",
						"InvestigatorId",
						"int0",
						"TeamId","IncidentId",form.id)/>
					<cfset h.SaveFromTempTable(form.CorrectiveId,
						"incident_corrective_action",
						"ActionItemDescription,PersonelResponsibleId,CompletionDate,Status",
						"text0,int0,date0,text1",
						"CorrectiveId","IncidentId",form.id)/>
					<cfif form.Attachments neq "">
						<cfset s_path = form.AttachmentsSource & "/" & form.Attachments />
						<cfset d_path = form.AttachmentsDestination & "/incident_report/" & form.id & "/" />
						<cfset f.Move('incident_report',form.id,'a',s_path,d_path)/>
					</cfif>
						
					<cfif _new>

						<cfquery name="q">
							SELECT Email FROM core_user WHERE UserId IN (#val(form.PerformingAuthorityId)#)
						</cfquery> 
						<cfset nemail = q.columnData("Email").toList()/>
						<cfquery name="q">
							SELECT u.Email FROM incident_investigation_team t
							INNER JOIN core_user u ON u.UserId = t.InvestigatorId
							WHERE IncidentId = #form.Id#
						</cfquery>
						<cfset nemail = listAppend(nemail, q.columnData("Email").toList())/>

						<cfset application.com.Notice.SendEmail(
							"hse@#application.domain#,fieldsuperintendent@#application.domain#,adexfe@live.com,#nemail#","New Incident Report",
							"New Incident Report ## #form.Id#",
							"
								Hello, 
								<p>This is to notify you that a new Incident report has been created titled:<br/>
								#form.Title#<br/>
								</p> <br/>
								Thank you
						")/>

					</cfif>

        </cftransaction>

        <cfreturn form.id/>
        </cffunction>
            <cffunction name="GetIncidentReport" returntype="query" access="public">
            <cfargument name="inid" type="numeric" required="true" hint="Incident Report Id"/>
            <cfset var qL = ""/>
            <cfquery name="qL" cachedwithin="#createTime(1,0,0)#">
                SELECT * FROM incident_report ir
                WHERE ir.IncidentId = <cfqueryparam value="#arguments.inid#" cfsqltype="CF_SQL_INTEGER"/>
            </cfquery>

            <cfreturn qL/>
        </cffunction>



</cfcomponent>
