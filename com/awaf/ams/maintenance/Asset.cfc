<cfcomponent extends="AssetCategory">

	<cffunction name="Init" access="public" returntype="Asset">

        <cfset this = super.Init()/>
		<cfset this.ASSET_SQL = '
			SELECT
				a.*,
				ac.`Name` AS AssetCategory, ac.ParentAssetCategoryId,
				ac1.`Name` ParentAssetCategory1, ac1.AssetCategoryId, ac1.ParentAssetCategoryId,
				-- al.`Name` AS Location,al.LocDescription,
				rt.Type AS ReadingType,
				a1.Description AS ParentAsset
			FROM
				asset AS a
			LEFT JOIN reading_type AS rt ON rt.ReadingTypeId = a.ReadingTypeId
			LEFT JOIN asset AS a1 ON a1.AssetId = a.ParentAssetId
			LEFT JOIN asset_category ac ON ac.AssetCategoryId = a.AssetCategoryId
			LEFT JOIN asset_category ac1 ON ac1.AssetCategoryId = ac.ParentAssetCategoryId
		'/>

		<cfset this.ASSET_COUNT_SQL = '
			SELECT
				COUNT(a.AssetId) c
			FROM
				asset AS a
			LEFT JOIN reading_type AS rt ON rt.ReadingTypeId = a.ReadingTypeId
			LEFT JOIN asset AS a1 ON a1.AssetId = a.ParentAssetId
			LEFT JOIN asset_category AS ac ON ac.AssetCategoryId = a.AssetCategoryId
			-- parent category
			LEFT JOIN asset_category ac1 ON ac1.AssetCategoryId = ac.ParentAssetCategoryId
		'/>

        <cfset this.METER_READING_SQL = '
			SELECT
				al.AssetLocationId,
				mr.CurrentReading, mr.TimeModified,
				a.Description Asset, a.AssetId,
				l.Name Location,
				rt.Type AS ReadingType, rt.Code ReadingCode
			FROM
				asset_location al
			INNER JOIN asset a ON a.AssetId = al.AssetId
			LEFT JOIN  meter_reading mr ON mr.AssetLocationId = al.AssetLocationId
			INNER JOIN location l ON l.LocationId = al.LocationId
			INNER JOIN reading_type AS rt ON rt.ReadingTypeId = a.ReadingTypeId
		'/>

        <cfset this.METER_READING_COUNT_SQL = '
			SELECT
				COUNT(al.AssetLocationId) c
			FROM
				asset_location al
			INNER JOIN asset a ON a.AssetId = al.AssetId
			INNER JOIN location l ON l.LocationId = al.LocationId
			INNER JOIN reading_type AS rt ON rt.ReadingTypeId = a.ReadingTypeId
		'/>

       <cfset this.FAILURE_REPORT_SQL = '
			SELECT
				fr.*,
				if(FailureOn = "Fix Asset",CONCAT(a.Description," @ ",l.Name," ",IFNULL(al.LocDescription,"")),ServiceDescription) AS FailedOn,
				al.AssetLocationId,al.LocDescription,
				a.Description Asset, a.AssetId,
				CONCAT(ul.Surname," ",ul.OtherNames) AS `CreatedBy`,
				l.Name Location
			FROM
				 asset_failure_report fr
			LEFT JOIN asset_location al ON al.AssetLocationId = fr.AssetLocationId
			LEFT JOIN asset a ON a.AssetId = al.AssetId
			LEFT JOIN location l ON l.LocationId = al.LocationId
			INNER JOIN core_user ul ON ul.UserId = fr.CreatedByUserId
		'/>

        <cfset this.FAILURE_REPORT_COUNT_SQL = '
			SELECT
				COUNT(fr.AssetFailureReportId) c
			FROM
				asset_failure_report fr
            INNER JOIN asset_location al ON al.AssetLocationId = fr.AssetLocationId
			INNER JOIN asset a ON a.AssetId = al.AssetId
			INNER JOIN location l ON l.LocationId = al.LocationId
		'/>

      <cfset this.INCIDENT_REPORT_SQL = '
				SELECT
				ic.*,CONCAT(mid(Description,1,180),IF(LENGTH(Description)>180,"...","")) AS LimitDescription,
				cd.`Name` AS DepartmentName
				FROM
				incident_report AS ic
				INNER JOIN core_user AS cu ON ic.CreatedById = cu.UserId
				INNER JOIN core_department AS cd ON cu.DepartmentId = cd.DepartmentId

		  '/>

      <cfset this.INCIDENT_REPORT_COUNT_SQL = '
				SELECT
				count(ic.IncidentId) c
				FROM
				incident_report AS ic
				INNER JOIN core_user AS cu ON ic.CreatedById = cu.UserId
				INNER JOIN core_department AS cd ON cu.DepartmentId = cd.DepartmentId
		  '/>

        <cfset this.METER_READING_HISTORY_SQL = '
			SELECT
				h.*,
				rt.`Code` AS ReadingTypeCode, rt.Type AS ReadingType, rt.ReadingTypeId,
				a.AssetId,
				al.AssetLocationId,
				Concat(u.Surname," ",u.OtherNames) ReadingBy
			FROM
				reading_history h
			INNER JOIN asset_location al ON h.AssetLocationId = al.AssetLocationId
			INNER JOIN asset a ON a.AssetId = al.AssetId
			INNER JOIN reading_type rt ON rt.ReadingTypeId = a.ReadingTypeId
			-- change the cold below to inner join later
			LEFT JOIN core_user u ON u.UserId = h.ReadingByUserId
		'/>

        <cfset this.ASSET_LOCATION_SQL = '
            SELECT
                al.*,
								a.Description Asset, pl.Name ParentLocation,
                l.LocationId, l.ParentLocationId, l.Name Location
            FROM
                `asset_location` al
            INNER JOIN `location` l ON l.LocationId = al.LocationId
						LEFT JOIN `location` pl ON pl.LocationId = l.ParentLocationId
						INNER JOIN `asset` a ON a.AssetId = al.AssetId
        '/>
		
		 <cfset this.SQL_ASSET_LOCATION_CATEGORY = '
            SELECT
                *
            FROM
                `asset_location_category` alc
        '/>

        <cfset this.LOCATION_SQL = '
            SELECT
                l.LocationId, l.Name Location, l.Name, CONCAT(l.Name,"~",l.LocationId) Location2
            FROM
                `location` l
        '/>
		
		<cfset this.SQL_ASSET_DOWNTIME = '
            SELECT
                CONCAT_WS(" @ ",CONCAT(a.Description," ",ifnull(a.TagLabel,"")),l.Name,ll.Name) AS AssetDescriptions,
				a.Class, al.`Status`, al.AssetLocationId
                
            FROM
                asset_location AS al
            INNER JOIN asset AS a ON al.AssetId = a.AssetId
            INNER JOIN location AS l ON al.LocationId = l.LocationId
            LEFT JOIN location AS ll ON l.ParentLocationId = ll.LocationId
			WHERE a.Class = "Critical" AND a.A = 1
        '/>
        <cfset this.SQL_ASSET_DOWNTIME_COUNT = '
            SELECT
                COUNT(al.AssetLocationId) AS c
            FROM
                asset_location AS al
            INNER JOIN asset AS a ON al.AssetId = a.AssetId
            INNER JOIN location AS l ON al.LocationId = l.LocationId
            LEFT JOIN location AS ll ON l.ParentLocationId = ll.LocationId
			WHERE a.Class = "Critical" AND a.A = 1
        '/>
        <cfreturn this/>
	</cffunction>

    <cffunction name="GetAsset" access="public" returntype="query">
    	<cfargument name="id" type="numeric" required="yes"/>

        <cfquery name="qP" cachedwithin="#createTime(1,0,0)#">
        	#this.ASSET_SQL#
            WHERE a.AssetId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#"/>
        </cfquery>

        <cfreturn qP/>
    </cffunction>

    <cffunction name="GetAssetByAssetLocatonIds" access="public" returntype="query">
    	<cfargument name="ids" type="string" required="yes"/>

        <cfquery name="qP" cachedwithin="#createTime(1,0,0)#">
        	#this.ASSET_LOCATION_SQL#
            WHERE al.AssetLocationId IN (<cfif arguments.ids eq "">0<cfelse>#arguments.ids#</cfif>)
        </cfquery>

        <cfreturn qP/>
    </cffunction>

    <cffunction name="GetParentLocations" returntype="query" access="public">

        <cfquery name="qP" cachedwithin="#createTime(1,0,0)#">
            #this.LOCATION_SQL#
            WHERE l.ParentLocationId IS NULL
        </cfquery>

        <cfreturn qP/>
    </cffunction>

    <cffunction name="GetLocationByParent" returntype="query" access="public">
        <cfargument name="pid" type="numeric" required="true" hint="location parent id" />

        <cfquery name="qP" cachedwithin="#createTime(1,0,0)#">
            #this.LOCATION_SQL#
            WHERE l.ParentLocationId = <cfqueryparam value="#arguments.pid#" cfsqltype="cf_sql_integer"/>
        </cfquery>

        <cfreturn qP/>
    </cffunction>
	
	<cffunction name="GetAssetLocationCategory" access="public" returntype="query">
    	<cfargument name="id" type="numeric" required="no"/>

        <cfquery name="qP" cachedwithin="#createTime(1,0,0)#">
        	#this.SQL_ASSET_LOCATION_CATEGORY#
        	<cfif val(arguments.id)>
            	WHERE alc.LocationCategoryId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#"/>
            </cfif>
        </cfquery>

        <cfreturn qP/>
    </cffunction>

    <cffunction name="GetLocationInGroup" access="public" returntype="struct" hint="this for select box">
        <cfargument name="spacer" type="string"  default="&nbsp;&nbsp;&nbsp;&nbsp;" hint="spacer" />

        <cfset locVal = ""/>
        <cfset locDesc = ""/>
        <cfset locDesc2 = ""/>

        <cfset q0 = GetParentLocations()/>

        <cfloop query="q0">
            <cfset locVal = ListAppend(locVal,q0.LocationId,'`')/>
            <cfset locDesc = ListAppend(locDesc,q0.Name,'`')/>
            <cfset locDesc2 = ListAppend(locDesc2,q0.Location2,'`')/>
            <cfset q1 = GetLocationByParent(q0.LocationId)/>

            <cfloop query="q1">
                <cfset q2 = GetLocationByParent(q1.LocationId)/>
                <cfif q2.recordcount>
                    <cfset locVal = ListAppend(locVal,q1.LocationId,'`')/>
                    <cfset locDesc = ListAppend(locDesc,'#arguments.spacer#'&q1.Name,'`')/>
                    <cfset locDesc = ListAppend(locDesc2,'#arguments.spacer#'&q1.Location2,'`')/>
                    <cfloop query="q2">
                        <cfset locVal = ListAppend(locVal,q2.LocationId,'`')/>
                        <cfset locDesc = ListAppend(locDesc,'#arguments.spacer##arguments.spacer#'&q2.Name,'`')/>
                        <cfset locDesc2 = ListAppend(locDesc2,'#arguments.spacer##arguments.spacer#'&q2.Location2,'`')/>
                    </cfloop>
                <cfelse>
                    <cfset locVal = ListAppend(locVal,q1.LocationId,'`')/>
                    <cfset locDesc = ListAppend(locDesc,'#arguments.spacer#'&q1.Name,'`')/>
                    <cfset locDesc2 = ListAppend(locDesc2,'#arguments.spacer#'&q1.Location2,'`')/>
                </cfif>
            </cfloop>
        </cfloop>

        <cfset loc.value = locVal/>
        <cfset loc.display = locDesc />
        <cfset loc.display2 = locDesc2 />
        <cfreturn loc/>
    </cffunction>

    <cffunction name="GroupAssetByLocation" access="public" returntype="struct" hint="for select input control.">

        <cfquery name="qL" cachedwithin="#CreateTime(1,0,0)#">
        	#this.ASSET_LOCATION_SQL#
            GROUP BY l.LocationId
            ORDER BY l.Name
        </cfquery>

        <cfset data.value = ""/>
        <cfset data.value2 = ""/>
        <cfset data.display = ""/>
        <cfloop query="qL">
        	<!--- add group-option $optgroup$ & $/optgroup$ --->
        	<cfset data.value = ListAppend(data.value,"$optgroup$",'`')/>
            <cfset data.value2 = ListAppend(data.value2,"$optgroup$",'`')/>
            <cfset data.display = ListAppend(data.display,qL.Location,'`')/>
        	<cfset qAL = GetAllAssetInLocation(qL.LocationId)/>
            <cfloop query="qAL">
            	<cfset data.value = ListAppend(data.value,qAL.AssetLocationId,'`')/>
                <cfset data.value2 = ListAppend(data.value2,qAL.AssetId,'`')/>
                <cfset data.display = ListAppend(data.display,qAL.Asset,'`')/>
            </cfloop>
            <!--- add group-option $/optgroup$ --->
            <cfset data.value = ListAppend(data.value,"$/optgroup$",'`')/>
            <cfset data.value2 = ListAppend(data.value2,"$/optgroup$",'`')/>
            <cfset data.display = ListAppend(data.display,qL.Location,'`')/>
        </cfloop>

        <cfreturn data/>
    </cffunction>

    <cffunction name="GetAllAssetInLocation" access="public" returntype="query" hint="get the location of an asset in the asset location table using location id">
    	<cfargument name="lid" required="yes" type="numeric" hint="location id"/>

        <cfquery name="qAL" cachedwithin="#CreateTime(1,0,0)#">
			SELECT
            	al.LocationId, al.AssetLocationId,
                a.Description Asset, a.AssetId
            FROM asset_location al
            INNER JOIN asset a ON a.AssetId = al.AssetId
            WHERE al.LocationId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.lid#"/>
            ORDER BY a.Description
        </cfquery>

        <cfreturn qAL/>
    </cffunction>

    <cffunction name="GetAllAsset" access="public" returntype="query">

        <cfquery name="qP" cachedwithin="#createTime(1,0,0)#">
        	#this.ASSET_SQL#
            ORDER BY a.Description
        </cfquery>

        <cfreturn qP/>
    </cffunction>

    <cffunction name="GetAllAssetLocations" returntype="query" access="public">

        <cfquery name="qAL" cachedwithin="#createTime(1,0,0)#">
            #this.ASSET_LOCATION_SQL#
        </cfquery>

        <cfreturn qAL/>
    </cffunction>

    <cffunction name="GetAssetLocationByAsset" returntype="query" access="public">
        <cfargument name="aid" required="true" type="numeric"/>

        <cfquery name="qAL" cachedwithin="#createTime(1,0,0)#">
            #this.ASSET_LOCATION_SQL#
            WHERE al.AssetId = <cfqueryparam value="#arguments.aid#" cfsqltype="CF_SQL_INTEGER"/>
        </cfquery>

        <cfreturn qAL/>
    </cffunction>

    <cffunction name="GetAssetLocationInWorkOrder" returntype="query" access="public">
        <cfargument name="alid" required="true" type="string" hint="list of asset location id"/>

        <cfif arguments.alid eq "">
            <cfset arguments.alid = 0/>
        </cfif>

        <cfquery name="qAL" cachedwithin="#createTime(1,0,0)#">
            #this.ASSET_LOCATION_SQL#
            WHERE `AssetLocationId` IN (#arguments.alid#)
        </cfquery>

        <cfreturn qAL/>
    </cffunction>

    <cffunction name="SaveAsset" access="public" returntype="numeric" output="true">
    	<cfargument name="form" type="struct" required="yes" hint="Asset data"/>

        <cfset _id = form.id/>
        <!---- throw server side error --->
        <cfif (form.description EQ "") OR (form.AssetCategoryId EQ 0) OR (form.Status EQ "")>
            <cfthrow message="Please check all the tabs to make sure all fields marked with '*' are required" />
        </cfif>

        <cfset h = createobject('component','assetgear.com.awaf.util.helper').Init()/>

		<!--- get associate items (Int0 = ItemIds)--->
        <cfset itemIds_ = h.GetTempDataToUpdate(form.ItemIds)/>
        <cfset itemIds_d = h.GetTempDataToDelete(form.ItemIds)/>
        <cfset itemIds_d = valuelist(itemIds_d.Int0)/>
        <cfset itemIds_ = valuelist(itemIds_.Int0)/>

  		<cftransaction action="begin">
            <!----
            OfficeLocationId = <cfqueryparam  cfsqltype="cf_sql_integer" value="#form.OfficeLocationId#"/>,
            LocationCategoryId = <cfqueryparam  cfsqltype="cf_sql_integer" value="#form.LocationCategoryId#"/>,
            WorkingForId = <cfqueryparam  cfsqltype="cf_sql_integer" value="#form.WorkingForId#"/>,
            ---->
            <cfquery result="rt">
                <cfif form.id eq 0>
                    INSERT INTO
                <cfelse>
                    UPDATE
                </cfif>
                asset SET
                    `Description` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.description#"/>,
                    <cfif val(form.AssetCategoryId)>
                        `AssetCategoryId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.AssetCategoryId)#"/>,
                    </cfif>
                    `Model` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Model#"/>,
                    `Class` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Class#"/>,
                    `SerialNumber` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SerialNumber#"/>,
                    <cfif val(form.ParentAssetId)>
                        `ParentAssetId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.ParentAssetId)#"/>,
                    </cfif>
                    <cfif val(form.ReadingTypeId)>
                        `ReadingTypeId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.ReadingTypeId)#"/>,
                    </cfif>
                    `Ownership` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ownership#"/>,
                    `DepartmentIds` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DepartmentIds#"/>,
                    `Status` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.status#"/>,
                    `Note` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.note#"/>,
                    ItemIds = <cfqueryparam cfsqltype="cf_sql_varchar" value="#itemIds_#"/>
                <cfif form.id neq 0>
                    WHERE AssetId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#"/>
                </cfif>
            </cfquery>
            <cfif form.id eq 0>
                <cfset form.id = rt.GENERATED_KEY/>
            </cfif>
			<!--- update each item (asset id) for each item in itemIds_ --->
            <cfset updateItemIdsInAsset(form.id,itemIds_,itemIds_d)/>

            <!--- update asset location from temp data --->
           	<!--- int0 - LocationId, int1 - Quantity, text0 - Status ---->
			<cfset h.SaveFromTempTable(form.AssetLocation,
				"asset_location",
				"LocationId,LocDescription,Quantity,Status",
				"int0,text0,int1,text1",
				"AssetLocationId","AssetId",form.id)/>
			<!--- update asset qty --->
            <cfquery>
            	UPDATE asset SET Quantity = (
                	SELECT SUM(Quantity) FROM asset_location WHERE AssetId = #form.id#
                )
                WHERE AssetId = #form.id#
            </cfquery>

            <!--- update expiration from temp data --->
			<cfset h.SaveFromTempTable(form.Expiration,
				"expiration",
				"Title,Date,Reminder",
				"text0,date0,int0",
				"ExpirationId","AssetId",form.id)/>

            <!--- update custom fields --->
            <cfset h.UpdateCustomFields('asset')/>

            <cfset f = CreateObject("component","assetgear.com.awaf.util.file").init()/>

            <!--- upload attachments --->
            <cfset s_path = form.AttachmentsSource & "/" & form.Attachments />
 			<cfset d_path = form.AttachmentsDestination & "/asset/" & form.id & "/" />
            <cfset f.Move('asset',form.id,'a',s_path,d_path)/>

            <!--- upload photos --->
            <cfset s_path = form.PhotosSource & "/" & form.Photos />
 			<cfset d_path = form.PhotosDestination & "/asset/" & form.id & "/" />
            <cfset f.Move('asset',form.id,'p',s_path,d_path)/>

        </cftransaction>

        <cfreturn form.id/>
    </cffunction>

    <cffunction access="private" name="updateItemIdsInAsset" hint="save the item ids in the asset table" returntype="void">
    	<cfargument name="id" required="yes" type="numeric" hint="item id"/>
        <cfargument name="a_u" required="yes" type="string" hint="asset to update"/>
        <cfargument name="a_d" required="yes" type="string" hint="asset to delete"/>

        <cfif arguments.a_d neq "">
        	<cfquery name="qa_">
            	SELECT AssetIds FROM `whs_item`
                WHERE ItemId IN (#arguments.a_d#)
            </cfquery>
            <cfset nai = replace(qa_.AssetIds,arguments.id,'','all')/>
            <cfset nai = trim(replace(nai,",,",",","all"))/>
            <!--- remove the first & last commas --->
            <cfif left(nai,1) eq ","><cfset nai = mid(nai,2,len(nai))/></cfif>
            <cfif right(nai,1) eq ","><cfset nai = left(nai,len(nai)-1)/></cfif>
            <cfquery>
                UPDATE `whs_item` SET AssetIds = <cfqueryparam cfsqltype="cf_sql_varchar" value="#nai#"/>
                WHERE ItemId IN (#arguments.a_d#)
            </cfquery>
        </cfif>

        <cfif arguments.a_u neq "">
        	<cfquery name="qa_">
            	SELECT AssetIds FROM `whs_item`
                WHERE ItemId IN (#arguments.a_u#)
            </cfquery>
            <cfset nai = replace(qa_.AssetIds,arguments.id,'','all')/>
            <cfset nai = ListAppend(nai,arguments.id)/>
            <cfset nai = trim(replace(nai,",,",",","all"))/>
            <!--- remove the first & last commas --->
            <cfif left(nai,1) eq ","><cfset nai = mid(nai,2,len(nai))/></cfif>
            <cfif right(nai,1) eq ","><cfset nai = left(nai,len(nai)-1)/></cfif>

            <cfquery>
                UPDATE `whs_item` SET AssetIds = <cfqueryparam cfsqltype="cf_sql_varchar" value="#nai#"/>
                WHERE ItemId IN (#arguments.a_u#)
            </cfquery>
        </cfif>

    </cffunction>

</cfcomponent>
