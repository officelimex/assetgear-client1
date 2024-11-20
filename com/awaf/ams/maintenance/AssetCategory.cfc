<cfcomponent>

	<cffunction name="Init" access="public" returntype="AssetCategory">

		<cfset this.ASSET_CATEGORY_SQL = '
			SELECT
				*
			FROM asset_category	ac
		'/>

        <cfreturn this/>
	</cffunction>

    <cffunction name="GetParentAssetCategory" access="public" returntype="query">

        <cfquery name="q" cachedwithin="#CreateTime(1,0,0)#">
        	#this.ASSET_CATEGORY_SQL#
            WHERE ac.ParentAssetCategoryId IS NULL
            ORDER BY ac.Name
        </cfquery>

        <cfreturn q/>
    </cffunction>

    <cffunction name="GetAssetCategoryByParent" access="public" returntype="query">
    	<cfargument name="pid" required="yes" hint="parent asset category id"/>

        <cfquery name="qACP" cachedwithin="#CreateTime(1,0,0)#">
        	#this.ASSET_CATEGORY_SQL#
            WHERE ac.ParentAssetCategoryId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pid#"/>
            ORDER BY ac.Name
        </cfquery>

        <cfreturn qACP/>
    </cffunction>

    <cffunction name="GetCategoryInGroup" access="public" returntype="struct" hint="this for select box">

     	<cfset assetVal = ""/>
        <cfset assetDesc = ""/>

    	<cfset q0 = GetParentAssetCategory()/>

        <cfloop query="q0">
            <cfset assetVal = ListAppend(assetVal,q0.AssetCategoryId,'`')/>
            <cfset assetDesc = ListAppend(assetDesc,q0.Name,'`')/>
            <cfset q1 = GetAssetCategoryByParent(q0.AssetCategoryId)/>

            <cfloop query="q1">
            	<cfset q2 = GetAssetCategoryByParent(q1.AssetCategoryId)/>
                <cfif q2.recordcount>
                	<cfset assetVal = ListAppend(assetVal,q1.AssetCategoryId,'`')/>
            		<cfset assetDesc = ListAppend(assetDesc,'&nbsp;&nbsp;&nbsp;&nbsp;'&q1.Name,'`')/>
                	<cfloop query="q2">
						<cfset assetVal = ListAppend(assetVal,q2.AssetCategoryId,'`')/>
            			<cfset assetDesc = ListAppend(assetDesc,'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'&q2.Name,'`')/>
                    </cfloop>
                <cfelse>
					<cfset assetVal = ListAppend(assetVal,q1.AssetCategoryId,'`')/>
            		<cfset assetDesc = ListAppend(assetDesc,'&nbsp;&nbsp;&nbsp;&nbsp;'&q1.Name,'`')/>
                </cfif>
            </cfloop>
        </cfloop>

        <cfset asset.value = assetVal/>
        <cfset asset.description = assetDesc />
        <cfreturn asset/>
    </cffunction>

</cfcomponent>
