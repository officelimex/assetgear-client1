<cfsetting requesttimeout="999999999"/>

<cfoutput>

<cfscript>

	public query function getWO(required numeric id) {
		
		var qW = queryExecute("
			SELECT 
				wo.SupervisedByUserId, wo.WorkOrderId, wo.DepartmentId,
					wo.Description, wo.Status2,
					wo.SupervisedApprovedDate,
				u.Email,
				cb.Email cb_Email
			FROM work_order wo
			INNER JOIN core_user u ON u.UserId = wo.SupervisedByUserId
			LEFT  JOIN core_user cb ON cb.UserId = wo.CreatedByUserId
			WHERE WorkOrderId = ? 
		", [arguments.id])

		return qW
	}

</cfscript>

<cfswitch expression="#url.cmd#">

	<cfcase value="RejectWO">
		
		<cfscript>
			qW = getWO(url.id)
			send = false 
			msg = ""
			switch (qW.Status2) {
				case "Sent to Supervisor":
					msg = "Your supervisor"
					send = true 
					qW = queryExecute("
						UPDATE work_order SET 
							Status2 = ''
						WHERE WorkOrderId = :_wid
					", {_wid : url.id})				
				break;
				case "Sent to FS":
					msg = "The Field Superintendent"
					send = true 
					qW = queryExecute("
						UPDATE work_order SET 
							Status2 = ''
						WHERE WorkOrderId = :_wid
					", {_wid : url.id})				
				break;
				case "Sent to Materials":
					msg = "Materials department"
					send = true 
					qW = queryExecute("
						UPDATE work_order SET 
							Status2 = ''
						WHERE WorkOrderId = :_wid
					", {_wid : url.id})				
				break;
			}

			if(send)	{
				cfparam(name="form.pmt", default="");
				application.com.Notice.SendEmail(
					to  		: qW.cb_Email,
					subject	: "Work Order ###qW.WorkOrderId# Rejected",
					msg 		: "
						Hello, 
						<p>
							#msg# just rejected WO ###qW.WorkOrderId# <br/>
							Reason : #form.pmt#
							===================<br/>
							#qW.Description#<br/>
							===================<br/>
							Kindly contact them for reasons
						</p> 
						Thank you
					"
				)	
			}
		</cfscript>


	</cfcase>
	<!--- FSApprove --->
	<cfcase value="FSApprove">
		<cfscript>

			qW = getWO(url.id)

				application.com.Notice.SendEmail(
					cc			: qW.Email,
					to  		: qW.cb_Email,
					subject	: "Work Order ###qW.WorkOrderId#",
					msg 		: "
						Hello, 
						<p>
							WO ###qW.WorkOrderId# for (#qW.Description#) has been approved by Field Superintendent
						</p> 
						Thank you
					"
				)

				qW = queryExecute("
					UPDATE work_order SET 
						Status2 = 'Approved',
						FSApprovedDate = :_date, 
						FSUserId = :_uid
					WHERE WorkOrderId = :_wid
				", {
					_wid : url.id,
					_uid : request.userinfo.userid,
					_date   : {value: now(), cfsqltype="cf_sql_timestamp"}					
				})
			
		</cfscript>
	</cfcase>

	<!--- FSApprove --->
	<cfcase value="WHApprove">
		<cfscript>

			qW = getWO(url.id)

				application.com.Notice.SendEmail(
					cc			: qW.Email,
					to  		: qW.cb_Email,
					subject	: "Work Order ###qW.WorkOrderId#",
					msg 		: "
						Hello, 
						<p>
							WO ###qW.WorkOrderId# for (#qW.Description#) has been approved by Materials
						</p> 
						Thank you
					"
				)

				qW = queryExecute("
					UPDATE work_order SET 
						Status2 = 'Sent to FS',
						WHApprovedDate = :_date, 
						WHUserId = :_uid
					WHERE WorkOrderId = :_wid
				", {
					_wid : url.id,
					_uid : request.userinfo.userid,
					_date   : {value: now(), cfsqltype="cf_sql_timestamp"}					
				})
			
		</cfscript>
	</cfcase>

	<!--- sendToSupervisor --->
	<cfcase value="sendToSupervisor">
		<cfscript>

			qW = getWO(url.id)

			if(val(qW.SupervisedByUserId))	{
				application.com.Notice.SendEmail(
					to			: qW.Email,
					cc  		: qW.cb_Email,
					subject	: "Work Order ###qW.WorkOrderId#",
					msg 		: "
						Hello, 
						<p>
							Work Order ###qW.WorkOrderId# has been sent to you for approval <br/>
							==================<br/>
							#qW.Description#<br/>
							==================<br/>
						</p> 
						Thank you
					"
				)

				qW = queryExecute("
					UPDATE work_order SET 
						Status2 = 'Sent to Supervisor',
						SentToUserId = ?
					WHERE WorkOrderId = ? 
				", [qW.SupervisedByUserId, url.id])
			}
			
		</cfscript>
	</cfcase>

  <!--- SupervisorApproveWO --->
  <cfcase value="SupervisorApproveWO">

    <cfscript>

			qW = getWO(url.id)

      if((val(qW.SupervisedByUserId) || request.IsMS) && request.userinfo.departmentId == qW.DepartmentId)	{

				if(url.to == "FS")	{
					_to_email = "fieldsuperintendent@#application.domain#"
					_status = "Sent to FS"
				}
				else {	
					_to_email = "materials-logistics@#application.domain#"
					_status = "Sent to Materials"
				}

				queryExecute("
					UPDATE work_order SET
						SupervisedApprovedDate 	= :_date,
						SupervisedByUserId 			= :_userid,
						Status2                	= :_status,
						SentToUserId						= NULL 
					WHERE WorkOrderId = :_id
				", {
					_date   : {value: now(), cfsqltype="cf_sql_timestamp"},
					_status : _status,
					_id     : url.id,
					_userid : request.userinfo.UserId
				})


				application.com.Notice.SendEmail(
					to 			: _to_email,
					cc			: qW.cb_Email,
					subject	: "Work Order ###qW.WorkOrderId# Requires Approval",
					msg 		: "
						Hello, 
						<p>
							Work Order ###qW.WorkOrderId# has been sent to you for approval <br/>
							==================<br/>
							#qW.Description#<br/>
							==================<br/>
						</p> 
						Thank you
					"
				)

      }
      
    </cfscript>

		<cfobjectcache action="clear"/>
  </cfcase>

	<!--- SendToFS --->
	<cfcase value="sendToFS">
		<cfscript>

			qW = getWO(url.id)

			if(val(qW.SupervisedByUserId))	{
				application.com.Notice.SendEmail(
					to			: "fieldsuperintendent@#application.domain#",
					subject	: "Work Order ###qW.WorkOrderId#",
					msg 		: "
						Hello, 
						<p>
							Work Order ###qW.WorkOrderId# has been sent to you for approval <br/>
							==================<br/>
							#qW.Description#<br/>
							==================<br/>
						</p> 
						Thank you
					"
				)

				qW = queryExecute("
					UPDATE work_order SET 
						Status2 = 'Sent to FS',
						WHApprovedDate = :_date,
						WHUserId = :_uid,
						SentToUserId = null
					WHERE WorkOrderId = :_wid 
				", {
					_wid : url.id,
					_uid : request.userinfo.userid,
					_date   : {value: now(), cfsqltype="cf_sql_timestamp"}
				})
				

			}
			
		</cfscript>
	</cfcase>

	<!---getAllAsset--->
	<cfcase value="getAllAsset">
		<cfparam name="url.cid" default=""/>
		<cfparam name="url.status" default="Online"/>

		<cfif  (url.status eq "Online")||(url.status eq "")>
			<cfset url.status = ' IN ("Online","Transfered") '/>
		<cfelseif url.status eq "Off">
			<cfset url.status = ' = "Offline" '/>
		<cfelse>
			<cfset url.status = ' = "Decommissioned" '/>
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
	<cfcase value="getAllPMTask">
    <cfparam name="url.cid" default=""/>
    <cfparam name="url.filter" default=""/>
    <cfset start = (url.page * url.perpage) - (url.perpage)/>

    <cfquery name="q" cachedwithin="#CreateTime(0,0,0)#">
      #application.com.PMTask.PM_TASK_SQL#
    	<cfswitch expression="#url.filter#">
            	<cfcase value="date">
								<cfif url.cid neq "">
                        WHERE pm.FrequencyId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cid#"/>
                       	<cfif !(request.IsHost or request.IsAdmin)>
                        	AND pm.DepartmentId = #request.userinfo.DepartmentId#
                            <cfif val(request.userinfo.UnitId)>AND pm.UnitId=#request.userinfo.UnitId#</cfif>
                        </cfif>
                        <cfif structkeyexists(url,'keyword')>
    						AND #url.Field# LIKE "%#url.keyword#%"
    					</cfif>
                    <cfelse>
                        <cfif structkeyexists(url,'keyword')>
                            WHERE #url.Field# LIKE "%#url.keyword#%"
							<cfif !(request.IsHost or request.IsAdmin)>
                                AND pm.DepartmentId = #request.userinfo.DepartmentId#
                            <cfelse>
                                <cfif val(request.userinfo.UnitId)>AND pm.UnitId=#request.userinfo.UnitId#</cfif>
                            </cfif>
                        </cfif>
                    </cfif>
                </cfcase>
                <cfcase value="milestone">
					<cfif url.cid neq "">
                        WHERE pm.ReadingTypeId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cid#"/>
                        <cfif structkeyexists(url,'keyword')>
                            AND #url.Field# LIKE "%#url.keyword#%"
                        </cfif>
                    <cfelse>
                        <cfif structkeyexists(url,'keyword')>
                            WHERE #url.Field# LIKE "%#url.keyword#%"
                        </cfif>
                    </cfif>
                </cfcase>
            	<cfdefaultcase>
                	WHERE pm.DepartmentId
                        <cfif request.IsHost or request.IsAdmin>
                            IS NOT NULL
                       <cfelse>
                        = #request.userinfo.DepartmentId# <cfif val(request.userinfo.UnitId)>AND pm.UnitId=#request.userinfo.UnitId#</cfif>
                       </cfif>
                	<cfif structkeyexists(url,'keyword')>
                    	AND #url.Field# LIKE "%#url.keyword#%"
                	</cfif>
                </cfdefaultcase>
            </cfswitch>
            ORDER BY #url.sort# #url.sortOrder#
            LIMIT #start#,#url.perpage#
        </cfquery>

        <cfquery name="qT">
            #application.com.PMTask.PM_TASK_COUNT_SQL#
            <cfswitch expression="#url.filter#">
            	<cfcase value="date">
					<cfif url.cid neq "">
                        WHERE pm.FrequencyId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cid#"/>
                       	<cfif !(request.IsHost or request.IsAdmin)>
                        	AND DepartmentId = #request.userinfo.DepartmentId#
                            <cfif val(request.userinfo.UnitId)>AND pm.UnitId=#request.userinfo.UnitId#</cfif>
                        </cfif>
                        <cfif structkeyexists(url,'keyword')>
    						AND #url.Field# LIKE "%#url.keyword#%"
    					</cfif>
                    <cfelse>
                        <cfif structkeyexists(url,'keyword')>
                            WHERE #url.Field# LIKE "%#url.keyword#%"
							<cfif !(request.IsHost or request.IsAdmin)>
                                AND DepartmentId = #request.userinfo.DepartmentId#
                                <cfif val(request.userinfo.UnitId)>AND pm.UnitId=#request.userinfo.UnitId#</cfif>
                            </cfif>
                        </cfif>
                    </cfif>
                </cfcase>
                <cfcase value="milestone">
					<cfif url.cid neq "">
                        WHERE pm.ReadingTypeId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cid#"/>
                        <cfif structkeyexists(url,'keyword')>
                            AND #url.Field# LIKE "%#url.keyword#%"
                        </cfif>
                    <cfelse>
                        <cfif structkeyexists(url,'keyword')>
                            WHERE #url.Field# LIKE "%#url.keyword#%"
                        </cfif>
                    </cfif>
                </cfcase>
            	<cfdefaultcase>
                	WHERE pm.DepartmentId
                        <cfif request.IsHost or request.IsAdmin>
                            IS NOT NULL
                       <cfelse>
                        = #request.userinfo.DepartmentId# <cfif val(request.userinfo.UnitId)>AND pm.UnitId=#request.userinfo.UnitId#</cfif>
                       </cfif>
                	<cfif structkeyexists(url,'keyword')>
                    	AND #url.Field# LIKE "%#url.keyword#%"
                	</cfif>
                </cfdefaultcase>
            </cfswitch>
        </cfquery>
        {"total": #qT.c#,
            "page": #url.page#,
            "rows":[<cfloop query="q">
                [#q.PMTaskId#,#serializeJSON(q.Asset)#,#serializeJSON(q.Location)#,#serializeJSON(q.Description)#,#serializeJSON(q.Frequency)#, <cfif val(q.Milestone) eq 0>"#q.ReadingType#"<cfelse>"#q.Milestone# #q.ReadingType#"</cfif>,
                	<cfswitch expression="#q.IsActive#">
                    	<cfcase value="yes,true" delimiters=",">#serializeJSON('<span class="label label-warning">' & q.IsActive & '</span>')#</cfcase>
                        <cfdefaultcase>#serializeJSON('<span class="label label">' & q.IsActive & '</span>')#</cfdefaultcase>
                    </cfswitch>
                ]
                 <cfif q.recordcount neq q.currentrow>,</cfif>
            </cfloop>]}
    </cfcase>

	<!---getAllWorkOrder--->
	<cfcase value="getAllWorkOrder">
		<cfparam name="url.cid" default=""/>
		<cfparam name="url.jid" default=""/>
		<cfparam name="url.filter" default=""/>
		<cfparam name="url.page" default="1"/>
		<cfparam name="url.perpage" default="20"/>
		<cfparam name="url.sort" default="WorkOrderId"/>
		<cfparam name="url.sortorder" default="DESC"/>
		<cfset start = (url.page * url.perpage) - (url.perpage)/>
		<!---- replace _ with " " because of "part on hold" --->
		<cfset url.cid = replace(url.cid,"_"," ","all")/>
		<cfquery name="q" cachedwithin="#CreateTime(0,0,0)#">
			#application.com.WorkOrder.WORK_ORDER_SQL#
			<cfswitch expression="#url.filter#">
				<cfcase value="d">
					<cfif url.cid neq "" >
						<cfif request.isFS>
							WHERE wo.DepartmentId IS NOT NULL
						<cfelse>
							WHERE wo.DepartmentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cid#">
						</cfif>
						<cfif url.jid != "">
							AND WorkClassId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.jid#"/>
						</cfif>

						<cfif request.isFS>
							<cfif request.userinfo.unitid neq "">
								AND wo.UnitId = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.unitid#">
							</cfif>

							<!--- display the current wo ---->
							<cfif request.userinfo.email neq "thankgod.innocent@#application.domain#">
								AND DateOpened <= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"/>
							</cfif>
						</cfif>

						<cfif structkeyexists(url,'keyword')>
							AND #url.Field# LIKE "%#url.keyword#%"
						</cfif>
					<cfelse>
						<cfif structkeyexists(url,'keyword')>
							WHERE #url.Field# LIKE "%#url.keyword#%"
							<cfif request.userinfo.email neq "thankgod.innocent@#application.domain#">
								AND DateOpened <= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"/>
							</cfif>
						</cfif>
					</cfif>
				</cfcase>
				<cfcase value="status">
					WHERE wo.DepartmentId = #request.userinfo.departmentid#
					<cfif url.cid != "">
						AND wo.Status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.cid#"/>
					</cfif>
					<cfif val(request.userinfo.unitid)>
						AND wo.UnitId = #request.userinfo.unitid#
					</cfif>
					<!--- display the current wo ---->
					<cfif request.userinfo.email neq "thankgod.innocent@#application.domain#">
						AND DateOpened <= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"/>
					</cfif>
					<cfif structkeyexists(url,'keyword')>
						AND #url.Field# LIKE "%#url.keyword#%"
					</cfif>
				</cfcase>
				<cfcase value="unit"> 
					WHERE wo.UnitId = #request.userinfo.unitid#
					<cfif structkeyexists(url,'keyword')>
						AND #url.Field# LIKE "%#url.keyword#%"
					</cfif>
				</cfcase>
				<cfdefaultcase>
					<cfif url.cid neq "" >
						WHERE wo.WorkClassId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cid#">
						<cfif request.userinfo.email neq "thankgod.innocent@#application.domain#">
							AND DateOpened <= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"/>
						</cfif>
						<cfif structkeyexists(url,'keyword')>
							AND #url.Field# LIKE "%#url.keyword#%"
						</cfif>
					<cfelse>
						<cfif structkeyexists(url,'keyword')>
							WHERE #url.Field# LIKE "%#url.keyword#%"
							<cfif request.userinfo.email neq "thankgod.innocent@#application.domain#">
								AND DateOpened <= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"/>
							</cfif>
						</cfif>
					</cfif>
				</cfdefaultcase>
      </cfswitch>
            ORDER BY #url.sort# #url.sortOrder#, Status DESC, wo.DateOpened DESC
            LIMIT #start#,#url.perpage#
        </cfquery>

        <cfquery name="qT">
            #application.com.WorkOrder.WORK_ORDER_COUNT_SQL#
            <cfswitch expression="#url.filter#">
                <cfcase value="d">
                    <cfif url.cid neq "" >
											<cfif request.userinfo.role eq "FS">
												WHERE wo.DepartmentId IS NOT NULL
											<cfelse>
												WHERE wo.DepartmentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cid#">
											</cfif>
											<cfif url.jid neq "">
												AND WorkClassId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.jid#"/>
											</cfif>
						<cfif request.isFS>
							<cfif request.userinfo.unitid neq "">
								AND wo.UnitId = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.unitid#">
							</cfif>

							<!--- display the current wo ---->
							AND DateOpened <= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"/>
						</cfif>

											<cfif structkeyexists(url,'keyword')>
													AND #url.Field# LIKE "%#url.keyword#%"
											</cfif>
                    <cfelse>
                        <cfif structkeyexists(url,'keyword')>
                            WHERE  #url.Field# LIKE "%#url.keyword#%"
                            AND DateOpened <= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"/>
                        </cfif>
                    </cfif>
								</cfcase>
				<cfcase value="unit"> 
					WHERE wo.UnitId = #request.userinfo.unitid#
					<cfif structkeyexists(url,'keyword')>
						AND #url.Field# LIKE "%#url.keyword#%"
					</cfif>
				</cfcase>
				<cfcase value="status">
					WHERE wo.DepartmentId = #request.userinfo.departmentid#
						AND wo.Status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.cid#"/>
					<cfif request.userinfo.unitid neq "">
						AND wo.UnitId = #request.userinfo.unitid#
					</cfif>
					<!--- display the current wo ---->
					<cfif request.userinfo.email neq "thankgod.innocent@#application.domain#">
						AND wo.DateOpened <= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"/>
					</cfif>
					<cfif structkeyexists(url,'keyword')>
						AND #url.Field# LIKE "%#url.keyword#%"
					</cfif>
				</cfcase>
                <cfdefaultcase>
                    <cfif url.cid neq "">
						WHERE wo.WorkClassId = #url.cid#
                        AND DateOpened <= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"/>
                        <cfif structkeyexists(url,'keyword')>
                            AND #url.Field# LIKE "%#url.keyword#%"
                        </cfif>
                    <cfelse>
                        <cfif structkeyexists(url,'keyword')>
                            WHERE  #url.Field# LIKE "%#url.keyword#%"
                            AND DateOpened <= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"/>
                        </cfif>
                    </cfif>
                </cfdefaultcase>
            </cfswitch>
        </cfquery>

        {"total": #qT.c#,
            "page": #url.page#,
            "rows":[<cfloop query="q">
                [#q.WorkOrderId#,"#q.ServiceRequestId#",#serializeJSON(q.Description)#,#serializeJSON(q.Asset)#,#serializeJSON(q.JobClass)#,"#dateformat(q.DateOpened,'dd-mmm-yyyy')#",
									<cfswitch expression="#q.Status#">
										<cfcase value="Open" delimiters=",">#serializeJSON('<span class="label label-warning">' & q.Status & '</span>')#</cfcase>
										<cfcase value="Close">#serializeJSON('<span class="label">Close</span>')#</cfcase>
										<cfcase value="Suspended">#serializeJSON('<span class="label label-info">Suspended</span>')#</cfcase>
										<cfdefaultcase>#serializeJSON('<span class="label label-important">' & q.Status & '</span>')#</cfdefaultcase>
									</cfswitch>,
									<cfswitch expression="#q.Status2#">
										<cfcase value="Approved">#serializeJSON('<span class="label label-success">' & q.Status2 & '</span>')#</cfcase>
										<cfcase value="Sent to FS,Sent to Materials" delimiters=",">#serializeJSON('<span class="label label-primary">' & q.Status2 & '</span>')#</cfcase>
										<cfdefaultcase>#serializeJSON('<span class="label label-info">' & q.Status2 & '</span>')#</cfdefaultcase>
									</cfswitch>,
                  #q.DepartmentId#, "#q.UnitId#"
                ]
                 <cfif q.recordcount neq q.currentrow>,</cfif>
            </cfloop>]}
    </cfcase>


    <!--- get meter readings --->
	<cfcase value="getMeterReadings">
        <cfset start = (url.page * url.perpage) - (url.perpage)/>

        <cfquery name="q" cachedwithin="#CreateTime(0,0,0)#">
            #application.com.Asset.METER_READING_SQL#
            WHERE a.Status = "Online"
            <cfif structkeyexists(url,'keyword')>
				AND (#url.Field# LIKE "%#url.keyword#%")
			</cfif>
            ORDER BY <cfif url.sort eq "assetid">a.#url.sort#<cfelse>#url.sort#</cfif> #url.sortOrder#
            LIMIT #start#,#url.perpage#
        </cfquery>
        <cfquery name="qT">
            #application.com.Asset.METER_READING_COUNT_SQL#
            WHERE a.Status = "Online"
            <cfif structkeyexists(url,'keyword')>
				AND (#url.Field# LIKE "%#url.keyword#%")
			</cfif>
        </cfquery>
        <cfset stl = "font-size:11px;color:gray;"/>
        {"total": #qT.c#,
            "page": #url.page#,
            "rows":[<cfloop query="q">
                [#q.AssetLocationId#,#serializeJSON(q.Asset)#, #serializeJSON(Location)#, "#NumberFormat(q.CurrentReading,'9,999.99')# #q.ReadingCode#",
                <cfset ddif = -1/>
                <cfset aa=""/>
				<cfif isdate(q.TimeModified)>
					<!---<cfset ddif = abs(datediff('d',q.TimeModified,now()))/>--->
                    <cfset d1 = dateformat(q.TimeModified,'yyyy/m/d')/>
                    <cfset d2 = dateformat(now(),'yyyy/m/d')/>
                    <cfset ddif = datediff('d',d1,d2)/>
                </cfif>
                <cfswitch expression="#ddif#">
                	<cfcase value="0"><cfset ddate = "<span class='label label-warning'>TODAY</span> <span style='#stl#'>#TimeFormat(q.TimeModified,'hh:mm tt')#</span>"/></cfcase>
                	<cfcase value="1"><cfset ddate = "<span class='label label-info'>YESTERDAY</span> <span style='#stl#'>#TimeFormat(q.TimeModified,'hh:mm tt')#</span>"/></cfcase>
                    <cfcase value="2,3,4,5" delimiters=","><cfset ddate = "<span class='label label-important'>#ddif# DAYS AGO</span> <span style='#stl#'>#TimeFormat(q.TimeModified,'hh:mm tt')#</span>"/></cfcase>
                    <cfcase value="-1"><cfset ddate = "<span class='label'>Never</span>"/></cfcase>
                    <cfdefaultcase><cfset ddate = "<span class='label label-success'>#dateformat(q.TimeModified,'dd-mmm-yyyy')#</span> <span style='#stl#'>#TimeFormat(q.TimeModified,'hh:mm tt')#</span>"/></cfdefaultcase>
                </cfswitch>
                #serializeJSON(ddate & aa)#]
                 <cfif q.recordcount neq q.currentrow>,</cfif>
            </cfloop>]}
    </cfcase>
	<!---get Downtime --->
	<cfcase value="getDowntime">
        <cfset start = (url.page * url.perpage) - (url.perpage)/>
        <cfquery name="q" cachedwithin="#CreateTime(0,0,0)#">
            #application.com.Asset.SQL_ASSET_DOWNTIME#
            ORDER BY a.Description ASC
            LIMIT #start#,#url.perpage#
        </cfquery>
        <cfquery name="qT">
            #application.com.Asset.SQL_ASSET_DOWNTIME_COUNT#
        </cfquery>
        
        {"total": #qT.c#,
            "page": #url.page#,
            "rows":[<cfloop query="q">
                [
                    #q.AssetLocationId#,#serializeJSON(q.AssetDescriptions)#,
                    <cfquery name="q2"> 
						SELECT
						SUM(TIMESTAMPDIFF(hour,startperiod,EndPeriod)) as DTPeriod, TIMESTAMPDIFF(hour,DATE_FORMAT(NOW() ,'%Y-01-01'),CURRENT_DATE()) AS TotalHour,
						StartPeriod,EndPeriod
						FROM asset_downtime 
						WHERE `Status` = "Close" AND AssetLocationId = #q.AssetLocationId# AND
						YEAR(StartPeriod) = year(now())
					</cfquery>
                    #val(q2.DTPeriod)#,#val(q2.TotalHour) - val(q2.DTPeriod)#,#numberFormat(((val(q2.TotalHour) - val(q2.DTPeriod))/val(q2.TotalHour))*100,"9.99")#,
                    <cfquery name="q3"> SELECT Status FROM asset_downtime WHERE AssetLocationId = "#q.AssetLocationId#" AND Status = "Open" </cfquery>

                    <cfif q3.RecordCount gt 0>
                        #serializeJSON('<span class="label label-warning">Down</span>')#
                    <cfelse>
                        #serializeJSON('<span class="label label-success">Online</span>')#
                    </cfif>
                ]
                 <cfif q.recordcount neq q.currentrow>,</cfif>
            </cfloop>]
        }
    </cfcase>
	
    <!--- get failure reports --->
	<cfcase value="getFailureReports">
        <cfset start = (url.page * url.perpage) - (url.perpage)/>

        <cfquery name="q" cachedwithin="#CreateTime(0,0,0)#">
            #application.com.Asset.FAILURE_REPORT_SQL#
			WHERE fr.OfficeLocationId IN (#request.userinfo.OfficeLocationId#)
			<cfif url.s eq 1>
				AND fr.Status <> "Close"
			<cfelse>
				AND fr.Status = "Close"	
			</cfif>
			
            <cfif structkeyexists(url,'keyword')>
                AND (#url.Field# LIKE "%#url.keyword#%")
			</cfif>
            ORDER BY AssetFailureReportId DESC
            LIMIT #start#,#url.perpage#
        </cfquery>
        <cfquery name="qT">
            #application.com.Asset.FAILURE_REPORT_COUNT_SQL#
			WHERE fr.OfficeLocationId IN (#request.userinfo.OfficeLocationId#)
			<cfif url.s eq 1>
				AND fr.Status <> "Close"
			<cfelse>
				AND fr.Status = "Close"	
			</cfif>
            <cfif structkeyexists(url,'keyword')>
				AND (#url.Field# LIKE "%#url.keyword#%")
			</cfif>
        </cfquery>
        
        <cfset stl = "font-size:11px;color:gray;"/>
        {"total": #qT.c#,
            "page": #url.page#,
            "rows":[<cfloop query="q">
                [#q.AssetFailureReportId#,#serializeJSON(q.ReportTitle)#,#serializeJSON(q.FailedOn)#,#serializeJSON(q.Asset)#,#serializeJSON(q.Location)#,#serializeJSON(q.LocDescription)#, #serializeJSON(q.RiskLevel)#, "#Dateformat(q.Date,'dd-mmm-yyyy')#",#q.CreatedByUserId#,#serializeJSON(q.Status)#, 
                 #serializeJSON(q.CreatedBy)#,
				 <cfif (application.com.User.IsMyBackToBack(q.CreatedByUserId,request.userinfo.userid) || application.com.User.IsMySupervisor(q.CreatedByUserId,request.userinfo.userid))>
				     #serializeJSON("True")#
				 <cfelse>
				     #serializeJSON("False")#
				 </cfif>
				 ,
                <cfswitch expression="#q.Status#">
						<cfcase value="Close">#serializeJSON('<span class="label label-success">' & q.Status & '</span>')#</cfcase>
						<cfcase value="Open">#serializeJSON('<span class="label label-warning">' & q.Status & '</span>')#</cfcase>
								<cfdefaultcase>#serializeJSON('<span class="label label">' & q.Status & '</span>')#</cfdefaultcase>
				 </cfswitch>]
                 <cfif q.recordcount neq q.currentrow>,</cfif>
            </cfloop>]}
    </cfcase>

    <!--- get Incident reports --->
	<cfcase value="getIncidentReports">
        <cfset start = (url.page * url.perpage) - (url.perpage)/>

        <cfquery name="q" cachedwithin="#CreateTime(0,0,0)#">
            #application.com.Asset.INCIDENT_REPORT_SQL#
            <cfif structkeyexists(url,'keyword')>
                WHERE (#url.Field# LIKE "%#url.keyword#%")
						</cfif>
            ORDER BY <cfif url.sort eq "incidentid">ic.#url.sort#<cfelse>#url.sort#</cfif> #url.sortOrder#
            LIMIT #start#,#url.perpage#
        </cfquery>
        <cfquery name="qT">
            #application.com.Asset.INCIDENT_REPORT_COUNT_SQL#
            <cfif structkeyexists(url,'keyword')>
				WHERE (#url.Field# LIKE "%#url.keyword#%")
			</cfif>
        </cfquery>
        <cfset stl = "font-size:11px;color:gray;"/>
        {"total": #qT.c#,
            "page": #url.page#,
            "rows":[<cfloop query="q">
                [#q.IncidentId#,#serializeJSON(q.Title)#, #serializeJSON(q.Description)#,"#Dateformat(q.ReportTime,'dd-mmm-yyyy')#",
									#serializeJSON('<span class="label label-success">' & q.DepartmentName & '</span>')#
								]
                 <cfif q.recordcount neq q.currentrow>,</cfif>
            </cfloop>]}
    </cfcase>
    
    <!--- get Drilling Returns reports --->
	<cfcase value="getDrillingReturns">
        <cfset start = (url.page * url.perpage) - (url.perpage)/>

        <cfquery name="q" cachedwithin="#CreateTime(0,0,0)#">
            SELECT dr.*,
            CONCAT(mid(Comment,1,90),IF(LENGTH(Comment)>90,'...',''))  AS LimitComment,
            CONCAT(cu.Surname, " ",cu.OtherNames) AS CreatedBy
            FROM drilling_return AS dr
            LEFT JOIN core_user AS cu ON dr.CreatedById = cu.UserId            
            <cfif structkeyexists(url,'keyword')>
                WHERE (#url.Field# LIKE "%#url.keyword#%")
						</cfif>
            ORDER BY <cfif url.sort eq "DReturnedId">dr.#url.sort#<cfelse>#url.sort#</cfif> #url.sortOrder#
            LIMIT #start#,#url.perpage#
        </cfquery>
        <cfquery name="qT">
            SELECT count(DReturnedId) c FROM drilling_return
            <cfif structkeyexists(url,'keyword')>
				WHERE (#url.Field# LIKE "%#url.keyword#%")
			</cfif>
        </cfquery>
        <cfset stl = "font-size:11px;color:gray;"/>
        {"total": #qT.c#,
            "page": #url.page#,
            "rows":[<cfloop query="q"> 
            <cfquery name="qn" result="rt">SELECT SUM(Qty) AS RecordCount FROM drilling_returned_item WHERE DReturnedId = #q.DReturnedId#</cfquery>
                [#q.DReturnedId#,#serializeJSON(q.ReturedBy)#,"#Dateformat(q.ReturedDate,'dd-mmm-yyyy')#",#serializeJSON(q.LimitComment)#,
									#serializeJSON(qn.RecordCount)#
								]
                 <cfif q.recordcount neq q.currentrow>,</cfif>
            </cfloop>]}
    </cfcase>

    <!--- Save Asset ---->
    <cfcase value="SaveIncideReport">
        <cfparam name="form.NotifyMng" default=""/>
        <cfparam name="form.NotifyGov" default=""/>
        <cfparam name="form.IsWorkRelated" default=""/>
        <cfparam name="form.IncidentType" default=""/>
        <cfparam name="form.AffectedParty" default=""/>
        <cfparam name="form.AffectedPersonel" default=""/>
        <cfparam name="form.OccurredLocation" default=""/>
        <cfparam name="form.IncidentAgent" default=""/>
        <cfparam name="form.Gender" default="Male"/>
        <cfparam name="form.JobDuration" default=""/>
        <cfparam name="form.InjuryType" default=""/>
        <cfparam name="form.ReturnToWork" default=""/>
        <cfparam name="form.ASeverityPeople" default=""/>
        <cfparam name="form.ASeverityEnvironment" default=""/>
        <cfparam name="form.ASeverityAsset" default=""/>
        <cfparam name="form.ASeverityReputation" default=""/>
        <cfparam name="form.PSeverityPeople" default=""/>
        <cfparam name="form.PSeverityEnvironment" default=""/>
        <cfparam name="form.PSeverityAsset" default=""/>
        <cfparam name="form.PSeverityReputation" default=""/>
        <cfparam name="form.PhysicalInvestigation" default=""/>
        <cfparam name="form.Witnesses" default=""/>
        <cfparam name="form.Paper" default=""/>
        <cfparam name="form.MajorCauses" default=""/>
        <cfparam name="form.Policy" default=""/>
        <cfparam name="form.Communication" default=""/>
        <cfparam name="form.Hazard" default=""/>
        <cfparam name="form.BloodBorne" default=""/>
        <cfparam name="form.ProductivityFactors" default=""/>
        <cfparam name="form.WorkBehaviour" default=""/>
        <cfparam name="form.Training" default=""/>
        <cfparam name="form.Environment" default=""/>
        <cfparam name="form.PPE" default=""/>
        <cfparam name="form.Facility" default=""/>
        <cfparam name="form.ElementInvolved" default=""/>

        <cfset n_incident = application.com.Incident.SaveIncideReport(form)/>
        Incident Report #form.Title# with ##: #n_incident# was successfuly updated...
    </cfcase>

    <!--- Save Asset ---->
    <cfcase value="SaveAsset">
        <cfparam name="form.DepartmentIds" default=""/>
        <cfparam name="form.ParentAssetId" default=""/>
        <cfparam name="form.OfficeLocationId" default=""/>
        <cfparam name="form.LocationCategoryId" default=""/>
        <cfparam name="form.WorkingForId" default=""/>

        <cfset n_asset = application.com.Asset.SaveAsset(form)/>
        Asset #form.Description# with ##: #n_asset# was successfuly updated...
    </cfcase>

	<!---Get Frequency--->
    <cfcase value="getFrequency">
        <cfset start = (url.page * url.perpage) - (url.perpage)/>

        <cfquery name="q" cachedwithin="#CreateTime(0,0,0)#">
            SELECT *
			FROM frequency
            <cfif structkeyexists(url,'keyword')>
				WHERE (#url.Field# LIKE "%#url.keyword#%")
			</cfif>
            ORDER BY #url.sort# #url.sortOrder#
            LIMIT #start#,#url.perpage#
        </cfquery>
        <cfquery name="qT">
            SELECT count(*) c
            FROM frequency
            <cfif structkeyexists(url,'keyword')>
				WHERE (#url.Field# LIKE "%#url.keyword#%")
			</cfif>
        </cfquery>
        {"total": #qT.c#,
            "page": #url.page#,
            "rows":[<cfloop query="q">
                [#q.FrequencyId#,#serializeJSON(q.Code)#,#serializeJSON(q.Description)#,#q.Years#,#q.Quarters#,#q.Months#,#q.Weeks#,#q.Days#,#q.Hours#, #q.Minutes#]
                 <cfif q.recordcount neq q.currentrow>,</cfif>
            </cfloop>]}
    </cfcase>

    <!---getAllServiceRequest--->
    <cfcase value="getAllServiceRequest">
			<cfset start = (url.page * url.perpage) - (url.perpage)/>
			<cfparam name="url.status" default="Open"/>
			<cfparam name="url.srtype" default=""/>

			<cfquery name="q" cachedwithin="#CreateTime(0,0,0)#">
				#application.com.WorkOrder.SERVICE_REQUEST_SQL#
				WHERE
			<cfif url.srtype eq "">
				<cfif url.status <> "">
					sr.Status = '#url.status#'
				<cfelse>
					sr.Status <> ''
				</cfif>
				<cfif !ListContainsNoCase('HT,WHS,FS',request.userinfo.role)>
					AND u.DepartmentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.departmentid#"/>
				</cfif>
		   <cfelse>
 					sr.Status = 'Open'
          <cfif request.userinfo.DepartmentId eq 8>
             AND sr.Category = 'm'
          <cfelseif request.userinfo.DepartmentId eq 2>
             AND sr.Category = 's'
             AND u.CompanyId = #request.userinfo.CompanyId#
          </cfif>
			 </cfif>
			<cfif structkeyexists(url,'keyword')>
				AND (#url.Field# LIKE "%#url.keyword#%")
			</cfif>
					ORDER BY #url.sort# #url.sortOrder#
					LIMIT #start#,#url.perpage#
			</cfquery>

			<cfquery name="qT">
					#application.com.WorkOrder.SERVICE_REQUEST_COUNT_SQL#
					WHERE
					<cfif url.srtype eq "">
						<cfif url.status <> "">
							sr.Status = '#url.status#'
						<cfelse>
							sr.Status <> ''
						</cfif>
						<cfif !ListContainsNoCase('HT,WHS,FS',request.userinfo.role)>
							AND u.DepartmentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.departmentid#"/>
						</cfif>
				   <cfelse>
							 sr.Status = 'Open'
							 <cfif request.userinfo.DepartmentId eq 8>
									AND sr.Category = 'm'
							 <cfelseif request.userinfo.DepartmentId eq 2>
									AND sr.Category = 's'
							 </cfif>
					 </cfif>
					<cfif structkeyexists(url,'keyword')>
			AND #url.Field# LIKE "%#url.keyword#%"
		</cfif>
			</cfquery>
<!---cfdump var="#q#">
<cfabort--->
			{"total": #qT.c#,
					"page": #url.page#,
					"rows":[<cfloop query="q">
						 [#q.ServiceRequestId#,#serializeJSON(q.Asset)#,#serializeJSON(left(q.Description,'100') & '...' & q.ReasonForRequest)#,#serializeJSON(q.RequestBy)#,"#dateformat(q.Date,'dd-mmm-yyyy')#",#serializeJSON(q.Categ)#,
						 <cfswitch expression="#q.ServiceType#">
									<cfcase value="JR">#serializeJSON('<span class="label label-important">Job Request</span>')#</cfcase>
									<cfcase value="MR">#serializeJSON('<span class="label label-info">Material Request</span>')#</cfcase>
							</cfswitch>,
						 <cfswitch expression="#q.Priority#">
									<cfcase value="m">#serializeJSON('<span class="label label-success">Medium</span>')#</cfcase>
									<cfcase value="h">#serializeJSON('<span class="label label-warning">High</span>')#</cfcase>
									<cfdefaultcase>#serializeJSON('<span class="label label">Low</span>')#</cfdefaultcase>
							</cfswitch>,
							<cfswitch expression="#q.Status#">
									<cfcase value="Open">#serializeJSON('<span class="label label-success">' & q.Status & '</span>')#</cfcase>
									<cfcase value="Suspended">#serializeJSON('<span class="label label-warning">' & q.Status & '</span>')#</cfcase>
											<cfdefaultcase>#serializeJSON('<span class="label label">' & q.Status & '</span>')#</cfdefaultcase>
									</cfswitch>]
							 <cfif q.recordcount neq q.currentrow>,</cfif>
					</cfloop>]}
    </cfcase>

		<!---Save Frequency--->
    <cfcase value="SaveFrequency">
			<cfquery>
        <cfif form.id eq 0>
          INSERT INTO
        <cfelse>
					UPDATE
				</cfif>
          frequency SET
						`Code` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Code#">,
						Description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Description#">,
						`Years` = <cfqueryparam cfsqltype="cf_sql-integer" value="#val(form.Years)#">,
						Quarters = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Quarters#">,
						`Months` = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Months#">,
						`Weeks` = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Weeks#">,
						`Days` = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Days#">,
						Hours = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Hours#">,
						Minutes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Minutes#">
				<cfif form.id neq "">
				WHERE FrequencyId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#">
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
            	SELECT * FROM asset_failure_report WHERE AssetFailureReportId = #val(form.AssetFailureReportId)#
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

        <cfif val(form.PMTaskId) == 0 && form.WorkClassId == 10>
            <cfthrow message="You can't change this work order to a PM Task, kindly use the PM task module, or cantact the Administrator"/>
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
				<cfif (form.CurrentReading-form.PreviousReading) gt 991000>
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
                            `Reading` = #creading# + `Reading`
                        WHERE PMTaskId = <cfqueryparam cfsqltype="cf_sql_integer" value="#qPM.PMTaskId#"/>
                    <cfelse>
                        INSERT INTO pm_milestone SET
                            `AssetLocationId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.AssetLocationId#"/>,
                            `PMTaskId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#qPM.PMTaskId#"/>,
                            `Reading` = #creading#
                    </cfif>

                </cfquery>

            </cfloop>

			<!--- Generate WO if necessary by running PM --->
            <cfset application.com.PMTask.GenerateWorkOrder()/>
        </cftransaction>

    </cfcase>

</cfswitch>
</cfoutput>

<cfobjectcache action="clear"/>