<cfoutput>
<cfswitch expression="#url.cmd#">

	<!---getAllAsset--->
	<cfcase value="getAllAsset">
    	<cfparam name="url.cid" default=""/>
    	<cfparam name="url.status" default="Online"/>

        <cfif  (url.status eq "Online")||(url.status eq "")>
            <cfset url.status = ' = "Online" '/>
        <cfelse>
            <cfset url.status = ' <> "Online" '/>
        </cfif>
        
        <cfset start = (url.page * url.perpage) - (url.perpage)/>

        <cfquery name="q" cachedwithin="#CreateTime(0,0,0)#">
            #application.com.Asset.ASSET_SQL#
            WHERE a.Status  #url.status#
				<!---<cfif (url.status eq "Online")||(url.status eq "")>
		            
		        <cfelse>
		            a.Status   <> 'Online'
		        </cfif>--->
            <cfif url.cid neq "">
                AND (a.AssetCategoryId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cid#"/>
                    OR ac.ParentAssetCategoryId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cid#"/>
                        OR ac1.AssetCategoryId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cid#"/>
                            OR  ac1.ParentAssetCategoryId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cid#"/>)
                <cfif structkeyexists(url,'keyword')>
                    AND (#url.Field# LIKE "%#url.keyword#%")
                </cfif>
            <cfelse>
				<cfif structkeyexists(url,'keyword')>
					AND (#url.Field# LIKE "%#url.keyword#%")
				</cfif>
			</cfif>
            ORDER BY #url.sort# #url.sortOrder#
            LIMIT #start#,#url.perpage#
        </cfquery>
        <cfquery name="qT">
            #application.com.Asset.ASSET_COUNT_SQL#
            WHERE   a.Status  #url.status#
            <cfif url.cid neq "">
                AND (a.AssetCategoryId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cid#"/>
                    OR ac.ParentAssetCategoryId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cid#"/>
                        OR ac1.AssetCategoryId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cid#"/>
                            OR  ac1.ParentAssetCategoryId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cid#"/>)
                <cfif structkeyexists(url,'keyword')>
                    AND (#url.Field# LIKE "%#url.keyword#%")
                </cfif>
            <cfelse>
				<cfif structkeyexists(url,'keyword')>
					AND (#url.Field# LIKE "%#url.keyword#%")
				</cfif>
            </cfif>
        </cfquery>
        <!--- get all locations first --->
        <cfset qLocations = application.com.Asset.GetAllAssetLocations()/>

        {"total": #qT.c#,
            "page": #url.page#,
            "rows":[<cfloop query="q">
                [#q.AssetId#,#serializeJSON(q.Description)#, #serializeJSON(q.AssetCategory)#,
                    <!--- get locations for this asset --->
                    <cfquery name="qAssetLoc" dbtype="query" cachedwithin="#createTime(1,0,0)#">
                        SELECT Location FROM qLocations
                        WHERE al.AssetId = <cfqueryparam value="#q.AssetId#" cfsqltype="CF_SQL_INTEGER"/>
												AND <cfif q.status eq "Online">
								            a.Status  = 'Online'
								        <cfelse>
								            a.Status   <> 'Online'
								        </cfif>
                    </cfquery>
                    <cfset nloc = ""/>
                    <cfloop query="qAssetLoc" startrow="1" endrow="3">
                        <cfset nloc = qAssetLoc.Location & ", " & nloc />
                    </cfloop>
                    <cfif qAssetLoc.Recordcount gt 3>
                        <cfset nloc = nloc & "..."/>
                    </cfif>
                    #serializeJSON(nloc)#
                ,
                	<cfswitch expression="#q.Status#">
                    	<cfcase value="Online,Transfered" delimiters=",">#serializeJSON('<span class="label label-success">' & q.Status & '</span>')#</cfcase>
                        <cfcase value="Offline">#serializeJSON('<span class="label">Offline</span>')#</cfcase>
                        <cfdefaultcase>#serializeJSON('<span class="label label-warning">' & q.Status & '</span>')#</cfdefaultcase>
                    </cfswitch>
                ]
                 <cfif q.recordcount neq q.currentrow>,</cfif>
            </cfloop>]}
    </cfcase>

	<!---getAllPMTask--->
	<cfcase value="getStopCard">
    	<cfparam name="url.cid" default=""/>
        <cfparam name="url.filter" default="d"/>
        <cfset start = (url.page * url.perpage) - (url.perpage)/>

        <cfquery name="q" cachedwithin="#CreateTime(0,0,0)#">
            SELECT
            sc.*,CONCAT(sc.ObserverSurnameName," ",sc.ObserverFirstName) AS Observer,CONCAT(IFNULL(cu.Surname,"")," ",IFNULL(cu.OtherNames,"")) AS CreatedBy, cd.`Name` AS Department
            FROM
            sop_card AS sc
            INNER JOIN core_user AS cu ON cu.UserId = sc.CreatedByUserId
            INNER JOIN core_department AS cd ON cd.DepartmentId = sc.DepartmentId
            <cfswitch expression="#url.filter#">
            	<cfcase value="d">
					<cfif request.IsHost || request.IsAdmin || (request.userinfo.role eq "HSE")>
                    	<cfif url.cid eq "">
                        	WHERE sc.DepartmentId <> 0
                        <cfelse>
                        	WHERE sc.DepartmentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cid#"/>
                        </cfif>
                    <cfelse>
                        WHERE sc.DepartmentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.departmentid#"/>
                    </cfif>
                    
					<cfif structkeyexists(url,'keyword')>
                        AND #url.Field# LIKE "%#url.keyword#%"
                    </cfif>

                </cfcase>
                <cfcase value="a">
					<cfif request.IsHost || request.IsAdmin || (request.userinfo.role eq "HSE")>
                        WHERE sc.Acts = "#url.cid#"
                    <cfelse>
                        WHERE sc.DepartmentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.departmentid#"/>
                        AND  sc.Acts = "#url.cid#"
                    </cfif>
                    
					<cfif structkeyexists(url,'keyword')>
                        AND #url.Field# LIKE "%#url.keyword#%"
                    </cfif>
                </cfcase>

            </cfswitch>
            ORDER BY #url.sort# #url.sortOrder#
            LIMIT #start#,#url.perpage#
        </cfquery>

        <!---<cfquery name="qT">
            SELECT sc.*,CONCAT(cu.Surname," ",cu.OtherNames) AS CreatedBy FROM sop_card sc
            INNER JOIN core_user cu ON cu.UserId = sc.CreatedByUserId
            <cfswitch expression="#url.filter#">
            	<cfcase value="d">
					<cfif request.IsHost || request.IsAdmin || (request.userinfo.role eq "HSE")>
                    	<cfif url.cid eq "">
                        	WHERE sc.DepartmentId <> 0
                        <cfelse>
                        	WHERE sc.DepartmentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cid#"/>
                        </cfif>
                    <cfelse>
                        WHERE sc.DepartmentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.departmentid#"/>
                    </cfif>
                    
					<cfif structkeyexists(url,'keyword')>
                        AND #url.Field# LIKE "%#url.keyword#%"
                    </cfif>

                </cfcase>
                <cfcase value="a">
					<cfif request.IsHost || request.IsAdmin || (request.userinfo.role eq "HSE")>
                    	<cfif url.cid eq "">
                        	WHERE sc.ActDetails = "#url.action#"
                        </cfif>
                    <cfelse>
                        WHERE sc.DepartmentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.departmentid#"/>
                        AND  sc.ActDetails = "#url.action#"
                    </cfif>
                    
					<cfif structkeyexists(url,'keyword')>
                        AND #url.Field# LIKE "%#url.keyword#%"
                    </cfif>
                </cfcase>

            </cfswitch>
        </cfquery>--->
        {"total": #q.recordcount#,
            "page": #url.page#,
            "rows":[<cfloop query="q">
                [#q.SOPId#,
                <cfif q.Acts eq "SafeActs">
                	"Safe Acts"
                <cfelseif q.Acts eq "UnsafeActs">
                	"Unsafe Acts"
                <cfelse>
                	"Unsafe Conditions"
                </cfif>
                ,#serializeJSON(q.Observation)#,#serializeJSON(dateformat(q.SOPDate,'dd-mm-yyyy'))#,#serializeJSON(q.Observer)#,#serializeJSON(q.CreatedBy)#,#serializeJSON(q.Department)#,#q.CreatedByUserId#
                ]
                 <cfif q.recordcount neq q.currentrow>,</cfif>
            </cfloop>]}
    </cfcase>

	<!---Save Frequency--->
    <cfcase value="SaveSOPCard">
		<cfquery>
        	<cfif form.id eq 0>
            	INSERT INTO
            <cfelse>
				UPDATE
			</cfif>
            	sop_card SET
                `Acts` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Acts#">,
                ActDetails = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ActDetails#">,
                Observation = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Observation#">,
                ImmediateAction = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ImmediateAction#">,
                FurtherCorrection = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FurtherCorrection#">,
                `ObserverFirstName` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ObserverFirstName#">,
                `ObserverSurnameName` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ObserverSurnameName#">,
                `Location` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Location#">,
                SOPDate = <cfqueryparam cfsqltype="cf_sql_date" value="#form.SOPDate#">,
                Site = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Site#">,
                <cfif form.id eq 0>
                    CreatedByUserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.userid#">,
                </cfif>
                DepartmentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DepartmentId#">
                
                
        	<cfif form.id neq 0>
				WHERE SOPId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#">
			</cfif>
		</cfquery>
	</cfcase>

    <!---SaveServiceRequest--->
    <cfcase value="SaveServiceRequest">
    	<cfparam name="form.id" default="0"/>
        <cfparam name="form.AssetLocationId" default="0"/>
        <cfset form.RequestByUserId = request.userinfo.userid/>
        <cfset id_ = form.id/>

        <cfset jrid = application.com.WorkOrder.SaveServiceRequest(form)/>

        <cfif form.ServiceType eq "MR">
			<!--- update service request item from temp data --->
            <!---  text0 - Description, float0 - unitprice, int0 - Quantity ---->
            <cfset h = createobject('component','assetgear.com.awaf.util.helper').Init()/>
            <cfset h.SaveFromTempTable(form.ServiceRequestItem,
                "service_request_item",
                "Description,UnitPrice,Quantity",
                "text0,float0,int0",
                "ServiceRequestItemId","ServiceRequestId",jrid)/>
        </cfif>

        <cfif id_ eq 0>
            Service Request was successfuly create [###jrid#]
        <cfelse>
            Service Request ###jrid# was updated
        </cfif>
	</cfcase>

    <!---getAssetCategory--->
    <cfcase value="getAssetCategory">
        <cfset start = (url.page * url.perpage) - (url.perpage)/>

        <cfquery name="q1" cachedwithin="#CreateTime(0,0,0)#">
            SELECT
                *
            FROM asset_category
            WHERE ParentAssetCategoryId IS NULL
            <cfif structkeyexists(url,'keyword')>
				AND (#url.Field# LIKE "%#url.keyword#%")
			</cfif>
        </cfquery>
        <cfquery name="qT">
            SELECT count(AssetCategoryId) c FROM asset_category
            <cfif structkeyexists(url,'keyword')>
				WHERE (#url.Field# LIKE "%#url.keyword#%")
			</cfif>
        </cfquery>
        {"total": #qT.c#,
            "page": #url.page#,
            "rows":[<cfloop query="q1">
                [#q1.AssetCategoryId#,#serializeJSON(q1.Name)#,"",""]
                <!--- get category --->
                <cfquery name="q2" cachedwithin="#CreateTime(0,0,0)#">
                    SELECT * FROM asset_category WHERE ParentAssetCategoryId = #q1.AssetCategoryId#
                </cfquery>
                <cfloop query="q2">
                    ,[#q2.AssetCategoryId#,#serializeJSON("&nbsp;&nbsp;&nbsp;&nbsp;&mdash;&mdash;&mdash;&nbsp;&nbsp;" & q2.Name)#,"",""]
                    <!--- get sub category --->
                    <cfquery name="q3" cachedwithin="#CreateTime(0,0,0)#">
                        SELECT * FROM asset_category WHERE ParentAssetCategoryId = #q2.AssetCategoryId#
                    </cfquery>
                    <cfloop query="q3">
                        ,[#q3.AssetCategoryId#,#serializeJSON("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&mdash;&mdash;&mdash;&nbsp;&nbsp;" & q3.Name)#,"",""]
                    </cfloop>
                </cfloop>

                <cfif q1.recordcount neq q1.currentrow>,</cfif>
            </cfloop>]}
    </cfcase>

    <!---SaveAssetCategory--->
    <cfcase value="SaveAssetCategory">
        <cfquery>
            <cfif form.id eq 0>
                INSERT INTO
            <cfelse>
                UPDATE
            </cfif>
                asset_category SET
                Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Name#">
                <cfif val(form.ParentAssetCategoryId)>
                  ,ParentAssetCategoryId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ParentAssetCategoryId#"/>
                </cfif>
            <cfif form.id neq 0>
            WHERE AssetCategoryId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#">
            </cfif>
        </cfquery>
    </cfcase>

    <!--- savePMTask --->
    <cfcase value="SavePMTask">

    	<cfset form.FrequencyId = val(form.FrequencyId)/>
        <cfset form.ReadingTypeId = val(form.ReadingTypeId)/>
        <cfparam name="form.DepartmentId" default="#request.userinfo.departmentid#"/>
        <cfparam name="form.UnitId" default="#request.userinfo.unitid#"/>
        <cfparam name="form.StartTime" default="#dateformat(now(),'yyyy/mm/yy')#"/>

        <cfset pmid = application.com.PMTask.SavePMTask(form)/>

        <cfif form.id eq 0>
        	The new PM Task #pmid# has been created
        <cfelse>
        	The PM Task updated.
        </cfif>
	</cfcase>


    <!---Save Work Order--->
    <cfcase value="SaveWorkOrder">

        <cfparam name="form.PMTaskId" default="0"/>
        <cfparam name="form.Id" default="0"/>
        <cfparam name="form.dateclosed" default=""/>
        <!--- if the user is supervisor --->
        <!---<cfif (form.WorkClassId eq "3")&&(form.AssetFailureReportId eq "")>
        	<cfthrow message="Create and attach failure report number before creating a CM WorkOrder."/>
        </cfif>--->
        <cfif val(form.AssetFailureReportId)>
        	<cfquery name="q" result="rt">
            	SELECT * FROM asset_failure_report WHERE AssetFailureReportId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.AssetFailureReportId#"/>
            </cfquery>
            <cfif rt.RecordCount lt 1>
            	<cfthrow message="Invalid Failure Report Number. Please Check Again."/>
            </cfif>
            <!---<cfthrow message="#listLen(form.AssetId)#"/>
			<cfif listLen(wo.AssetId) eq 1>
                <cfset wo.AssetLocationIds = listLast(wo.AssetId)/>
                <cfset wo.AssetId = listFirst(wo.AssetId)/>
            </cfif>--->
            
        </cfif>
        
        
        <cfif request.IsSV OR request.IsPS>
            <cfparam name="form.ClosedByUserId" default="#request.userinfo.userid#"/>
            <cfparam name="form.SupervisedByUserId" default="#request.userinfo.userid#"/>
        </cfif>
        <cfif form.Id eq 0>
            <cfparam name="form.CreatedByUserId" default="#request.userinfo.userid#"/>
            <cfparam name="form.DepartmentId" default="#request.UserInfo.DepartmentId#"/>
            <cfparam name="form.UnitId" default="#request.UserInfo.UnitId#"/>
        </cfif>

        <cfset newId = application.com.WorkOrder.SaveWorkOrder(form)/>

        <cfif form.id eq 0>
        	Work Order #newId# has been created
        <cfelse>
        	Work Order was <cfif form.status eq "close">closed<cfelse>updated</cfif>
        </cfif>
	</cfcase>


    <!--- Take Asset Reading --->
    <cfcase value="TakeAssetReading">

        <cfset form.CurrentReading = replace(form.CurrentReading,',','','all')/>
        <cfset form.EntryDate = dateformat(form.EntryDate,'yyyy-mm-dd')/>
		<cfset form.PreviousReading = val(form.PreviousReading)/>

        <!--- check the current reading against the previous reading and make sure the current is not equal to less than the previous --->
        <cfif form.CurrentReading lte form.PreviousReading>
        	<cfthrow message="Your current reading (#Numberformat(form.CurrentReading,'9,999.99')#) can not be equal to or greater than your previous reading (#Numberformat(form.PreviousReading,'9,999.99')#). Please review your input"/>
        </cfif>
		<cfif (form.CurrentReading-form.PreviousReading) gt 1000>
        	 <cfthrow message="Your new reading is too high, the difference between your current reading and your previous reading can not be greater than '1000'. You will need to split your readings"/>
        </cfif>

        <cftransaction action="begin">
			<!--- insert into meter reading history ---->
            <cfquery>
                INSERT INTO reading_history SET
                `AssetLocationId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.AssetLocationId#"/>,
                `EntryDate` = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.EntryDate# #timeformat(now(),'HH:mm:ss')#"/>,
                `CurrentReading` = <cfqueryparam cfsqltype="cf_sql_float" value="#form.CurrentReading#"/>,
                `ReadingByUserId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.userid#"/>,
                `Comment` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.comment#"/>
            </cfquery>
            <!--- enter the current reading --->
            <cfquery name="qR">
                SELECT AssetLocationId FROM meter_reading
                WHERE AssetLocationId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.AssetLocationId#"/>
            </cfquery>

            <cfquery>
                <cfif qR.recordcount>
                    UPDATE meter_reading SET
                <cfelse>
                    INSERT INTO meter_reading SET
                    `AssetLocationId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.AssetLocationId#"/>,
                </cfif>
                `CurrentReading` = <cfqueryparam cfsqltype="cf_sql_float" value="#form.CurrentReading#"/>,
                `TimeModified` = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.EntryDate# #timeformat(now(),'HH:mm:ss')#"/>,
                `Comment` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.comment#"/>
                <cfif qR.recordcount>
                    WHERE AssetLocationId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.AssetLocationId#"/>
                </cfif>
            </cfquery>

            <!--- update milestone table --->
            <!--- get all the pm task on this asset that is based on milestone --->
            <cfquery name="qPM">
            	SELECT
                	pm.Type, pm.IsActive, pm.PMTaskId, pm.AssetLocationId,
                    al.AssetId
                FROM pm_task pm
                INNER JOIN asset_location al ON (al.AssetLocationId = pm.AssetLocationId)
                WHERE pm.AssetLocationId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.AssetLocationId#"/>
                	AND pm.Type = "m"
                    AND pm.IsActive = "Yes"
            </cfquery>

            <!--- milestone reading --->
            <!---<cfif form.PreviousReading eq 0>
            	<cfset form.PreviousReading = form.CurrentReading/>
            </cfif>--->
            <cfset creading = abs(form.PreviousReading - form.CurrentReading)/>

            <cfloop query="qPM">
            	<!--- check if this pm is existing in the milestone table --->
                <cfquery name="qMs">
                	SELECT * FROM pm_milestone
                    WHERE `PMTaskId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#qPM.PMTaskId#"/>
                </cfquery>

                <!--- 	check if work order for this pm task is still open.
						if open, do not count --->
            	<cfquery>
					<cfif qMs.recordcount>
                        UPDATE pm_milestone SET
                    <cfelse>
                        INSERT INTO pm_milestone SET
                        `AssetLocationId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.AssetLocationId#"/>,
                        `PMTaskId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#qPM.PMTaskId#"/>,
                    </cfif>
                    `Reading` = #creading# + `Reading`
                    <cfif qR.recordcount>
                        WHERE PMTaskId = <cfqueryparam cfsqltype="cf_sql_integer" value="#qPM.PMTaskId#"/>
                    </cfif>
                </cfquery>

            </cfloop>

			<!--- Generate WO if necessary by running PM --->
            <cfset application.com.PMTask.GenerateWorkOrder()/>
        </cftransaction>

    </cfcase>

</cfswitch>
</cfoutput>
