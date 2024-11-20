<cfcomponent>
	<cffunction name="init" access="public" returntype="bNumber"> 
    
    	<cfreturn this>
	</cffunction>
    
    <cffunction name="AutoNumberLeadingZero" access="public" returntype="string">
        <cfargument name="count" required="yes" type="numeric"> 
        
        <cfswitch expression="#len(arguments.count)#">
            <cfcase value="1"><cfset itemp = "0000000#arguments.count#"></cfcase>
            <cfcase value="2"><cfset itemp = "000000#arguments.count#"></cfcase>
            <cfcase value="3"><cfset itemp = "00000#arguments.count#"></cfcase>
            <cfcase value="4"><cfset itemp = "0000#arguments.count#"></cfcase>
            <cfcase value="5"><cfset itemp = "000#arguments.count#"></cfcase>
            <cfcase value="6"><cfset itemp = "00#arguments.count#"></cfcase>
            <cfcase value="7"><cfset itemp = "0#arguments.count#"></cfcase>
            <cfcase value="8"><cfset itemp = "#arguments.count#"></cfcase>
            <cfdefaultcase><cfset itemp = "#arguments.count#"></cfdefaultcase>
        </cfswitch>
        
        <cfreturn itemp>
    </cffunction>
    
    <cffunction name="nth" access="public" returntype="string">
    	<cfargument name="number" required="yes" type="numeric">
        
        <cfset var temp = "">
        
        <cfswitch expression="#right(arguments.number,1)#">
        	<cfcase value="0,4,5,6,7,8,9" delimiters=",">
            	<cfset temp = "th">
            </cfcase>
            <cfcase value="1">
            	<cfset temp = "st">
            </cfcase>
            <cfcase value="2">
            	<cfset temp = "nd">
            </cfcase>
            <cfcase value="3">
            	<cfset temp = "rd">
            </cfcase>
    	</cfswitch>
        
        <cfreturn arguments.number & "<sup>#temp#</sup>">
    </cffunction>
	
	<cffunction name="ConvertByte" access="public" returntype="string">
		<cfargument name="b" required="true" type="numeric">
		
		<cfset temp = NumberFormat(arguments.b,'9,999.9') & "B">
		<cfset nte = replace(ListFirst(temp,'B'),',','','all')>
		<cfif nte gt 99.99 and nte lt 999999>
			<cfset temp = NumberFormat(arguments.b/1024,'9,999.9') & "KB">
		<Cfelseif nte gt 1000000>
			<cfset temp = NumberFormat(arguments.b/(1024^2),'9,999.99') & "MB">
		</cfif>
		<cfreturn temp>
	</cffunction>
    
	<cffunction name="ExtractNumbers" access="public" returntype="numeric">
		<cfargument name="v" required="true" type="string" hint="value to extract numbers from">
		 
        <cfset num = ""/>
        <cfloop from="1" to="#len(arguments.v)#" index="i">
        	<cfset ch = Mid(arguments.v,i,1)/>
            <cfif IsNumeric(ch) OR ch eq ".">
            	<cfset num = num & ch/>
            </cfif>
        </cfloop> 
        
		<cfreturn val(num) />
	</cffunction>

</cfcomponent>
  