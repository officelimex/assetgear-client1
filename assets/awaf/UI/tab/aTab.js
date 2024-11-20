/*!
 * AWAF JS Library 0.0.0.1
 * Copyright(c) 2011 Adexfe Systems Ltd.
 * http://awaf.adexfe.com/license
 */

/**
 * @class aTab
 * A class that create Tabs
 */
aTab = new Class({
    
    Extends: aComponent, 
	
    options: {
		'cls' : {
			tabContainer : 'tab_container', // the container of the entire tab
			tabHandle : 'tab_handle', // the handler for the tab
			tabContent : 'tab_content', // the container of all the tab pane
			tabPane : 'tab_pane', // the content of an individual tab
			tab : 'tab', // tab title
			tabSelected : 'selected' // the selected tab
		},
		orientation : 'h',
		size:{
			width : '100%',
			height: '100%' 
		}
    }, 
	
	tabHandle : null,
	
	tabContent : null, 
	
	tabIndex : 0,
    
    /** 
	 * Class constructor, create the tab container.
     * @param {String}	the Id of the entire tab.
     * @param {Object}	(optional) Optoions as defined by the user 
	 **/	
    initialize : function(id, options) {
        this.parent(id, options);
		
		this.tabHandle = new Element('div', {
			'class' : this.options.cls.tabHandle	
		});
		
		this.tabContent = new Element('div', {
			'class' : this.options.cls.tabContent	
		});

		// create the container for this tab
		this.toObject = new Element('div', {
			'id' : id,
			'class' : this.options.cls.tabContainer,
			styles : {
				height : this.options.size.height,
				width : this.options.size.width	
			}
		}).adopt(this.tabHandle, this.tabContent);  
    },

    /**
     * Create new tab.
     * @param {String}	the title of the new tab to create.
     * @param {Element}	aPane, the content of the tab
	 **/		
 	newTab : function(tile, el)	{
		this.tabIndex++;
		var nT = new Element('div', {
			html : tile,
			'class' : this.options.cls.tab,
			events : {
				click : function(e)	{
					this.select(e.target); 
					this.fireEvent('tabclick',e);
				}.bind(this),
				mouseenter : function(e)	{
					e.target.addClass('hover');
					this.fireEvent('tabmouseenter');
				}.bind(this),
				mouseleave : function(e)	{
					e.target.removeClass('hover');
					this.fireEvent('tabmouseleave');
				}.bind(this)
			}	
		});
		
		if(typeOf(el)!='element'){
			el = new Element('div', {html:el});	
		}
		
		var ntCont = new Element('div', {
			'class' : this.options.cls.tabPane	
		}).adopt(el);
		
		this.tabHandle.adopt(nT);
		this.tabContent.adopt(ntCont); 
	},

    /**
     * Select tab to display.
     * @param {Element}	the tab to display. 
	 **/	
	select: function(el) {	
		var tabs = $$('#' + this.Id + ' .' + this.options.cls.tabHandle + ' .' + this.options.cls.tab);  
 
		var contents = $$('#' + this.Id + ' .' + this.options.cls.tabContent + ' .' + this.options.cls.tabPane);
	   
		tabs.removeClass(this.options.cls.tabSelected);
		el.addClass(this.options.cls.tabSelected);
		contents.setStyle('display','none');
		
		var content = contents[tabs.indexOf(el)];
		content.setStyle('display','block'); 
		this.fireEvent('tabChange');
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
		content.setStyle('display','block'); 
		this.fireEvent('tabChange');
	}
});
