<cfcomponent>

	<cffunction name="Init" access="public" returntype="Item">

		<cfset this.WAREHOUSE_ITEM_SQL = '
			SELECT
				whi.*, CONCAT("[",whi.Code,"] ",whi.Description," ",whi.VPN) ItemDescription,
				sl.Code Location,
				um.Title UM
            FROM whs_item whi
			INNER JOIN um ON whi.UMId = um.UMId
			INNER JOIN shelf_location sl ON whi.ShelfLocationId = sl.ShelfLocationId
		'/>

		<cfset this.WAREHOUSE_ITEM_COUNT_SQL = '
			SELECT count(whi.ItemId) c
            FROM whs_item whi
			INNER JOIN um ON whi.UMId = um.UMId
			INNER JOIN shelf_location sl ON whi.ShelfLocationId = sl.ShelfLocationId
		'/>
        <cfreturn this/>
    </cffunction>

    <cffunction name="GetItem" access="public" returntype="query" hint="get al item in the warehouse">
        <cfargument name="wi" type="numeric" required="yes" hint="get Warehouse Item"/>

        <cfquery name="qI_">
            #this.WAREHOUSE_ITEM_SQL#
            WHERE ItemId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wi#">
        </cfquery>

        <cfreturn qI_/>
    </cffunction>

    <cffunction name="GetItems" access="public" returntype="query" hint="get al item in the warehouse">

        <cfquery name="qI" cachedwithin="#createTime(1,0,0)#">
            #this.WAREHOUSE_ITEM_SQL#
            WHERE Obsolete = "No" AND Status <> "Deleted"
						ORDER BY ItemDescription ASC
        </cfquery>

        <cfreturn qI/>
    </cffunction>

    <cffunction name="GetAllUM" access="public" returntype="query" hint="get unit of measurment">
        <cfquery name="qum" cachedwithin="#createTime(5,0,0)#">
            SELECT * FROM `um`
            ORDER BY `title`
        </cfquery>

        <cfreturn qum/>
    </cffunction>

    <cffunction name="GetShelfLocations" access="public" returntype="query" hint="get shelf locations">

        <cfquery name="qsl" cachedwithin="#createTime(5,0,0)#">
             SELECT * FROM `shelf_location`
             ORDER BY `code`
        </cfquery>

        <cfreturn qsl/>
    </cffunction>

    <cffunction name="SaveWarehouseItem" access="public" returntype="numeric" output="true">
    	<cfargument name="form_" type="struct" required="yes" hint="Warehouse Item Data"/>

        	<cfset form = arguments.form_/>
            <cfset form.unitprice = val(trim(replace(form.unitprice,',','','all')))/>
        	<cfset _id = form.id/>
            <cfparam name="form.departmentids" default=""/>
            <cfparam name="form.Currency" default=""/>

			<cfset h = createobject('component','assetgear.com.awaf.util.helper').init()/>

			<!--- get associate asset (Int0 = AssetIds)--->
            <cfset assetIds_ = h.GetTempDataToUpdate(form.AssetIds)/>
            <cfset assetIds_d = h.GetTempDataToDelete(form.AssetIds)/>
            <cfset assetIds_d = valuelist(assetIds_d.Int0)/>
            <cfset assetIds_ = valuelist(assetIds_.Int0)/>

			<cftransaction action="begin">
                <cfquery result="rt">
                    <cfif form.id eq 0>
                        INSERT INTO
                    <cfelse>
                        UPDATE
                    </cfif>
                        whs_item SET
                        Code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Code#">,
                        Description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Description#">,
                        VPN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.VPN#">,
                        UMid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.UMid#">,
                        AssetCategoryId = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.AssetCategoryId)#">,
                        ShelfLocationId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ShelfLocationId#">,
                        Reference = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Reference#">,
                        DepartmentIds = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DepartmentIds#">,
                        MinimumInStore = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MinimumInStore#">,
                        DateAdded = <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(now(),'yyyy-mmm-dd')#">,
                        UnitPrice = <cfqueryparam cfsqltype="cf_sql_float" value="#form.unitprice#">,
                        Currency = <cfqueryparam cfsqltype="cf_sql_char" maxlength="3" value="#form.Currency#">,
                        `Obsolete` = <cfqueryparam cfsqltype="cf_sql_char" maxlength="3" value="#form.Obsolete#">,
                        MaximumInStore = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MaximumInStore#">,
                        AssetIds = <cfqueryparam cfsqltype="cf_sql_varchar" value="#assetIds_#"/>
                    <cfif form.id neq 0>
                    	WHERE ItemId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#">
                    </cfif>
                </cfquery>
                <cfif form.id eq 0>
                    <cfset form.id = rt.GENERATED_KEY/>
                </cfif>
                <!--- update each asset (items id) for each asset in assetIds_ --->
                <cfset updateItemIdsInAsset(form.id,assetIds_,assetIds_d)/>

                <!--- update custom fields --->
                <cfset h.UpdateCustomFields('whs_item')/>

                <cfset f = CreateObject("component","assetgear.com.awaf.util.file").init()/>
                <!--- upload attachments --->
                <cfset s_path = form.AttachmentsSource & "/" & form.Attachments />
     			<cfset d_path = form.AttachmentsDestination & "/whs_item/" & form.id & "/" />
                <cfset f.Move('whs_item',form.id,'a',s_path,d_path)/>
                <!--- upload photos --->
                <cfset s_path = form.PhotosSource & "/" & form.Photos />
     			<cfset d_path = form.PhotosDestination & "/whs_item/" & form.id & "/" />
                <cfset f.Move('whs_item',form.id,'p',s_path,d_path)/>

            </cftransaction>

        <cfreturn form.id/>
	</cffunction>

    <cffunction access="private" name="updateItemIdsInAsset" hint="save the item ids in the asset table" returntype="void">
    	<cfargument name="id" required="yes" type="numeric" hint="item id"/>
        <cfargument name="a_u" required="yes" type="string" hint="asset to update"/>
        <cfargument name="a_d" required="yes" type="string" hint="asset to delete"/>

        <cfif arguments.a_d neq "">
        	<cfquery name="qa_">
            	SELECT ItemIds FROM `asset`
                WHERE AssetId IN (#arguments.a_d#)
            </cfquery>
            <cfset nai = replace(qa_.ItemIds,arguments.id,'','all')/>
            <cfset nai = trim(replace(nai,",,",",","all"))/>
            <!--- remove the first & last commas --->
            <cfif left(nai,1) eq ","><cfset nai = mid(nai,2,len(nai))/></cfif>
            <cfif right(nai,1) eq ","><cfset nai = left(nai,len(nai)-1)/></cfif>
            <cfquery>
                UPDATE `asset` SET ItemIds = <cfqueryparam cfsqltype="cf_sql_varchar" value="#nai#"/>
                WHERE AssetId IN (#arguments.a_d#)
            </cfquery>
        </cfif>

        <cfif arguments.a_u neq "">
        	<cfquery name="qa_">
            	SELECT ItemIds FROM `asset`
                WHERE AssetId IN (#arguments.a_u#)
            </cfquery>
            <cfset nai = replace(qa_.ItemIds,arguments.id,'','all')/>
            <cfset nai = ListAppend(nai,arguments.id)/>
            <cfset nai = trim(replace(nai,",,",",","all"))/>
            <!--- remove the first & last commas --->
            <cfif left(nai,1) eq ","><cfset nai = mid(nai,2,len(nai))/></cfif>
            <cfif right(nai,1) eq ","><cfset nai = left(nai,len(nai)-1)/></cfif>
            <cfquery>
                UPDATE `asset` SET ItemIds = <cfqueryparam cfsqltype="cf_sql_varchar" value="#nai#"/>
                WHERE AssetId IN (#arguments.a_u#)
            </cfquery>
        </cfif>

    </cffunction>

    <cffunction name="DeductFromQOH" access="public" returntype="void" hint="deduct form quantity on hand">
    	<cfargument name="id" required="yes" type="numeric" hint="item id"/>
        <cfargument name="qty" required="yes" type="numeric" hint="quantity to remove"/>

        <cfset qI = GetItem(arguments.id)/>
        <cfif arguments.qty gt qI.QOH>
        	<cfthrow message="The Quantity (#arguments.qty#) you want to issue out for Item '#qI.Description#' is more than the quantity on hand (#qI.QOH#)"/>
        <cfelse>
        	<cfquery>
            	UPDATE whs_item SET QOH = QOH - #arguments.qty#
                WHERE ItemId = #arguments.id#
            </cfquery>
        </cfif>

    </cffunction>

   <cffunction name="ReceiveItem" access="public" returntype="void" hint="update the stock price">
   	<cfargument name="id" required="yes" type="numeric" hint="item id"/>
      <cfargument name="qty" required="yes" type="numeric" hint="qty to reive"/>
		<cfargument name="up" required="yes" type="numeric" hint="the new unit price"/>
      <cfargument name="mr" required="yes" type="numeric" hint="MR Id"/>

		<cfset qI = GetItem(arguments.id)/>
		<cfset np = arguments.up/>

		<!---
		<cfif qI.QOH neq 0>
			<cfset np =((qI.QOH * qI.UnitPrice) + arguments.up) /(qI.QOH+1)/>
		</cfif>
		--->

		<cfquery>
		   UPDATE whs_item SET
				<cfif arguments.up neq 0>
		   		UnitPrice = #arguments.up#,
				</cfif>
		      QOH = QOH + #arguments.qty#,
				QOR = QOR - #arguments.qty#
		   WHERE ItemId = #arguments.id#
		</cfquery>
		<cfquery name="qD">
			SELECT * FROM whs_item
			WHERE ItemId = #arguments.id#
		</cfquery>
		<cfif qD.QOR lt 1>
			<cfquery>
			   UPDATE whs_item SET
					QOR = 0
			   WHERE ItemId = #arguments.id#
			</cfquery>
			<cfquery>
				UPDATE whs_mr_item SET
					`Status` = "Close"
			   WHERE ItemId = #arguments.id# AND MRId = #arguments.mr#
			</cfquery>
		</cfif>

    </cffunction>

    <cffunction name="CorrectItem" access="public" returntype="numeric" hint="correct stock qoh,qor and price">
		<cfargument name="f" required="yes" type="struct" hint="struct data"/>

		<cftransaction action="begin">
			<cfquery>
				UPDATE whs_item SET
					`QOH` = <cfqueryparam cfsqltype="cf_sql_decimal" value="#arguments.f.QOH#"/>,
					`QOR` = <cfqueryparam cfsqltype="cf_sql_decimal" value="#arguments.f.QOR#"/>,
					`UnitPrice` = <cfqueryparam cfsqltype="cf_sql_decimal" value="#arguments.f.UnitPrice#"/>,
					`Currency` = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.f.Currency#"/>
				WHERE `ItemId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.f.Id#"/>
			</cfquery>
			<cfquery result="rt">
				INSERT INTO whs_inventory_adjustment SET
					`AdjustedByUserId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.f.AdjustedByUserId#"/>,
					`ItemId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.f.Id#"/>,
					`QOH` = <cfqueryparam cfsqltype="cf_sql_decimal" value="#arguments.f.QOH#"/>,
					`QOR` = <cfqueryparam cfsqltype="cf_sql_decimal" value="#arguments.f.QOR#"/>,
					`UnitPrice` = <cfqueryparam cfsqltype="cf_sql_decimal" value="#arguments.f.UnitPrice#"/>,
					`Date` = <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.f.Date#"/>,
					`Currency` = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.f.Currency#"/>,
					`Reason` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.f.Reason#"/>
			</cfquery>
			<cfset rtid = rt.GENERATED_KEY/>
		</cftransaction>

		<cfreturn rtid/>
	</cffunction>

</cfcomponent>
