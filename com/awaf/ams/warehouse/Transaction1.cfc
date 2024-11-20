<cfcomponent>

	<cffunction name="init" returntype="Transaction" access="public">

		<cfset this.MR_SQL = '
			SELECT
				mr.*,
				d.Name Department
			FROM whs_mr mr
			LEFT JOIN core_department d ON d.DepartmentId = mr.DepartmentId
		'/>
		<cfset this.MR_COUNT_SQL = '
			SELECT COUNT(mr.MRId) C
			FROM whs_mr mr
		'/>

		<cfset this.MR_ITEM_SQL = '
			SELECT
				mri.*,
				CONCAT(wi.Description," ",wi.VPN) Item, CONVERT(CONCAT(wi.Description,"~",wi.ItemId) USING utf8) ItemDescription,
					wi.Currency,
				um.Code UM
			FROM whs_mr_item mri
			INNER JOIN whs_item wi ON wi.ItemId = mri.ItemId
			INNER JOIN um ON um.UMId = wi.UMId
		'/>

		<cfset this.MR_NI_ITEM_SQL = '
			SELECT
				mri.*, mri.VPN Item
			FROM whs_mr_item mri
		'/>

		<cfset this.MI_SQL = '
            SELECT
            	mi.*,
                CONCAT(cu.Surname," ",cu.OtherNames) IssuedBy,CONCAT(cu2.Surname," ",cu2.OtherNames) IssuedTo,
                d.Name Department
            FROM whs_issue mi
        	INNER JOIN core_department d ON mi.DepartmentId = d.DepartmentId
        	INNER JOIN core_user cu ON mi.IssuedByUserId = cu.UserId
        	INNER JOIN core_user cu2 ON mi.IssuedToUserId = cu2.UserId
		'/>

		<cfset this.MI_COUNT_SQL = '
            SELECT
            	COUNT(mi.IssueId) C
            FROM whs_issue mi
        	INNER JOIN core_department d ON mi.DepartmentId = d.DepartmentId
        	INNER JOIN core_user cu ON mi.IssuedByUserId = cu.UserId
        	INNER JOIN core_user cu2 ON mi.IssuedToUserId = cu2.UserId
		'/>

		<cfset this.MI_ITEM_SQL = '
			SELECT
				mii.*,
				mi.DateIssued, mi.WorkOrderId,
				d.Name Department,
				CONCAT(wi.Description," ",wi.VPN) Item, wi.Currency,
				um.Code UM
			FROM whs_issue_item mii
			INNER JOIN whs_issue mi ON mi.IssueId = mii.IssueId
			INNER JOIN core_department d ON d.DepartmentId = mi.DepartmentId
			INNER JOIN whs_item wi ON wi.ItemId = mii.ItemId
			INNER JOIN um ON um.UMId = wi.UMId
		'/>

		<cfset this.MATERIAL_RECEIVED_ITEM_SQL = '
			SELECT
				ri.*,
				r.Date, r.MRId,
				CONCAT(i.Description," ",i.VPN) Item,
				um.Code UM
			FROM whs_material_received_item ri
			INNER JOIN whs_material_received r ON r.MaterialReceivedId = ri.MaterialReceivedId
			INNER JOIN whs_item i ON (ri.ItemId = i.ItemId)
			INNER JOIN um ON (um.UMId = i.UMId)
		'/>

		<cfset this.MATERIAL_RECEIVED_SQL = '
            SELECT
            	r.*,
                CONCAT(cu.Surname," ",cu.OtherNames) ReceivedBy
            FROM whs_material_received r
        	-- LEFT JOIN whs_mr mr ON (mr.MRId = r.MRId)
        	INNER JOIN core_user cu ON (r.ReceivedByUserId = cu.UserId)
		'/>

		<cfset this.MATERIAL_RECEIVED_COUNT_SQL = '
            SELECT
            	COUNT(r.MaterialReceivedId) C
            FROM whs_material_received r
        	-- LEFT JOIN whs_mr mr ON (mr.MRId = r.MRId)
		'/>

		<cfset this.MATERIAL_RETURN_SQL = '
			SELECT
				wr.*,
				CONCAT(cu.Surname," ",cu.OtherNames) ReturnedBy,
				CONCAT(cu2.Surname," ",cu2.OtherNames) ReturnedTo,
				cd.`Name` as Department
			FROM whs_return AS wr
			INNER JOIN core_user AS cu ON wr.ReturnedByUserId = cu.UserId
			INNER JOIN core_user AS cu2 ON wr.ReturnedToUserId = cu2.UserId
			INNER JOIN whs_issue wi ON wr.IssueId = wi.IssueId
			INNER JOIN core_department cd ON wi.DepartmentId = cd.DepartmentId
		'/>

		<cfset this.MATERIAL_RETURN_COUNT_SQL = '
			SELECT COUNT(ReturnId) C
			FROM whs_return
		'/>

		<cfset this.DN_SQL = '
			SELECT
				dn.*,
				CONCAT(cu.Surname," ",cu.OtherNames) DeliverTo,
				d.`Name` as Department
			FROM whs_dn AS dn
			INNER JOIN core_user AS cu ON dn.DeliverToUserId= cu.UserId
			INNER JOIN whs_mr mr ON mr.MRId = dn.MRId
			INNER JOIN core_department d ON d.DepartmentId = mr.DepartmentId
		'/>

		<cfset this.DN_COUNT_SQL = '
			SELECT COUNT(DeliveryNoteId) C
			FROM whs_dn
		'/>

		<cfreturn this/>
	</cffunction>

	<cffunction name="GetDN" return="query" access="public">
		<cfargument name="did" hint="delivery note id" required="true" type="numeric"/>

		<cfquery name="qDN">
			#this.DN_SQL#
			WHERE dn.DeliveryNoteId = <cfqueryparam value="#arguments.did#" cfsqltype="cf_sql_integer"/>
		</cfquery>

		<cfreturn qDN/>
	</cffunction>

	<cffunction name="GetDNItems" return="query" access="public">
		<cfargument name="did" hint="dn id" required="true" type="numeric"/>

		<cfquery name="qdni">
            SELECT dni.*
            FROM whs_dn_item dni
			WHERE dni.DeliveryNoteId = <cfqueryparam value="#arguments.did#" cfsqltype="cf_sql_integer"/>
		</cfquery>

		<cfreturn qdni/>
	</cffunction>

	<cffunction name="GetMR" return="query" access="public">
		<cfargument name="mrid" hint="material requisition id" required="true" type="numeric"/>

		<cfquery name="qMR">
			#this.MR_SQL#
			WHERE mr.MRId = <cfqueryparam value="#arguments.mrid#" cfsqltype="cf_sql_integer"/>
		</cfquery>

		<cfreturn qMR/>
	</cffunction>

	<cffunction name="GetMaterialReceived" return="query" access="public">
		<cfargument name="mrid" hint="material received id" required="true" type="numeric"/>

		<cfquery name="qMR">
			#this.MATERIAL_RECEIVED_SQL#
			WHERE r.MaterialReceivedId = <cfqueryparam value="#arguments.mrid#" cfsqltype="cf_sql_integer"/>
		</cfquery>

		<cfreturn qMR/>
	</cffunction>

	<cffunction name="GetMaterialReceivedItems" return="query" access="public">
		<cfargument name="mrid" hint="material received id" required="true" type="numeric"/>

		<cfquery name="qMR">
			#this.MATERIAL_RECEIVED_ITEM_SQL#
			WHERE ri.MaterialReceivedId = <cfqueryparam value="#arguments.mrid#" cfsqltype="cf_sql_integer"/>
		</cfquery>

		<cfreturn qMR/>
	</cffunction>

	<cffunction name="GetMRItems" return="query" access="public">
		<cfargument name="mrid" hint="material requisition id" required="true" type="numeric"/>

		<cfquery name="qMRI">
			#this.MR_ITEM_SQL#
			WHERE mri.MRId = <cfqueryparam value="#arguments.mrid#" cfsqltype="cf_sql_integer"/>
		</cfquery>

		<cfreturn qMRI/>
	</cffunction>

	<cffunction name="GetMRNIItems" return="query" access="public">
		<cfargument name="mrid" hint="material requisition id" required="true" type="numeric"/>

		<cfquery name="qMRI">
			#this.MR_NI_ITEM_SQL#
			WHERE mri.MRId = <cfqueryparam value="#arguments.mrid#" cfsqltype="cf_sql_integer"/>
            	AND mri.ItemId IS NULL
		</cfquery>

		<cfreturn qMRI/>
	</cffunction>

	<cffunction name="GetMI" return="query" access="public">
		<cfargument name="mid" hint="material issue id" required="true" type="numeric"/>

		<cfquery name="qMI">
			#this.MI_SQL#
			WHERE mi.IssueId = <cfqueryparam value="#arguments.mid#" cfsqltype="cf_sql_integer"/>
		</cfquery>

		<cfreturn qMI/>
	</cffunction>

	<cffunction name="GetMIItems" return="query" access="public">
		<cfargument name="miid" hint="material issue id" required="true" type="numeric"/>

		<cfquery name="qMII">
			#this.MI_ITEM_SQL#
			WHERE mii.IssueId = <cfqueryparam value="#arguments.miid#" cfsqltype="cf_sql_integer"/>
		</cfquery>

		<cfreturn qMII/>
	</cffunction>

	<cffunction name="SaveMR" returntype="numeric" access="public" hint="Save material requisition">
		<cfargument name="mr_" hint="material requisition data in struct form" type="struct" required="true"/>

		<cfset mr = arguments.mr_/>
		<cfset mrid = mr.id/>

        <cfparam name="form.ServiceRequestId" default="0"/>

		<cftransaction action="begin">

            <cfquery result="rt">
                <cfif mrid eq 0>
                    INSERT INTO
                <cfelse>
                    UPDATE
                </cfif>
                    whs_mr SET
					<cfif val(form.ServiceRequestId)>
                    	`ServiceRequestId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ServiceRequestId#">,
					</cfif>
					<cfif val(form.DepartmentId)>
                    	`DepartmentId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DepartmentId#">,
					</cfif>
                    `Date` = <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(Now(),'dd/mmm/yyyy')#">,
                    `DateRequired` = <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(form.DateRequired,'dd/mmm/yyyy')#">,
                    `DateIssued` = <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(form.DateIssued,'dd/mmm/yyyy')#">,
                    `Note` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Note#">,
					<cfif val(form.WorkOrderId)>
                   		`WorkOrderId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.WorkOrderId#">,
					</cfif>
                    `CreatedByUserId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.UserInfo.UserId#">,
                    `Currency` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Currency#">,
                    `Type` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.type#">
                <cfif mrid neq 0>
                    WHERE MRId = <cfqueryparam cfsqltype="cf_sql_integer" value="#mrid#">
                </cfif>
            </cfquery>

            <cfif mrid eq 0>
                <cfset mrid = rt.GENERATED_KEY/>
            </cfif>

            <!---   update Material Requisition from temp data
                    int0 - Quantity, int1 - Description, int2 - Unit Price ---->
            <cfset h = createobject('component','assetgear.com.awaf.util.helper').Init()/>

            <cfif mr.Type eq "SI">
                <!--- update qor --->
                <cfset qmri = h.GetTempDataToUpdate(mr.MRSIItem)/>
                <cfloop query="qmri">
                	<cfquery>
                    	UPDATE whs_item SET
                        	<cfif mr.id eq 0>
                        		QOR = QOR + #qmri.int1#
                            <cfelse>
                            	<!--- qor = qor - oldqor + newqor --->
                                QOR = ABS(QOR - (SELECT Quantity FROM whs_mr_item WHERE ItemId = #qmri.int0# AND MRId = #mrid#) + #qmri.int1#)
                            </cfif>
                        WHERE ItemId = <cfqueryparam cfsqltype="cf_sql_integer" value="#qmri.int0#"/>
                    </cfquery>
                </cfloop>
                <cfset h.SaveFromTempTable(mr.MRSIItem,
                    "whs_mr_item",
                    "ItemId,Quantity,UnitPrice",
                    "int0,int1,float0",
                    "MRItemId","MRId",mrid)/>
            <cfelse><!--- NI --->
                <cfset h.SaveFromTempTable(mr.MRNIItem,
                    "whs_mr_item",
                    "VPN,Quantity,UnitPrice",
                    "text0,float0,float1",
                    "MRItemId","MRId",mrid)/>
            </cfif>
            <!--- update totalvalue in MR --->
            <cfquery>
                UPDATE `whs_mr` SET
                    TotalValue = (
                        SELECT SUM(UnitPrice*Quantity)
                        FROM `whs_mr_item`
                        WHERE MRId = #mrid#
                    )
                WHERE MRId = #mrid#
            </cfquery>
            <!--- update wo --->
            <cfif form.WorkOrderId neq "">
                <cfquery>
                    UPDATE work_order SET MRId = <cfqueryparam cfsqltype="cf_sql_integer" value="#mrid#"/>
                    WHERE WorkOrderId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.WorkOrderId#"/>
                </cfquery>
            </cfif>
		</cftransaction>

		<cfreturn mrid/>
	</cffunction>

   <cffunction name="ReturnMaterialToWarehouse" returntype="void" access="public">
   	<cfargument name="form" required="yes" type="struct"/>

        <!--- throw error --->
      	<cfif !IsNumeric(form.ReturnedToUserId)>
      		<cfthrow detail="Please select the person that returned item(s) below"/>
      	</cfif>
			<cftransaction action="begin">
			   <cfquery result="rt">
			       INSERT INTO whs_return SET
						Date = <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(Now(),'dd/mmm/yyyy')#">,
						ReturnedByUserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ReturnedByUserId#">,
						DateReturned = <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(form.DateReturned,'dd/mmm/yyyy')#">,
						IssueId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.IssueId#">,
						ReturnedToUserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ReturnedToUserId#">,
						Note = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Note#">
			   </cfquery>
			   <cfset form.id = rt.GENERATED_KEY/>
			   <!---  int0 - ItemId, int1 - Quantity ---->
			   <cfset h = createobject('component','assetgear.com.awaf.util.helper').Init()/>
			   <cfset qRI = h.GetTempDataToUpdate(form.ItemReturn)/>
			   <!--- return the item back to warehouse ---->
			   <cfloop query="qRI">
			      <!--- TODO check that the item to return is not more than the item issued --->
			      <cfquery>
			      	UPDATE whs_item SET
			            QOH = QOH + #qRI.int1#
			         WHERE ItemId = <cfqueryparam cfsqltype="cf_sql_integer" value="#qRI.int0#"/>
			      </cfquery>
			   </cfloop>
			   <!--- update Material Return from temp data --->
			   <cfset h.SaveFromTempTable(form.ItemReturn,
			      "whs_return_item",
			      "ItemId,Quantity",
			      "int0,int1",
			      "ItemReturnId","ReturnId",form.id)/>
			</cftransaction>

    </cffunction>

	<cffunction name="CloseMR" returntype="void" access="public">
   	<cfargument name="mid" required="yes" type="numeric"/>

		<cftransaction action ="begin">
		
			<cfquery name="qT">
				UPDATE whs_item SET
					QOR = 0
				WHERE ItemId IN (
					SELECT ItemId FROM whs_mr_item
					WHERE MRItemId = #val(arguments.mid)#
				)
			</cfquery>

			<cfquery>
				UPDATE whs_mr SET Status = "Close" WHERE MRId = #arguments.mid#
			</cfquery>
			
			<cfquery name="qMr">
				SELECT * FROM whs_mr WHERE MRId = #arguments.mid#
			</cfquery>
			
			<cfif val(qMr.ServiceRequestId)>
				<cfquery>
					UPDATE service_request SET Status = "Close" WHERE ServiceRequestId = #qMr.ServiceRequestId#					
				</cfquery>
			</cfif>
			
		</cftransaction>

    </cffunction>

</cfcomponent>
