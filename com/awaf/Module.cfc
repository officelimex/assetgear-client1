<cfcomponent hint="Module">

	<cffunction name="init" access="public" returntype="Module">

		<cfreturn this>
	</cffunction>

    <cffunction name="getModules" access="public" returntype="query">

        <cfquery name="qMs">
        	SELECT * FROM core_module m
            ORDER BY Position ASC
        </cfquery>

        <cfreturn qMs/>
    </cffunction>

    <cffunction name="getModulesInRole" access="public" returntype="query">
		<cfargument required="yes" type="string" name="rl"/>

        <cfquery name="qMs" cachedwithin="#CreateTime(5,0,0)#">
        	SELECT * FROM core_module m
			<cfif arguments.rl neq "HT">
            	WHERE ModuleId IN (
                	SELECT ModuleId FROM core_privilege
                    WHERE `Role` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.rl#"/>
                )
            </cfif>
            ORDER BY Position ASC
        </cfquery>

        <cfreturn qMs/>
    </cffunction>

    <cffunction name="getModule" access="public" returntype="query">
    	<cfargument name="id" required="yes" hint="module id" type="numeric"/>

        <cfquery name="qM">
        	SELECT * FROM core_module
            WHERE ModuleId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#"/>
        </cfquery>

        <cfreturn qM/>
    </cffunction>

    <cffunction name="getPages" access="public" returntype="query">

        <cfquery name="qPs">
        	SELECT
            	p.PageId, p.Title,p.Code, p.Url,
                m.Title Module, m.ModuleId
            FROM core_page p
            INNER JOIN core_module m ON m.ModuleId = p.ModuleId
            ORDER BY m.ModuleId
        </cfquery>

        <cfreturn qPs/>
    </cffunction>

    <cffunction name="getPagesByModule" access="public" returntype="query">
    	<cfargument name="id" required="yes" hint="module id" type="numeric"/>

        <cfquery name="qPs">
        	SELECT * FROM core_page
            WHERE ModuleId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#"/>
            	AND IsTab = "y"
            ORDER BY Position ASC
        </cfquery>

        <cfreturn qPs/>
    </cffunction>

    <cffunction name="getPage" access="public" returntype="query">
    	<cfargument name="id" required="yes" hint="page id" type="numeric"/>

        <cfquery name="qP">
        	SELECT * FROM core_page
            WHERE PageId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#"/>
        </cfquery>

        <cfreturn qP/>
    </cffunction>

    <cffunction name="getRole" access="public" returntype="query" hint="get role">
    	<cfargument name="id" required="yes" hint="role id" type="numeric"/>

        <cfquery name="qP">
        	SELECT * FROM core_role
            WHERE RoleId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#"/>
        </cfquery>

        <cfreturn qP/>
    </cffunction>

    <cffunction name="getRoles" access="public" returntype="query" hint="get all roles">

        <cfquery name="qP">
        	SELECT * FROM core_role
            WHERE RoleId <> 1
        </cfquery>

        <cfreturn qP/>
    </cffunction>

   <cffunction name="getPrivileges" access="public" returntype="query" hint="get all privileges by role and module">
   	<cfargument name="mid" required="yes" hint="module id" type="numeric"/>
		<cfargument name="r" required="yes" hint="role" type="string"/>

      	<cfquery name="qP" cachedwithin="#createTime(0,1,0,0)#">
            SELECT
                pr.*
            FROM core_privilege pr
				WHERE pr.ModuleId = #arguments.mid#
            	AND Role = "#arguments.r#"
      	</cfquery>

      	<cfreturn qP/>
   </cffunction>

   <cffunction name="SetupModuleIds" access="public" returntype="Struct" >
   	<cfargument name="sufix" required="no" default="_app_mod_" type="string"/>

		<cfset qm = getModules()/>
		<cfset rt = structNew() />
		<cfloop query="qm">
      	<cfset tt = replacenocase(Title,' ','','all')/>
			<cfset rt[tt]["Name"] = arguments.sufix & lcase(left(qm.Title,3)) & '_'/>
         <cfset rt[tt]["Id"] = qm.ModuleId/>
         <cfset rt[tt]["Position"] = qm.Position/>
		</cfloop>

		<cfreturn rt/>
	</cffunction>

</cfcomponent>
