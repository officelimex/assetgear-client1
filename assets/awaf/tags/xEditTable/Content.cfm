<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">
  
    <cfparam name="Attributes.TagName" type="string" default="Content"/> 
    <cfparam name="Attributes.Query" type="query" default=""/>
    <cfparam name="Attributes.List" type="string" default=""/> 
	<cfparam name="Attributes.PKField" type="string" default=""/>
    <cfparam name="Attributes.Columns" type="string"/>
    <cfparam name="Attributes.Type" type="string"/><!--- example of types are int-select, text,date,int --->
 	
    <cfassociate basetag="cf_Table"/>

    <!--- insert data into temp table --->
     <cfset colLen = listLen(Attributes.Columns)/>
	
    ,data:[
    <cfif Attributes.List neq ""> 
    
        <cfloop list="Attributes.List" index="litem">
            <cfset iI = 0/> <cfset iD = 0/> <cfset iT = 0/>
            <cfquery result="rt">
                INSERT INTO temp_data SET
                    <cfif Attributes.PKField neq "">
                    	`PK` = <cfqueryparam value="#Evaluate(Attributes.PKField)#" cfsqltype="CF_SQL_INTEGER"/>,
                    </cfif>
                    `Session` = <cfqueryparam value="#request.tabletag.sessionid#" cfsqltype="CF_SQL_VARCHAR"/>,
                    <cfif Attributes.PKField eq "">
                    	`Flag` = "n",
                    <cfelse>	
                        `Flag` = "",
                    </cfif>
                    `TimeCreated` = <cfqueryparam value="#now()#" cfsqltype="CF_SQL_DATE"/>,
                    `int0` = #val(listlast(litem,'~'))#
            </cfquery>
            <cfset tempid = rt.GENERATED_KEY/> 
            [	
            	#litem#,
                <!--- primary key from the temp --->
                #tempid#
            ], 
        </cfloop>
    
    <cfelse>
        <cfloop query="Attributes.Query">
            <cfset iI = 0/> <cfset iD = 0/> <cfset iT = 0/>
            <cfquery result="rt">
                INSERT INTO temp_data SET
                    <cfif Attributes.PKField neq "">
                    	`PK` = <cfqueryparam value="#Evaluate(Attributes.PKField)#" cfsqltype="CF_SQL_INTEGER"/>,
                    </cfif>
                    `Session` = <cfqueryparam value="#request.tabletag.sessionid#" cfsqltype="CF_SQL_VARCHAR"/>,
                    <cfif Attributes.PKField eq "">
                    	`Flag` = "n",
                    <cfelse>	
                        `Flag` = "",
                    </cfif>
                    `TimeCreated` = <cfqueryparam value="#now()#" cfsqltype="CF_SQL_DATE"/>,
                <cfset j = 0/>
                <cfloop list="#Attributes.Columns#" index="c" delimiters=",">
                    <cfset j++/>
                    <cfset ctype = ListGetAt(Attributes.Type,j)/>
                    <cfswitch expression="#ctype#">
                        <cfcase value="int-select,int" delimiters=",">
                            `int#iI#` = <cfqueryparam value="#listlast(Evaluate(c),'~')#" cfsqltype="CF_SQL_INTEGER"/><cfif colLen neq j>,</cfif>
                            <cfset iI++/>
                        </cfcase>
                        <cfcase value="date">
                            `date#iD#` = <cfqueryparam value="#Evaluate(c)#" cfsqltype="CF_SQL_DATE"/><cfif colLen neq j>,</cfif>
                            <cfset iD++/>
                        </cfcase>
                        <cfdefaultcase>
                            `text#iT#` = <cfqueryparam value="#Evaluate(c)#" cfsqltype="CF_SQL_VARCHAR"/><cfif colLen neq j>,</cfif>
                            <cfset iT++/>
                        </cfdefaultcase>
                    </cfswitch> 
                </cfloop>
            </cfquery>
            <cfset tempid = rt.GENERATED_KEY/> 
            [
                <cfloop list="#Attributes.Columns#" index="l">
                    #SerializeJSON(Evaluate(l))#,
                </cfloop>
                <!--- primary key from the temp --->
                #tempid#
            ], 
        </cfloop>
    </cfif>    
    ]


 
<cfelse> 

</cfif> 
</cfoutput>