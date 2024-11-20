<!--- Author:	Arowolo Abiodun M.
----- Created	17/02/2012
----- Updated	17/02/2012
----- Copyright	adexfe systems (c) 2009
----- About		Coldfusion custom tag for AWAF --->

<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start"> 
     
    <cfparam name="Attributes.type" type="string" default="query"/> 
    <cfparam name="Attributes.datasource" type="any"/> 
    <cfparam name="Attributes.striped" type="boolean" default="true"/>
    <cfparam name="Attributes.hover" type="boolean" default="true"/>
    <cfparam name="Attributes.compressed" type="boolean" default="false"/>
    <cfparam name="Attributes.bordered" type="boolean" default="false"/>

	<!--- clear footer content --->
    <cfset request.PlainGrid.Footer.content = ""/>
    
<cfelse> 


<cfset cls = "table"/>
<cfif Attributes.striped><cfset cls = ListAppend(cls,"table-striped"," ")/></cfif>
<cfif Attributes.hover><cfset cls = ListAppend(cls,"table-hover"," ")/></cfif>
<cfif Attributes.compressed><cfset cls = ListAppend(cls,"table-condensed"," ")/></cfif>
<cfif Attributes.bordered><cfset cls = ListAppend(cls,"table-bordered"," ")/></cfif>	

<!---<cfif Attributes.type eq "query">
	<cfset totalRecord = Attributes.datasource.recordcount/>
</cfif>--->
<table class="#cls#">
<thead>
    <tr>
    	<cfloop array="#request.PlainGrid.columns#" index="attr">
        	<th <cfif attr.align neq"">style="text-align:#attr.align#;"</cfif>>
            	#attr.caption#
            </th>
        </cfloop>       
    </tr>
</thead>
<tbody>
	<cfloop query="Attributes.datasource">
        <tr>
            <cfloop array="#request.PlainGrid.columns#" index="attr">
                <td <cfif attr.align neq"">style="text-align:#attr.align#;"</cfif>>  
                	<cfswitch expression="#attr.format#">
                    	<cfcase value="money">
							#numberformat(evaluate(attr.value),'9,999.99')#
						</cfcase>
                    	<cfcase value="date">
							#dateformat(evaluate(attr.value),'dd-mmm-yy')#
						</cfcase>
                        <cfdefaultcase>
							<cfloop list="#attr.value#" delimiters="#attr.delimiters#" index="cur_value">								
								#evaluate(cur_value)#
							</cfloop>
						</cfdefaultcase>
                   	</cfswitch>
                </td>
            </cfloop>       
        </tr>
    </cfloop>
</tbody>
<cfif request.PlainGrid.Footer.content neq "">
<tfoot>
	<tr>
    	<td colspan="#ArrayLen(request.PlainGrid.columns)#" style="text-align:#request.PlainGrid.Footer.align#">#request.PlainGrid.Footer.Content#</td>
    </tr>
</tfoot>
</cfif>
</table>


</cfif> 
</cfoutput>