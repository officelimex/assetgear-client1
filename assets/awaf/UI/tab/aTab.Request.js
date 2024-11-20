/*!
 * AWAF JS Library 0.0.0.1
 * Copyright(c) 2011 Adexfe Systems Ltd.
 * http://awaf.adexfe.com/license
 */

/**
 * @class aTab.Request
 * A class that create Tabs
 */
aTab.Request = new Class({
    
    Extends: aTab,
	
    options: {
		'cls' : {
			tabContainer : 'tab_container', // the container of the entire tab
			tabHandle : 'tab_handle', // the handler for the tab
			tabContent : 'tab_content', // the container of all the tab pane
			tabPane : 'tab_pane', // the content of an individual tab
			tab : 'tab', // tab title
			tabSelected : 'selected' // the selected tab
		},
		assets : {
			'loading' : 'assets/awaf/UI/img/loading.gif',
			'spacer' : 'assets/awaf/UI/img/spacer.gif',
			'refresh' : 'assets/awaf/UI/img/refresh1.png'
		}
    }, 
    
    /** 
	 * Class constructor, create the tab container.
     * @param {String}	the Id of the entire tab.
     * @param {Object}	(optional) Optoions as defined by the user 
	 **/	
    initialize : function(id, options) {
        this.parent(id, options); 
    },

    /** 
	 * create click event on tab menu.
     * @param {Event}	the event argument.
     * @param {Image Element}	the refresh icon by the tab menu	
	 **/
	_tabMenuClick : function(e, imgR)	{
		e.stop();
		this.fireEvent('click', e);					 
		this.select(e.target, imgR); 
		if(typeOf(imgR)=='element')	{
			imgR.removeClass('tab_ref_higlight');
		}
	},
	
    /**
     * Create new tab.
     * @param {String}	the title of the new tab to create.
     * @param {String}	url page
	 **/		
 	newTab : function(tile, uloc)	{
		this.tabIndex++;
		
		var imgRefresh = new Element('img', {
			src : this.options.assets.refresh,
			align : 'absmiddle',
			ref : this.tabIndex,
			alt : 'r',
			title : 'Refresh',
			'class' : 'tab_ref_higlight',
 			styles :	{
				'padding-left': '2px',
			},
			events : {
				'click' : function(e)	{  
					e.stop();
					if(confirm('Are you sure you want to refresh the content of this tab?'))	{
						this.fireEvent('refresh');
						// TODO: 
						// work on a way so that the user will not be able to 
						// click twice once the refrsh button has been clicked
						this.showTab(e.target.get('ref'));
					}
				}.bind(this)
			}	
		}); 
		
		var nT = new Element('div', {
			html : tile,
			'class' : this.options.cls.tab,
			'ref' : uloc, 
			// events for each tabs
			events : {
				'click' : function(e)	{
					e.stop();  
					this._tabMenuClick(e, imgRefresh); 
				}.bind(this),
				mouseenter : function(e)	{
					e.target.addClass('hover');	
					if(this.isSelected(e.target))	{
						imgRefresh.removeClass('tab_ref_higlight');
					}					
					this.fireEvent('mouseenter');
				}.bind(this),
				mouseleave : function(e)	{
					e.target.removeClass('hover');
					imgRefresh.addClass('tab_ref_higlight');
					this.fireEvent('mouseleave');
				}.bind(this)
			}	
		}).adopt(imgRefresh);
		
		var imgLoading = new Element('img', {
			events : {
				'click' : function(e)	{e.stop();},
				'mouseenter' : function(e)	{e.stop();},
				'mouseleave' : function(e)	{e.stop();}
			},
			'src' : this.options.assets.spacer,
			align : 'absmiddle',
			'class' : 'load', 
			styles : {
				'padding-right' : '2px',				
				'padding-bottom': '3px',
			},
			height : '13px',
			width : '13px'
		});
			
		nT.grab(imgLoading, 'top');
 
		var ntCont = new Element('div', {
			id : this.Id + '_' + this.tabIndex,
			'class' : this.options.cls.tabPane	
		});
		
		this.tabHandle.adopt(nT);
		this.tabContent.adopt(ntCont); 
	},

    /**
     * check if the current tab is the selected  one.
     * @param {Element}	the tab to display.
	 **/
	isSelected: function(el)	{ 

		var tabs = $$('#' + this.Id + ' .' + this.options.cls.tabHandle + ' .' + this.options.cls.tab);  
		var contents = $$('#' + this.Id + ' .' + this.options.cls.tabContent + ' .' + this.options.cls.tabPane);
		var rt = false;	
		var content = contents[tabs.indexOf(el)];
		if(content.getStyle('display')=='block')	{
			rt = true;	
		} 
		return rt;
	},	
	
    /**
     * Select tab to display.
     * @param {Element}	the tab to display. 
	 * @param {Boolean}	force the contect to reload. 
	 * @param {Image Element}	the refresh icon near the tab menu.
	 **/ 
	select: function(el, bReloadCont) {
		var imgR = el.lastChild;
		var bReloadCont = (arguments[1]) ? arguments[1] : false ;	

		var tabs = $$('#' + this.Id + ' .' + this.options.cls.tabHandle + ' .' + this.options.cls.tab);  
 
		var contents = $$('#' + this.Id + ' .' + this.options.cls.tabContent + ' .' + this.options.cls.tabPane);
	   
		tabs.removeClass(this.options.cls.tabSelected);
		el.addClass(this.options.cls.tabSelected);
		contents.setStyle('display','none');
		
		var content = contents[tabs.indexOf(el)];
		if(content.get('text')=='')	{
			this._requestContent(content, el);
		}
		content.setStyle('display','block'); 
		this.fireEvent('change');
	},
	
    /**
     * Select tab to display.
     * @param {Number}	the tab to display. 
	 **/	
	showTab: function(idx) {	  
		var tabs = $$('#' + this.Id + ' .' + this.options.cls.tabHandle + ' .' + this.options.cls.tab);  
		var contents = $$('#' + this.Id + ' .' + this.options.cls.tabContent + ' .' + this.options.cls.tabPane);	   
	   	
		tabs.removeClass(this.options.cls.tabSelected);
		var tab = tabs[idx-1]
		tab.addClass(this.options.cls.tabSelected);
		contents.setStyle('display','none');
		
		var content = contents[idx-1];
		this._requestContent(content, tab);
		
		content.setStyle('display','block'); 
		this.fireEvent('tabChange');
	},
	
	_requestContent : function(ntCont, tabHandle)	{ 
		
		var uloc = tabHandle.get('ref');
		var imgLoading = tabHandle.firstChild;	
		var imgR = tabHandle.lastChild;	 
		
		new Request.HTML({noCache:true, link:'ignore', url: uloc, update: ntCont,
			onRequest: function()	{ 
				tabHandle.removeEvents('click');
				imgLoading.set('src', this.options.assets.loading);
			}.bind(this),
			onSuccess: function(){}, 
			onFailure: function(r){alert(r.statusText)},
			onComplete: function(){
				// add event back
				tabHandle.addEvent('click', function(e)	{
					this._tabMenuClick(e, imgR);
				}.bind(this));
				//
				imgLoading.set('src', this.options.assets.spacer); 
				this.fireEvent('rendercomplete'); 
			}.bind(this)
		}).send(); 
	}
});
