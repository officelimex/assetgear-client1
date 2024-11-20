/*
 * AWAF JS Library 0.0.2.1
 * Copyright(c) 2011 Adexfe Systems Ltd.
 * http://awaf.adexfe.com/license
 */
/*
 * @class aComponent
 * A class that create aComponent
 */
var aComponent = new Class({
		
		Implements : [Events, Options],
		
		options : {
			'layout' : 'default',
			'layoutConfig' : null
		},
		
		Id : '',
		toObject : null,
		
		/*
		 * Class constructor, create the tab container.
		 * @param {String}	the Id of the entire tab.
		 * @param {Object}	(optional) options as defined by the user
		 **/
		initialize : function (id, options) {
			
			this.Id = id;
			this.setOptions(options);
			
		},
		
		/*
		* Select tab to display.
		* @param {Element}	the tab to display.
		**/
		render : function () {
			var lid = this.options.layout + '_' + this.Id;
			var rt = new Element('div', {
					id : lid
				}).adopt(this.toObject);
			
			switch (this.options.layout) {
			case 'fit':
				rt.setStyles({
					border : '10px solid red'
				});
				break;
			}
			return rt;
		}
		
	});

var aContainer = new Class({
		
		Extends : aComponent,
		
		options : {
			bg : 'white',
			border : 0,
			padding : '0px 0px 0px 0px'
		},
		
		initialize : function (cont, options) {
			
			this.parent(String.uniqicID, options);
			
			return new Element('div', {
				html : cont,
				styles : {
					'background-color' : this.options.bg,
					'border' : this.options.border + 'px solid #5D6C7A',
					'height' : '100%',
					'padding' : this.options.padding
				}
			});
		}
		
	});

