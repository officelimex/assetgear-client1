<cfoutput>

<cfswitch expression="#url.cmd#">
	
    <cfcase value="AddPrivilegeToRole">   	
		<!--- get moduleid ---> 
        <cfquery name="qM">
        	SELECT ModuleId FROM core_page
            WHERE PageId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.pageid#"/>
        </cfquery>
    	<cfquery>
        	INSERT INTO core_privilege SET 
            	RoleId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#"/>,
                PageId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.pageid#"/>,
                ModuleId = <cfqueryparam cfsqltype="cf_sql_integer" value="#qM.ModuleId#"/>,
                Rights = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.rights#"/>
        </cfquery>
    </cfcase>
    
	<cfcase value="SaveModule">
		<cfquery>
        	<cfif form.id eq 0>
            	INSERT INTO
            <cfelse>
				UPDATE 
			</cfif>
            	core_module SET
				Title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.title#">,
                URL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.url#"/>,
				Description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desc#">,
                Position = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Position#"/>,
                `Code` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.code#"/>
        	<cfif form.id neq 0>
			WHERE ModuleId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#">
			</cfif> 
		</cfquery>
	</cfcase> 
    
    <cfcase value="deleteModule">
    	<cfquery>
        	DELETE FROM core_module
            WHERE ModuleId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
        </cfquery>
    </cfcase>
    
	<cfcase value="SavePage">
		<cfquery>
        	<cfif form.id eq 0>
            	INSERT INTO
            <cfelse>
				UPDATE 
			</cfif>
            	core_page SET
            	Title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.title#">,
                `Code` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.code#"/>,
                URL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.url#"/>,
				Description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desc#">,
                ModuleId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.moduleid#"/>,
                Position = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Position#"/>
        	<cfif form.id neq 0>
            	WHERE `PageId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#"> 
			</cfif> 
		</cfquery>
	</cfcase>
    
	<cfcase value="SaveRole">
		<cfquery>
        	<cfif form.id eq 0>
            	INSERT INTO
            <cfelse>
				UPDATE 
			</cfif>
			core_role SET
				Title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.title#">, 
				Description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desc#"> 
        	<cfif form.id neq 0>
            	WHERE RoleId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#">
            </cfif>
		</cfquery>
	</cfcase>
    
	<cfcase value="SavePrivilege">
		<cfquery>
        	<cfif StructKeyExists(form,'Id')>
            	UPDATE 
            <cfelse>
            	INSERT INTO
            </cfif>
			core_privilege SET
				RoleId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.roleid#">, 
				ModuleId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.moduleid#">,
                PageId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.pageid#">,
                Rights = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.rights#"> 
            <cfif StructKeyExists(form,'id')>
            	WHERE PrivilegeId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#">
            </cfif>
		</cfquery>
	</cfcase>
    
	<cfcase value="ModuleGrid">
        <cfparam name="url.page" default="1">
        <cfparam name="url.perpage" default="15">
        <cfparam name="url.sort" default="ModuleId">
        <cfparam name="url.sortOrder" default="15">
        <cfset start = (url.page * url.perpage) - (url.perpage)/>
        <cfquery name="q">
            SELECT * FROM core_module
            ORDER BY #url.sort# #url.sortOrder#
            LIMIT #start#,#url.perpage#
        </cfquery>
        <cfquery name="qT">
            SELECT count(*) c FROM core_module
        </cfquery>
        <cfoutput>
        {"total": #qT.c#,
            "page": #url.page#,
            "rows":[
            <cfloop query="q">
                [#q.ModuleId#, #serializeJSON(q.Title)#, #serializeJSON(q.Description)#, #serializeJSON(q.URL)#,
                <!--- get pages --->
                <cfquery name="qP">
                	SELECT * FROM core_page
                    WHERE ModuleId = <cfqueryparam cfsqltype="cf_sql_integer" value="#q.ModuleId#"/>
                </cfquery>
                "<cfloop query="qP">#qP.Title#<cfif qP.recordcount neq qP.currentrow>, </cfif></cfloop>"
                ]<cfif q.recordcount neq q.currentrow>,</cfif>
            </cfloop>]}
        </cfoutput>
    </cfcase>

	<cfcase value="PageGrid">
        <cfparam name="url.page" default="1">
        <cfparam name="url.perpage" default="15">
        <cfparam name="url.sort" default="PageId">
        <cfparam name="url.sortOrder" default="15">
        <cfset start = (url.page * url.perpage) - (url.perpage)/>
        <cfquery name="q">
            SELECT
				p.*,
				m.Title Module
			FROM core_page p
			INNER JOIN core_module m ON m.ModuleId = p.ModuleId
            ORDER BY <!---#url.sort#--->ModuleId #url.sortOrder#
            LIMIT #start#,#url.perpage#
        </cfquery>
        <cfquery name="qT">
            SELECT count(*) c FROM core_page
        </cfquery>
        <cfoutput>
        {"total": #qT.c#,
            "page": #url.page#,
            "rows":[<cfloop query="q">
                [#q.PageId#,#serializeJSON(q.Module)#,#serializeJSON(q.Title)#,#serializeJSON(q.Description)#,#serializeJSON(q.URL)#]<cfif q.recordcount neq q.currentrow>,</cfif>
            </cfloop>]}
        </cfoutput>
    </cfcase>
    
	<cfcase value="Role_PrivilegeGrid">
        <cfparam name="url.page" default="1">
        <cfparam name="url.perpage" default="15">
        <cfparam name="url.sort" default="ModuleId">
        <cfparam name="url.sortOrder" default="15">
        <cfset start = (url.page * url.perpage) - (url.perpage)/>
        <cfquery name="q">
            SELECT * FROM core_role
            WHERE RoleId <> 1
            ORDER BY #url.sort# #url.sortOrder#
            LIMIT #start#,#url.perpage#
        </cfquery>
        <cfquery name="qT">
            SELECT count(*) c FROM core_role
            WHERE RoleId <> 1
        </cfquery>
        <cfoutput>
        {"total": #qT.c#,
            "page": #url.page#,
            "rows":[
            <cfloop query="q">
                [#q.RoleId#, #serializeJSON(q.Title)#, #serializeJSON(q.Description)#,
                <!--- get pages --->
                <cfquery name="qP">
                	SELECT 
                    	pg.Title PageTitle, m.Title ModuleTitle
                    FROM core_privilege pr
                    LEFT JOIN core_page pg ON pg.PageId = pr.PageId
                    LEFT JOIN core_module m ON m.ModuleId = pr.ModuleId
                    WHERE RoleId = <cfqueryparam cfsqltype="cf_sql_integer" value="#q.RoleId#"/>
                </cfquery>
                "<cfloop query="qP">#qP.ModuleTitle#.<cfif qP.PageTitle eq "">*<cfelse>#qP.PageTitle#</cfif><cfif qP.recordcount neq qP.currentrow>, </cfif></cfloop>"
                ]<cfif q.recordcount neq q.currentrow>,</cfif>
            </cfloop>]}
        </cfoutput>
    </cfcase>
</cfswitch>

</cfoutput>