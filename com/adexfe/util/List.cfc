<cfcomponent>

	<cffunction name="init" access="public" returntype="List">
    
    	<cfreturn this />
    </cffunction>
    
    <cffunction name="ListToQuery" access="public" returntype="query" hint="convert list to Query">
        <cfargument name="Cols" type="string" required="yes" hint="the columns" />
        <cfargument name="lstArg" type="string" required="yes" hint="the list" />
		<cfargument name="del" type="string" required="no" default="," hint="list delimiters" />
        
        <cfset var qTemp = QueryNew(cols) />
        <cfloop list="#lstArg#" index="lstItem" delimiters="#arguments.del#">
            <cfset QueryAddRow(qTemp) />
            <cfset QuerySetCell(qTemp,"#Cols#",lstItem) /> 
        </cfloop>
        
        <cfreturn qTemp />
    </cffunction>
    
    <cffunction name="ListDistinctNoCase" access="public" returntype="string">
        <cfargument name="List" type="string" required="yes" />
        <cfargument name="delimiter" type="string" default=","/>
         
		<cfset arguments.List = replace(arguments.List,'#delimiter# ','#delimiter#','all') />
        <cfset arguments.List = replace(arguments.List,' #delimiter#','#delimiter#','all') />
        <cfset nlist = ""/>
        <cfloop list="#arguments.List#" index="_lst" delimiters="#arguments.delimiter#">  
   
            <cfif ListValueCountNoCase(nlist,_lst,arguments.delimiter) eq 0>
				<cfset nlist = ListAppend(nlist,_lst,arguments.delimiter) />
            </cfif>
                       
        </cfloop> 
       	
        <cfreturn nlist />
    </cffunction> 
    
    <cffunction name="ListDistinct" access="public" returntype="string">
        <cfargument name="List" type="string" required="yes" />
        <cfargument name="delimiter" type="string" default=","/>
         
		<cfset arguments.List = replace(arguments.List,'#delimiter# ','#delimiter#','all') />
        <cfset arguments.List = replace(arguments.List,' #delimiter#','#delimiter#','all') />
        <cfset nlist = ""/>
        <cfloop list="#arguments.List#" index="_lst" delimiters="#arguments.delimiter#">  
   
            <cfif ListValueCount(nlist,_lst,arguments.delimiter) eq 0>
				<cfset nlist = ListAppend(nlist,_lst,arguments.delimiter) />
            </cfif>
                       
        </cfloop> 
       	
        <cfreturn nlist />
    </cffunction>
    
<!---    <cffunction name="_xxx" access="private" returntype="boolean">
    	<cfargument name="l" type="string" required="yes" />
        <cfargument name="f" type="string" required="yes" />
        <cfargument name="d" type="string" required="yes" />
        
        <cfset boo = false />
        <cfloop list="#l#" delimiters="#d#" index="i">
        	<cfif f eq i >
            	<cfset boo = true />
                <cfbreak />
            </cfif>
        </cfloop>
        
        <cfreturn boo/>
    </cffunction>--->

<!---    <cffunction name="ListDistinctNoCase2" access="public" returntype="string">
        <cfargument name="List" type="string" required="yes" />
        <cfargument name="delimiter" type="string" default=","/>
        
		<CFSET temp_list="">
        <CFLOOP list="#arguments.list#" index="i">
            <CFIF ListFindNoCase(temp_list,i,arguments.delimiter) EQ 0>
                <CFSET temp_list = ListAppend(temp_list,i,arguments.delimiter)>
            </CFIF>
        </CFLOOP>
          
       	
        <cfreturn temp_list />
    </cffunction>
        
    <cffunction name="ListDistinctNoCase" access="public" returntype="string">
        <cfargument name="List" type="string" required="yes" />
        <cfargument name="delimiter" type="string" default=","/>
        
		<cfset qTemp = ListToQuery('ListItem',LCase(List)) />
        <cfquery name="qList" dbtype="query" >
        	SELECT DISTINCT(ListItem) FROM qTemp
        </cfquery>
          
       	
        <cfreturn ValueList(qList.ListItem,delimiter) />
    </cffunction>--->
    
    <cffunction name="QueryToList" access="public" returntype="string">
        <cfargument name="Query" type="query" required="yes" />
        <cfargument name="Column" type="string" required="yes" />
        <cfargument name="delimiter" type="string" default=","/>
        
        <cfset sList = "" >
		<cfloop query="Query">
        	<cfset sList = ListAppend(sList,evaluate(Column),delimiter) />
        </cfloop>
       	
        <cfreturn sList />
    </cffunction>
    
</cfcomponent>