var aTab = new Class({
		
		Extends : aComponent,
		
		options : {
			'cls' : {
				tabContainer : 'tab_container', // the container of the entire tab
				tabHandle : 'tab_handle', // the handler for the tab
				tabContent : 'tab_content', // the container of all the tab pane
				tabPane : 'tab_pane', // the content of an individual tab
				tab : 'tab', // tab title
				tabSelected : 'selected' // the selected tab
			},
			orientation : 'h',
			size : {
				width : '100%',
				height : '100%'
			}
		},
		
		tabHandle : null,
		
		tabContent : null,
		
		tabIndex : 0,
		
		/*
		 * Class constructor, create the tab container.
		 * @param {String}	the Id of the entire tab.
		 * @param {Object}	(optional) options as defined by the user
		 **/
		initialize : function (id, options) {
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
		
		/*
		 * Create new tab.
		 * @param {String}	the title of the new tab to create.
		 * @param {Element}	aPane, the content of the tab
		 **/
		newTab : function (tile, el) {
			this.tabIndex++;
			var nT = new Element('div', {
					html : tile,
					'class' : this.options.cls.tab,
					events : {
						click : function (e) {
							this.select(e.target);
							this.fireEvent('tabclick', e);
						}
						.bind(this),
						mouseenter : function (e) {
							e.target.addClass('hover');
							this.fireEvent('tabmouseenter');
						}
						.bind(this),
						mouseleave : function (e) {
							e.target.removeClass('hover');
							this.fireEvent('tabmouseleave');
						}
						.bind(this)
					}
				});
			
			if (typeOf(el) != 'element') {
				el = new Element('div', {
						html : el
					});
			}
			
			var ntCont = new Element('div', {
					'class' : this.options.cls.tabPane
				}).adopt(el);
			
			this.tabHandle.adopt(nT);
			this.tabContent.adopt(ntCont);
		},
		
		/*
		 * Select tab to display.
		 * @param {Element}	the tab to display.
		 **/
		select : function (el) {
			var tabs = $$('#' + this.Id + ' .' + this.options.cls.tabHandle + ' .' + this.options.cls.tab);
			
			var contents = $$('#' + this.Id + ' .' + this.options.cls.tabContent + ' .' + this.options.cls.tabPane);
			
			tabs.removeClass(this.options.cls.tabSelected);
			el.addClass(this.options.cls.tabSelected);
			contents.setStyle('display', 'none');
			
			var content = contents[tabs.indexOf(el)];
			content.setStyle('display', 'block');
			this.fireEvent('tabChange');
		},
		
		/*
		 * Select tab to display.
		 * @param {Number}	the tab to display.
		 **/
		showTab : function (idx) {
			var tabs = $$('#' + this.Id + ' .' + this.options.cls.tabHandle + ' .' + this.options.cls.tab);
			var contents = $$('#' + this.Id + ' .' + this.options.cls.tabContent + ' .' + this.options.cls.tabPane);
			
			tabs.removeClass(this.options.cls.tabSelected);
			var tab = tabs[idx - 1];
			tab.addClass(this.options.cls.tabSelected);
			contents.setStyle('display', 'none');
			var content = contents[idx - 1];
			content.setStyle('display', 'block');
			this.fireEvent('tabChange');
		}
	});

aTab.Request = new Class({
		
		Extends : aTab,
		
		options : {
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
		
		/*
		 * Class constructor, create the tab container.
		 * @param {String}	the Id of the entire tab.
		 * @param {Object}	(optional) options as defined by the user
		 **/
		initialize : function (id, options) {
			this.parent(id, options);
		},
		
		/*
		 * create click event on tab menu.
		 * @param {Event}	the event argument.
		 * @param {Image Element}	the refresh icon by the tab menu
		 **/
		_tabMenuClick : function (e, imgR) {
			e.stop();
			this.fireEvent('click', e);
			this.select(e.target, imgR);
			if (typeOf(imgR) == 'element') {
				imgR.removeClass('tab_ref_higlight10');
			}
		},
		
		/*
		 * Create new tab.
		 * @param {String}	the id for the tab.
		 * @param {String}	the title of the new tab to create.
		 * @param {String}	url page
		 * @param [json]	opts	option for the creation of the new tab {clickable, class}
		 **/
		newTab : function (_id, tile, uloc, opts) {
			
			var _clickable = true,
			selclass = _id,
			_css = '';
			
			if (typeOf(opts) != 'null') {
				if (typeOf(opts['class']) != 'null') {
					_css = opts['class'];
				}
				if (typeOf(opts.clickable) != 'null') {
					_clickable = false;
				}
			}
			
			this.tabIndex++;
			
			var nT = new Element('div', {
					html : tile,
					id : selclass + '_t',
					'class' : this.options.cls.tab + ' ' + selclass + ' ' + _css,
					'ref' : uloc
				});

			if (_clickable == true) {
				var imgRefresh = new Element('img', {
						src : this.options.assets.refresh,
						align : 'absmiddle',
						ref : selclass,
						alt : 'r',
						title : 'Refresh',
						'class' : 'tab_ref_higlight10',
						styles : {
							'padding-left' : '2px',
							'opacity' : '0.3',
							'filter' : 'alpha(opacity=30)',
							'-ms-filter' : 'progid:DXImageTransform.Microsoft.Alpha(Opacity=30)'
						},
						events : {
							'click' : function (e) {
								e.stop();
								if (confirm('Are you sure you want to refresh the content of this tab?')) {
									this.fireEvent('refresh');
									// TODO:
									// work on a way so that the user will not be able to
									// click twice once the refresh button has been clicked
									this.showTab(e.target.get('ref'));
								}
							}
							.bind(this)
						}
					});

				var imgLoading = new Element('img', {
						events : {
							'click' : function (e) {
								e.stop();
							},
							'mouseenter' : function (e) {
								e.stop();
							},
							'mouseleave' : function (e) {
								e.stop();
							}
						},
						'src' : this.options.assets.spacer,
						align : 'absmiddle',
						'class' : 'load',
						styles : {
							'padding-right' : '2px',
							'padding-bottom' : '3px'
						},
						height : '13px',
						width : '13px'
					});

				// add event to tab
				nT.addEvent('click', function (e) {
					e.stop();
					this._tabMenuClick(e, imgRefresh);
				}
					.bind(this));
				nT.addEvent('mouseenter', function (e) {
					e.target.addClass('hover');
					if (this.isSelected(e.target)) {
						imgRefresh.removeClass('tab_ref_higlight10');
					}
					this.fireEvent('mouseenter');
				}
					.bind(this));
				nT.addEvent('mouseleave', function (e) {
					e.target.removeClass('hover');
					imgRefresh.addClass('tab_ref_higlight10');
					this.fireEvent('mouseleave');
				}
					.bind(this));

				nT.adopt(imgRefresh);
				nT.grab(imgLoading, 'top');
			}
			
			var ntCont = new Element('div', {
					id : selclass + '_c',
					'class' : this.options.cls.tabPane + ' ' + selclass
				});
			this.tabContent.adopt(ntCont);
			this.tabHandle.adopt(nT);
		},
		
		/*
		 * check if the current tab is the selected  one.
		 * @param {Element}	the tab to display.
		 **/
		isSelected : function (el) {
			var tabs = $$('#' + this.Id + ' .' + this.options.cls.tabHandle + ' .' + this.options.cls.tab);
			var contents = $$('#' + this.Id + ' .' + this.options.cls.tabContent + ' .' + this.options.cls.tabPane);
			var rt = false;
			
			var content = contents[tabs.indexOf(el)];
			
			if (content.getStyle('display') == 'block') {
				rt = true;
			}
			return rt;
		},
		
		/*
		 * Select tab to display.
		 * @param {Element}	the tab to display.
		 * @param {Boolean}	force the content to reload.
		 **/
		select : function (el, bReloadCont) {
			var imgR = el.lastChild;
			var bReloadCont = (arguments[1]) ? arguments[1] : false;
			
			var tabs = $$('#' + this.Id + ' .' + this.options.cls.tabHandle + ' .' + this.options.cls.tab);
			var contents = $$('#' + this.Id + ' .' + this.options.cls.tabContent + ' .' + this.options.cls.tabPane);
			
			tabs.removeClass(this.options.cls.tabSelected);
			el.addClass(this.options.cls.tabSelected);
			contents.setStyle('display', 'none');
			
			var content = contents[tabs.indexOf(el)];
			if (content.get('text') == '') {
				this._requestContent(content, el);
			}
			content.setStyle('display', 'block');
			this.fireEvent('change');
		},
		
		/*
		 * Select tab to display.
		 * @param [String]	the id the tab
		 **/
		showTab : function (idx) {
			var tabs = $$('#' + this.Id + ' .' + this.options.cls.tabHandle + ' .' + this.options.cls.tab);
			var contents = $$('#' + this.Id + ' .' + this.options.cls.tabContent + ' .' + this.options.cls.tabPane);
			
			tabs.removeClass(this.options.cls.tabSelected);
			
			var tab = $(idx + '_t');
			tab.addClass(this.options.cls.tabSelected);
			
			contents.setStyle('display', 'none');
			
			var content = $(idx + '_c');
			this._requestContent(content, tab);
			
			content.setStyle('display', 'block');
			
			this.fireEvent('tabChange');
		},
		
		_requestContent : function (ntCont, tabHandle) {
			
			var uloc = tabHandle.get('ref');
			var imgLoading = tabHandle.firstChild;
			
			var imgR = tabHandle.lastChild;
			
			new Request.HTML({
				noCache : true,
				link : 'ignore',
				url : uloc,
				update : ntCont,
				onRequest : function () {
					tabHandle.removeEvents('click');
					imgLoading.set('src', this.options.assets.loading);
				}
				.bind(this),
				onSuccess : function () {},
				onFailure : function (e) {
					var d = e.responseText.clean();
					var re = new RegExp("<\s*h1[^>]*>(.*?)<\s*/\s*h1>", "gmi");
					ntCont.innerHTML = 'Error on request:\r\r' + re.exec(d)[1];
				},
				onComplete : function () {
					// add event back
					tabHandle.addEvent('click', function (e) {
						this._tabMenuClick(e, imgR);
					}
						.bind(this));
					//
					imgLoading.set('src', this.options.assets.spacer);
					this.fireEvent('rendercomplete');
				}
				.bind(this)
			}).send();
		}
	});

var aButton = new Class({
		
		Extends : aComponent,
		
		options : {
			'value' : 'button',
			'click' : function () {},
			'class' : '',
			'title' : '',
			styles : {}
		},
		
		initialize : function (id, options) {
			this.parent(id, options);
			var but = new Element('input[type="button"]', {
					'id' : id,
					'class' : 'btn ' + this.options['class'],
					'title' : this.options.title,
					styles : this.options.styles,
					events : {
						click : this.options.click
					}
				});
			but.value = this.options.value;
			return but;
		}
		
	});

/*
add class to aGrid for twitter bootsrap table
 */
var aGrid = new Class({

		Extends : aComponent,

		options : {
			commandWidth : '',
			firstsortOrder : 'ASC',
			url : '',
			'class' : 'table-striped', // table-condensed
			imgSrc : 'assets/awaf/UI/img/',
			method : 'get',
			perPage : 20,
			headers : [], //
			columns : [], // caption, id, nowrap
			commands : [], // type = 'button,img,text',
			width : '100%',
			searchParam : ''
		},

		initialize : function (el, options) {
			this.parent(el, options);
			this.el = $(el);
			this.pages = 0;
			this.createElements();
			// help check if the pinned command has been displayed
			this.pincounter = 0;
		},

		createElements : function () {

			// build the table structure..
			if (this.options.headers.length == 0) {
				this.options.headers = this.options.columns;
			} else {
				this.options.columns = this.options.headers;
			}
			var hlen = this.options.headers.length + 1;
			var structureHtml = "<table id='" + this.Id + "_t' class='table table-striped " + this.options['class'] + "'><thead><tr></tr></thead><tfoot><tr><td colspan='" + hlen + "'><div>&nbsp;<span class='moo-foot-left'></span><span class='search'></span><span class='moo-foot-right'></span></div></td></tr></tfoot><tbody></tbody></table>";

			// Assign the HTML and CSS class to our element
			this.el.set('html', structureHtml);
			this.el.addClass('moo-table');
			this.el.setStyle('width', this.options.width);
			// Grab the important elements
			this.table = this.el.getChildren("table")[0];
			this.tableBody = this.table.getChildren("tbody")[0];
			this.tableHead = this.table.getChildren("thead")[0];
			this.footerLeft = this.table.getElements('tfoot > tr > td > div > span.moo-foot-left')[0];
			this.footerSearch = this.table.getElements('tfoot > tr > td > div > span.search')[0];
            this.searchButton = null;
			this.footerRight = this.table.getElements('tfoot > tr > td > div > span.moo-foot-right')[0];
			// initiate and create the headers
			this.headersEl = [];
			this.createHeaders();

		},

		createHeaders : function () {
			var headerTr = this.tableHead.getChildren("tr")[0];

			//create select for search
			var sSearch = new Element('select');

			// Create the column headers
			var headerLen = this.options.headers.length - 1;
			this.options.headers.each(function (header, index) {
				// hide th
				if (header['hide'] == true) {
					// do nothing
				} else {
					if (typeOf(header['caption']) == 'null') {
						header['caption'] = header['id'];
					}
					var headerTd = new Element('th', {
							id : this.Id + header['id'],
							html : header['caption']
						});

					// add the click event for column re-ordering
					if (header['sortable']) {
						headerTd.addEvent("click", function (arg1) {
							// remove the grid id
							this.reorder(arg1.get('id').replace(this.Id, ''));
						}
							.bind(this, headerTd));
					}
					this.headersEl.push(headerTd);
					headerTd.inject(headerTr);
				}
				// create search object
				if (header['searchable'] == true) {
					new Element('option', {
						'value' : header['field'],
						'text' : header['caption']
					}).inject(sSearch);
				}

				// create commands
				if ((headerLen == index) && (this.options.commands.length != 0)) {
					//alert(this.Id);
					this.headersEl.push(new Element('th', {
							id : this.Id + '_pinned_cmd',
							styles : {
								'width' : this.options.commandWidth,
								'text-align' : 'right'
							},
							html : '&nbsp;'
						}).inject(headerTr));
				}
			}, this);

			var stxt = new Element('input', {
					'type' : 'text',
					events : {
						keydown : function (e) {
							if (e.key == 'enter') {
                                this.searchGrid(stxt.value,sSearch.value);
							}
						}.bind(this)
					}
			});
			//var srBut='';
            this.searchButton = new Element('a', {
					'html' : '<i class="icon-search icon-white"/>',
					'class' : 'btn btn-warning',
					events : {
						click : function (e) {
                            this.searchGrid(stxt.value,sSearch.value);
						}.bind(this)
					}
				});

			this.footerSearch.adopt(sSearch, stxt, this.searchButton);

			// Set the initial page and sort column...
			this.page = 1;
			this.sort = 'id';
			// set the sort order to DESC, it will be inverted to ASC by default on first call...
			this.sortOrder = "DESC";

			this.reorder(this.options.headers[0]['id']);
		},

        /*
         * @Function void searchGrid
         * @param string kw	: keyword
         * @param string flvi :	field
         */
        searchGrid : function(kw,fld) {
            this.options.searchParam = '&keyword=' + kw + '&field=' + fld;
            this.requestData(1);// start the search from page 1
        },

		reorder : function (id) {
			var orderClass = "";
			if (this.sort == id) {
				// same column clicked... just reverse the order...
				this.sortOrder = this.sortOrder == "DESC" ? "ASC" : "DESC";
			} else {
				// new column clicked, set to ASC by default
				this.sortOrder = this.options.firstsortOrder //"ASC";
			}

			orderClass = this.sortOrder == "ASC" ? "moo-active-asc" : "moo-active-desc";
			this.activeColumnEl = this.tableHead.getChildren("tr")[0].getChildren("th#" + this.Id + id)[0];
			this.headersEl.each(function (el) {
				el.removeClass('moo-active-column');
				el.removeClass('moo-active-asc');
				el.removeClass('moo-active-desc');
			});

			this.activeColumnEl.addClass("moo-active-column");
			this.activeColumnEl.addClass(orderClass);
			this.sort = id;
			// send the new request
			this.requestData(this.page);
		},

		requestData : function (page) {
			// initiate the ajax request...
			new Request.JSON({
				url : this.options.url + this.options.searchParam,
				method : this.options.method,
				onRequest : function () {
                    //TODO: disable the search button
                    //this.searchButton.disabled=true;
					//this.footerLeft.set('html', 'Wait');
				}.bind(this),
				onSuccess : function (resp) {
					if (resp == null) {
						this.footerLeft.set('html', "Invalid JSON result...");
					} else {
						this.parseData(resp.total, resp.page, resp.rows);
					}
				}.bind(this),
                onComplete : function ()    {
                    //this.searchButton.removeClass('disabled');
                }.bind(this),
				onFailure : function (e) {
					showError(e);
					//var d=e.responseText.clean();
					//var re = new RegExp("<\s*h1[^>]*>(.*?)<\s*/\s*h1>", "gmi");
					//this.footerLeft.set('html', 'Error on request:\r\r' + re.exec(d)[1]);
				}.bind(this)
			}).send("page=" + page + "&perPage=" + this.options.perPage + '&sort=' + this.sort + '&sortOrder=' + this.sortOrder);
			this.page = page;
		},

		parseData : function (total, page, rows) {
			var i = -1;
			// empty the table first...
			this.tableBody.empty();
			//alert();
			rows.each(function (row, index) {
				var index = index + 1;
				// Create a new row...
				var tr = new Element('tr', {
						'valign' : 'top',
						'tween' : {
							duration : 'long',
							transition : 'bounce:out'
						}
					});
				// Check if it's an even row...
				//var cssClass = index % 2 == 0 ? 'moo-table-even' : 'moo-table-odd';
				//tr.addClass(cssClass);

				// insert individual data
				row.each(function (cell) {
					// get template form header
					i++;
					if (this.options.headers.length == i) {
						i = 0;
					}
					fmt = this.options.headers[i]["template"];

					// hide coloum
					if (this.options.headers[i]['hide'] == true) {
						// do nothing
					} else {
						if (typeOf(fmt) != 'null') {
							cell = eval(fmt);
						}

						if (this.options.columns[i]['nowrap'] == true) {
							new Element('td', {
								html : cell,
								styles : {
									'white-space' : 'nowrap'
								}
							}).inject(tr);
						} else {
							new Element('td', {
								html : cell
							}).inject(tr);
						}
					}
				}, this);
				// add command
				if (this.options.commands.length != 0) {
					this.createCommand(row, tr, index).inject(tr);
				}

				tr.inject(this.tableBody);
				if (index == this.options.perPage) {
					tr.addClass('moo-table-last');
				}
			}, this);
			// set the total pages if not set...
			this.pages = Math.ceil(total / this.options.perPage);

			var recMax = this.options.perPage * page;
			recMax = recMax > total ? total : recMax;
			var recMin = (this.options.perPage * page) - (this.options.perPage - 1);
			// Set the footer data
			//this.footerLeft.set('html', "Page " + page + " of " + this.pages + " [ " + recMin + " to " + recMax + " of " + total + " ] ");
			this.footerLeft.set('text', "");
			// refresh button
			this._addRefreshButton();
			this.paginate();
		},

		_addRefreshButton : function () {
			this.footerLeft.adopt(new Element('a', {
					html : '<i class="icon-refresh icon-white"/> ',
					'class' : 'btn btn-success',
					events : {
						'click' : function () {
							this.options.searchParam = "";
							this.reloadActivePage();
						}.bind(this)
					}
				}));
		},

		/*
		* @Function void createCommand
		* 		Create the command button to on the right side of the Grid
		* @param array row : Items on the row of the Grid
		*		(do not change this variable name, its used outside this script.
		*		will work on a better solution in upcoming version)
		* @param element tr	:
		* @param number	i :	Current item on the Grid
		*/
		createCommand : function (row, tr, i) {
			var cmdEl = new Element('td', {
					'class' : 'cmd'
				});
			//alert(tr);
			var dv = new Element('div', {
					style : 'float:right',
					'class' : 'btn-group'
				});
			this.options.commands.each(function (cmd, index) {
                var eType, cmdid, cmdText, cmdIcon, eTxt, cmdPin;
                eType = 'a';
                cmdid = cmd['id'];
                cmdText = '';
                cmdIcon = '';
                eTxt = '';
                cmdPin = cmd['pin'];
				this.pincounter = this.pincounter + 1
					// if the cmd button is pinned
					if (cmdPin && this.pincounter == 1) {

						var pin_id = $(this.Id + '_pinned_cmd');
						if (typeOf(cmd['text']) != 'null') {
							cmdText = eTxt = cmd['text'];
						}
						if (typeOf(cmd['type']) != 'null') {
							eType = cmd['type'];
						}
						if (typeOf(cmd['icon']) != 'null') {
							eTxt = '<i class="icon-' + cmd['icon'] + '"></i> ' + eTxt;
						}

						var i_Cmd = new Element('a', {
								'class' : cmd['class'],
								html : eTxt,
								events : {
									click : function (e) {
										this.fireEvent(cmdid + 'click');
									}
									.bind(this)
								}
							});
						// add other optional attributes
						if (typeOf(cmd['help']) != 'null') {
							i_Cmd.set('title', cmd['help']);
						}

						pin_id.adopt(i_Cmd);

					} else
						if (!cmdPin) {
							// check if the command has a condition defined
							var if_condition = '';
							if (typeOf(cmd['condition']) != 'null') {
								if_condition = cmd['condition'];
							}
							if (typeOf(cmd['text']) != 'null') {
								cmdText = eTxt = cmd['text'];
							}
							if (typeOf(cmd['type']) != 'null') {
								eType = cmd['type'];
							}
							if (typeOf(cmd['icon']) != 'null') {
								eTxt = '<i class="icon-' + cmd['icon'] + '"></i> ' + eTxt;
							}
							var iCmd; // command
							if(if_condition=='')	{// not defined
								iCmd = new Element('a', {
										'class' : cmd['class'],
										html : eTxt,
										events : {
											click : function (e) {
												this.fireEvent(cmdid + 'click', [tr, row, e]);
											}
											.bind(this)
										}
								});
							}
							else	{
								if(eval(if_condition))	{
									iCmd = new Element('a', {
											'class' : cmd['class'],
											html : eTxt,
											events : {
												click : function (e) {
													this.fireEvent(cmdid + 'click', [tr, row, e]);
												}.bind(this)
											}
									});
								}
								else	{// disable control
									// do nothing
								}
							}

							if(typeOf(iCmd)!='null')	{
								// add other optional attributes
								if (typeOf(cmd['help']) != 'null') {
									iCmd.set('title', cmd['help']);
								}

								iCmd.inject(dv);
							}
						}
			}, this);
			return cmdEl.adopt(dv);
		},

		paginate : function () {
			// clear the old pagination...
			//alert(this.page + " " + this.pages);
			this.footerRight.empty();
			//alert(this.pages);
			if (this.pages == 1) {
				return;
			} else {
				if (this.page > 1) {
					// previous link
					var prevLink = new Element('a', {
							'html' : "←",
							'events' : {
								'click' : function () {
									this.pageClicked("prev");
									return false;
								}
								.bind(this)
							}
						});
					prevLink.inject(this.footerRight);
				}
				// First page
				if (this.page == 1) {
					// We are on the first page so, non-clickable...
					var pr = new Element('span', {
							'html' : "←",
							'class' : 'moo-active-page-noclick'
						});
					pr.inject(this.footerRight);
					var page1Span = new Element('span', {
							'html' : "1",
							'class' : 'moo-active-page'
						});
					page1Span.inject(this.footerRight);
				} else {
					// Not on first page so... clickable...
					var page1Link = new Element('a', {
							'html' : '1',

							'events' : {
								'click' : function () {
									this.pageClicked("first");
									return false;
								}
								.bind(this)
							}
						});
					page1Link.inject(this.footerRight);
				}

				if (this.page > 2) {
					var leftSpacer = new Element('span', {
							'html' : ' . '
						});
					leftSpacer.inject(this.footerRight);
					if (this.page == this.pages && this.pages > 3) {
						var minusTwo = new Element('a', {
								'html' : this.page - 3 + "",

								'events' : {
									'click' : function () {
										this.pageClicked(this.page - 2);
										return false;
									}
									.bind(this)
								}
							});
						minusTwo.inject(this.footerRight);
					}

					var minusOne = new Element('a', {
							'html' : this.page - 1 + "",

							'events' : {
								'click' : function () {
									this.pageClicked(this.page - 1);
									return false;
								}
								.bind(this)
							}
						});
					minusOne.inject(this.footerRight);

				}
				if (this.page != 1 && this.page != this.pages) {
					var current = new Element('span', {
							'html' : this.page + "",
							'class' : 'moo-active-page'
						});
					current.inject(this.footerRight);
				}
				if (this.page < this.pages - 1) {

					var plusOne = new Element('a', {
							'html' : this.page + 1 + "",

							'events' : {
								'click' : function () {
									this.pageClicked(this.page + 1);
									return false;
								}
								.bind(this)
							}
						});
					plusOne.inject(this.footerRight);

					if (this.page == 1 && this.pages > 3) {
						var plusTwo = new Element('a', {
								'html' : this.page + 2 + "",

								'events' : {
									'click' : function () {
										this.pageClicked(this.page + 2);
										return false;
									}
									.bind(this)
								}
							});
						plusTwo.inject(this.footerRight);
					}

					// spacer
					var rightSpacer = new Element('span', {
							'html' : ' . '
						});
					rightSpacer.inject(this.footerRight);
				}
				if (this.page == this.pages) {

					var lastPageSpan = new Element('span', {
							'html' : this.pages + "",
							'class' : 'moo-active-page btn-priamry'
						});
					lastPageSpan.inject(this.footerRight);
					var pr = new Element('span', {
							'html' : "→",
							'class' : 'moo-active-page-noclick'
						});
					pr.inject(this.footerRight);
				} else {

					var lastPageLink = new Element('a', {
							'html' : this.pages + "",

							'events' : {
								'click' : function () {
									this.pageClicked("last");
									return false;
								}
								.bind(this)
							}
						});
					lastPageLink.inject(this.footerRight);
				}

				if (this.page < this.pages) {
					var nextLink = new Element('a', {
							'html' : "→",
							'events' : {
								'click' : function () {
									this.pageClicked("next");
									return false;
								}
								.bind(this)
							}
						});
					nextLink.inject(this.footerRight);
				}
			}
		},

		pageClicked : function (page) {

			if (typeOf(page) === "string") {
				if (page === "next" && this.page < this.pages) {
					this.fireEvent('nextclick');
					this.requestData(this.page + 1);
				} else
					if (page === "prev" && this.page > 1) {
						this.fireEvent('prevclick');
						this.requestData(this.page - 1);
					} else
						if (page === "first" && this.page != 1) {
							this.fireEvent('firstclick');
							this.requestData(1);
						} else
							if (page === "last" && this.page != this.pages) {
								this.fireEvent('lastclick');
								this.requestData(this.pages);
							}
			} else {
				if (page > 0 && page <= this.pages) {
					this.fireEvent('paging');
					this.requestData(page);
				}
			}
		},

		// only "public" method, (with the constructor huh)...
		// used if, for example, you delete a record and you
		// want to refresh the current active page...
		reloadActivePage : function () {
			this.requestData(this.page);
		}
	});

var aWindow = new Class({
		
		Extends : aContainer,
		
		options : {
			title : 'Window',
			position : {
				x : null,
				y : null
			},
			modal : false,
			size : {
				width : '600px',
				height : '300px',
				min_height : ''
			},
			ctrlButtons : {
				'close' : true,
				hide : true
			},
			warnBeforeClose : false,
			draggable : true,
			renderTo : '',
			url : ''
		},
		
		windowFrame : null,
		modalWindow : null,
		windowInnerFrame : null,
		windowContentFrame : null,
		buttonFrame : null,
		winTitle : null,
		titleBar : null,
		
		initialize : function (id, options) {
			// check if element already exitthis.parent(id, options);\this.parent(id, options);\
			if (this.options.renderTo == '') {
				this.options.renderTo = document.body;
			}
			
			this.id = id;
			if (typeOf($(id)) == 'element') {
				$('mdl__' + id).style.display = 'block';
				this._makewindowActive(id);
				var winId = $$('#' + id + ' .dbx-titlebar');
				winId.set('tween', {
					duration : 'long',
					transition : 'bounce:out'
				});
				winId.highlight('#ddd');
			} else {
				this.parent(id, options);
				
				this.winTitle = new Element('div', {
						'class' : 'dbx-t'
					});
				
				var clsButton = this._createCloseButton();
				var minButton = this._createHideButton();
				
				var clsButtonFrame = new Element('div', {
						'class' : 'dbx-ctl'
					}).adopt(minButton, clsButton);
				
				this.titleBar = new Element('div', {
						'class' : 'dbx-titlebar'
					}).adopt(this.winTitle, clsButtonFrame);
				
				this.buttonFrame = this._createButtonFrame();
				this.windowContentFrame = this._createWindowContentFrame();
				
				this.windowInnerFrame = this._createWindowInnerFrame().adopt(this.windowContentFrame);
				
				this.windowFrame = this._createWindowFrame(id);
				this.windowFrame.adopt(this.titleBar, this.windowInnerFrame, this.buttonFrame);
				
				this.modalWindow = this._createModality().adopt(this.windowFrame);
				
				this.setProperties(this.options);
				//write element
				this.options.renderTo = document.id(this.options.renderTo);
				this.options.renderTo.adopt(this.modalWindow);
				
				if (this.options.draggable) {
					this.windowFrame.makeDraggable({
						'handle' : this.titleBar
					});
				}
				
				this._addContent((new aPane.Request(this.options.url)));
			}
			this._makewindowActive(id);
		},
		
		addButton : function (el) {
			this.buttonFrame.adopt(el);
		},
		
		addCloseButton : function () {
			/*		this.buttonFrame.adopt(new aButton(String.uniqicID, {
			'value':'Close',
			click : function()	{
			this.close();
			}.bind(this)
			}));*/
			this.buttonFrame.adopt(new Element('a', {
					html : '<i class="icon-remove icon-white"></i> Close',
					'class' : 'btn btn-danger',
					styles : {
						'float' : 'left',
						'clear' : 'right'
					},
					events : {
						click : function () {
							this.close();
						}
						.bind(this)
					}
				}));
		},
		
		_addContent : function (el) {
			if (this.windowContentFrame.childElementCount == 0) {
				this.windowContentFrame.adopt(el);
			}
		},
		
		show : function () {
			this.fireEvent('show');
			this.modalWindow.show();
		},
		
		hide : function () {
			this.fireEvent('hide');
			this.modalWindow.hide();
		},
		
		close : function () {
			this.fireEvent('close');
			this.modalWindow.dispose();
		},
		
		getSize : function () {
			return this.windowFrame.getSize();
		},
		
		setProperties : function (properties) {
			this.setOptions(properties);
			this._setTitle();
			this._setPosition();
		},
		
		_createCloseButton : function () {
			var clsButton = null
				if (this.options.ctrlButtons.close == true) {
					clsButton = new Element('div', {
							'class' : 'close',
							events : {
								click : function () {
									if (this.options.warnBeforeClose) {
										if (confirm('Are you sure you want to close this window?')) {
											this.close();
										}
									} else {
										this.close();
									}
								}
								.bind(this)
							}
						});
				}
				return clsButton;
		},
		
		_createHideButton : function () {
			var minButton = null;
			if (this.options.ctrlButtons.hide == true) {
				minButton = new Element('div', {
						'class' : 'hide',
						events : {
							click : function () {
								this.hide();
							}
							.bind(this)
						}
					});
			}
			return minButton;
		},
		
		_createWindowFrame : function (_id) {
			return new Element('div', {
				'class' : 'dbx-frame',
				id : _id,
				'styles' : {
					'width' : this.options.size.width,
					'min-width' : this.options.size.width,
					'min-height' : this.options.size.min_height
					//'height': this.options.size.height
				},
				events : {
					/*keydown : function(e)	{
					alert('d');
					if(e.key=='esc')	{
					this.close();
					}
					}.bind(this),*/
					click : function () {
						//get all dbx-frame elements on the page and make their z-index = 1000000
						this._makewindowActive(_id);
					}
					.bind(this)
				}
			});
		},
		
		_makewindowActive : function (_id) {
			$$('#' + this.options.renderTo.get('id') + ' .dbx-frame').setStyle('z-index', 10000000);
			$$('#' + this.options.renderTo.get('id') + ' .dbx-frame .dbx-titlebar .dbx-ctl .close').addClass('cls-dis');
			$(_id).setStyle('z-index', 1000001);
			$$('#' + _id + ' .dbx-titlebar .dbx-ctl .close').removeClass('cls-dis');
		},
		
		_createWindowInnerFrame : function () {
			return new Element('div', {
				'class' : 'dbx-inner-frame',
				'styles' : {
					'min-height' : this.options.size.height /* - 28*/
				}
			});
		},
		
		_createWindowContentFrame : function () {
			return new Element('div', {
				'class' : 'dbx-win-content',
				'styles' : {
					'height' : this.options.size.height // - 79
				}
			});
		},
		
		_createButtonFrame : function () {
			return new Element('div', {
				'class' : 'dbx-but-frame',
				'styles' : {
					height : '29px'
				}
			});
		},
		
		_createModality : function () {
			var _modal = new Element('div', {
					id : 'mdl__' + this.id
				});
			if (this.options.modal) {
				_modal.addClass('dbx-modal');
				_modal.setStyle('z-index', 1000001);
			}
			return _modal;
		},
		
		_setTitle : function () {
			this.winTitle.set('text', this.options.title);
		},
		
		_setPosition : function () {
			//if(this.options.renderTo==null){
			//	this.options.renderTo = document.body;
			//}
			var bsize = this.options.renderTo.getSize();				
			
			if (this.options.position.x == null) {
				this.options.position.x = 150 + (bsize.x / 2) - (parseInt(this.options.size.width) / 2);
			}
			if (this.options.position.y == null) {
				var h = parseInt(this.options.size.height)
					this.options.position.y = 100 //h/2;
					//if(h<=200)	{
					//	this.options.position.y = (h/2)+180;
					//}
					//this.options.position.y = (bsize.y/2)-(parseInt(this.options.size.height)/2);
			}
			
			this.windowFrame.setPosition(this.options.position);
			this.fireEvent('position');
		}
		
	});

var aPane = new Class({
		
		Extends : aContainer,
		
		options : {
			styles : {}
		},
		
		initialize : function (cont, options) {
			
			this.parent(this.options.id, options);
			
			var nE = new Element('div', {
					styles : this.options.styles
				});
			switch (typeOf(cont)) {
			case 'string':
				nE.set('html', cont);
				break;
			case 'element':
				nE.adopt(cont);
				break;
			}
			return nE;
		}
	});

aPane.Request = new Class({
		
		Extends : aPane,
		
		options : {},
		
		url : '',
		
		initialize : function (ul, options) {
			this.url = ul;
			var rt = new Element('div');
			this.parent(this.requestData(rt), options);
			return rt
		},
		
		requestData : function (u) {
			new Request.HTML({
				noCache : true,
				url : this.url,
				update : u,
				onRequest : function () {
					u.innerHTML = 'please wait...';
				},
				onFailure : function (e) {
					var d = e.responseText.clean();
					var re = new RegExp("<\s*h1[^>]*>(.*?)<\s*/\s*h1>", "gmi");
					u.innerHTML = '<div style="color:red">Error on request:\r\r' + re.exec(d)[1] + '</div>';
				}
			}).send();
		}
		
	});

/*
 * @class aNotify
 * A class that create aNotify
 */
var aNotify = new Class({
		
		Extends : aComponent,
		
		options : {
			'class' : 'alert',
			'type' : 'info'
			//'renderTo' : $('_notfy_aera')
		},
		/*
		 * Class constructor .
		 * @param {Object}	(optional) Options as defined by the user
		 **/
		initialize : function (options) {
			
			this.parent(String.uniqicID, options);
			this.nContainner = new Element('div', {
					'class' : this.options['class'] + ' alert-' + this.options.type,
					styles : {
						//width: this.options.width,
						position : 'relative',
						bottom : 0,
						right : 20,
						opacity : 0
					}
				});
			$('_notify_aera').adopt(this.nContainner);
			
		},
		
		/*
		 * close/distroy the alert
		 **/
		close : function () {
			var mfx = new Fx.Morph(this.nContainner, {
					duration : 1000,
					transition : Fx.Transitions.Back.easeInOut
				});
			mfx.start({
				'bottom' : [0, -100],
				'opacity' : [1, 0]
			});
			mfx.addEvent('complete', function (e) {
				this.nContainner.dispose();
				//this.nContainner = null;
			}
				.bind(this));
		},
		
		/*
		 * display the alert to the user
		 * @param {String}	the title of the entire tab.
		 * @param {String}	the message of the alert
		 **/
		alert : function (tle, msg) {
			var cls = new Element('a', {
					'class' : 'close',
					html : '&times;',
					events : {
						click : function (e) {
							this.close();
						}
						.bind(this)
					}
				});
			var tle = new Element('h4', {
					'class' : 'alert-heading',
					'text' : tle
				});
			var msg = new Element('span', {
					'text' : msg
				});
			
			this.nContainner.adopt(cls, tle, msg);
			
			var mfx = new Fx.Morph(this.nContainner, {
					duration : 800,
					transition : Fx.Transitions.Back.easeInOut
				});
			mfx.start({
				'bottom' : [-100, -10],
				'opacity' : [0, 1]
			});
			mfx.addEvent('complete', function (e) {
				(function () {
					this.close();
				}
					.bind(this)).delay(10000);
			}
				.bind(this));
			//delay
			
		}
		
	});

/*
 * @class aNavigate
 *
 */
var aNavigate = new Class({
		
		Extends : aComponent,
		
		options : {
			'items' : '', //array
			loadImage : 'assets/awaf/UI/img/loading.gif'
		},
		
		renderNavTo : null,
		renderNavToId : '',
		renderGridToId : '',
		renderTo : '',
		renderToId : '',
		mainNav : null,
		renderGridTo : null,
		/*
		 * Class constructor
		 * @param {string}	(required) Where to render the initial page
		 * @param {Object}	(optional) Optoions as defined by the user
		 **/
		initialize : function (rTo, options) {
			
			this.parent(String.uniqicID, options);
			this.renderToId = rTo;
			this.renderNavToId = rTo + '_nav';
			this.renderGridToId = rTo + '_grid';
			this.renderNavTo = document.id(this.renderNavToId);
			this.renderTo = document.id(rTo);
			this.renderGridTo = document.id(this.renderGridToId);
			// create the main nav menu
			this.mainNav = new Element('ul', {
					'class' : 'nav nav-list'
				});
			
			this.options.items.each(function (item_, i) {
				switch (item_.type) {
				case 'header':
					this.mainNav.adopt(new Element('li', {
							'class' : 'nav-header',
							html : item_.title
						}));
					break;
				case 'divider':
					this.mainNav.adopt(new Element('li', {
							'class' : 'divider'
						}));
					break;
				case 'new window':
					this.mainNav.adopt(new Element('li').adopt(new Element('a', {
								'html' : item_.title,
								'target' : '_blank',
								'href' : item_.url
							})));
					break;
				default:
					var act_ = '';
					if (typeOf(item_.isactive) == 'boolean') {
						if (item_.isactive == true) {
							act_ = 'active';
						}
					}
					var a_ = new Element('a', {
							html : item_.title
						});
					switch (typeOf(item_.url)) {
					case 'string':
						var imgL = new Element('img', {
								src : this.options.loadImage,
								'class' : 'display-none',
								styles : {
									'float' : 'right',
									'vertical-align' : 'middle'
								}
							});
						
						a_.adopt(imgL);
						
						a_.addEvent('click', function (e) {
							this.loadContent(item_.id, item_.url, imgL);
							$$('#' + this.renderNavToId + ' ul li').removeClass('active');
							e.target.parentElement.addClass('active');
						}
							.bind(this));
						break;
					}
					this.mainNav.adopt(new Element('li', {
							'class' : act_
						}).adopt(a_));
					break;
				}
				
			}, this);
			
			this.renderNavTo.adopt(this.mainNav);
			
		},
		
		/*
		 * load the content of a url
		 * @param {string}	(id) the id(class) of the containner
		 * @param {string}	(url) the url to load
		 * @param {Element}	(img_) the image to indicate loading
		 **/
		loadContent : function (id_, url, img_) {
			var _id_ = this.renderToId + "_" + id_;
			// find the element id_ in the dom structure before requesting for a new content
			
			if (typeOf($(_id_)) == 'element') {
				// the element exists
				//alert(this.renderGridToId);
				$$('#' + this.renderGridToId + ' .sub_page').each(function (i) {
					i.removeClass('display-block');
					i.addClass('display-none');
				});
				
				document.id(_id_).addClass('display-block');
				document.id(_id_).removeClass('display-none');
			} else {
				// element does not exists
				$$('#' + this.renderToId + ' .sub_page').addClass('display-none');
				var el = new Element('div', {
						id : _id_,
						'class' : id_ + ' sub_page display-block moo-table'
					});
				this.renderGridTo.adopt(el);
				
				new Request.HTML({
					noCache : true,
					url : url,
					update : document.id(_id_),
					onRequest : function () {
						img_.removeClass('display-none');
						img_.addClass('display-block');
					}
					.bind(this),
					onFailure : function (r) {
						alert(r.statusText);
					},
					onComplete : function () {
						img_.addClass('display-none');
						img_.removeClass('display-block');
					}
				}).send();
			}
		}
		
	});

/*
 * @class aNavigateTab
 *
 */
var aNavigateTab = new Class({
		
		Extends : aComponent,
		
		options : {
			'tabs' : [],
			'content' : [],
			'align' : '' //tabs-left'
		},
		
		mainTab : null,
		navTab : null,
		
		/*
		 * Class constructor
		 * @param {string}	(required) Where to render the initial page
		 * @param {Object}	(optional) Optoions as defined by the user
		 **/
		initialize : function (rTo, options) {
			
			this.parent(String.uniqicID, options);
			
			this.mainTab = new Element('div', {
					'class' : 'tabbable ' + this.options.align
				});
			this.navTab = new Element('ul', {
					'class' : 'nav nav-tabs'
				});
			this.mainContent = new Element('div', {
					'class' : 'tab-content'
				});
			
			var act_ = '';
			
			this.options.tabs.each(function (item_, i) {
				act_ = '';
				if (item_.isactive) {
					act_ = 'active';
				}
				var li_ = new Element('li', {
						'class' : act_
					}).adopt(new Element('a', {
							'html' : item_.title,
							events : {
								click : function (e) {
									//alert(i);
									$$('#' + rTo + ' ul li').removeClass('active');
									e.target.parentElement.addClass('active');
									// load content
									$$('#' + rTo + ' .tab-pane').removeClass('active');
									$$('#' + rTo + ' .tab-content')[0].getChildren()[i].addClass('active');
								}
								.bind(this)
							}
						}));
				
				this.navTab.adopt(li_);
			}, this);
			
			// build the content structure
			
			this.options.content.each(function (ct_, i) {
				act_ = '';
				if (ct_.isactive) {
					act_ = 'active';
				}
				var dv_ = new Element('div', {
						'class' : act_ + ' tab-pane'
					}).adopt(document.id(ct_.id));
				
				this.mainContent.adopt(dv_);
			}, this);
			
			this.mainTab.adopt(this.navTab, this.mainContent);
			document.id(rTo).adopt(this.mainTab);
		}
		
	});

/*
 * @class aFileUploader
 *
 */
var aFileUploader = new Class({
		
		Extends : aComponent,
		
		options : {
			'height' : '340px'
		},
		
		Containner : null,
		
		/*
		 * Class constructor
		 * @param {string}	(required) Where to render the initial page
		 * @param {Object}	(optional) Optoions as defined by the user
		 **/
		initialize : function (rTo, options) {
			
			this.parent(String.uniqicID, options);
			this.renderTo = $(rTo);
			this.UploadBox = new Element('div');
			var _a = new Element('div', {
					'class' : 'sapn12'
				});
			this.Containner = new Element('div', {
					'class' : 'row-fluid'
				}).adopt(_a);
			
			this.renderTo.adopt(this.UploadBox, this.Containner);
		},
		
		addUploadSection : function () {
			var nr = new Element('div', {
					'class' : 'row-fluid',
					styles : {
						'border-bottom' : '1px solid #ddd',
						'padding-top' : '5px'
					}
				});
			var pic = new Element('div', {
					'class' : 'span2',
					html : '&nbsp;'
				});
			var inp = new Element('div', {
					'class' : 'span4'
				});
			var progb = new Element('div', {
					'class' : 'span3',
					styles : {
						'padding-top' : '5px'
					}
				});
			var progc = new Element('div', {
					'class' : 'span1',
					html : '&nbsp;',
					styles : {
						'padding-top' : '3px'
					}
				});
			var btnP = new Element('div', {
					'class' : 'span2 btn-group',
					styles : {
						'padding-bottom' : '5px'
					}
				});
			
			nr.adopt(pic, inp, progb, progc, btnP);
			
			var p1 = new Element('div', {
					'class' : 'progress progress-info progress-striped active'
				});
			p1.setStyle('display', 'none');
			var progBar = new Element('div', {
					'class' : 'bar',
					styles : {
						width : '0%'
					}
				});
			progb.adopt(p1.adopt(progBar));
			
			/* delete uploaded file button */
			var dbtn = new Element('input', {
					'type' : 'button',
					'title' : 'Delete uploaded file',
					'value' : 'x',
					'class' : 'btn btn-small btn-danger',
					styles : {
						'display' : 'none'
					},
					events : {
						click : function (e) {
							_me = e.target;
							if (confirm('Are you sure you want to delete this file (' + _me.get('rel') + ')?')) {
								new Request({
									url : "assets/awaf/tags/xUploader_1000/deletefile.cfm?tempfolder=" + this.options.tempfolder + '&filename=' + _me.get('rel'),
									method : 'post',
									//onRequest: function(){)},
									onComplete : function (rt) {
										nr.destroy();
									}
									//onFailure: function(){alert('text', 'Sorry, your request failed :(');}
								}).send();
							}
						}
						.bind(this)
					}
				});
			
			/* button for uploading */
			var btn = new Element('input', {
					'type' : 'button',
					'class' : 'btn btn-small',
					'value' : 'upload',
					styles : {
						'display' : 'none'
					},
					events : {
						click : function (e) {
							var _me = e.target;
							var thisClass = this;
							var file = infu.files[0];
							if (typeOf(file) == 'undefined') {
								_me.disabled = true;
							}
							p1.setStyle('display', 'block');
							var xhrObj = new XMLHttpRequest();
							xhrObj.upload.addEventListener("progress", function (evt) {
								if (evt.lengthComputable) {
									var tt = Math.round(evt.loaded / evt.total * 100);
									progBar.setStyle('width', tt + '%');
									progc.set('html', tt + "%");
								}
							}, false);
							xhrObj.upload.addEventListener("load", function () {
								infu.disabled = true;
								_me.value = 'done';
								_me.disabled = true;
								p1.removeClass('active');
								//dbtn.disabled = false;
								dbtn.setStyle('display', 'block');
								thisClass.addUploadSection();
								// for firefox.
								progBar.setStyle('width', '100%');
								progc.set('html', '100%');
							}, false);
							xhrObj.open("POST", "assets/awaf/tags/xUploader_1000/upload.cfm?tempfolder=" + this.options.tempfolder, true);
							xhrObj.setRequestHeader("Content-type", file.type);
							xhrObj.setRequestHeader("X_FILE_NAME", file.name);
							// save the file name to the delete control
							dbtn.set('rel', file.name);
							xhrObj.send(file);
						}
						.bind(this)
					}
				});
			
			btnP.adopt(btn, dbtn)
			
			// build the file input
			var infu = new Element('input', {
					'type' : 'file',
					'accept' : this.options.accept,
					events : {
						change : function (evt) {
							var files = evt.target.files;
							// Loop through the FileList and render image files as thumbnails.
							for (var i = 0, f; f = files[i]; i++) {
								// Only process image files.
								if (!f.type.match('image.*')) {
									continue;
								}
								var reader = new FileReader();
								// Closure to capture the file information.
								reader.onload = (function (theFile) {
									return function (e) {
										pic.set('html', '<img class="thumb" src="' + e.target.result + '"/>');
									};
								})(f);
								// Read in the image file as a data URL.
								reader.readAsDataURL(f);
							}
							// make upload button visble
							btn.setStyle('display', 'block');
						}
					}
				});
			inp.adopt(infu);
			
			this.UploadBox.adopt(nr);
			new Fx.Scroll(this.renderTo).toBottom();
		}
		
	});

/*
 * @class aEditTable
 *
 */
var aEditTable = new Class({
		
		Extends : aComponent,
		
		options : {
			headers : [], // header : [{title:'',type:'', size, data:[[][]]},{}]
			data : [], // arrya of array of data. eg [[],[],[]]
			allowInput : false,
			allowUpdate : false,
			height : '300px',
			sessionId : '' // required
		},
		
		Containner : null,
		InputRow : null,
		Header : null,
		Content : null,
		ControlIdPrefix : null,
		RowCount : 0,
		/*
		 * Class constructor
		 * @param {string}	(required) Where to render the initial page
		 * @param {Object}	(optional) Optoions as defined by the user
		 **/
		initialize : function (rTo, options) {
			
			this.parent(String.uniqicID, options);
			this.renderTo = $(rTo);
			// the content of the data
			this.Content = new Element('div', {
					styles : {
						'max-height' : this.options.height,
						'overflow-y' : 'auto',
						'overflow-x' : 'hidden',
						'padding-right' : '5px'
					}
				});
			
			this.ControlIdPrefix = 'ctl' + rTo;
			this.Containner = new Element('div', {
					'class' : 'sapn12'
				});
			var _a = new Element('div', {
					'class' : 'row-fluid'
				}).adopt(this.Containner);
			
			this.buildHeader();
			this.populateData();
			
			this.Containner.adopt(this.Content);
			
			//if(this.options.allowInput)	{
			this.Containner.adopt(this.InputRow);
			//}
			if (!this.options.allowInput) {
				this.InputRow.setStyle('display', 'none');
			}
			
			this.addRows(this.options.data);
			$(rTo).adopt(_a);
		},
		
		/*
		 * buildHeader
		 **/
		buildHeader : function () {
			var row = new Element('div', {
					'class' : 'row-fluid',
					'styles' : {
						'border-bottom' : '1px solid #ddd',
						'padding' : '5px 0'
					}
				})
				var i_row = row.clone(),
			a_row = row.clone();
			var ctlInput = '';
			var hdLen = this.options.headers.length - 1;
			var thisClass = this;
			var unid = this.ControlIdPrefix;
			this.options.headers.each(function (hd, _index1) {
				// create row
				row.adopt(new Element('div', {
						'class' : 'span' + hd['size'],
						'html' : '<b>' + hd['title'] + '</b>'
					}));
				
				//add input element into i_row
				switch (hd['type']) {
				case 'int':
					if (typeOf(hd['data']) == 'array') {
						ctlInput = new Element('select', {
								'id' : unid + _index1,
								styles : {
									'width' : '100%'
								}
							});
						hd['data'].each(function (aF, i) {
							ctlInput.adopt(new Element('option', {
									'value' : aF[0],
									html : aF[1]
								}));
						});
						
					} else {
						ctlInput = new Element('input', {
								'id' : unid + _index1,
								'type' : 'text',
								'placeholder' : hd['hint'],
								styles : {
									'width' : '100%'
								}
							});
					}
					break
					/*case 'date':
					ctlInput = new Element('input',	{
					'id':unid + _index1,
					'type':'text',
					styles:{
					'width':'100%'
					}
					});
					break*/
				default: // text, date, float
					if (typeOf(hd['data']) == 'array') {
						ctlInput = new Element('select', {
								'id' : unid + _index1,
								styles : {
									'width' : '100%'
								}
							});
						hd['data'].each(function (aF, i) {
							ctlInput.adopt(new Element('option', {
									'value' : aF[0],
									html : aF[1]
								}));
						});
					} else {
						ctlInput = new Element('input', {
								'id' : unid + _index1,
								'type' : 'text',
								'placeholder' : hd['hint'],
								styles : {
									'width' : '100%'
								}
							});
					}
					break
				}
				if (hdLen == _index1) {
					var nrw = new Element('div', {
							'class' : 'span' + hd['size']
						});
					i_row.adopt(nrw);
					//if(thisClass.options.allowUpdate)	{
					var btn = new aButton('', {
							'value' : 'add',
							'click' : function (e) {
								var _me = e.target,
								data_ = "";
								for (var _i = 0; _i <= hdLen - 1; ++_i) {
									data_ = data_ + '&' + thisClass.options.headers[_i]['type'] + _i + '=' + encodeURIComponent($(unid + _i).value);
								}
								new Request({
									url : 'assets/awaf/tags/xEditTable/save_data.cfm?' + data_ + '&session=' + thisClass.options.sessionId,
									method : 'post',
									onRequest : function () {
										_me.disabled = true;
										_me.value = "...";
									},
									onSuccess : function (r) {
										//insert new row on top with data and clear this one,
										thisClass._addRow(unid, 0, r, false);
										_me.value = "add";
										_me.disabled = false;
									},
									onFailure : function (e) {
										showError(e);
										_me.value = "add";
										_me.disabled = false;
									}
								}).send();
							}
						});
					nrw.adopt(btn);
					//}
				} else {
					var incont = new Element('div', {
							'class' : 'span' + hd['size']
						}).adopt(ctlInput);
					if (ctlInput.get('tag') == 'select') {
						var ctl_sel = ctlInput.get('id') + '_sel';
						console.log(ctl_sel);
						if (typeOf(ctl_sel) == 'element') {
							incont.adopt(ctl_sel)
						}
						new Meio.Autocomplete.Select.One(ctlInput);
					}
					i_row.adopt(incont);
				}
			});
			
			this.InputRow = i_row;
			this.Header = row;
			this.Containner.adopt(this.Header);
		},
		
		/*
		 * populateData
		 **/
		populateData : function () {},
		
		clear : function () {
			this.Content.empty();
		},
		/*
		 * addRows
		/*/
		addRows : function (dt) {
			var thisClass = this;
			// set the options
			this.options.data = dt
				//alert(this.options.data);
				dt.each(function (d, i) {
					thisClass._addRow('', i, 0, true);
				});
		},
		
		_newFluidRow : function () {
			return new Element('div', {
				'class' : 'row-fluid',
				'styles' : {
					'border-bottom' : '1px solid #ddd',
					'padding' : '5px 0'
				}
			})
		},
		
		/*
		 * _addRow
		 * @param unid : the prefix Id of the Input control
		 * @param row : the is the row number, recordcount
		 * @param _id : temp id of the new insert record on temp_data table
		 * @param nr : for event
		 **/
		_addRow : function (unid, row, _id, bolnr) {
			var nr = this._newFluidRow();
			var hdl = this.options.headers.length - 1,
			thisClass = this;
			var unid = this.ControlIdPrefix;
			var rc = this.RowCount++;
			this.options.headers.each(function (hd, _i) {
				// create row
				var vd = new Element('div', {
						id : '_' + unid + _i + rc,
						'class' : 'span' + hd['size']
					});
				var ctrIn = $(unid + _i),
				ctrInSel = $(unid + _i + '_sel');
				
				if (hdl != _i) {
					//alert(typeOf(ctrIn));
					if (!bolnr) {
						//alert('d');
						if (ctrIn.get('tag') == 'select') {
							var sv = ctrIn.getSelected().get('text');
							vd.set('html', sv + '~' + ctrIn.value) + '&nbsp;';
							if (sv == ctrIn.value) {
								vd.set('html', sv + '&nbsp;')
							};
						} else {
							vd.set('html', ctrIn.value + '&nbsp;');
						}
						ctrIn.value = '';
						ctrIn.removeClass('ma-selected');
						// clear auto too
						if (typeOf(ctrInSel) == 'element') {
							ctrInSel.value = '';
							ctrInSel.removeClass('ma-selected');
						}
						if (_i == 0) {
							ctrIn.focus();
						}
					}
					if (bolnr) {
						vd.set('html', '&nbsp;' + thisClass.options.data[row][_i]);
					}
				}
				if (hdl == _i) {
					if (thisClass.options.allowUpdate) {
						var bg = new Element('div', {
								'class' : 'btn-group'
							});
						if (_id == 0) {
							_id = thisClass.options.data[row][_i];
							//alert(_id);
						}
						_id = String.from(_id).clean();
						bg.adopt(new aButton('', {
								'value' : 'e',
								'class' : 'btn-mini',
								'title' : 'edit',
								'click' : function (e) {
									var _me = e.target;
									switch (_me.value) {
										// command to change the fields to edit mode
									case 'e':
										_me.set('value', 's');
										_me.set('title', 'save');
										_me.addClass('btn-success');
										// clone the controls at the bottom and take them to where they are needed
										thisClass.options.headers.each(function (hd, i) {
											if (hdl != i) {
												var ct = $('_' + unid + i + rc);
												var bv = ct.get('text');
												var nct = $(unid + i).clone();
												if (hd['disabled']) {
													nct.set('disabled', true);
												}
												var ncid_ = unid + i + _id; // make the new id on the element unid+i+_id
												nct.set('id', ncid_);
												ct.empty();
												nct.set('value', bv.trim());
												//var atocomp = false; // for m- autocompeter
												var is_sel = nct.get('tag');
												if (hd['type'] == 'int' && is_sel == 'select') {
													var ni = listGetAt(bv, 1, '~');
													if (!isNaN(ni)) {
														nct.set('value', ni.trim());
													}
												}
												ct.adopt(nct);
												if (is_sel == 'select') {
													new Meio.Autocomplete.Select.One(nct);
												}
											}
										});
										break;
										// command to save the edited date
									case 's':
										var _param = '',
										ctl_vl;
										for (var _i = 0; _i < thisClass.options.headers.length - 1; ++_i) {
											ctl_vl = $(unid + _i + _id).value.trim();
											_param = _param + '&' + thisClass.options.headers[_i]['type'] + _i + '=' + encodeURIComponent(ctl_vl);
										}
										//alert(_id);
										new Request({
											url : 'assets/awaf/tags/xEditTable/save_data.cfm?id=' + _id + _param + '&session=' + thisClass.options.sessionId,
											method : 'post',
											onRequest : function () {
												_me.disabled = true;
											},
											onSuccess : function () {
												
												// remove the controls
												thisClass.options.headers.each(function (hd, _i) {
													// get the current column
													if (hdl != _i) {
														
														var vd = $('_' + unid + _i + rc);
														var ctrIn = $(unid + _i + _id);
														
														if (typeOf(ctrIn) == 'element') {
															if (ctrIn.get('tag') == 'select') {
																var sv = ctrIn.getSelected().get('text');
																vd.set('html', '&nbsp;' + sv + '~' + ctrIn.value);
																// this is when the select option value is equal to the text
																if (sv == ctrIn.value) {
																	vd.set('html', '&nbsp;' + sv)
																};
															} else {
																vd.set('html', '&nbsp;' + ctrIn.value);
															}
															// clean up
															ctrIn.dispose();
														}
													}
												});
												_me.disabled = false;
												_me.set('value', 'e');
												_me.set('title', 'edit');
												_me.removeClass('btn-success')
											},
											onFailure : function (e) {
												showError(e);
												_me.disabled = false;
											}
										}).send();
										break
									}
								}
							}));
						bg.adopt(new aButton('', {
								'value' : 'x',
								'class' : 'btn-mini btn-warning',
								'title' : 'delete',
								'click' : function (e) {
									var _me = e.target;
									if (confirm('Are you sure you want to delete this item?')) {
										// update the flag on the table
										new Request({
											url : 'assets/awaf/tags/xEditTable/del_data.cfm?id=' + _id,
											method : 'post',
											onRequest : function () {
												_me.disabled = true;
											},
											onSuccess : function () {
												nr.dispose();
											},
											onFailure : function (e) {
												showError(e);
												_me.disabled = false;
											}
										}).send();
										
									}
								}
							}));
						vd.adopt(bg);
					}
				}
				nr.adopt(vd);
			});
			this.Content.adopt(nr);
			new Fx.Scroll(this.Content).toBottom();
			//this.Header.inject(nr,'before');
		}
		
	});

/* global functions **/
function showError(e) {
	var d = e.responseText.clean();
	var re = new RegExp("<\s*h1[^>]*>(.*?)<\s*/\s*h1>", "gmi");
	alert('Error on request:\r\r' + re.exec(d)[1]);
	//var msg = 'Error on request:\r\r' + re.exec(d)[1];
	//new aNotify().alert('Error',msg);
}

function listGetAt(list, position, delimiter) {
	if (delimiter == null) {
		delimiter = ',';
	}
	list = list.split(delimiter);
	if (list.length > position) {
		return list[position];
	} else {
		return 0;
	}
}

function listFind(list, value, delimiter) {
	var result = 0;
	if (delimiter == null)
		delimiter = ',';
	list = list.split(delimiter);
	for (var i = 0; i < list.length; i++) {
		if (value == list[i]) {
			result = i + 1;
			return result;
		}
	}
	return result;
}

function listRemove(list, value, delimiter) {
	var newValue = "";
	if (delimiter == null) {
		delimiter = ',';
	}
	list = list.split(delimiter);
	for (var i = 0; i < list.length; i++) {
		if (value != list[i]) {
			if (i > 0) {
				newValue = newValue + delimiter;
			}
			newValue = newValue + list[i];
		}
	}
	return newValue;
}
