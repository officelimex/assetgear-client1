<cfcomponent>

	<cffunction name="init" access="public" returntype="Random">
    
    	<cfreturn this />
    </cffunction>
    
    <cffunction name="RandValue" access="public" returntype="string">
        <cfargument name="Length" required="yes" default="6" type="numeric">
        <cfargument name="Type" required="no" type="string" default="all"><!--- numbers,alphabets --->
        
        <cfset alph = "A,B,C,D,E,F,G,H,J,K,L,M,N,P,Q,R,S,T,U,V,W,X,Y,Z"> 
        <cfset temp="">
        <cfset Pick=0>
        <cfloop from="1" to="#arguments.length#" index="i">
            <cfif Type eq 'all'> 
                <cfset Pick = randrange(0,1)> 
            <cfelseif Type eq "numbers">
                <cfset Pick = 1>
            </cfif>
            <cfif Pick eq 1>
                <cfset temp=temp & randRange(2,9)>
            <cfelse>
                <cfset temp = temp & listgetat(alph,randrange(1,24),',')>
            </cfif>		
        </cfloop> 
        <cfreturn temp />
    </cffunction>

</cfcomponent>