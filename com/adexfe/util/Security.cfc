<cfcomponent>

	<cffunction name="init" access="public" returntype="Security"> 
    
		<cfreturn this>
	</cffunction>
    
    <cffunction name="URLEncrypt" returntype="string" access="public">
        <cfargument name="querystring" required="yes" type="string"> 
        <cfargument name="key" required="no" type="string" default="p">
        
        <cfreturn "h=#Encrypt(arguments.querystring, arguments.key, 'CFMX_COMPAT','hex')#">
    </cffunction> 
    
    <cffunction name="URLDecrypt" returntype="struct" access="public">
        <cfargument name="hashstring" required="yes" type="string">
        <cfargument name="key" required="no" type="string" default="p">
        
		<cfset url['QueryString'] = "">
        <cftry>
            <cfif len(arguments.hashstring)>
                <cfset qs = Decrypt(arguments.hashstring, arguments.key, 'CFMX_COMPAT','hex')>                
                <cfloop list="#qs#" index="lst" delimiters="&">
                	<cfset res2 = ListLast(lst,'=')>
					<cfif listlen(lst,'=') eq 1>
                    	<cfset res2 = "">
                    </cfif>                	
                    <cfset res1 = ListFirst(lst,'=')>
                    <cfset url[res1] = res2>
                    <cfset url['QueryString'] = ListAppend(url['QueryString'],"#res1#=#res2#",'&')>
                </cfloop>
            </cfif>
            <cfcatch type="any">
            
            </cfcatch>
        </cftry>
        
        <cfreturn url>
    </cffunction> 
    
    <cffunction name="GenerateLicenceKey" returntype="string" access="public">
    	<cfargument name="cn" required="yes" type="string">
        <cfargument name="sd" required="no" type="string">
        <cfargument name="ed" required="no" type="string">
        
        <cfset nh ="">
        <cfif arguments.sd neq "" or arguments.ed neq "">
  		<cfset h = hash(lcase(arguments.cn) & Dateformat(arguments.sd,'yyyy-mm-dd') & Dateformat(arguments.ed,'yyyy-mm-dd'))>

    	<cfset nh = left(h,4)>
  		<cfloop from="1" to="#len(h)#" index="i">
			<cfif not i mod 5>
                <cfset nh = nh & "-" & mid(h,i,5)>
            </cfif>
    	</cfloop>
 
		<cfset nh = ListDeleteAt(nh,1,'-')>
        <cfset nh = ListDeleteAt(nh,6,'-')>
        </cfif>
   		<cfreturn nh> 
    </cffunction>
    
</cfcomponent>