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
            <cfif fld eq vlu>
            	<cfthrow message="All fields are required"/>
            </cfif>
            <cfset fld = replacenocase(fld,i-1,'')/>
            <cfif Findnocase("int",fld)>
            	<cfif !IsNumeric(vlu)>
                	<cfthrow message="Error: Integer format required, e.g 45, 12, 5"/>
                </cfif>
            	`#fld##iI#` = <cfqueryparam cfsqltype="cf_sql_integer" value="#vlu#"/><cfif paramLen neq i>,</cfif>
            	<cfset iI++/>
            </cfif>
            <cfif Findnocase("float",fld)>
            	<cfset vlu = replace(vlu,'%2C','','all')/>
            	<cfif !IsNumeric(vlu)>
                	<cfthrow message="Error: float format required. e.g 12.5, 34.09, 0.38"/>
                </cfif>
            	`#fld##iF#` = <cfqueryparam cfsqltype="cf_sql_float" value="#vlu#"/><cfif paramLen neq i>,</cfif>
            	<cfset iF++/>
            </cfif>
         	<cfif Findnocase("date",fld)>
            	<cfif !IsDate(URLDecode(vlu))>
                	<cfthrow message="Date format error"/>
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