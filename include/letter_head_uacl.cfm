<cfparam name="request.letterhead.noline" default="false" type="boolean"/>
<cfparam name="request.letterhead.logosize" default="190" type="numeric"/>
<cfparam name="request.letterhead.titlesize" default="13" type="numeric"/>
<cfparam name="request.letterhead.date" default=""/>

<cfoutput>
   <tr>
      <td class="noline">
         <table width="100%" border="0">
            <tr>
               <td width="#request.letterhead.logosize#+15" rowspan="2" align="left" valign="top" class="noline">
                  <img src="#application.site.url#assets/img/uacl.png" width="#request.letterhead.logosize#">
                  <div style="font-family:Arial, Helvetica, sans-serif;">
                     <div style="font-size:#request.letterhead.titlesize-3#px; font-weight:bold;">Umugini Asset Company Limited</div>
                     <div style="font-size:#request.letterhead.titlesize-5#px;color:gray;">ERIEMU / UMUSADEGE OIL FIELD</div>
                  </div>
               </td>
               <td valign="middle" style="" >

               </td>
               <td align="right" valign="bottom" style="font-family: Tahoma;" class="noline">
                  <div style="font-size:#request.letterhead.titlesize#px;font-weight: bold;">#request.letterhead.title#</div>
                  <div style="font-size:#request.letterhead.titlesize-3#px;margin-top:5px;">
                     <cfif request.letterhead.date neq "">
                        <span>#request.letterhead.date#</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                     </cfif>
                     <span style="font-size:#request.letterhead.titlesize+1#px;">#request.letterhead.id#</span>
                  </div>
               </td>
            </tr>
            <cfif !request.letterhead.noline>
               <tr>
                  <td colspan="2" style="font-size:3px"><div style="border-top:##ECF4CF 1px solid; margin-top:1px;">&nbsp;</div></td>
               </tr>
            </cfif>
         </table>
      </td>
   </tr>
</cfoutput>
