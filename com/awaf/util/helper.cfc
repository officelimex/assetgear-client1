<cfcomponent>
	
    <cffunction name="Init" access="public" returntype="helper">
    	
        <cfreturn this/>
    </cffunction>
	
	<cffunction name="UpdateCustomFields" access="public" returntype="void">
		<cfargument name="tbl" type="string" required="true" hint="the table that owns the custom field" />
		<cfargument name="cf_count" hint="Number of Custom fields available to update" required="false" default="8"  type="numeric" />
		<cfargument name="cf_prefix" hint="Custom Field prefix name" type="string" required="false" default="CustomField"/>		

	    <cfloop from="1" to="#arguments.cf_count#" index="i">

	    	<cfset cfvlu = form["#arguments.cf_prefix##i#"]/> 
 
            <cfset cfid = form["#arguments.cf_prefix##i#_id"]/>
            <cfset cffld = form["#arguments.cf_prefix##i#_label"]/>     

        	<cfswitch expression="#cffld#">
        		<cfcase value="{Custom field}">
        			<!--- do nothing --->
        		</cfcase>
        		<cfdefaultcase>
	                <cfquery>
	                    <cfset cfid = form["CustomField#i#_id"]/>
	                    <cfset cffld = form["CustomField#i#_label"]/>                        
	                    
	                    <cfif cfid eq 0>
	                        INSERT INTO custom_field SET
	                            `Table` = <cfqueryparam value="#arguments.tbl#" cfsqltype="cf_sql_varchar"/>,
	                            `PK` = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#"/>,
	                            `Field` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cffld#"/>,
	                            `Value` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cfvlu#"/>
		                <cfelseif cffld eq "">
		                	<!--- delete the custom field from the table --->
		                	DELETE FROM `custom_field`
		                	WHERE `CustomFieldId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#cfid#"/>
	                    <cfelseif cffld neq "">
	                        UPDATE custom_field SET
	                            `Field` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cffld#"/>,
	                            `Value` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cfvlu#"/>
	                        WHERE `CustomFieldId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#cfid#"/>
	                    </cfif>	                    
	                </cfquery>
        		</cfdefaultcase>
        	</cfswitch> 

	    </cfloop>

	</cffunction>

	<cffunction name="SaveFromTempTable" access="public" returntype="void" hint="save data into the proper table from temp_data" output="true">
		<cfargument name="sid" hint="session id" required="true" type="string"/>
		<cfargument name="tbl" hint="table to insert to" required="true" type="string"/>
		<cfargument name="fld_des" hint="field to insert into (destination)" required="true" type="string"/>
		<cfargument name="fld_src" hint="field to insert from (source)" required="true" type="string"/>
		<cfargument name="pk_field" hint="primary key field" required="true" type="string"/>
		<cfargument name="fk_field" hint="foringe key field" required="true" type="string"/>
		<cfargument name="fk_value" hint="foringe key value" required="true" type="numeric" />
		
		<cfset llen = listlen(arguments.fld_des)/>
		
		<cftransaction action="begin">
		
		<cfquery name="qTemp">
			SELECT * FROM temp_data
		    WHERE `Session` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sid#"/>
				<!---AND `Flag` <> "" --->
		</cfquery>
		<!--- insert ---> 
		<cfloop query="qTemp"> 
			<cfquery>
		        <cfswitch expression="#qTemp.Flag#">
		            <cfcase value="d">
		                DELETE FROM `#arguments.tbl#` 
		                WHERE `#arguments.pk_field#` = <cfqueryparam cfsqltype="cf_sql_integer" value="#qTemp.PK#"/>
		            </cfcase>
		            <cfcase value="u"> 
						<cfif qTemp.PK eq "">
		                INSERT INTO `#arguments.tbl#` SET
		                    <cfif arguments.fk_field neq "">
								`#arguments.fk_field#` = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.fk_value#"/>,
							</cfif>
						<cfelse>
						UPDATE `#arguments.tbl#` SET	
						</cfif>	
						
							<cfset i=0/>
							<cfloop list="#fld_des#" delimiters="," index="fld_d">
								<cfset i++/>
								<cfset fld_s = listgetat(arguments.fld_src,i)/>
								<cfset ttype = left(fld_s,len(fld_s)-1)/>
		                    	`#fld_d#` = 
									<cfswitch expression="#ttype#">
										<cfcase value="int"><cfqueryparam cfsqltype="cf_sql_integer" value="#val(evaluate(fld_s))#"/></cfcase>
                                        <cfcase value="float"><cfqueryparam cfsqltype="cf_sql_decimal" value="#val(evaluate(fld_s))#"/></cfcase>
										<cfcase value="date"><cfqueryparam cfsqltype="cf_sql_date" value="#evaluate(fld_s)#"/></cfcase>
										<cfdefaultcase><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate(fld_s)#"/></cfdefaultcase>
									</cfswitch>
									<cfif llen neq i>,</cfif>
							</cfloop>
		                <cfif qTemp.PK neq "">
							WHERE `#arguments.pk_field#` = <cfqueryparam cfsqltype="cf_sql_integer" value="#qTemp.PK#"/>
						</cfif>
		            </cfcase>
		            <cfdefaultcase>
                    	<!--- insert if the flag is new and the primary key value is 0 ---->
                        
                    	<cfif (qTemp.Flag eq "n") or (val(qTemp.PK) eq 0)>           	 
                            INSERT INTO `#arguments.tbl#` SET
                                <cfif arguments.fk_field neq "">
                                    `#arguments.fk_field#` = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.fk_value#"/>,
                                </cfif> 
                                <cfset i=0/>
                                <cfloop list="#fld_des#" delimiters="," index="fld_d">
                                    <cfset i++/>
                                    <cfset fld_s = listgetat(arguments.fld_src,i)/>
                                    <cfset ttype = left(fld_s,len(fld_s)-1)/>
                                    `#fld_d#` = 
                                        <cfswitch expression="#ttype#">
                                            <cfcase value="int"><cfqueryparam cfsqltype="cf_sql_integer" value="#val(evaluate(fld_s))#"/></cfcase>
                                            <cfcase value="date"><cfqueryparam cfsqltype="cf_sql_date" value="#evaluate(fld_s)#"/></cfcase>
                                            <cfcase value="float"><cfqueryparam cfsqltype="cf_sql_decimal" value="#val(evaluate(fld_s))#"/></cfcase>
                                            <cfdefaultcase><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate(fld_s)#"/></cfdefaultcase>
                                        </cfswitch>
                                        <cfif llen neq i>,</cfif>
                                </cfloop>
                        <cfelse>
                        	<!--- make query not emplty --->
                            SELECT 1
                    	</cfif>
		            </cfdefaultcase>
		        </cfswitch> 
		    </cfquery>    
		</cfloop>
		<!--- clear temp table --->
		<cfquery>
            DELETE FROM `temp_data` 
            WHERE `Session` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sid#"/>
		</cfquery>
		
		</cftransaction>
		
		<cfobjectcache action="clear"/>
	</cffunction>
	
    <cffunction name="GetTempDate" access="public" returntype="query" hint="get the temp data using session field">
    	<cfargument name="sid" required="yes" type="string"/>
        
        <cfset var qT = ""/>
        <cfquery name="qT">
        	SELECT * FROM temp_data
            WHERE `Session` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sid#"/>
        </cfquery>
        
        <cfreturn qT/>
    </cffunction>
    
    <cffunction name="GetTempDataToUpdate" access="public" returntype="query" hint="">
    	<cfargument name="sid" required="yes" type="string"/>
        
        <cfset var qT = ""/>
        <cfquery name="qT">
        	SELECT * FROM temp_data
            WHERE `Session` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sid#"/>
            	AND Flag <> "d"
        </cfquery>
        
        <cfreturn qT/>
    </cffunction>

    <cffunction name="GetTempDataToDelete" access="public" returntype="query" hint="">
    	<cfargument name="sid" required="yes" type="string"/>
        
        <cfset var qT = ""/>
        <cfquery name="qT">
        	SELECT * FROM temp_data
            WHERE `Session` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sid#"/>
            	AND Flag = "d"
        </cfquery>
        
        <cfreturn qT/>
    </cffunction>  
    
    <cffunction name="FlagTempDataToDelete" access="public" returntype="void" hint="clear temp data via session">
    	<cfargument name="sid" required="yes" type="string"/>
         
        <cfquery>
            UPDATE temp_data SET `Flag` = "d"
            WHERE `Session` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.sid#"/>
        </cfquery>
         
    </cffunction>

    <cffunction name="UpdateStatus" access="public" hint="update the status of a table" returntype="void">
    	<cfargument name="key" hint="the field name of the item to update" required="yes" type="string"/>
        <cfargument name="value" hint="the value of the item to update : id" required="yes" type="numeric"/>
        <cfargument name="status" hint="the new status you want to change to" required="yes" type="string"/>
        <cfargument name="table" hint="the database table you want to update" required="yes" type="string"/> 
        
        <cfquery>
        	UPDATE #arguments.table# SET
            	`Status` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.status#"/>
            WHERE `#arguments.key#` = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.value#"/>
        </cfquery>
    	
    </cffunction>
    
</cfcomponent>