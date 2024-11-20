<cfparam name="IsUpdate" type="boolean" default="false" />
<cfset nparam = listlast(cgi.query_string,'?')/>
<cfoutput>
<!--- check if the user is trying to update by grabbing the first item which should be _id --->
<cfset pk = listFirst(nparam,'&')/>
<cfif listfirst(pk,'=') eq "id">
    <!--- remove pk from nparam --->
    <cfset nparam = replacenocase(nparam,pk,"")/>
    <cfset IsUpdate = true/>
    <cfset pk = ListLast(pk,'=')/>
</cfif>
<!--- get the session out --->
<cfset sessionid = ListLast(nparam,'&')/>
<cfset nparam = replacenocase(nparam,sessionid,"")/> 
<!--- get the field caption/title out --->
<cfset fn = ListLast(nparam,'&')/>
<cfset nparam = replacenocase(nparam,fn,"")/>
<cfset fn = URLDecode(ListLast(fn,'='))/>
<!--- get the required field out --->
<cfset rf = ListLast(nparam,'&')/>
<cfset nparam = replacenocase(nparam,rf,"")/>
<cfset rf = ListLast(rf,'=')/>
<!--- loop throught required field and throw error is data is not provided --->
<cfloop list="#rf#" item="req_f" index="ii">
	<cfif trim(url[req_f]) eq "">
		<cfthrow message="Error: #listgetAt(fn,ii,'`')# Field is required"/>
	</cfif>
</cfloop>

<cfset paramLen = ListLen(nparam,'&')/>
<cfset iI = iF = iD = iT = i = 0/>


<cfquery result="rt">
	<cfif IsUpdate>
        UPDATE 
    <cfelse>
        INSERT INTO
    </cfif> 
        temp_data SET
        <cfif !IsUpdate>  <!--- i don't need to update the session again --->
    	   `Session` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listlast(sessionid,'=')#"/>,
           `TimeCreated` = <cfqueryparam value="#now()#" cfsqltype="CF_SQL_DATE"/>,
        </cfif>
        `Flag` = <cfif IsUpdate>"u"<cfelse>"n"</cfif>,
        <cfloop list="#nparam#" delimiters="&" index="d">
        	<cfset i++/>
            <cfset fld = listfirst(d,'=')/>
            <cfset vlu = listlast(d,'=')/>
			<cfset cap = listgetat(fn,i,'`')/>
            <cfset fld = replacenocase(fld,i-1,'')/>
            <cfif Findnocase("int",fld)>
				<!--- check if field is not required ---->
				<cfif !listContainsNoCase(rf,fld & i-1)>
					<cfif vlu eq fld & i-1>
						<cfset vlu=0/>
					</cfif>
				</cfif>
				<cfif !IsNumeric(vlu)>
					<cfthrow message="Error: Integer format required for '#cap#' field, e.g 45, 12, 5"/>
				</cfif>
				`#fld##iI#` = <cfqueryparam cfsqltype="cf_sql_integer" value="#vlu#"/><cfif paramLen neq i>,</cfif>
				<cfset iI++/>
			</cfif>
			<cfif Findnocase("float",fld)>
				<cfset vlu = replace(vlu,'%2C','','all')/>
				<!--- check if field is not required ---->
				<cfif !listContainsNoCase(rf,fld & i-1)>
					<cfif vlu eq fld & i-1>
						<cfset vlu=0/>
					</cfif>
				</cfif>
				<cfif !IsNumeric(vlu)>
					<cfthrow message="Error: float format required for '#cap#' field. e.g 12.5, 34.09, 0.38"/>
				</cfif>
				`#fld##iF#` = <cfqueryparam cfsqltype="cf_sql_float" value="#vlu#"/><cfif paramLen neq i>,</cfif>
				<cfset iF++/>
			</cfif>
			<cfif Findnocase("date",fld)>
				<cfif !IsDate(URLDecode(vlu))>
					<cfthrow message="Date format error for '#cap#' field"/>
				</cfif>
				`#fld##iD#` = <cfqueryparam cfsqltype="cf_sql_date" value="#URLDecode(vlu)#"/><cfif paramLen neq i>,</cfif>
				<cfset iD++/>
			</cfif>            
			<cfif Findnocase("text",fld)>
				`#fld##iT#` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDecode(vlu)#"/><cfif paramLen neq i>,</cfif>
				<cfset iT++/>
			</cfif>

		</cfloop>
		<cfif IsUpdate>
			WHERE `TempDataId` = <cfqueryparam value="#pk#" cfsqltype="CF_SQL_INTEGER"/>
			-- AND `Flag` <> 'd'	
		</cfif>
</cfquery>

<cfif !IsUpdate >
    #rt.GENERATED_KEY#
<cfelse>
    #pk#
</cfif>

</cfoutput>