<cfoutput>
    <cfswitch expression="#url.cmd#">    
    	
        <!---getPermit--->
        <cfcase value="getPermit">
        	<cfset start = (url.page * url.perpage) - (url.perpage)/>
            <cfquery name="q">
                #application.com.Permit.PERMIT_SQL#
                <cfif url.cid neq "" >
               		WHERE d.DepartmentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cid#"/>
                    <cfif structkeyexists(url,'keyword')>
                        AND  (#url.Field# LIKE "%#url.keyword#%")
                    </cfif>
                <cfelse>
                    <cfif structkeyexists(url,'keyword')>
                        WHERE  #url.Field# LIKE "%#url.keyword#%"
                    </cfif>
                </cfif>

                ORDER BY #url.sort# #url.sortOrder#
                LIMIT #start#,#url.perpage#
            </cfquery>
           
            <cfquery name="qT">
                #application.com.Permit.PERMIT_COUNT_SQL#
                <cfif url.cid neq "" >
                    WHERE d.DepartmentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cid#"/>
                    <cfif structkeyexists(url,'keyword')>
                        AND  (#url.Field# LIKE "%#url.keyword#%")
                    </cfif>
                <cfelse>
                    <cfif structkeyexists(url,'keyword')>
                        WHERE  #url.Field# LIKE "%#url.keyword#%"
                    </cfif>
                </cfif>
            </cfquery>
            
            <cfoutput>
            {"total": #qT.c#,
                "page": #url.page#,
                "rows":[<cfloop query="q">
       			 [#q.PermitId#,#q.JHAId#,#serializeJSON(q.Work)#, "#DateFormat(q.Date,'dd-mmm-yyyy')#","#DateFormat(q.EndTime,'dd-mmm-yyyy')#",#serializeJSON(q.Status)#]
                  <cfif q.recordcount neq q.currentrow>,</cfif>
                </cfloop>]}
            </cfoutput>
        </cfcase>

        <!--- get un approved permit--->
        <cfcase value="GetUnApprovedPermit">
        	<cfset start = (url.page * url.perpage) - (url.perpage)/>
            <cfquery name="q">
                #application.com.Permit.PERMIT_SQL#
                WHERE d.DepartmentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.departmentid#"/>
                	AND p.Status IN ('STPSTA','WFPSTA','SFR','WFFSTA')
                <cfif structkeyexists(url,'keyword')>
                	AND (#url.Field# LIKE "%#url.keyword#%")
                </cfif>
                ORDER BY #url.sort# #url.sortOrder#
                LIMIT #start#,#url.perpage#
            </cfquery>
           
            <cfquery name="qT">
                #application.com.Permit.PERMIT_COUNT_SQL#
                WHERE d.DepartmentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.departmentid#"/>
                	AND p.Status IN ('STPSTA','WFPSTA','SFR','WFFSTA')
				<cfif structkeyexists(url,'keyword')>
                    AND (#url.Field# LIKE "%#url.keyword#%")
                </cfif>
            </cfquery>
            
            <cfoutput>
            {"total": #qT.c#,
                "page": #url.page#,
                "rows":[<cfloop query="q">
       			 [#q.PermitId#,#q.JHAId#,#serializeJSON(q.Work)#, "#DateFormat(q.Date,'dd-mmm-yyyy')#","#DateFormat(q.EndTime,'dd-mmm-yyyy')#",
                	<cfswitch expression="#q.Status#">
                    	<cfcase value="STPSTA">"Waiting for you to send permit to Facility Supervisor"</cfcase>
                        <cfcase value="WFPSTA">"Waiting for Facility Supervisor to Sign permit"</cfcase>
                        <cfcase value="SFR">"Waiting for Facility Supervisor to validate"</cfcase>
                        <cfcase value="WFFSTA">"Waiting for FS to Sign permit"</cfcase>
                        <cfdefaultcase>"#q.Status#"</cfdefaultcase>
                    </cfswitch>,
                    "#q.Status#"]
                  <cfif q.recordcount neq q.currentrow>,</cfif>
                </cfloop>]}
            </cfoutput>
        </cfcase>
        
        <!--- get approved permit--->
        <cfcase value="GetApprovedPermitByFS">
        	<cfset start = (url.page * url.perpage) - (url.perpage)/>
            <cfquery name="q">
                #application.com.Permit.PERMIT_SQL#
                
                	<cfif (request.userinfo.role eq "FS")||(request.userinfo.role eq "HSE")> 
                    	WHERE p.Status <> 'C'
                	<cfelseif request.userinfo.role eq "MS"> 
                    	WHERE p.Status <> 'C' 
                        AND d.DepartmentId =  <cfqueryparam cfsqltype="cf_sql_integer" value="16"/>
                    
                    <cfelse>
                    	<cfif val(request.userinfo.UnitId)>
                        	WHERE p.Status <> 'C' AND pa.UnitId = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.UnitId#"/>
                        <cfelse>
                        	WHERE p.Status <> 'C' AND d.DepartmentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.departmentid#"/>
                        </cfif>
                    </cfif>
                
                
                <cfif structkeyexists(url,'keyword')>
                	AND (#url.Field# LIKE "%#url.keyword#%")
                </cfif>
                ORDER BY #url.sort# #url.sortOrder#
                LIMIT #start#,#url.perpage#
            </cfquery>

            <cfquery name="qT">
                #application.com.Permit.PERMIT_COUNT_SQL#
                	<cfif (request.userinfo.role eq "FS")||(request.userinfo.role eq "HSE")> 
                    	WHERE p.Status <> 'C'
                	<cfelseif request.userinfo.role eq "MS"> 
                    	WHERE p.Status <> 'C' 
                        AND d.DepartmentId =  <cfqueryparam cfsqltype="cf_sql_integer" value="16"/>
                    
                    <cfelse>
                    	<cfif val(request.userinfo.UnitId)>
                        	WHERE p.Status <> 'C' AND pa.UnitId = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.UnitId#"/>
                        <cfelse>
                        	WHERE p.Status <> 'C' AND d.DepartmentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.departmentid#"/>
                        </cfif>
                    </cfif>
				<cfif structkeyexists(url,'keyword')>
                    AND (#url.Field# LIKE "%#url.keyword#%")
                </cfif>
            </cfquery>

            <cfoutput>
            {"total": #qT.c#,
                "page": #url.page#,
                "rows":[<cfloop query="q">
       			 [#q.PermitId#,#q.JHAId#,#serializeJSON(q.WorkOrderId & ': ' & q.Work)#,#serializeJSON(q.PA)#,"#DateFormat(q.Date,'dd-mmm-yyyy')#","#DateFormat(q.EndTime,'dd-mmm-yyyy')#",
                 <cfswitch expression="#q.Status#">
                    	<cfcase value="STPSTA">"Waiting for you to send permit to Facility Supervisor"</cfcase>
                        <cfcase value="WFPSTA">"Waiting for Facility Supervisor to Sign permit"</cfcase>
                        <cfcase value="SFR">"Waiting for Facility Supervisor to validate"</cfcase>
                        <cfcase value="WFFSTA">"Waiting for FS to Sign permit"</cfcase>
                        <cfcase value="STPSTC">"Waiting for FS to Close permit"</cfcase>
                        <cfcase value="WFHTS">"Waiting for HSE to Sign permit"</cfcase>
                        
                 	<cfcase value="FSA">"Approved Permit. Work on going"</cfcase>
                    <cfcase value="PSR">"Facility Supv. has revalidate this permit"</cfcase>,
                    <cfdefaultcase>"Open"</cfdefaultcase>
                 </cfswitch>,
                 "#q.Status#"]
                  <cfif q.recordcount neq q.currentrow>,</cfif>
                </cfloop>]}
            </cfoutput>
        </cfcase>
        
        <!---getPermit To Approve For PS--->
        <cfcase value="getPermitToApproveForPS">
        	<cfset start = (url.page * url.perpage) - (url.perpage)/>
            <cfquery name="q">
                #application.com.Permit.PERMIT_SQL#
                WHERE p.Status IN ('WFPSTA')
                <cfif structkeyexists(url,'keyword')>
                	AND  (#url.Field# LIKE "%#url.keyword#%")
                </cfif>
                ORDER BY #url.sort# #url.sortOrder#
                LIMIT #start#,#url.perpage#
            </cfquery>
           
            <cfquery name="qT">
                #application.com.Permit.PERMIT_COUNT_SQL#
                WHERE p.Status IN ('WFPSTA')
				<cfif structkeyexists(url,'keyword')>
                    AND (#url.Field# LIKE "%#url.keyword#%")
                </cfif>
            </cfquery>
            
            <cfoutput>
            {"total": #qT.c#,
                "page": #url.page#,
                "rows":[<cfloop query="q">
       			 [#q.PermitId#,#q.JHAId#,#serializeJSON(q.Work)#, "#DateFormat(q.Date,'dd-mmm-yyyy')#","#DateFormat(q.EndTime,'dd-mmm-yyyy')#",
                 <cfswitch expression="#q.Status#">
                 	<cfcase value="WFPSTA">"Waiting for you to Approve Permit"</cfcase>
                 </cfswitch>]
                  <cfif q.recordcount neq q.currentrow>,</cfif>
                </cfloop>]}
            </cfoutput>
        </cfcase>
        
        <!---getPermit To Approve For HSE--->
        <cfcase value="getPermitToApproveForHSE">
        	<cfset start = (url.page * url.perpage) - (url.perpage)/>
            <cfquery name="q">
                #application.com.Permit.PERMIT_SQL#
                WHERE p.Status = "WFHTS"
                <cfif structkeyexists(url,'keyword')>
                	AND  (#url.Field# LIKE "%#url.keyword#%")
                </cfif>
                ORDER BY #url.sort# #url.sortOrder#
                LIMIT #start#,#url.perpage#
            </cfquery>
           
            <cfquery name="qT">
                #application.com.Permit.PERMIT_COUNT_SQL#
                WHERE (FSApprovedByUserId <> 0 OR FSApprovedByUserId IS NOT NULL)
                    AND (HSApprovedByUserId = 0 OR HSApprovedByUserId IS NULL)
				<cfif structkeyexists(url,'keyword')>
                    AND (#url.Field# LIKE "%#url.keyword#%")
                </cfif>
            </cfquery>
            
            <cfoutput>
            {"total": #qT.c#,
                "page": #url.page#,
                "rows":[<cfloop query="q">
       			 [#q.PermitId#,#q.JHAId#,#serializeJSON(q.Work)#, "#DateFormat(q.Date,'dd-mmm-yyyy')#","#DateFormat(q.EndTime,'dd-mmm-yyyy')#","Waiting for you to Sign permit"]
                  <cfif q.recordcount neq q.currentrow>,</cfif>
                </cfloop>]}
            </cfoutput>
        </cfcase>

        <!---getPermit To Approve For FS--->
        <cfcase value="getPermitToApproveForFS">
        	<cfset start = (url.page * url.perpage) - (url.perpage)/>
            <cfquery name="q">
                #application.com.Permit.PERMIT_SQL#
                WHERE p.Status = "WFFSTA"
                <cfif structkeyexists(url,'keyword')>
                	AND  (#url.Field# LIKE "%#url.keyword#%")
                </cfif>
                ORDER BY #url.sort# #url.sortOrder#
                LIMIT #start#,#url.perpage#
            </cfquery>
           
            <cfquery name="qT">
                #application.com.Permit.PERMIT_COUNT_SQL#
                WHERE p.Status = "WFFSTA"
				<cfif structkeyexists(url,'keyword')>
                    AND (#url.Field# LIKE "%#url.keyword#%")
                </cfif>
            </cfquery>
            
            <cfoutput>
            {"total": #qT.c#,
                "page": #url.page#,
                "rows":[<cfloop query="q">
       			 [#q.PermitId#,#q.JHAId#,#serializeJSON(q.Work)#, "#DateFormat(q.Date,'dd-mmm-yyyy')#","#DateFormat(q.EndTime,'dd-mmm-yyyy')#",
                 <cfswitch expression="#q.Status#">
                 	<cfcase value="WFFSTA">"Wating for you to Sign Permt"</cfcase>
                 </cfswitch>]
                  <cfif q.recordcount neq q.currentrow>,</cfif>
                </cfloop>]}
            </cfoutput>
        </cfcase>
        
        <!---Get Closed Permit--->
        <cfcase value="GetClosedPermit">
        	<cfset start = (url.page * url.perpage) - (url.perpage)/>
            <cfquery name="q">
                #application.com.Permit.PERMIT_SQL#
                WHERE p.Status IN ('C','STPSTC')
                <cfif structkeyexists(url,'keyword')>
                	AND  (#url.Field# LIKE "%#url.keyword#%")
                </cfif>
                ORDER BY #url.sort# #url.sortOrder#
                LIMIT #start#,#url.perpage#
            </cfquery>
           
            <cfquery name="qT">
                #application.com.Permit.PERMIT_COUNT_SQL#
                WHERE p.Status IN ('C','STPSTC')
				<cfif structkeyexists(url,'keyword')>
                    AND (#url.Field# LIKE "%#url.keyword#%")
                </cfif>
            </cfquery>
            
            <cfoutput>
            {"total": #qT.c#,
                "page": #url.page#,
                "rows":[<cfloop query="q">
       			 [#q.PermitId#,#q.JHAId#,#serializeJSON(q.Work)#, "#DateFormat(q.Date,'dd-mmm-yyyy')#","#DateFormat(q.EndTime,'dd-mmm-yyyy')#",
                 <cfswitch expression="#q.Status#">
                 	<cfcase value="C">"Close"</cfcase>
                    <cfcase value="STPSTC">"Waiting for Facility Superv. to close permit"</cfcase>
                 </cfswitch>
                 ]
                  <cfif q.recordcount neq q.currentrow>,</cfif>
                </cfloop>]}
            </cfoutput>
        </cfcase>
        
        <!---get Permit To Close By PS--->
        <cfcase value="getPermitToCloseByPS">
        	<cfset start = (url.page * url.perpage) - (url.perpage)/>
            <cfquery name="q">
                #application.com.Permit.PERMIT_SQL#
                WHERE (`Completed` <> "" OR `Completed` IS NOT NULL)
                	AND (FSCloseByUserId = 0 OR FSCloseByUserId IS NULL)
                <cfif structkeyexists(url,'keyword')>
                	AND  (#url.Field# LIKE "%#url.keyword#%")
                </cfif>
                ORDER BY #url.sort# #url.sortOrder#
                LIMIT #start#,#url.perpage#
            </cfquery>
           
            <cfquery name="qT">
                #application.com.Permit.PERMIT_COUNT_SQL#
                WHERE (`Completed` <> "" OR `Completed` IS NOT NULL)
                	AND (FSCloseByUserId = 0 OR FSCloseByUserId IS NULL)
				<cfif structkeyexists(url,'keyword')>
                    AND (#url.Field# LIKE "%#url.keyword#%")
                </cfif>
            </cfquery>
            
            <cfoutput>
            {"total": #qT.c#,
                "page": #url.page#,
                "rows":[<cfloop query="q">
       			 [#q.PermitId#,#q.JHAId#,#serializeJSON(q.Work)#, "#DateFormat(q.Date,'dd-mmm-yyyy')#","#DateFormat(q.EndTime,'dd-mmm-yyyy')#",#serializeJSON(q.Status)#,
                 <cfswitch expression="#q.Completed#">
                 	<cfcase value="no">#serializeJSON('<span class="label label-info">NO</span>')#</cfcase>
                    <cfcase value="yes">#serializeJSON('<span class="label label-success">YES</span>')#</cfcase>
                    <cfdefaultcase>""</cfdefaultcase>
                 </cfswitch>
                 ]
                  <cfif q.recordcount neq q.currentrow>,</cfif>
                </cfloop>]}
            </cfoutput>
        </cfcase>
         
        <!--- get Permit To Revalidate --->
        <cfcase value="getPermitToRevalidate">
        	<cfset start = (url.page * url.perpage) - (url.perpage)/>
            <cfquery name="q">
                #application.com.Permit.PERMIT_SQL#
                WHERE p.Status = "SFR"
                <cfif structkeyexists(url,'keyword')>
                	AND  (#url.Field# LIKE "%#url.keyword#%")
                </cfif>
                ORDER BY #url.sort# #url.sortOrder#
                LIMIT #start#,#url.perpage#
            </cfquery>
           
            <cfquery name="qT">
                #application.com.Permit.PERMIT_COUNT_SQL#
                WHERE p.Status = "SFR"
				<cfif structkeyexists(url,'keyword')>
                    AND (#url.Field# LIKE "%#url.keyword#%")
                </cfif>
            </cfquery>
            
            <cfoutput>
            {"total": #qT.c#,
                "page": #url.page#,
                "rows":[<cfloop query="q">
       			 [#q.PermitId#,#q.JHAId#,#serializeJSON(q.Work)#, "#DateFormat(q.Date,'dd-mmm-yyyy')#","#DateFormat(q.EndTime,'dd-mmm-yyyy')#","Waiting for you to revalidate"]
                  <cfif q.recordcount neq q.currentrow>,</cfif>
                </cfloop>]}
            </cfoutput>
        </cfcase>
        
        <!---getJHA--->
        <cfcase  value="getJHAByUsers">
            <cfset start = (url.page * url.perpage) - (url.perpage)/>
			<cfparam name="url.cid" default=""/>
            
            <cfquery name="q">
                #application.com.Permit.JHA_SQL#
                <!---WHERE 
                <cfif request.IsHSE>
                	u1.DepartmentId <> 0
                <cfelse>
                	u1.DepartmentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.departmentid#"/>
                </cfif>--->
				<cfif url.cid neq "">
                   WHERE pj.JHAId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cid#"/>
                    <cfif structkeyexists(url,'keyword')>
                        AND  (#url.Field# LIKE "%#url.keyword#%")
                    </cfif>
                <cfelse>
                    <cfif structkeyexists(url,'keyword')>
                        WHERE  #url.Field# LIKE "%#url.keyword#%"
                    </cfif>
                </cfif>

                ORDER BY #url.sort# #url.sortOrder#
                LIMIT #start#,#url.perpage#
            </cfquery>
            
            <cfquery name="qT">
                #application.com.Permit.JHA_COUNT_SQL#               
                <cfif url.cid neq "" >
                     WHERE j.JHAId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cid#"/>-
                    <cfif structkeyexists(url,'keyword')>
                        AND  (#url.Field# LIKE "%#url.keyword#%")
                    </cfif>
                <cfelse>
                    <cfif structkeyexists(url,'keyword')>
                        WHERE  #url.Field# LIKE "%#url.keyword#%"
                    </cfif>
                </cfif>
            </cfquery>
            <!---<cfdump var="#qt#"/>--->
            <cfoutput>
            {"total": #qT.c#,
                "page": #url.page#,
                "rows":[<cfloop query="q">
                 [#q.JHAId#,#serializeJSON(q.WorkDescription)#,#serializeJSON(q.EquipmentToUse)#, "#DateFormat(q.Date,'dd-mmm-yyyy')#",#serializeJSON(q.PreparedBy)#,#serializeJSON(q.ReviewedBy)#,
                    <cfswitch expression="#q.Status#">  
                        <cfcase value="c">#serializeJSON('<span class="label label-success">ok</span>')#</cfcase>
                        <cfdefaultcase>#serializeJSON('<span class="label">draft</span>')#</cfdefaultcase>
                    </cfswitch>,
                    "#q.Status#",#q.DepartmentId#
                 ]
                  <cfif q.recordcount neq q.currentrow>,</cfif>
                </cfloop>]}
            </cfoutput>    

        </cfcase>
        
		<!---Save JHA--->  
        <cfcase value="saveJHA">
    		
            <cfset form.PreparedByUserId = request.userinfo.userId/>
        	<cfset id_ = application.com.Permit.saveJHA(form)/>
            <cfif form.id eq 0>
            	JHA ###id_# was successfuly created
            </cfif>
        </cfcase>  
        
        <!---SavePermit--->
        <cfcase value="SavePermit">

            <cfset form.id = val(form.id)/>
            <cfparam name="form.SafetyRequirement1" default=""/>
            <cfparam name="form.SafetyRequirement2" default=""/>
            <cfparam name="form.SafetyRequirement3" default=""/>
            <cfparam name="form.SafetyRequirement4" default=""/>
            <cfparam name="form.HotWork" default=""/>
            <cfparam name="form.Precaution" default=""/>
            <cfparam name="form.PPE" default=""/>
            <cfparam name="form.ConfinedSpace" default=""/>
            <cfparam name="form.GasFree" default=""/>
            <cfparam name="form.WorkType" default=""/>
            
            <!--- check if JHA  from your department first --->
            <cfset qJ = application.com.Permit.GetJHA(form.JHAId)/>
            <cfif qJ.DepartmentId neq request.userinfo.departmentId>
            	<cfthrow message="Sorry! you dont have permission to create Permit with JHA #form.JHAId#">
            </cfif>
            
            <!--- check if user has other permit opened --->
            <cfif form.id eq 0>
                <cfquery name="qCheck">
                    SELECT PermitId FROM ptw_permit 
                    WHERE PAApprovedByUserId = #val(request.userinfo.userid)#
                        AND Status <> "C"
                </cfquery>
                <cfif qCheck.recordcount gt 3>
                    <cfthrow message="Sorry! You already have 3 opened Permits. To create a permit close Permits ## #valuelist(qCheck.PermitId)#">
                </cfif>
            </cfif>
            
            <cfquery result="rt">
				<cfif form.id eq 0>
                    INSERT INTO
                <cfelse>
                    UPDATE 
                </cfif>
                ptw_permit SET
                    JHAId=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.JHAId#"/>,
                    NumberOfWorkers = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.NumberOfWorkers)#"/>,
                    Date=<cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(Now(),'yyyy-mmm-dd')#"/>,
                    StartTime=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateFormat(form.StartTime,'yyyy/mm/dd')# #TimeFormat(form.StartTime,'HH:MM')#"/>,
                    EndTime=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateFormat(form.EndTime,'yyyy/mm/dd')# #TimeFormat(form.EndTime,'HH:MM')#"/>,
                    Contractor=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Contractor#"/>,
                    SafetyRequirement1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SafetyRequirement1#"/>,
                    SafetyRequirement2=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SafetyRequirement2#"/>,
                    SafetyRequirement3=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SafetyRequirement3#"/>,
                    SafetyRequirement4=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SafetyRequirement4#"/>,
                    PPE=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PPE#"/>,
                    AdditionalPrecaution=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AdditionalPrecaution#"/>,
                    HotWork =<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.HotWork#"/>,
                    Custom1 =<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Custom1#"/>,
                    ConfinedSpace=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ConfinedSpace#"/>,
                    Precaution=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Precaution#"/>,
                    Custom2=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Custom2#"/>,
                    Custom3=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Custom3#"/>,
                    Custom4=<cfqueryparam cfsqltype="cf_sql_float" value="#val(form.Custom4)#"/>,
                    GasFree=<cfqueryparam cfsqltype="cf_sql_char" value="#form.GasFree#" maxlength="3"/>,
                    WorkType=<cfqueryparam cfsqltype="cf_sql_char" value="#form.WorkType#"/>
                    <!--- for sign --->
                    <cfif form.id eq 0> 
                    	<!--- if document was signed --->
                        <cfif form.PAApprovedByUserId neq 0>
                            ,PAApprovedByUserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.PAApprovedByUserId#"/>,
                            PAApprovedDate = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"/>,
                            `Status` = 'STPSTA' <!--- TODO: the system should send to PS automatically ---->
                        <cfelse>
                        	,`Status` = 'STPSTA'
                        </cfif>
                    <cfelse>
                    	,`Status` = 'STPSTA'
                    </cfif>
                    
                    <cfif form.id neq 0>
                        WHERE Permitid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#">
                    </cfif> 
            </cfquery>
                        
			<cfif form.id eq 0>
                <cfset form.id = rt.GENERATED_KEY/>
                Permit #form.id# was successfuly created 
            </cfif>
            
            <cfset h = createobject('component','assetgear.com.awaf.util.helper').Init()/>
            <cfset h.SaveFromTempTable(form.PermitGasTest,
                "ptw_gas_test",
                "Date,Gas,O2,H2o",
                "text0,text1,text2,text3",
                "GasTestId","PermitId",form.id)/>	
        </cfcase>
        
        <cfcase value="SendToPS">
        	<!--- check if permit has been signed --->
			<cfset qPM2 = application.com.Permit.GetPermit(url.id)/>
			<cfif val(qPM2.PAApprovedByUserId) neq 0>
				
				<!--- check if user has sent notification first --->
				<cfset qN = application.com.Notice.GetNoticeByModule(url.id,'ptw')/>
				<cfif qN.Recordcount gt 1>
					<cfthrow message="Notification already sent to the Facility Supervisour"/>
				<cfelse>            	
					<!--- update status --->
					<cfquery>
						UPDATE `ptw_permit` SET
							`Status` = "WFPSTA"
						WHERE PermitId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
					</cfquery>
					<cfset qP = application.com.Permit.GetPermit(url.id)/>
					<cfif val(qP.PAApprovedByUserId) eq 0>
						<cfthrow message="You need to Sign this document first. Under Section 4"/>
					</cfif>
					<cftransaction action="begin">
						<!---close the alert on JHA for this permit --->
						<cfset application.com.Notice.CloseNoticeByModule(qP.jhaid,'jha')/>
						<cfset application.com.Notice.CloseNoticeByModule(url.id,'ptw')/>
						<!--- send alert to PS --- production department is 7 --->
						<cfset application.com.Notice.SendNotice(request.userinfo.userid, 0, 0, 0, 'ptw', 'PTW ###url.id# "#qP.Work#" has been sent to you for approval', url.id,'PS')/>
					</cftransaction>
					Your Permit was sent to the Facility Supervisour
				</cfif>
			<cfelse>
				<cfthrow message="Please sign permit before sending to Facility Supervisour"/>
			</cfif>
        </cfcase>
                
        <cfcase value="ConfirmPin">
        	<cfif !(IsCorrectPIN(url.pin))>  
            	<cfthrow message="Wrong PIN, please try again"/>
            <cfelse>
            	<!--- sign permit --->
                <cfquery>
                	UPDATE ptw_permit SET 
                    	PAApprovedByUserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.userid#"/>,
                        PAApprovedDate = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"/>
                    WHERE PermitId = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer"/>
                </cfquery>
            </cfif>
        </cfcase>
    
        <cfcase value="ConfirmPINForPS"> 
        	<cfif !IsCorrectPIN(url.pin)>  
            	<cfthrow message="Wrong PIN, please try again"/>
            <cfelse> 
            	<cftransaction action="begin">
					<!--- sign permit --->
                    <cfquery>
                        UPDATE ptw_permit SET 
                            FSApprovedByUserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.userid#"/>,
                            FSApprovedDate = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"/>,
                            `Status` = "WFHTS"                            
                        WHERE PermitId = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer"/>
                    </cfquery><cfset qP = application.com.Permit.GetPermit(url.id)/>
                    <!--- Clear PS alert --->
                    <cfset application.com.Notice.CloseNoticeByModule(url.id,'ptw')/>
                    <!--- send alert to HSE department = 3 --->
                    <cfset application.com.Notice.SendNotice(request.userinfo.userid, 0, 0, 0, 'ptw', 'PTW ###url.id# "#qP.Work#" has been sent to you for approval', url.id,'HSE')/>
                </cftransaction>
            </cfif>
        </cfcase>

        <cfcase value="ConfirmPINForHSE"> 
        	<cfif !IsCorrectPIN(url.pin)>  
            	<cfthrow message="Wrong PIN, please try again"/>
            <cfelse> 
            	<cftransaction action="begin">
					<!--- sign permit --->
                    <cfquery>
                        UPDATE ptw_permit SET 
                            HSApprovedByUserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.userid#"/>,
                            HSApprovedDate = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"/>,
                            `Status` = "WFFSTA"
                        WHERE PermitId = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer"/>
                    </cfquery><cfset qP = application.com.Permit.GetPermit(url.id)/>
                    <!--- Clear HSE alert --->
                    <cfset application.com.Notice.CloseNoticeByModule(url.id,'ptw')/>
                    <!--- send alert to FS role = 'FS' --->
                    <cfset application.com.Notice.SendNotice(request.userinfo.userid, 0, 0, 0,'ptw', 'PTW ###url.id# "#qP.Work#" has been sent to you for approval', url.id, 'FS')/>
                </cftransaction>
            </cfif>
        </cfcase>
        
        <cfcase value="ConfirmPINForFS"> 
        	<cfif !IsCorrectPIN(url.pin)>  
            	<cfthrow message="Wrong PIN, please try again"/>
            <cfelse> 
            	<cftransaction action="begin">
					<!--- sign permit --->
                    <cfquery>
                        UPDATE ptw_permit SET 
                            LSApprovedByUserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.userid#"/>,
                            LSApprovedDate = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"/>,
                            `Status` = "FSA"
                        WHERE PermitId = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer"/>
                    </cfquery>
                    <!--- Clear FS alert --->
                    <cfset application.com.Notice.CloseNoticeByModule(url.id,'ptw')/>
                    <!--- send alert back to the creator of the permit --->
                    <cfset qP = application.com.Permit.GetPermit(url.id)/>
                    <!--- get unitid of the creator --->
                    <cfquery name="qU">
                    	SELECT UnitId FROM core_user WHERE UserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#qP.PAApprovedByUserId#"/>
                    </cfquery> 
                    <cfset application.com.Notice.SendNotice(request.userinfo.userid, qP.PAApprovedByUserId, 0, val(qU.UnitId), 'ptw', 'PTW ###url.id# "#qP.Work#" has been approved.', url.id)/>--->
                </cftransaction>
            </cfif>
        </cfcase> 
         
        <cfcase value="ConfirmPINForFSReject"> 
        	<cfif !IsCorrectPIN(url.pin)>  
            	<cfthrow message="Wrong PIN, please try again"/>
            <cfelse> 
            	<cftransaction action="begin">
                    <!--- Clear alert --->
                    <cfset application.com.Notice.CloseNoticeByModule(url.id,'ptw')/>
                    <!--- send alert back to the creator of the permit --->
                    <cfset qP = application.com.Permit.GetPermit(url.id)/>
                    <!---<script>alert(#url.id#);</script>--->
                    <!--- get unitid of the creator --->
                    <cfquery name="qU">
                    	SELECT UnitId FROM core_user WHERE UserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#qP.PAApprovedByUserId#"/>
                    </cfquery>
                    <cfset application.com.Notice.SendNotice(request.userinfo.userid, qP.PAApprovedByUserId, 0, val(qU.UnitId), 'ptw', 'PTW ###url.id# has rejected by FS with the following comment: #url.cmt#', url.id)/>
                </cftransaction>
            </cfif>
        </cfcase> 
               
        <cfcase value="ConfirmPINForPANotComplete"> 
        	<cfif !IsCorrectPIN(url.pin)>  
            	<cfthrow message="Wrong PIN, please try again"/>
            <cfelse> 
            	<cftransaction action="begin">
					<!--- close permit --->
                    <cfquery> 
                        UPDATE ptw_permit SET 
                            PACloseByUserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.userid#"/>,
                            PACloseDate = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"/>,
                            `Completed` = "no",
                            `Status` = "STPSTC"
                        WHERE PermitId = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer"/>
                    </cfquery>
                    <!--- close out jha --->
                    <cfquery>
                        UPDATE ptw_jha SET 
                                Status = "c"
                        WHERE JHAId = (SELECT JHAId FROM ptw_permit WHERE PermitId = #url.id#)
                    </cfquery>
                    <!--- Clear previous alert on the permit --->
                    <cfset application.com.Notice.CloseNoticeByModule(url.id,'ptw')/>
                    <!--- send alert to FS --->
                    <cfset application.com.Notice.SendNotice(request.userinfo.userid, 0, 0, 0, 'ptw', 'PTW ###url.id# has been flagged as suspended/not completed. Please close out this permit', url.id, 'PS')/>
                </cftransaction>
            </cfif>
        </cfcase>  

        <!--- send back to PA from PS/hse --->
        <cfcase value="SendBackToPA">
                
					<cfquery>
						UPDATE ptw_permit SET 
							`Status` = "STPSTA"
						WHERE PermitId = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer"/>
					</cfquery>
					<cfset qP = application.com.Permit.GetPermit(url.id)/>
					<cfset application.com.Notice.SendBackMail("Review: Permit ##" & url.id, qp.PAApprovedByUserId, form.msg)/>

        </cfcase> 
        
        <cfcase value="ConfirmPINForPAComplete"> 
        	<cfif !IsCorrectPIN(url.pin)>  
            	<cfthrow message="Wrong PIN, please try again"/>
            <cfelse> 
            	<cftransaction action="begin">
					<!--- close permit --->
                    <cfquery>
                        UPDATE ptw_permit SET 
                            PACloseByUserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.userid#"/>,
                            PACloseDate = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"/>,                             
                            `Completed` = "yes",
                            `Status` = "STPSTC"
                        WHERE PermitId = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer"/>
                    </cfquery>
                    <!--- close out jha --->
                    <cfquery>
                        UPDATE ptw_jha SET 
                                Status = "c"
                        WHERE JHAId = (SELECT JHAId FROM ptw_permit WHERE PermitId = #url.id#)
                    </cfquery><cfset qP = application.com.Permit.GetPermit(url.id)/>
                    <!--- Clear previous alert on the permit --->
                    <cfset application.com.Notice.CloseNoticeByModule(url.id,'ptw')/>
                    <!--- send alert to PS --- production department is 7 --->
                    <cfset application.com.Notice.SendNotice(request.userinfo.userid, 0, 0, 0,'ptw', 'PTW ###url.id# "#qP.Work#" has been flagged as completed. Please close out this permit', url.id, 'PS')/>
                </cftransaction>
            </cfif>
        </cfcase> 
        
        <cfcase value="ConfirmPINClosePermit"> 
        	<cfif !IsCorrectPIN(url.pin)>  
            	<cfthrow message="Wrong PIN, please try again"/>
            <cfelse> 
            	<cftransaction action="begin">
					<!--- close permit --->
                    <cfquery>
                        UPDATE ptw_permit SET 
                            FSCloseByUserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.userid#"/>,
                            FSCloseDate = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"/>,
                            `Status` = "C"
                        WHERE PermitId = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer"/>
                    </cfquery>
                    <!--- Clear previous alert on the permit --->
                    <cfset application.com.Notice.CloseNoticeByModule(url.id,'ptw')/>
                    <!--- send alert to PS --- production department is 7 
                    <cfset application.com.Notice.SendNotice(request.userinfo.userid, 0, 7, 0, 'ptw', 'PTW ###url.id# has been flagged as completed. Please close out this permit', url.id)/>--->
                </cftransaction>
            </cfif>
        </cfcase> 
       
        <cfcase value="ConfirmPINValidatePermit"> 
        	<cfif !IsCorrectPIN(url.pin)>  
            	<cfthrow message="Wrong PIN, please try again"/>
            <cfelse> 
            	<cftransaction action="begin">
                	<cfquery name="qP">
                    	SELECT * FROM ptw_permit_revalidated
                        WHERE `Date` = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"/>
                        	AND PermitId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
                    </cfquery>
                    <cfif !qP.Recordcount>
                        <cfquery>
                            INSERT INTO ptw_permit_revalidated SET 
                                ValidatedByUserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.userid#"/>,
                                PermitId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>,
                                `Date` = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"/>,
                                `StartTime` = <cfqueryparam cfsqltype="cf_sql_time" value="7:00"/>,
                                `EndTime` = <cfqueryparam cfsqltype="cf_sql_time" value="18:00"/>
                        </cfquery>
                        <!--- update permit status--->
                        <cfquery>
                        	UPDATE ptw_permit SET
                            	`Status` = "PSR" 
                            WHERE PermitId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
                        </cfquery>
                        <!--- Clear previous alert on the permit --->
                        <cfset application.com.Notice.CloseNoticeByModule(url.id,'ptw')/>
                        <!--- send alert to PA --->
                        <cfquery name="qPr">
                            SELECT PAApprovedByUserId FROM ptw_permit
                            WHERE PermitId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
                        </cfquery>
						<!--- get unitid of the creator --->
                        <cfquery name="qU">
                            SELECT UnitId FROM core_user WHERE UserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#qPr.PAApprovedByUserId#"/>
                        </cfquery>
                        <cfset application.com.Notice.SendNotice(request.userinfo.userid, qPr.PAApprovedByUserId, 0, val(qU.UnitId),'ptw', 'PTW ###url.id# has been revalidated for another 24 hours', url.id)/>
                	</cfif>
                </cftransaction>
            </cfif>
        </cfcase>
        
        <cfcase value="AsForPermitEstension">
        	
            <!--- flag permit for revalidation --->
            <cfquery>
            	UPDATE ptw_permit SET 
                	Revalidate = "y", `Status` = "SFR"
                WHERE PermitId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
            </cfquery>
			<cfset qP = application.com.Permit.GetPermit(url.id)/>
            <!--- Clear previous alert --->
            <cfset application.com.Notice.CloseNoticeByModule(url.id,'ptw')/>
			<!--- send alert to PS to extend permit ---->
            <cfset application.com.Notice.SendNotice(request.userinfo.userid, 0, 0, 0, 'ptw', 'PTW ###url.id# "#qP.Work#" need to be extended for another 24 hours', url.id,'PS')/>--->
            
        </cfcase>
        
   </cfswitch>
    
 
</cfoutput>

<cffunction name="IsCorrectPIN" access="private" returntype="boolean">
	<cfargument name="pin" required="yes" type="string"/>
    
    <cfset var bl = false/>
	<cfset var pinKey = createObject("component","assetgear.com.awaf.Security").EncryptPassword(request.userinfo.role,request.userinfo.Email,url.pin) />
    <!--- get the most currect key from db --->
    <cfquery name="qU">
        SELECT * FROM core_login 
        WHERE UserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.userid#"/>
    </cfquery>
    
    <cfif pinKey eq qU.PINKey>
    	<cfset bl = true/>
    </cfif>
    <cfreturn bl/>
</cffunction>