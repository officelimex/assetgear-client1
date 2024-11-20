<cfcomponent >

	<cffunction name="init" access="public" returntype="PMTask">

		<cfset this.PM_TASK_SQL = '
			SELECT
				pm.*,
				a.Description Asset, a.AssetId, a.Status,
				f.Description Frequency,
				rt.Type ReadingType,
				CONCAT(l.Name, " ", IFNULL(al.LocDescription,"")) Location,
        u.Name Unit,
				al.AssetLocationId
			FROM
				pm_task pm
			INNER JOIN asset_location al ON al.AssetLocationId = pm.AssetLocationId
			INNER JOIN location l ON l.LocationId = al.LocationId
			INNER JOIN asset a ON a.AssetId = al.AssetId
			LEFT JOIN frequency f ON pm.FrequencyId = f.FrequencyId
      LEFT JOIN core_unit u ON pm.UnitId = u.UnitId
			LEFT JOIN reading_type rt ON pm.ReadingTypeId = rt.ReadingTypeId
		'/>

		<cfset this.PM_TASK_COUNT_SQL = '
			SELECT
				COUNT(pm.PMTaskId) c
			FROM
				pm_task pm
			INNER JOIN asset_location al ON al.AssetLocationId = pm.AssetLocationId
			INNER JOIN location l ON l.LocationId = al.LocationId
			INNER JOIN asset a ON a.AssetId = al.AssetId
			LEFT JOIN frequency f ON pm.FrequencyId = f.FrequencyId
			LEFT JOIN reading_type rt ON pm.ReadingTypeId = rt.ReadingTypeId
		'/>

        <cfreturn this/>
	</cffunction>

    <cffunction name="GetPMTask" access="public" returntype="query">
    	<cfargument name="id" type="numeric" required="yes"/>

        <cfquery name="qP">
        	#this.PM_TASK_SQL#
            WHERE pm.PMTaskId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#"/>
        </cfquery>

        <cfreturn qP/>
    </cffunction>

    <cffunction name="GetAllActivePMTask" returntype="query" access="public">

    	<cfquery name="qP" cachedwithin="#createTime(1,0,0)#">
    		#this.PM_TASK_SQL#
    		WHERE pm.IsActive = "yes" -- AND pm.StartTime IS NOT NULL
    	</cfquery>

    	<cfreturn qP/>
    </cffunction>

    <cffunction name="GenerateWorkOrder" returntype="void" output="false" access="public" hint="run the pm task and generate work order">

			<cfset oW = createObject("component","assetgear.com.awaf.ams.maintenance.WorkOrder").init()/>
			<cfset qry = createObject("component", "assetgear.com.awaf.util.aQuery").Init()/>

    	<!--- get all active pm task --->
    	<cfset qPMTask = GetAllActivePMTask()/>

    	<cfloop query="qPMTask">

				<!--- get the last work order for this task --->
				<cfset qLastOpened = oW.GetLastOpenWorkOrder(qPMTask.PMTaskId)/>
				<cfset qWO  = oW.GetLastWorkOrder(qPMTask.PMTaskId)/>
				<cfset qLastClosed  = oW.GetLastClosedWorkOrder(qPMTask.PMTaskId)/>


				<cfset sWO = qry.QueryToStruct(qLastOpened)/>
				<cfset sWO.Id = 0/>
				<cfset sWO.DateClosed = ""/>
				<cfset sWO.AssetLocationIds = qPMTask.AssetLocationId/>
				<cfset sWO.AssetId = qPMTask.AssetId/>
				<cfset sWO.WorkClassId = 10/>
				<cfset sWO.DepartmentId = qPMTask.DepartmentId/>
				<cfset sWO.UnitId = qPMTask.UnitId/>
				<cfset sWO.Description = qPMTask.Description/>
				<cfset sWO.WorkDetails = qPMTask.TaskDetails/>
				<cfset sWO.PMTaskId = qPMTask.PMTaskId/>
				<cfset sWO.Status = "Open"/>
 
				<cfswitch expression="#qPMTask.Type#">
					<!--- for days based task --->
					<cfcase  value="d">
							<cfif !qLastOpened.recordcount>
								<cfif isdate(qLastClosed.DateClosed)>
									<cfset dateclosed = DateFormat(qLastClosed.DateClosed, "yyyy-mm-dd")/>
								<cfelse>
									<cfset dateclosed = DateFormat(qPMTask.StartTime, "yyyy-mm-dd")/>
								</cfif>
								<cfif isDate(dateclosed)>
									<cfset sWO.DateOpened = AddDateByFrequency(dateclosed, qPMTask.FrequencyId)/>
									<!--- create work order --->
									<cfset oW.SaveWorkOrder(sWO)/>
								</cfif>
							</cfif>
					</cfcase>
					<!--- for milestone reading --->
					<cfcase value="m">
							<!--- check if the milestone table is upto what the pmtask stated --->
							<cfquery name="qMT">
								SELECT * FROM pm_milestone
								WHERE PMTaskId = <cfqueryparam cfsqltype="cf_sql_integer" value="#qPMTask.PMtaskId#"/>
							</cfquery>
							
							<cfif qMT.Reading GTE qPMTask.Milestone>
									<cfset sWO.DateOpened = now()/>
									<cfif qWO.Status EQ "Close">
											<!--- create wo ---->
											<cfset oW.SaveWorkOrder(sWO)/>
									<cfelseif !qWO.RecordCount><!--- if the wo is empty create new one using the start time on the pm --->
											<cfset oW.SaveWorkOrder(sWO)/>
									</cfif>
									<cfquery>
										UPDATE pm_milestone SET
											Reading = #val(qMT.Reading-qPMTask.Milestone)#
										WHERE MilestoneId = <cfqueryparam cfsqltype="cf_sql_integer" value="#qMT.MilestoneId#"/>
									</cfquery>
							</cfif>
					</cfcase>
				</cfswitch>
    	</cfloop>

      <cfobjectcache action="clear"/>
    </cffunction>

    <cffunction name="AddDate" returntype="date" access="public" hint="add two dates together with a dynamic frequency">
        <cfargument name="d1" required="yes" type="date" hint="date to add">
        <cfargument name="fy" required="yes" type="numeric" hint="year">
        <cfargument name="fq" required="yes" type="numeric" hint="Quarters">
        <cfargument name="fm" required="yes" type="numeric" hint="months">
        <cfargument name="fw" required="yes" type="numeric" hint="weeks">
        <cfargument name="fd" required="yes" type="numeric" hint="days">
        <cfargument name="fh" required="yes" type="numeric" hint="hours">
        <cfargument name="fn" required="yes" type="numeric" hint="mminutes">

        <cfset stemp = arguments.d1>

        <cfset stemp = dateAdd('n',arguments.fn,stemp) />
        <cfset stemp = dateAdd('h',arguments.fh,stemp) />
        <cfset stemp = dateAdd('d',arguments.fd,stemp) />
        <cfset stemp = dateAdd('ww',arguments.fw,stemp) />
        <cfset stemp = dateAdd('m',arguments.fm,stemp) />
        <cfset stemp = dateAdd('q',arguments.fq,stemp) />
        <cfset stemp = dateAdd('yyyy',arguments.fy,stemp) />

        <cfset stemp  = dateformat(stemp,'yyyy/mm/dd') & " " & timeformat(stemp,'hh:mm:ss tt')/>
        <cfreturn stemp/>
    </cffunction>

    <cffunction name="AddDateByFrequency" returntype="any" access="public" hint="add two dates together with a dynamic frequency">
        <cfargument name="d1" required="yes" type="date" hint="date to add">
        <cfargument name="fid" required="yes" type="numeric" hint="frequency id">

        <cfquery name="qF">
            SELECT * FROM `frequency`
            WHERE `FrequencyId` = <cfqueryparam value="#arguments.fid#" cfsqltype="cf_sql_integer">
        </cfquery>

        <cfset ndate = AddDate(arguments.d1,qF.Years,qF.Quarters,qF.Months,qF.Weeks,qF.Days,qF.Hours,qF.Minutes)/>
        <cfif qF.WorkingDaysOnly eq "yes">
        	<cfset day_ = DayOfWeekAsString(DayOfWeek(ndate))/>
            <cfswitch expression="#day_#">
            	<cfcase value="Sunday">
                	<cfset ndate = dateadd('d',ndate,1)/>
                </cfcase>
                <cfcase value="Saturday">
                	<cfset ndate = dateadd('d',ndate,-1)/>
                </cfcase>
            </cfswitch>
        </cfif>

        <cfreturn ndate/>
    </cffunction>

    <cffunction name="SavePMTask" access="public" returntype="numeric">
        <cfargument name="pm_" required="true" hint="pm task struct data" type="struct"/>

        <cfset pm = arguments.pm_/>

        <cfif pm.Type eq "d">
            <cfset pm.ReadingTypeId = 0/>
            <cfif val(pm.FrequencyId) eq 0>
                <cfthrow  message="Please select a Frequency"/>
            </cfif>
        <cfelse>
            <cfset pm.FrequencyId = 0/>
            <cfif val(pm.ReadingTypeId) eq 0>
                <cfthrow detail="Please select a Reading type"/>
            </cfif>
        </cfif>

        <cfquery result="rt">
            <cfif pm.id eq 0>
                INSERT INTO
            <cfelse>
                UPDATE
            </cfif>
                `pm_task` SET
                `AssetLocationId` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pm.AssetLocationId#"/>,
                `RequireShortdown` = <cfqueryparam cfsqltype="cf_sql_char" maxlength="3" value="#pm.RequireShortdown#"/>,
                `DepartmentId` = <cfqueryparam cfsqltype="cf_sql_idstamp" value="#pm.DepartmentId#"/>,
					<cfif val(pm.UnitId)>
						`UnitId` = <cfqueryparam cfsqltype="cf_sql_idstamp" value="#val(pm.UnitId)#"/>,
					</cfif>
                `Description` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pm.Description#"/>,
                `TaskDetails` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pm.TaskDetails#"/>,
					<cfif pm.FrequencyId>
               	`FrequencyId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#pm.FrequencyId#"/>,
					</cfif>
					 `StartTime` = <cfqueryparam cfsqltype="cf_sql_date" value="#pm.StartTime#"/>,
                `IsActive` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pm.IsActive#"/>,
					<cfif pm.ReadingTypeId>
               	`ReadingTypeId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#pm.ReadingTypeId#"/>,
					</cfif>
                `Milestone` = <cfqueryparam cfsqltype="cf_sql_float" value="#pm.Milestone#"/>,
                `NotifyBefore` = <cfqueryparam cfsqltype="cf_sql_float" value="#val(pm.NotifyBefore)#"/>,
                `Type` = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="1" value="#pm.Type#"/>,
                `Note` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pm.Note#"/>
            <cfif pm.id neq 0>
                WHERE `PMTaskId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#pm.id#">
            </cfif>
        </cfquery>

        <cfset pmid = pm.id/>
        <cfif pm.id eq 0>
            <cfset pmid = rt.GENERATED_KEY/>
        </cfif>
        <cfreturn pmid/>
    </cffunction>
</cfcomponent>
