<cfcomponent>

	<cffunction name="init" access="public" returntype="bString"> 
    
		<cfreturn this>
	</cffunction>
    
<!---    <cffunction access="remote" name="Output" returntype="string">
    	<cfargument name="s" type="string" required="yes">
        <cfargument name="t" type="string" required="no" default="string">
        
        <cfset var stemp = s>
        
        <cfswitch expression="#t#">
        	<cfcase value="money">
            	<cfset stemp = NumberFormat(val(stemp),'_,___.__')>
            </cfcase> 
        </cfswitch>
        
        <cfreturn stemp>
    </cffunction>--->
    
	<cffunction name="cfListFirst" access="remote" returntype="string">
		<cfargument name="val_" type="string" required="yes">
        <cfargument name="del" type="string" required="yes">
        
		<cfset r=ListFirst(arguments.val_,arguments.del)>
		
        <cfreturn r>
	</cffunction>
    
    <cffunction name="Capitalize" access="public" returntype="string">
    	<cfargument name="svalue" required="yes" type="string">
        <cfargument name="delimeter" required="no" type="string" default=" ">
        
        
		<cfset svalue = lcase(svalue)>
        <cfset stemp = "">
         
        <cfloop list="#svalue#" delimiters="#delimeter#" index="sval">
            <cfset sval = trim(sval)>
            <cfset len_sval = len(sval)>
            <cfif len_sval eq 1>
                <cfset nval = ucase(Left(trim(sval),1))>
            <cfelse>
                <cfset nval = ucase(Left(sval,1)) & right(sval,len_sval-1) >
            </cfif> 
            <cfset stemp = listAppend(stemp,nval,delimeter)> 
        </cfloop> 
        
        <cfreturn stemp >
    </cffunction>
    
    <cffunction name="Capitalize2" access="public" returntype="string">
    	<cfargument name="svalue" required="yes" type="string"> 
        
        <cfset svalue = lcase(svalue)>
        <cfset stemp = "">
         
        <cfloop list="#svalue#" delimiters=" " index="sval">
            <cfset sval = trim(sval)>
            <cfset len_sval = len(sval)>
            <cfif len_sval eq 1>
                <cfset nval = ucase(Left(trim(sval),1))>
            <cfelse>
                <cfset nval = ucase(Left(sval,1)) & right(sval,len_sval-1) >
            </cfif>  
            
            <cfset stemp = listAppend(stemp,nval,' ')> 
        </cfloop> 
        
        <cfset stemp2="">
        <cfloop list="#stemp#" delimiters="#chr(13)#" index="sval"> 
        	 <cfset sval = trim(sval)>
             <cfset len_sval = len(sval)>
            <cfif len_sval eq 1>
                <cfset nval = ucase(Left(trim(sval),1))>
            <cfelseif len_sval-1 eq -1>
            	<cfset nval = ucase(Left(sval,1))>
            <cfelse>
                <cfset nval = ucase(Left(sval,1)) & right(sval,len_sval-1) >
            </cfif>  
            <cfset stemp2 = listAppend(stemp2,nval & ' ',chr(13))> 
        </cfloop>
        
        <cfset stemp3="">
        <cfloop list="#stemp2#" delimiters="." index="sval"> 
        	 <cfset sval = trim(sval)>
             <cfset len_sval = len(sval)>
            <cfif len_sval eq 1>
                <cfset nval = ucase(Left(trim(sval),1))>
            <cfelseif len_sval-1 eq -1>
            	<cfset nval = ucase(Left(sval,1))>
            <cfelse>
                <cfset nval = ucase(Left(sval,1)) & right(sval,len_sval-1) >
            </cfif>  
            <cfset stemp3 = listAppend(stemp3, nval,'.')> 
        </cfloop>
        
        <cfreturn stemp3 >
    </cffunction>
    
    <cffunction name="FormatFormXInput" returntype="string" access="public">
    	<cfargument name="st" required="yes" type="string" />
        
        <cfset t = "" />
		<cfloop list="#arguments.st#" index="sl" delimiters="#chr(10)#">
        	<cfif sl neq "">
				<cfif Left(sl,1) eq "-">
					<cfset t = ListAppend(t,'<li style="margin-left:28px !important;">#sl#</li>',' ') />	
				<cfelse>
					<cfset t = ListAppend(t,'<li style="margin-left:14px !important;">#sl#</li>',' ') />
                </cfif>
            </cfif>
        </cfloop>
        
        <cfreturn t />
    </cffunction>
    
    <cffunction name="WikiToHTML" access="public" returntype="any">
        <cfargument name="s" type="string" required="yes"/>
         
        <!--- save each line of text and process --->
        <cfset data=""/>
        <cfset alphab = "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z"/>
        <cfset roman = "i,ii,iii,iv,v,vi,vii,viii,ix,x,xi,xii,xiii,xiv,xv,xvi,xvii,xviii"/>
        <cfset open = false>
        <cfset rec = ArrayNew(1)/>
        <cfset s_ = replacenocase(arguments.s,chr(10),'<br/>#chr(10)#','all')/>
        
        <!--- work with image --->
        <cfset s_ = replacenocase(s_,"[image source",'<img src','all')/>
        <cfset s_ = replacenocase(s_,'"/]','"/>','all')/> 
        
        <!--- formating --->
        <cfset s_ = replacenocase(s_,"[b]","<b>",'all')/>
        <cfset s_ = replacenocase(s_,"[/b]","</b>",'all')/>
        <cfset s_ = replacenocase(s_,"[i]","<i>",'all')/>
        <cfset s_ = replacenocase(s_,"[/i]","</i>",'all')/>
        
        <cfset s_ = replacenocase(s_,"[quote]","<div style='background:##eee; border-top:1px solid ##bbb;border-bottom:1px solid ##bbb; padding:5px; width=60%; color:##000;'>",'all')/>
        <cfset s_ = replacenocase(s_,"[/quote]","</div>",'all')/>
        
        <cfloop list="#s_#" delimiters="#chr(10)#" index="line"> 
         
            <cfset ArrayAppend(rec,trim(line))/>
            
        </cfloop>
        
        <cfset i=0/><cfset j=0/>
        <cfset num="[num],[number]"/>
        <cfset pon="*"/> <cfset pon2="**"/><cfset pon3="***"/>
        <cfloop array="#rec#" index="line">
            <cfset i=i+1/> 
            <cfif ListFindnocase(num,line)>
                <cfset j = 0/>
                <cfset open=true/>
            <cfelseif ListFindnocase(pon,ListFirst(line,' '))>
                <cfset j=j+1/>
                <cfset alf = 0/>
                <cfset line=clean(line,pon)/>           
                <cfset data=data & "<div style='padding-left:10px;'>#j#." & line & "</div>" />
            <cfelseif ListFindnocase(pon2,ListFirst(line,' '))>
                <cfset line=clean(line,pon2)/>
                <cfset alf=alf+1/>
                <cfset rom = 0/>
                <cfset data=data & "<div style='padding-left:25px;'>#ListGetAt(alphab,alf)#." & line & "</div>" />
            <cfelseif ListFindnocase(pon3,ListFirst(line,' '))>
                <cfset line=clean(line,pon3)/>
                <cfset rom=rom+1/>
                <cfset data=data & "<div style='padding-left:40px;'>#ListGetAt(roman,rom)#." & line & "</div>" />
            <cfelseif ListFirst(line,' ') eq '='>
                <cfset line=clean(line,'=')/>
                <cfset data=data & "<div style='padding:10px 0 4px 0; font-weight:bold;'>" & line & "</div>" />
            <cfelse>
            	<cfset alf = 0/><cfset j = 0/>
                <cfset data = data & "<div>#line#</div>"/ >
            </cfif>
        </cfloop>  
        
        <cfreturn data/>
    </cffunction>
    
    <cffunction name="clean" access="private" returntype="string">
        <cfargument name="a" required="yes" type="string"/>
        <cfargument name="c" required="yes" type="string"/>
        
        <cfset temp=arguments.a/>
        <cfloop list="#arguments.c#" index="l">
            <cfset temp = replacenocase(temp,l,'')/>
        </cfloop>
        
        <cfreturn temp/>    
    </cffunction>
    
    <cffunction access="public" name="AgeOf" hint="tells the age of an object using two dates" output="yes">
		<cfargument name="oDate" required="yes" hint="date of object that you want to et the age of" type="date"/>
        <cfargument name="cDate" required="no" hint="current date to use to evaluate the age of the object" type="date" default="#now()#"/>
        
        <!--- start with seconds & minites --->
        <cfset stemp = dateDiff('n',arguments.oDate,arguments.cDate)/>
        <cfif stemp lt 1>
        	<cfset stemp = dateDiff('s',arguments.oDate,arguments.cDate) />
            <cfif stemp gt 1>
				<cfset stemp = stemp & " seconds"/>
            <cfelseif stemp eq 0>
            	<cfset stemp = "a second"/>
            <cfelse>
				<cfset stemp = stemp & " second"/>
            </cfif>
        <cfelse>
        	<cfif stemp gt 1><cfset stemp = stemp & " minutes"/><cfelse><cfset stemp = stemp & " minute"/></cfif>
        </cfif>
        
        <cfset nst = val(ListFirst(stemp,' '))/>
		<cfif nst gt 59>
			<!--- hours & days --->
            <cfset stemp = dateDiff('h',arguments.oDate,arguments.cDate)/> 
            <cfif stemp lt 24>
                <cfif stemp gt 1>
					<cfset stemp = stemp & " hours"/>
                <cfelseif stemp eq 1>
                	<cfset stemp = "an hour"/>
                <cfelse>
					<cfset stemp = stemp & " hour"/>
                 </cfif>
            <cfelse> 
            	<cfset stemp = dateDiff('d',arguments.oDate,arguments.cDate)/>
                <cfif stemp gt 1>
					<cfset stemp = stemp & " days"/>
                <cfelseif stemp eq 1>
                	<cfset stemp = "a day"/>
                <cfelse>
					<cfset stemp = stemp & " day"/>
                </cfif>
            </cfif>
        </cfif>
        
        <cfreturn stemp/>
    </cffunction>
</cfcomponent>