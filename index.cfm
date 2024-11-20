<!--- 
	Author: Arowolo Abiodun
	Created: 2011/09/03
	Modified: 2011/09/03
--->
<cfif !request.IsLogin><cflocation url="login.cfm" addtoken="false" ></cfif>
<cfoutput>
<!DOCTYPE html>
<html lang="en"><head> 
<link rel="icon" href="favicon.ico" type="image/x-icon">
<link rel="shortcut icon" href="favicon.ico" type="image/x-icon"> 
<link rel="shortcut icon" href="favicon.ico">
<link rel="apple-touch-icon-precomposed" sizes="144x144" href="assets/img/144_icon.png">
<link rel="apple-touch-icon-precomposed" sizes="72x72" href="assets/img/72_icon.png">
<link rel="apple-touch-icon-precomposed" href="assets/img/57_icon.png">
    
<script type="text/javascript" src="assets/awaf/mootools/mc-1.4.5.js"></script>
<script type="text/javascript" src="assets/awaf/mootools/mm-1.4.0.1.js"></script>
<script type="text/javascript" src="assets/awaf/UI/Meio.Autocomplete.js"></script>
<script type="text/javascript" src="assets/awaf/UI/ckeditor/ckeditor.js"></script>
<script type="text/javascript" src="assets/awaf/UI/awaf-0.0.4.0.js?v=1.3"></script>

<script type="text/javascript" src="assets/awaf/UI/canvasjs.min.js"></script> 

<!--- import datepicker ---->
<script type="text/javascript" src="assets/awaf/UI/datepicker/dp.js"></script> 
<link href="assets/awaf/UI/datepicker/css/datepicker_vista.css" rel="stylesheet" type="text/css" media="screen" />

<link href="assets/awaf/UI/css/aGrid.css" rel="stylesheet" type="text/css" media="screen" />
<link href="assets/awaf/UI/css/aWindow.css" rel="stylesheet" type="text/css" media="screen" />
<link href="assets/awaf/UI/css/bootstrap.min.2.2.1.css" rel="stylesheet" type="text/css" media="screen" />
<link href="assets/awaf/UI/css/Style.css" rel="stylesheet" type="text/css" media="screen" />
<link href="assets/awaf/UI/tab/aCustomTab.css" rel="stylesheet" type="text/css" media="screen" /> 

<cfimport taglib="assets/awaf/tags/xWindow_1000/" prefix="w" />

<style>
	##__inbox_count{ border-radius:7px; padding:0px 8px; margin-right:20px; font-weight:bold; background-color:##FF0000; color:white !important;} 
	.canvasjs-chart-credit{display:none !important;}

</style>
<cfimport taglib="assets/awaf/tags/xTab_1000/" prefix="t"/>

<t:TabRequest id="#application.AppModuleId#" IsApplicationTab>
	<cfset qM = application.com.Module.getModulesInRole(request.userinfo.role)/>
    <cfloop query="qM">
    	<cfif qM.Code eq "__message">
        	<t:Tab id="#qM.Code#" title='#qM.Title# <sup id="__inbox_count">5</sup>' url="#qM.URL#"/>
        <cfelse>
    		<t:Tab id="#qM.Code#" title="#qM.Title#" url="#qM.URL#"/>
        </cfif>
    </cfloop>
    <cfswitch expression="#request.userinfo.role#">
    	<cfcase value="WH"><t:DefaultTab renderTo="__bdy" tabid="__warehouse"/></cfcase>
        <cfcase value="HSE"><t:DefaultTab renderTo="__bdy" tabid="__ptw"/></cfcase>
        <cfdefaultcase><t:DefaultTab renderTo="__bdy" tabid="__maintenance"/></cfdefaultcase>        
    </cfswitch>
    
</t:TabRequest>
 
<script language="Javascript" type="text/javascript"> 
	function resizeTab()	{
		var stabH = window.getSize().y	- 115;
		var mtabH = stabH - 10;
		$$('.s_tab_container').setStyle('height',stabH);
		$$('.m_tab_container').setStyle('height',mtabH);
	} 
	<!---window.addEvent('domready', function(){
		var urlP = 'modules/ajax/profile.cfm?cmd=GetNoticeCount&current_count=';
		new Request({
			method: 'post',
			url: urlP+$('__notice_count').get('text'),
			initialDelay: 1,
			delay: 200000,
			limit: 600000,
			onRequest: function(){},
			onSuccess: function(r){
				$('__notice_count').set('text', r); 
				this.options.url = urlP+$('__notice_count').get('text'); 
			}//,
			//onFailure: function(r){showError(r);}
		}).startTimer();
	});--->
</script>
<title>AssetGear &mdash; #application.appName#</title>
<style>
##_user_session{
	text-align:right;
	position:fixed;
	z-index:999999999;
	right:0px;
	top:0px;
	color:##bbbbbb;
	font: 12px/normal Arial, Helvetica, sans-serif;
	width:300px;
}
##_user_session span	{
	color:##FFFFCC;
	font-weight: bold;
	line-height:19px; cursor:pointer;
}
##_user_session img.pic	{
	float:right;
	text-align:right;
	padding-left:5px;
}

##_user_session a {color:white;}
##_notify_aera{position:fixed; z-index:999999999;right:0px; bottom:0px; width:300px;}
</style>
</head>
<body id="bdy" class="__bdy" onResize="resizeTab();" onLoad="resizeTab();" style="overflow:hidden;">
<!--- pligin ---> 
<div id="_user_session">
<img class="pic" src="http://www.gravatar.com/avatar/#lcase(Hash(lcase(request.userinfo.personalemail)))#?s=41" height="41px" width="41px"/>
<w:Window Caption="#request.userinfo.user#" title="My Profile" url="modules/profile/profile.cfm"  Width="700px" >
	<w:Button IsSave/>
</w:Window>
<div>
<w:Window Height="400px" Width="750px" Caption="<img src='assets/img/notice.png'/> <span id=__notice_count></span>" title="Notification" url="modules/profile/notice.cfm"/> &mdash; <a href="logout.cfm">Logout</a></div>
</div>
<div id="_notify_aera"></div>
 <div id="hd" style="background-color:##EEEFF0; text-shadow:white 1px 1px 1px;">
 
 </div>  
</div>
</body>
</html>
</cfoutput> 