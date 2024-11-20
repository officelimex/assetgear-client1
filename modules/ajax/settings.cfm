<cfoutput>

<cfswitch expression="#url.cmd#">
    <!---getCompany--->
    <cfcase value="getCompany">
        <cfset start = (url.page * url.perpage) - (url.perpage)/>

        <cfquery name="q" cachedwithin="#CreateTime(0,0,0)#">
            SELECT *
            FROM core_company
			<cfif structkeyexists(url,'keyword')>
                WHERE (#url.Field# LIKE "%#url.keyword#%")
            </cfif>
            ORDER BY #url.sort# #url.sortOrder#
            LIMIT #start#,#url.perpage#
        </cfquery>
        <cfquery name="qT">
            SELECT count(*) c
            FROM core_company
			<cfif structkeyexists(url,'keyword')>
                WHERE (#url.Field# LIKE "%#url.keyword#%")
            </cfif>
        </cfquery>
        <cfoutput>
        {"total": #qT.c#,
            "page": #url.page#,
            "rows":[<cfloop query="q">
                [#q.CompanyId#,#serializeJSON(q.Name)#,#serializeJSON(q.Description)#,#serializeJSON(q.Address)#]
                 <cfif q.recordcount neq q.currentrow>,</cfif>
            </cfloop>]}
        </cfoutput>
    </cfcase>

	<!--- USE Users --->
    <cfcase value="getUsers">
    	<cfparam name="url.cid" default=""/>
        <cfset start = (url.page * url.perpage) - (url.perpage)/>

        <cfquery name="q" cachedwithin="#CreateTime(0,0,0)#">
					#application.com.User.SQL_USER#
					<cfif url.cid neq "" >
						WHERE u.CompanyId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cid#">
						<cfif structkeyexists(url,'keyword')>
							AND #url.Field# LIKE "%#url.keyword#%"
						</cfif>
					<cfelse>
						<cfif structkeyexists(url,'keyword')>
							WHERE  #url.Field# LIKE "%#url.keyword#%"
						</cfif>
					</cfif>
					ORDER BY d.`Name` DESC
					LIMIT #start#,#url.perpage#
        </cfquery>

        <cfquery name="qT">
					SELECT
						count(*) c
					FROM core_user u
					INNER JOIN core_department d ON u.DepartmentId = d.DepartmentId
					INNER JOIN core_company cc ON u.CompanyId = cc.CompanyId

					<cfif structkeyexists(url,'keyword')>
						WHERE #url.Field# LIKE "%#url.keyword#%"
						<cfif structkeyexists(url,'keyword')>
							AND #url.Field# LIKE "%#url.keyword#%"
						<cfelse>
							<cfif structkeyexists(url,'keyword')>
								WHERE  #url.Field# LIKE "%#url.keyword#%"
							</cfif>
						</cfif>
					</cfif>
        </cfquery>
        {"total": #qT.c#,
            "page": #url.page#,
            "rows":[<cfloop query="q">[#q.UserId#,#serializeJSON(q.UserName)#,#serializeJSON(q.Surname)#,#serializeJSON(q.OtherNames)#,#serializeJSON(q.Email)#,#serializeJSON(q.Company)#,#serializeJSON(q.DepartmentName)#]
                 <cfif q.recordcount neq q.currentrow>,</cfif>
            </cfloop>]}

    </cfcase>


    <!--- Get Location --->
    <cfcase value="getLocation">
        <cfset start = (url.page * url.perpage) - (url.perpage)/>

        <cfquery name="q" cachedwithin="#CreateTime(0,0,0)#">
            #application.com.User.SQL_LOCATION# 
            <cfif structkeyexists(url,'keyword')>
				WHERE (l.#url.Field# LIKE "%#url.keyword#%")
			</cfif>
            ORDER BY #url.sort# #url.sortOrder#
            LIMIT #start#,#url.perpage#
        </cfquery>
        <cfquery name="qT">
            #application.com.User.SQL_LOCATION_COUNT#
            <cfif structkeyexists(url,'keyword')>
				WHERE (l.#url.Field# LIKE "%#url.keyword#%")
			</cfif>
        </cfquery>
        <cfoutput>
        {"total": #qT.c#,
            "page": #url.page#,
            "rows":[<cfloop query="q">
                [#q.LocationId#,#serializeJSON(q.Name)#]

				<!--- get category 
                <cfquery name="qSL" cachedwithin="#CreateTime(0,0,0)#">
                    SELECT * FROM location WHERE ParentLocationId = #q.LocationId#
                </cfquery>
                <cfloop query="qSL">
                    ,[#qSL.LocationId#,#serializeJSON("&nbsp;&nbsp;&nbsp;&nbsp;&mdash;&mdash;&mdash;&nbsp;&nbsp;" & qSL.Name)#]
                </cfloop>--->


                 <cfif q.recordcount neq q.currentrow>,</cfif>
            </cfloop>]}
        </cfoutput>
    </cfcase>

    <!--- Get Departments --->
    <cfcase value="getDepartments">
        <cfset start = (url.page * url.perpage) - (url.perpage)/>

        <cfquery name="q" cachedwithin="#CreateTime(0,0,0)#">
            SELECT
                *
            FROM core_department
            <cfif structkeyexists(url,'keyword')>
                WHERE (#url.Field# LIKE "%#url.keyword#%")
            </cfif>
            ORDER BY #url.sort# #url.sortOrder#
            LIMIT #start#,#url.perpage#
        </cfquery>
        <cfquery name="qT">
            SELECT count(*) c FROM core_department
            <cfif structkeyexists(url,'keyword')>
                WHERE (#url.Field# LIKE "%#url.keyword#%")
            </cfif>
        </cfquery>
        <cfoutput>
        {"total": #qT.c#,
            "page": #url.page#,
            "rows":[<cfloop query="q">
                [#q.DepartmentId#,#serializeJSON(q.Name)#,"#q.Email#"]
                 <cfif q.recordcount neq q.currentrow>,</cfif>
            </cfloop>]}
        </cfoutput>
    </cfcase>

    <!--- Get Job Class --->
    <cfcase value="getJobClass">
        <cfset start = (url.page * url.perpage) - (url.perpage)/>

        <cfquery name="q" cachedwithin="#CreateTime(0,0,0)#">
            SELECT
            *
            FROM job_class
			<cfif structkeyexists(url,'keyword')>
                WHERE (#url.Field# LIKE "%#url.keyword#%")
            </cfif>
            ORDER BY #url.sort# #url.sortOrder#
            LIMIT #start#,#url.perpage#
        </cfquery>
        <cfquery name="qT">
            SELECT count(*) c FROM job_class
            <cfif structkeyexists(url,'keyword')>
                WHERE (#url.Field# LIKE "%#url.keyword#%")
            </cfif>
        </cfquery>
        <cfoutput>
        {"total": #qT.c#,
            "page": #url.page#,
            "rows":[<cfloop query="q">
                [#q.JobClassId#,#serializeJSON(q.Code)#,#serializeJSON(q.Class)#]
                 <cfif q.recordcount neq q.currentrow>,</cfif>
            </cfloop>]}
        </cfoutput>
    </cfcase>

    <!---Get Reading Type--->
    <cfcase value="GetReadingType">
        <cfset start = (url.page * url.perpage) - (url.perpage)/>

        <cfquery name="q" cachedwithin="#CreateTime(0,0,0)#">
            SELECT
                *
            FROM reading_type
            <cfif structkeyexists(url,'keyword')>
                WHERE (#url.Field# LIKE "%#url.keyword#%")
            </cfif>
            ORDER BY #url.sort# #url.sortOrder#
            LIMIT #start#,#url.perpage#
        </cfquery>
        <cfquery name="qT">
            SELECT count(*) c FROM reading_type
            <cfif structkeyexists(url,'keyword')>
                WHERE (#url.Field# LIKE "%#url.keyword#%")
            </cfif>
        </cfquery>
        <cfoutput>
        {"total": #qT.c#,
            "page": #url.page#,
            "rows":[<cfloop query="q">
                [#q.ReadingTypeId#,#serializeJSON(q.Code)#,#serializeJSON(q.Type)#]
                 <cfif q.recordcount neq q.currentrow>,</cfif>
            </cfloop>]}
        </cfoutput>
    </cfcase>

    <!---Get Shelf Location--->
    <cfcase value="getShelfLocation">
        <cfset start = (url.page * url.perpage) - (url.perpage)/>

        <cfquery name="q" cachedwithin="#CreateTime(0,0,0)#">
            SELECT
                *
            FROM shelf_location
            <cfif structkeyexists(url,'keyword')>
                WHERE (#url.Field# LIKE "%#url.keyword#%")
            </cfif>
            ORDER BY #url.sort# #url.sortOrder#
            LIMIT #start#,#url.perpage#
        </cfquery>
        <cfquery name="qT">
            SELECT count(*) c FROM shelf_location
            <cfif structkeyexists(url,'keyword')>
                WHERE (#url.Field# LIKE "%#url.keyword#%")
            </cfif>
        </cfquery>
        <cfoutput>
        {"total": #qT.c#,
            "page": #url.page#,
            "rows":[<cfloop query="q">
                [#q.ShelfLocationId#,#serializeJSON(q.Code)#]
                 <cfif q.recordcount neq q.currentrow>,</cfif>
            </cfloop>]}
        </cfoutput>
    </cfcase>

    <!--- Get Units --->
    <cfcase value="getUnits">
        <cfset start = (url.page * url.perpage) - (url.perpage)/>

        <cfquery name="q" cachedwithin="#CreateTime(0,0,0)#">
            SELECT
            	cu.UnitId,cu.Name,cu.DepartmentId,
            	cd.Name Department
            FROM core_unit cu
            Inner Join core_department cd ON cu.DepartmentId = cd.DepartmentId
            <cfif structkeyexists(url,'keyword')>
                WHERE (#url.Field# LIKE "%#url.keyword#%")
            </cfif>
            ORDER BY #url.sort# #url.sortOrder#
            LIMIT #start#,#url.perpage#
        </cfquery>
        <cfquery name="qT">
            SELECT count(*) c FROM core_unit cu Inner Join core_department cd ON cu.DepartmentId = cd.DepartmentId
            <cfif structkeyexists(url,'keyword')>
                WHERE (#url.Field# LIKE "%#url.keyword#%")
            </cfif>
        </cfquery>
        <cfoutput>
        {"total": #qT.c#,
            "page": #url.page#,
            "rows":[<cfloop query="q">
                [#q.UnitId#,#serializeJSON(q.Name)#,#serializeJSON(q.Department)#,#q.DepartmentId#]
                 <cfif q.recordcount neq q.currentrow>,</cfif>
            </cfloop>]}
        </cfoutput>
    </cfcase>

    <!---getUnitOfMeasurement--->
    <cfcase value="getUnitOfMeasurement">
        <cfset start = (url.page * url.perpage) - (url.perpage)/>

        <cfquery name="q" cachedwithin="#CreateTime(0,0,0)#">
            SELECT
            *
            FROM um
            <cfif structkeyexists(url,'keyword')>
                WHERE (#url.Field# LIKE "%#url.keyword#%")
            </cfif>
            ORDER BY #url.sort# #url.sortOrder#
            LIMIT #start#,#url.perpage#
        </cfquery>
        <cfquery name="qT">
            SELECT count(*) c FROM um
            <cfif structkeyexists(url,'keyword')>
                WHERE (#url.Field# LIKE "%#url.keyword#%")
            </cfif>
        </cfquery>
        <cfoutput>
        {"total": #qT.c#,
            "page": #url.page#,
            "rows":[<cfloop query="q">
                [#q.UMId#,#serializeJSON(q.Code)#,#serializeJSON(q.Title)#]
                 <cfif q.recordcount neq q.currentrow>,</cfif>
            </cfloop>]}
        </cfoutput>
    </cfcase>

    <!---getShipmentMode--->
    <cfcase value="getShipmentMode">
        <cfset start = (url.page * url.perpage) - (url.perpage)/>

        <cfquery name="q" cachedwithin="#CreateTime(0,0,0)#">
            SELECT
            *
            FROM shipment_mode
            <cfif structkeyexists(url,'keyword')>
                WHERE (#url.Field# LIKE "%#url.keyword#%")
            </cfif>
            ORDER BY #url.sort# #url.sortOrder#
            LIMIT #start#,#url.perpage#
        </cfquery>
        <cfquery name="qT">
            SELECT count(*) c FROM shipment_mode
            <cfif structkeyexists(url,'keyword')>
                WHERE (#url.Field# LIKE "%#url.keyword#%")
            </cfif>
        </cfquery>
        <cfoutput>
        {"total": #qT.c#,
            "page": #url.page#,
            "rows":[<cfloop query="q">
                [#q.ShipmentModeId#,#serializeJSON(q.Mode)#,#q.Days#]
                 <cfif q.recordcount neq q.currentrow>,</cfif>
            </cfloop>]}
        </cfoutput>
    </cfcase>

    <!---Save Department--->
    <cfcase value="SaveDepartment">
        <cfquery>
            <cfif form.id eq 0>
                INSERT INTO
            <cfelse>
                UPDATE
            </cfif>
                core_department SET
                Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Name#">,
                Email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Email#">
            <cfif form.id neq 0>
            WHERE DepartmentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#">
            </cfif>
        </cfquery>
    </cfcase>

    <!-- save user role --->
    <cfcase value="SaveUserRole">
    	<cfset form.UserId = form.Id/>
        <cfset k = application.com.User.SaveUserRole(form)/>
        New password is "#k#"
    </cfcase>

    <!---Save Company--->
    <cfcase value="SaveCompany">
        <cfquery>
            <cfif form.id eq 0>
                INSERT INTO
            <cfelse>
                UPDATE
            </cfif>
                core_company SET
                Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Name#">,
                Description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Description#">,
                Address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Address#">
            <cfif form.id neq 0>
            	WHERE CompanyId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#">
            </cfif>
        </cfquery>
    </cfcase>

    <!---Save Unit--->
    <cfcase value="SaveUnit">
        <cfquery>
            <cfif form.id eq 0>
                INSERT INTO
            <cfelse>
                UPDATE
            </cfif>
                core_unit SET
                Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Name#">,
                DepartmentId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DepartmentId#">
            <cfif form.id neq 0>
            WHERE UnitId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#">
            </cfif>
        </cfquery>
    </cfcase>

    <!---Save Job Class--->
    <cfcase value="SaveJobClass">
        <cfquery>
            <cfif form.id eq 0>
                INSERT INTO
            <cfelse>
                UPDATE
            </cfif>
                job_class SET
                COde = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Code#">,
                Class = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Class#">
            <cfif form.id neq 0>
            WHERE JobClassId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#">
            </cfif>
        </cfquery>
    </cfcase>

    <!---Save Location--->
    <cfcase value="SaveLocation">
         <cfquery>

             <cfif form.ParentLocationId eq "">
                <cfset form.ParentLocationId = 0/>
             </cfif>

			 <cfif form.id eq 0>
                 INSERT INTO
             <cfelse>
                 UPDATE
             </cfif>
             location SET
               <cfif val(form.ParentLocationId)>
                  ParentLocationId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ParentLocationId#">,
               </cfif>
                Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Name#">
              <cfif form.id neq 0>
                 WHERE LocationId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#">
              </cfif>
         </cfquery>

        <cfobjectcache action="clear"/>
    </cfcase>

    <!---Save Unit Of Measurement--->
    <cfcase value="SaveUnitOfMeasurement">
        <cfquery>
            <cfif form.id eq 0>
                INSERT INTO
            <cfelse>
                UPDATE
            </cfif>
                um SET
                Code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Code#">,
                Title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Title#">
            <cfif form.id neq 0>
            WHERE UMId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#">
            </cfif>
        </cfquery>
    </cfcase>

    <!--- Save Shipment Mode--->
    <cfcase value="SaveShipmentMode">
        <cfquery>
            <cfif form.id eq 0>
                INSERT INTO
            <cfelse>
                UPDATE
            </cfif>
                shipment_mode SET
                Mode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Mode#">,
                Days = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Days#">
            <cfif form.id neq 0>
            WHERE ShipmentModeId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#">
            </cfif>
        </cfquery>
    </cfcase>

    <!---SaveReadingType--->
    <cfcase value="SaveReadingType">
        <cfquery>
            <cfif form.id eq 0>
                INSERT INTO
            <cfelse>
                UPDATE
            </cfif>
                reading_type SET
                Code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Code#">,
                Type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Type#">
            <cfif form.id neq 0>
            WHERE ReadingTypeId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#">
            </cfif>
        </cfquery>
    </cfcase>

    <!---SaveShelfLocation--->
    <cfcase value="SaveShelfLocation">
        <cfquery>
            <cfif form.id eq 0>
                INSERT INTO
            <cfelse>
                UPDATE
            </cfif>
                shelf_location SET
                Code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Code#">
            <cfif form.id neq 0>
                WHERE ShelfLocationId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#">
            </cfif>
        </cfquery>
    </cfcase>

    <!---SaveFrequency--->
    <cfcase value="SaveFrequency">

    	<cfparam name="form.WorkingDaysOnly" default=""/>

        <cftransaction action="begin">
            <cfquery>
                <cfif form.id eq 0>
                    INSERT INTO
                <cfelse>
                    UPDATE
                </cfif>
                    frequency SET
                    Code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Code#">,
                    Description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Description#">,
                    `Years` = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Years#">,
                    `Quarters` = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Quarters#">,
                    `Months` = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Months#">,
                    `Weeks` = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Weeks#">,
                    `Days` = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Days#">,
                    `Hours` = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Hours#">,
                    `Minutes` = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Minutes#">,
                    `WorkingDaysOnly` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.WorkingDaysOnly#">
                <cfif form.id neq 0>
                    WHERE FrequencyId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#">
                </cfif>
            </cfquery>
        </cftransaction>
    </cfcase>

    <!---SaveUser--->
    <cfcase value="SaveUser">
        <cfparam name="form.Email" default=""/>
		<cfparam name="form.UnitId" default="0"/>
        <cfquery result="rt">
			<cfif form.id eq 0 >
            	INSERT INTO
            <cfelse>
            	UPDATE
            </cfif>
                core_user SET
                <cfif val(form.ManagerId)>
                    ManagerId=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.ManagerId#"/>,
                </cfif>
                <!---cfif val(form.RelieveUserId)>
                    RelieveUserId=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.RelieveUserId#"/>,                
                </cfif--->
                Position=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Position#"/>,
                OfficeLocationId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OfficeLocationId#"/>,
                DepartmentId=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.DepartmentId#"/>,
                CompanyId=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.CompanyId#"/>,
                <!---Location=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Location#"/>,--->
                PersonalEmail=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PersonalEmail#"/>,
                <cfif val(form.UnitId)>
                    UnitId=<cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.UnitId)#"/>
                <cfelse>
                    UnitId = NULL
                </cfif>,
                Surname=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Surname#"/>,
                Approved=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Approved#"/>,
            <cfif form.id eq 0 >
            	Email=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Email#"/>,
            </cfif>
            OtherNames=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OtherNames#"/>
            <cfif form.id neq 0>
           		WHERE UserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#"/>
            </cfif>
        </cfquery>
		<cfif form.id eq 0>
        	<cfset form.id = rt.GENERATED_KEY/>
        </cfif>

        <!--- signature ---->
		<cfset f = CreateObject("component","assetgear.com.awaf.util.file").init()/>
        <cfset s_path = form.PhotosSource & "/" & form.Photos />
		<cfset d_path = form.PhotosDestination & "/core_user/" & form.id & "/" />
        <cfset f.Move('core_user',form.id,'p',s_path,d_path)/>

        <cfquery name="qS">
       		SELECT UserId FROM signature WHERE UserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#"/>
        </cfquery>

        <cfquery>
			<cfif qS.UserId eq "">
            	INSERT INTO
            <cfelse>
            	UPDATE
            </cfif>
                signature SET
                UserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#"/>,
                `Height` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Height#"/>,
                `Width` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Width#"/>
            <cfif qS.UserId neq "">
           		WHERE UserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#"/>
            </cfif>
        </cfquery>

    </cfcase>

	<cfcase value="ResetPIN">

    	<cfset p = application.com.User.ResetPIN(form.id)/><!---TODO: secure the function --->
    	New PIN is #p#
    </cfcase>

</cfswitch>

</cfoutput>
