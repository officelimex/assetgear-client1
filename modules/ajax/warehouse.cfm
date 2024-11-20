<cfoutput>
<cfscript>

   switch (url.cmd)   {
      case 'SaveMaterialReceived':

         param name="form.CloseMR" default="false";

         transaction action="begin" {
            _id = form.id;
            if(form.id eq 0)  {
               start_sql = "INSERT INTO ";
               end_sql = "";
            }
            else  {
               start_sql = "UPDATE ";
               end_sql = "WHERE MaterialReceivedId=#form.id#";
            }
            n_date = DateFormat(form.Date,'yyyy/mm/dd');
            query result="rt"   {
                echo("
                    #start_sql# whs_material_received SET
                    Date                 = '#n_date#',
                    MRId                 = #val(form.MRId)#,
                    `Reference`          = '#form.Reference#',
                    `ReceivedByUserId`   = #val(request.userinfo.userid)#
                    #end_sql#
                ");
            }

            ngnt = usdt = 0;
            h = createobject('component','assetgear.com.awaf.util.helper').Init();
            if(_id EQ 0)   {
               _id = rt.GENERATED_KEY;
               qIS = h.GetTempDate(form.ItemReceived);
               loop query="qIS"  {
                  //--- calculate the total value received
                  if(qIS.text0 eq "NGN")  {
                     ngnt = ngnt + (qIS.int1*qIS.float0);
                  }
                  else  {
                     usdt = usdt + (qIS.int1*qIS.float0);
                  }
                  // update temp unitprice
                  if(qIS.float0 eq 0)  {
                     query{
                        echo('
                           UPDATE temp_data
                              SET `float0` = (SELECT UnitPrice FROM whs_item WHERE ItemId=#qIS.int0#)
                           WHERE TempDataId = #qIS.TempDataId#
                        ');
                     }
                  }
                  //--- update qoh & price
                  application.com.Item.ReceiveItem(qIS.int0, qIS.int1, qIS.float0, form.MRId);

               }
            }

          <!--- update Material received from temp data --->
          <!--- int0 - itemid, int1 - Quantity, text0 - Currency, float0 - UnitPrice, text1 - Reference ---->

            h.SaveFromTempTable(form.ItemReceived,
               "whs_material_received_item",
               "ItemId,Quantity,Currency,UnitPrice,Reference",
               "int0,int1,text0,float0,text1",
               "MaterialReceivedItemId","MaterialReceivedId",_id);

            //--- Update the total price --->
            query {
               echo('
                  UPDATE whs_material_received SET
                     NGNTotal = #val(ngnt)#,
                     USDTotal = #val(usdt)#
                  WHERE MaterialReceivedId = #val(_id)#
               ');
            }
            //--- close MR --->
            if(form.CloseMR eq "true") {
               application.com.Transaction.CloseMR(val(form.MRId));
            }
         }

      break;
   }

</cfscript>


    <cfswitch expression="#url.cmd#">
        <!---getWarehouseItem--->
        <cfcase value="getWarehouseItem">
            <cfset start = (url.page * url.perpage) - (url.perpage)/>
            <cfparam name="url.ob" default=""/>

            <cfquery name="q" cachedwithin="#CreateTime(0,0,0)#">
               #application.com.Item.WAREHOUSE_ITEM_SQL#
               WHERE
               <cfif url.ob eq "">
                Obsolete = "No" AND Status <> "Deleted"
               <cfelse>
                Obsolete = "Yes" AND Status <> "Deleted"
               </cfif>

                <cfif structkeyexists(url,'keyword')>
					AND (#url.Field# LIKE "%#url.keyword#%")

				</cfif>
                ORDER BY #url.sort# #url.sortOrder#
                LIMIT #start#,#url.perpage#
            </cfquery>


            <cfquery name="qT">
                #application.com.Item.WAREHOUSE_ITEM_COUNT_SQL#
                WHERE
                <cfif url.ob eq "">
                 Obsolete = "No" AND Status <> "Deleted"
                <cfelse>
                 Obsolete = "Yes" AND Status <> "Deleted"
                </cfif>
                <cfif structkeyexists(url,'keyword')>
					AND (#url.Field# LIKE "%#url.keyword#%")
				</cfif>
            </cfquery>
            <cfoutput>
            {"total": #qT.c#,
                "page": #url.page#,
                "rows":[<cfloop query="q">
      			   [#q.Itemid#,#serializeJSON(q.Code)#,#serializeJSON(q.Description)#,#serializeJSON(q.VPN)#, "#q.QOH#","#q.QOR#","#q.MinimumInStore#", "<cfif q.Currency eq 'NGN'>&##8358;<cfelseif q.Currency eq 'USD'>$</cfif> #NumberFormat(q.Unitprice,'9,999.99')#",
                	"#q.Location#",
                    <cfswitch expression="#q.Obsolete#">
                    	<cfcase value="Yes">#serializeJSON('<span class="label">Yes</span>')#</cfcase>
                        <cfdefaultcase>#serializeJSON('<span class="label label-success">' & q.Obsolete & '</span>')#</cfdefaultcase>
                    </cfswitch>,
                     "#q.assetcategoryid#","#q.UMId#","#q.ShelfLocationId#","#q.DepartmentIds#"]
                  <cfif q.recordcount neq q.currentrow>,</cfif>
                </cfloop>]}
            </cfoutput>
        </cfcase>

        <!---getMR--->
        <cfcase value="getMR">
            <cfset start = (url.page * url.perpage) - (url.perpage)/>

            <cfquery name="q" cachedwithin="#CreateTime(0,0,0)#">
                #application.com.Transaction.MR_SQL#
                <cfif url.t neq "">
                    WHERE Type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.t#">
                </cfif>
                <cfif structkeyexists(url,'keyword')>
					AND (#url.Field# LIKE "%#url.keyword#%")
				</cfif>
                ORDER BY #url.sort# #url.sortOrder#
                LIMIT #start#,#url.perpage#
            </cfquery>
            <cfquery name="qT">
                #application.com.Transaction.MR_COUNT_SQL#
                <cfif url.t neq "">
                	WHERE Type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.t#">
                </cfif>
                <cfif structkeyexists(url,'keyword')>
					AND (#url.Field# LIKE "%#url.keyword#%")
				</cfif>
            </cfquery>
            {"total": #qT.c#,
                "page": #url.page#,
                "rows":[<cfloop query="q">
       			 [#q.MRId#,"#q.WorkOrderId#","#q.ServiceRequestId#",#serializeJSON(q.Note)#,"#DateFormat(q.DateIssued,'dd-mmm-yyyy')#",
                <cfif q.Currency eq "NGN">"&##8358;#NumberFormat(q.TotalValue,'9,999.99')#"<cfelse>"#DollarFormat(q.TotalValue)#"</cfif>,
                <cfif q.Status eq "open">
                    #serializeJSON('<span class="label label-warning">' & q.Status & '</span>')#
                <cfelse>
                    #serializeJSON('<span class="label">' & q.Status & '</span>')#
                </cfif>]
                  <cfif q.recordcount neq q.currentrow>,</cfif>
                </cfloop>]}
        </cfcase>

        <!---getDeliveryNote--->
        <cfcase value="getDeliveryNote">
            <cfset start = (url.page * url.perpage) - (url.perpage)/>

            <cfquery name="q" cachedwithin="#CreateTime(0,0,0)#">
				#application.com.Transaction.DN_SQL#
                <cfif structkeyexists(url,'keyword')>
					WHERE (#url.Field# LIKE "%#url.keyword#%")
				</cfif>
                ORDER BY #url.sort# DESC
                LIMIT #start#,#url.perpage#
            </cfquery>
            <cfquery name="qT">
                #application.com.Transaction.DN_COUNT_SQL#
                <cfif structkeyexists(url,'keyword')>
					WHERE (#url.Field# LIKE "%#url.keyword#%")
				</cfif>
            </cfquery>
            <cfoutput>
            {"total": #qT.c#,
                "page": #url.page#,
                "rows":[<cfloop query="q">
       			 [#q.DeliveryNoteID#,#q.MRId#,#serializeJSON(q.Department)#,#serializeJSON(q.DeliverTo)#, #serializeJSON(q.Reference)#,"#DateFormat(q.Date,'dd-mmm-yyyy')#"]
                  <cfif q.recordcount neq q.currentrow>,</cfif>
                </cfloop>]}
            </cfoutput>
        </cfcase>

        <!---getmDeliveryNote--->
        <cfcase value="getmDeliveryNote">
            <cfset start = (url.page * url.perpage) - (url.perpage)/>

            <cfquery name="q" cachedwithin="#CreateTime(0,0,0)#">
                SELECT * FROM whs_mdn
            <cfif structkeyexists(url,'keyword')>
					WHERE (#url.Field# LIKE "%#url.keyword#%")
				</cfif>
                ORDER BY #url.sort# DESC
                LIMIT #start#,#url.perpage#
            </cfquery>
            <cfquery name="qT">
                SELECT COUNT(DeliveryNoteID) AS c FROM whs_mdn
                <cfif structkeyexists(url,'keyword')>
					WHERE (#url.Field# LIKE "%#url.keyword#%")
				</cfif>
            </cfquery>
            <cfoutput>
            {"total": #qT.c#,
                "page": #url.page#,
                "rows":[<cfloop query="q">
       			 [#q.DeliveryNoteID#,#serializeJSON(q.Remark)#, #serializeJSON(q.ItemFrom)#,#serializeJSON(q.Destination)#,"#DateFormat(q.Date,'dd-mmm-yyyy')#",#serializeJSON(q.RequestedBy)#,#serializeJSON(q.DeliverToUser)#]
                  <cfif q.recordcount neq q.currentrow>,</cfif>
                </cfloop>]}
            </cfoutput>
        </cfcase>

        <!---getFuelRequest--->
        <cfcase value="getFuelRequest">
            <cfset start = (url.page * url.perpage) - (url.perpage)/>

            <cfquery name="q" cachedwithin="#CreateTime(0,0,0)#">
                SELECT *
				FROM vh_fuel_request

                <cfif structkeyexists(url,'keyword')>
					WHERE (#url.Field# LIKE "%#url.keyword#%")
				</cfif>
                ORDER BY #url.sort# #url.sortOrder#
                LIMIT #start#,#url.perpage#
            </cfquery>
            <cfquery name="qT">
                SELECT count(*) c
                FROM whs_dn
                <cfif structkeyexists(url,'keyword')>
					WHERE (#url.Field# LIKE "%#url.keyword#%")
				</cfif>
            </cfquery>
            <cfoutput>
            {"total": #qT.c#,
                "page": #url.page#,
                "rows":[<cfloop query="q">
       			 [#q.DeliveryNoteID#,#q.MRId#,#serializeJSON(q.Destination)#," #DateFormat(q.Date,'dd-mmm-yyyy')#",#serializeJSON(q.ItemFrom)#, #serializeJSON(q.ReceivedBy)#, #serializeJSON(q.VerifiedBy)#,#serializeJSON(q.VehicleNo)#]
                  <cfif q.recordcount neq q.currentrow>,</cfif>
                </cfloop>]}
            </cfoutput>
        </cfcase>

        <!---getMaterialReceived--->
        <cfcase value="getMaterialReceived">
            <cfset start = (url.page * url.perpage) - (url.perpage)/>

           <cfquery name="q" cachedwithin="#CreateTime(0,0,0)#">
                #application.com.Transaction.MATERIAL_RECEIVED_SQL#
                <cfif structkeyexists(url,'keyword')>
					WHERE (#url.Field# LIKE "%#url.keyword#%")
				</cfif>
                ORDER BY Date DESC, #url.sort# #url.sortOrder#
                LIMIT #start#,#url.perpage#
            </cfquery>
            <cfquery name="qT">
                #application.com.Transaction.MATERIAL_RECEIVED_COUNT_SQL#
                <cfif structkeyexists(url,'keyword')>
					WHERE (#url.Field# LIKE "%#url.keyword#%")
				</cfif>
            </cfquery>
            {"total": #qT.c#,
                "page": #url.page#,
                "rows":[<cfloop query="q">
       			 [#q.MaterialReceivedId#,"#q.MRId#",#serializeJSON(q.Reference)#,#serializeJSON(q.ReceivedBy)#,"#DateFormat(q.Date,'dd-mmm-yyyy')#"]
                  <cfif q.recordcount neq q.currentrow>,</cfif>
                </cfloop>]}
        </cfcase>

        <!---getMaterialIssue--->
         <cfcase value="getMaterialIssue">
            <cfset start = (url.page * url.perpage) - (url.perpage)/>

            <cfquery name="q" cachedwithin="#CreateTime(0,0,0)#">
               #application.com.Transaction.MI_SQL#
               <cfif structkeyexists(url,'keyword')>
                  WHERE (#url.Field# LIKE "%#url.keyword#%")
               </cfif>
               ORDER BY IssueId #url.sortOrder#
               LIMIT #start#,#url.perpage#
            </cfquery>
            <cfquery name="qT">
               #application.com.Transaction.MI_COUNT_SQL#
               <cfif structkeyexists(url,'keyword')>
                  WHERE (#url.Field# LIKE "%#url.keyword#%")
               </cfif>
            </cfquery>
            {"total": #qT.c#,
            "page": #url.page#,
            "rows":[<cfloop query="q">
            [#q.IssueId#,"#q.MRId#","#q.WorkOrderId#",#serializeJSON(q.Remark)#,"#DateFormat(q.DateIssued,'dd-mmm-yyyy')#",#serializeJSON(q.IssuedBy)#, #serializeJSON(q.IssuedTo)#, "#DollarFormat(q.USDTotal)#", "&##8358;#numberformat(q.NGNTotal,'9,999.99')#"]
            <cfif q.recordcount neq q.currentrow>,</cfif></cfloop>]}
         </cfcase>

		<!---getMaterialReturn--->
        <cfcase value="getMaterialReturn">
            <cfset start = (url.page * url.perpage) - (url.perpage)/>

            <cfquery name="q" cachedwithin="#CreateTime(0,0,0)#">
				#application.com.Transaction.MATERIAL_RETURN_SQL#
                <cfif structkeyexists(url,'keyword')>
					WHERE (#url.Field# LIKE "%#url.keyword#%")
				</cfif>
                ORDER BY #url.sort# #url.sortOrder#
                LIMIT #start#,#url.perpage#
            </cfquery>
            <cfquery name="qT">
                #application.com.Transaction.MATERIAL_RETURN_COUNT_SQL#
                <cfif structkeyexists(url,'keyword')>
					WHERE (#url.Field# LIKE "%#url.keyword#%")
				</cfif>
            </cfquery>
            <cfoutput>
            {"total": #qT.c#,
                "page": #url.page#,
                "rows":[<cfloop query="q">
       			 [#q.ReturnId#,#serializeJSON(q.Note)#,#serializeJSON(q.Department)#," #DateFormat(q.Date,'dd-mmm-yyyy')#","#DateFormat(q.DateReturned,'dd-mmm-yyyy')#",#serializeJSON(q.ReturnedBy)#, #serializeJSON(q.ReturnedTo)#]
                  <cfif q.recordcount neq q.currentrow>,</cfif>
                </cfloop>]}
            </cfoutput>
        </cfcase>

        <!---Save Warehouse Item--->
        <cfcase value="SaveWarehouseItem">
            <cfset n_whs_item = application.com.Item.SaveWarehouseItem(form)/>

            Warehouse #form.Description# with Id: #n_whs_item# was successfuly updated...

            <cfobjectcache action="clear"/>
        </cfcase>

        <!---SaveMR--->
        <cfcase value="SaveMR">

            <cfset form.Type = url.Type/>

            <cfset mrid = application.com.Transaction.SaveMR(form)/>
            MR #mrid# was updated...
        </cfcase>

        <cfcase value="SaveDrillingReturns">

        	<cftransaction action="begin">

                <cfquery result="rt">
                    <cfif form.id eq 0>
                        INSERT INTO
                    <cfelse>
                        UPDATE
                    </cfif>
                        drilling_return SET
                        `ReturedDate` = <cfqueryparam cfsqltype="cf_sql_date" value="#form.ReturedDate#">,
                        ReturedBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ReturedBy#">,
                        `CreatedDate` = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                        Comment = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.Comment#"/>,
                        RecievedById = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RecievedById#"/>,
                        CreatedById = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.userid#"/>
                    <cfif form.id neq 0>
                        WHERE DReturnedId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#">
                    </cfif>
                </cfquery>
                <cfif form.id eq 0>
                	<cfset form.id = rt.GENERATED_KEY/>
                </cfif>
				<cfset h = createobject('component','assetgear.com.awaf.util.helper').Init()/>
                <!--- int0 - Quantity, int1 - Description, int2 - Unit Price ---->
				<!--- update Material Requisition from temp data --->
                <cfset h.SaveFromTempTable(form.DReturnedItemId,
					"drilling_returned_item",
					"ItemDescription,Qty,Status",
					"text0,int0,text1",
					"DReturnedItemId","DReturnedId",form.id)/>

                <!--- close MR --->
			</cftransaction>

        </cfcase>

        <!--- SaveDN --->
        <cfcase value="SaveDN">

            <cfparam name="form.CreatedByUserId" default="#request.userinfo.userid#"/>
            <cfparam name="form.CloseMR" default="false"/>

        	<cftransaction action="begin">

                <cfquery result="rt">
                    <cfif form.id eq 0>
                        INSERT INTO
                    <cfelse>
                        UPDATE
                    </cfif>
                        whs_dn SET
                        `Date` = <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(Now(),'dd/mmm/yyyy')#">,
                        DeliverToUserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DeliverToUserId#">,
                        MRId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MRId#">,
                        Reference = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Reference#">,
                        Remark = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Remark#">,
                        `CreatedByUserId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CreatedByUserId#"/>
                    <cfif form.id neq 0>
                        WHERE DeliveryNoteId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#">
                    </cfif>
                </cfquery>
                <cfif form.id eq 0>
                	<cfset form.id = rt.GENERATED_KEY/>
                </cfif>
				<cfset h = createobject('component','assetgear.com.awaf.util.helper').Init()/>
                <!--- int0 - Quantity, int1 - Description, int2 - Unit Price ---->
				<!--- update Material Requisition from temp data --->
                <cfset h.SaveFromTempTable(form.DNItem,
					"whs_dn_item",
					"MRItemId,Description,Quantity",
					"int0,text0,int1",
					"DNItemId","DeliveryNoteId",form.id)/>

                <!--- close MR --->
                <cfif form.CloseMR eq "true">
                	<cfset application.com.Transaction.CloseMR(val(form.MRId))/>
                </cfif>
			</cftransaction>

        </cfcase>

        <!--- SaveMDN --->
        <cfcase value="SaveMDN">
            <cfparam name="form.CreatedByUserId" default="#request.userinfo.userid#"/>
            <cfparam name="form.CloseMR" default="false"/>

        	<cftransaction action="begin">

                <cfquery result="rt">
                    <cfif form.id eq 0>
                        INSERT INTO
                    <cfelse>
                        UPDATE
                    </cfif>
                        whs_mdn SET
                        RequestedBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RequestedBy#">,
                        DeliverToUser = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DeliverToUser#">,
                        Destination = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Destination#">,
                        Attn = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Attn#">,
                        ItemFrom = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ItemFrom#">,
                        Requisition = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Requisition#">,
                        `CreatedByUserId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CreatedByUserId#"/>,
                        `Date` = <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(form.Date,'dd/mmm/yyyy')#">,
                        Remark = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Remark#">,
                        HauledBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.HauledBy#">,
                        LoadedBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.LoadedBy#">,
                        VehicleNo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.VehicleNo#">,
                        LoadedDate = <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(form.LoadedDate,'dd/mmm/yyyy')#">

                    <cfif form.id neq 0>
                        WHERE DeliveryNoteId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#">
                    </cfif>
                </cfquery>
                <cfif form.id eq 0>
                	<cfset form.id = rt.GENERATED_KEY/>
                </cfif>
				<cfset h = createobject('component','assetgear.com.awaf.util.helper').Init()/>
                <!--- int0 - Quantity, int1 - Description, int2 - Unit Price ---->
				<!--- update Material Requisition from temp data--->
                <cfset h.SaveFromTempTable(form.DNItem,
        					"whs_mdn_item",
        					"Description,Quantity,Unit",
        					"text0,float0,text1",
        					"DNItemId","DeliveryNoteId",form.id)/>

                <!--- close MR --->
			</cftransaction>

        </cfcase>


        <!---SaveMaterialIssue--->
        <cfcase value="SaveMaterialIssue">

            <cfset form.WorkOrderId = val(form.WorkOrderId)/>
            <cfif val(form.IssuedToUserId) eq 0>
            	<cfthrow message="Please select who received this item. the field 'Received by' field must be green"/>
            </cfif>

            <!--- get WO description and add it to remark if empty --->
            <cfif form.WorkOrderId neq 0>
            	<cfset oWO = application.com.WorkOrder.GetWorkOrder(form.WorkOrderId)/>
                <cfif form.remark eq "">
                	<cfset form.remark = oWO.Description/>
                </cfif>
            </cfif>

            <cftransaction action="begin">
				<cfset _id = form.id/>
                <cfquery result="rt">
                    <cfif form.id eq 0>
                        INSERT INTO
                    <cfelse>
                        UPDATE
                    </cfif>
                        whs_issue SET
                        DepartmentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DepartmentId#">,
                        <cfif form.id eq 0>
                            Date = <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(Now(),'dd/mmm/yyyy')#">,
                            IssuedByUserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.Userinfo.UserId#">,
                        </cfif>
                        DateIssued = <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(form.DateIssued,'dd/mmm/yyyy')#">,
                        <cfif val(form.MRId)>
                            MRId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MRId#">,
                        </cfif>
                        <cfif val(form.WorkOrderId)>
                            WorkOrderId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.WorkOrderId#">,
                        </cfif>
                        IssuedToUserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.IssuedToUserId#">,
                        Ref = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ref#"/>,
                        `remark` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.remark#"/>
                    <cfif form.id neq 0>
                        WHERE IssueId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#">
                    </cfif>
                </cfquery>

                <cfset h = createobject('component','assetgear.com.awaf.util.helper').Init()/>
                <cfif _id EQ 0>
                    <cfset _id = rt.GENERATED_KEY/>
                    <cfset qIS = h.GetTempDate(form.ItemIssue)/>
                    <cfloop query="qIS">
                    	<!--- update the status of the work order item to "close" --->
                        <cfquery>
                        	UPDATE work_order_item SET
                            	`Status` = "Close"
                            WHERE ItemId = <cfqueryparam cfsqltype="cf_sql_integer" value="#qIS.int0#"/>
                            	AND WorkOrderId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.WorkOrderId#"/>
                        </cfquery>
                        <!--- update qoh --->
                        <cfset application.com.Item.DeductFromQOH(qIS.int0, qIS.int1)/>
                    </cfloop>
                </cfif>

                <!--- update Material Issue from temp data --->
                    <!---  int0 - itemid, int1 - Quantity ---->

				<cfset h.SaveFromTempTable(form.ItemIssue,
                    "whs_issue_item",
                    "ItemId,Quantity",
                    "int0,int1",
                    "ItemIssueId","IssueId",_id)/>
            </cftransaction>

			<!--- update price of issued item --->
            <cfquery name="qIItem">
                SELECT * FROM whs_issue_item WHERE IssueId = #_id#
            </cfquery>
            <cfset dtotal = ntotal = 0/>
            <cfloop query="qIItem">
            	<cfquery name="qI">
                	SELECT UnitPrice,Currency FROM whs_item WHERE ItemId = #qIItem.ItemId#
                </cfquery>
                <cfquery>
                    UPDATE whs_issue_item SET
                        UnitPrice = <cfqueryparam cfsqltype="cf_sql_float" value="#qI.unitprice#"/>,
                        Currency = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qI.Currency#"/>
                    WHERE ItemIssueId = #qIItem.ItemIssueId#
                </cfquery>
                <cfif qI.Currency eq "NGN">
                	<cfset ntotal = ntotal + (qI.unitprice*qIItem.Quantity)/>
                <cfelse>
                	<cfset dtotal = dtotal + (qI.unitprice*qIItem.Quantity)/>
                </cfif>
            </cfloop>
            <!--- save total price --->
            <cfquery>
            	UPDATE whs_issue SET
                	USDTotal = #val(dtotal)#,
                    NGNTotal = #val(ntotal)#
                WHERE IssueId = #_id#
            </cfquery>
        </cfcase>


        <!---SaveMaterialReturn--->
        <cfcase value="SaveMaterialReturn">

            <cfset form.ReturnedToUserId = Request.UserInfo.UserId/>
            <cfset application.com.Transaction.ReturnMaterialToWarehouse(form)/>

        </cfcase>

        <cfcase value="getxxx">
        	<cfquery name="qE" cachedwithin="#CreateTime(1,0,0)#">
            	SELECT
                	CONVERT(CONCAT(i.Description,'~',i.ItemId) USING utf8) Item, i.ItemId,
                    mri.Quantity, mri.MRItemId
                FROM whs_mr_item mri
                INNER JOIN whs_item i ON i.ItemId = mri.ItemId
                WHERE MRId = <cfqueryparam value="#val(url.id)#" cfsqltype="cf_sql_integer"/>
            </cfquery>
            <!--- clear temp data --->
            <cfquery>
                UPDATE temp_data SET `Flag` = "d"
                WHERE `Session` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#"/>
            </cfquery>
           {"data":[
                <cfloop query="qE">
                	<cfquery result="rt">
                    	INSERT INTO temp_data SET
                    	`Session` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#"/>,
                        `int0` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qE.ItemId#"/>,
                        `int1` = <cfqueryparam cfsqltype="cf_sql_integer" value="#qE.Quantity#"/>,
                        <!---`PK` = <cfqueryparam cfsqltype="cf_sql_integer" value="#qE.MRItemId#"/>,--->
                        `Flag` = "n",
                        `TimeCreated` = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"/>
                    </cfquery>
                	[#SerializeJSON(qE.Item)#,#qE.Quantity#,#rt.GENERATED_KEY#]<cfif qE.recordcount neq qE.currentrow>,</cfif>
                </cfloop>
            ]}
        </cfcase>

        <cfcase value="getWorkOrderNI">

            <cfquery name="qE">
            	#application.com.WorkOrder.WORK_ORDER_ITEM_SQL#
                WHERE wo.WorkOrderId = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer"/>
                	AND woi.ItemId IS NULL
            </cfquery>

            <cfquery>
                UPDATE temp_data SET `Flag` = "d"
                WHERE `Session` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#"/>
            </cfquery>
           {"data":[
                <cfloop query="qE">
                    <cfquery result="rt">
                        INSERT INTO temp_data SET
                        `Session` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#"/>,
                        `text0` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qE.Description#"/>,
                        `float0` = <cfqueryparam cfsqltype="cf_sql_decimal" value="#qE.Quantity#"/>,
                        `float1` = <cfqueryparam cfsqltype="cf_sql_decimal" value="#qE.Unitprice#"/>,
                        `Flag` = "n",
                        `TimeCreated` = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"/>
                    </cfquery>
                    [#SerializeJSON(qE.Description)#,#qE.Quantity#,#numberformat(qE.UnitPrice,'999.99')#,#rt.GENERATED_KEY#]<cfif qE.recordcount neq qE.currentrow>,</cfif>
                </cfloop>
            ]}
        </cfcase>

        <cfcase value="getServiceRequestItem">

            <cfquery name="qE">
            	SELECT * FROM service_request_item
                WHERE ServiceRequestId = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer"/>
            </cfquery>
            <cfquery>
                UPDATE temp_data SET `Flag` = "d"
                WHERE `Session` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#"/>
            </cfquery>
           {"data":[
                <cfloop query="qE">
                    <cfquery result="rt">
                        INSERT INTO temp_data SET
                        `Session` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#"/>,
                        `text0` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qE.Description#"/>,
                        `float0` = <cfqueryparam cfsqltype="cf_sql_integer" value="#qE.Quantity#"/>,
                        `float1` = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#qE.Unitprice#"/>,
                        `Flag` = "n",
                        `TimeCreated` = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"/>
                    </cfquery>
                    [#SerializeJSON(qE.Description)#,#qE.Quantity#,#numberformat(qE.UnitPrice,'999.99')#,#rt.GENERATED_KEY#]<cfif qE.recordcount neq qE.currentrow>,</cfif>
                </cfloop>
            ]}
        </cfcase>

        <cfcase value="getWorkOrder">
            <!---<cfset qE = application.com.WorkOrder.GetWorkOrderItems(url.id)/>--->
            <cfquery name="qE">
            	#application.com.WorkOrder.WORK_ORDER_ITEM_SQL#
                WHERE wo.WorkOrderId = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer"/>
                	AND woi.ItemId <> 0
            </cfquery>
            <cfquery>
                UPDATE temp_data SET `Flag` = "d"
                WHERE `Session` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#"/>
            </cfquery>
           {"data":[
                <cfloop query="qE">
                    <cfquery result="rt">
                        INSERT INTO temp_data SET
                        `Session` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#"/>,
                        `int0` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qE.ItemId#"/>,
                        `int1` = <cfqueryparam cfsqltype="cf_sql_integer" value="#qE.Quantity#"/>,
                        `float0` = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#qE.Unitprice#"/>,
                        `Flag` = "n",
                        `TimeCreated` = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"/>
                    </cfquery>
                    [#SerializeJSON(qE.ItemDescription)#,#qE.Quantity#,#numberformat(qE.UnitPrice,'999.99')#,#rt.GENERATED_KEY#]<cfif qE.recordcount neq qE.currentrow>,</cfif>
                </cfloop>
            ]}
        </cfcase>

        <!--- does not include unitprice, unitprice will be save automaticaly--->
        <cfcase value="getWorkOrderItems2">
            <!---<cfset qE = application.com.WorkOrder.GetWorkOrderItems(url.id)/>--->
            <cfquery name="qE">
            	#application.com.WorkOrder.WORK_ORDER_ITEM_SQL#
                WHERE wo.WorkOrderId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
				<!--- remove item not in the warehouse and already issued --->
                	AND woi.ItemId <> 0
                	AND woi.Status = "Open"
            </cfquery>
            <cfquery>
                UPDATE temp_data SET `Flag` = "d"
                WHERE `Session` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#"/>
            </cfquery>
           {"data":[
                <cfloop query="qE">

                    <cfquery result="rt">
                        INSERT INTO temp_data SET
                        `Session` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#"/>,
                        `int0` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qE.ItemId#"/>,
                        `int1` = <cfqueryparam cfsqltype="cf_sql_integer" value="#qE.Quantity#"/>,
                        `Flag` = "n",
                        `TimeCreated` = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"/>
                    </cfquery>
                    [#SerializeJSON(qE.ItemDescription)#,#qE.Quantity#,#rt.GENERATED_KEY#]<cfif qE.recordcount neq qE.currentrow>,</cfif>

                </cfloop>
            ]}
        </cfcase>

        <!--- get mr items for material to reveive --->
        <cfcase value="getMaterialToReceive">
            <cfset qE = application.com.Transaction.GetMRItems(url.id)/>
            <!--- delete the current date --->
            <cfquery>
                UPDATE temp_data SET `Flag` = "d"
                WHERE `Session` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#"/>
            </cfquery>
           {"data":[
                <cfloop query="qE">
                    <cfquery result="rt">
                        INSERT INTO temp_data SET
                        `Session` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#"/>,
                        `int0` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qE.ItemId#"/>,
                        `int1` = <cfqueryparam cfsqltype="cf_sql_integer" value="#qE.Quantity#"/>,
                        `text0` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qE.Currency#"/>,
                        `float0` = <cfqueryparam cfsqltype="cf_sql_integer" value="#qE.UnitPrice#"/>,
                        `text1` = "",
                        `Flag` = "n",
                        `TimeCreated` = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"/>
                    </cfquery>
                    [#SerializeJSON(qE.ItemDescription)#,#qE.Quantity#,"#qE.Currency#",#Numberformat(qE.UnitPrice,'999.99')#,"",#rt.GENERATED_KEY#]<cfif qE.recordcount neq qE.currentrow>,</cfif>
                </cfloop>
            ]}
        </cfcase>

        <!--- get mr items for delivery note--->
        <cfcase value="getMaterialToDeliver">
            <cfset qE = application.com.Transaction.GetMRNIItems(url.id)/>
            <!--- delete the current date --->
            <cfquery>
                UPDATE temp_data SET `Flag` = "d"
                WHERE `Session` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#"/>
            </cfquery>
           {"data":[
                <cfloop query="qE">
                    <cfquery result="rt">
                        INSERT INTO temp_data SET
                        `Session` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#"/>,
                        `int0` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qE.MRItemId#"/>,
                        `int1` = <cfqueryparam cfsqltype="cf_sql_integer" value="#qE.Quantity#"/>,
                        `text0` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qE.VPN#"/>,
                        `Flag` = "n",
                        `TimeCreated` = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"/>
                    </cfquery>
                    [#SerializeJSON(qE.VPN)#,#qE.Quantity#,#rt.GENERATED_KEY#]<cfif qE.recordcount neq qE.currentrow>,</cfif>
                </cfloop>
            ]}
        </cfcase>


        <cfcase value="getIssue">
        	<cfquery name="qE" cachedwithin="#CreateTime(1,0,0)#">
                SELECT
                    ii.*,
                    CONVERT(CONCAT(it.Description,'~',ii.ItemId) USING utf8) Description
                FROM
                    whs_issue_item AS ii
                INNER JOIN whs_item AS it ON ii.ItemId = it.ItemId
                WHERE ii.IssueId = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(url.Id)#">
            </cfquery>
            <!--- clear temp data --->
            <cfquery>
                UPDATE temp_data SET `Flag` = "d"
                WHERE `Session` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#"/>
            </cfquery>
           {"data":[
                <cfloop query="qE">
                	<cfquery result="rt">
                    	INSERT INTO temp_data SET
                    	`Session` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#"/>,
                        `int0` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qE.ItemId#"/>,
                        `int1` = <cfqueryparam cfsqltype="cf_sql_integer" value="#qE.Quantity#"/>,
                        <!---`PK` = <cfqueryparam cfsqltype="cf_sql_integer" value="#qE.MRItemId#"/>,--->
                        `Flag` = "n",
                        `TimeCreated` = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"/>
                    </cfquery>
                	[#SerializeJSON(qE.Description)#,#qE.Quantity#,#rt.GENERATED_KEY#]<cfif qE.recordcount neq qE.currentrow>,</cfif>
                </cfloop>
            ]}
        </cfcase>

      <!--- correct item in the warehouse --->
		<cfcase value="CorrectItem">
			<!--- set other forms parameters --->
			<cfset form.AdjustedByUserId = request.userinfo.userid/>
			<cfset application.com.Item.CorrectItem(form)/>
			Item corrected!
		</cfcase>

    </cfswitch>



</cfoutput>
