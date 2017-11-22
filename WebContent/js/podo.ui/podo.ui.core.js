/**
 * PODO UI CORE
 * dependency : jquery, kendo
 */

    (function (window, $, undefined) {

		
		var podo = window.podo = window.podo || { ui : {} },
		extend = $.extend,
		each = $.each,
		isArray = $.isArray,
		proxy = $.proxy,
		noop = $.noop,
		math = Math,
		FUNCTION = "function",
		STRING = "string",
		OBJECT = "object",
		isFunction = kendo.isFunction,
		DataSource = kendo.data.DataSource,
		Widget = kendo.ui.Widget, 
		progress = kendo.ui.progress,
		POST = 'POST',	
		JSON = 'json',
		VISIBLE = ":visible",
		DISABLED = "disabled",
		STRING = 'string',
		CLICK = "click",
		CHANGE = "change",	
		OPEN = "open",
		HIDDEN = "hidden",
		CURSOR = "cursor",	
		DEACTIVATE = "deactivate",
		ACTIVATE = "activate",	
		UNDEFINED = "undefined",
		
		
		ERROR_MESSAGES = {
			'Forbidden' : "접근 권한이 없습니다.",	
			'timeout': "처리 대기 시간을 초가하였습니다. 잠시 후 다시 시도하여 주십시오.",
			'parsererror' : "데이터 파싱 중에 오류가 발생하였습니다."
		},
		
		STATUS_ERROR_MESSAGES = {
			'0' : "오프라인 상태입니다.",
			'404' : "요청하신 웹 페이지를 찾을 수 없습니다.",
			'405' : "웹 사이트에서 페이지를 표시할 수 없습니다.",
			'406' : "이 웹 페이지 형식을 읽을 수 없습니다.",
			'408' : "서버에서 웹 페이지를 표시하는 데 시간이 너무 오래 걸리거나 같은 페이지를 요청하는 사용자가 너무 많습니다. 나중에 다시 시도하여 주십시오.",
			'409' : "서버에서 웹 페이지를 표시하는 데 시간이 너무 오래 걸리거나 같은 페이지를 요청하는 사용자가 너무 많습니다. 나중에 다시 시도하여 주십시오.",
			'500' : "오류가 발생하였습니다.",
			'503' : "서비스 이용이 지연되고 있습니다. 잠시 후 다시 시도하여 주십시오.",
			'403' : "접근 권한이 없습니다. 권한이 필요한 경우 관리자에게 문의하십시오."			
		};
		
		function handleAjaxError(xhr) {	
			
			var message = "";		
			if( typeof xhr === STRING ){
				message = xhr;			
			} else {	
				var $xhr = xhr;
				if(  $xhr.xhr ){
					$xhr = $xhr.xhr;			
				}			
				if ($xhr.status == 0 || $xhr.status == 404 || $xhr.status == 503 || $xhr.status == 403 ) {				
					message = STATUS_ERROR_MESSAGES[$xhr.status];		
				} else if ($xhr.status == 500){						
					if( $xhr.responseJSON ){
						message = $xhr.responseJSON.error.message;
					}else{	
						message = STATUS_ERROR_MESSAGES[$xhr.status];
						if( $xhr.responseText ){
							var obj = eval("("+$xhr.responseText+")");				
							if( obj != null && obj.error.message ){
								message = obj.error.message ;
							}
						}
					}
				} else if ( $xhr.errorThrown == "Forbidden" || $xhr.errorThrown == 'timeout' || $xhr.errorThrown == 'parsererror') {
					message = ERROR_MESSAGES[$xhr.errorThrown];						
				} else {		
					if( $xhr.responseText ){
						var obj = eval("("+$xhr.responseText+")")
						
						if( obj != null && obj.error.exceptionMessage ){
							if( obj.error.exceptionMessage == 'Bad credentials' ){
								message = '아이디 또는 비밀번호를 잘못 입력하셨습니다.';
							}
						}
					}else{
						message = STATUS_ERROR_MESSAGES[500];	
					}
				}
			}
			
			//console.log(message);
			
			notification().show({ title:null, 'message': message },"error");
		};
		
		
		function defined(x) {
			return (typeof x != UNDEFINED);
		};
		

			
		function grid(renderTo, options){
			options = options || {};		
			if(!renderTo.data("kendoGrid")){			
				 renderTo.kendoGrid(options);
			}		
			return renderTo.data("kendoGrid");
		}
		
		function listview( renderTo, options){		
			if(!renderTo.data("kendoListView")){			
				 renderTo.kendoListView(options);
			}		
			return renderTo.data("kendoListView");
		}
		
		
		var DEFAULT_PAGER_SETTING = {
				refresh : true,		
				buttonCount : 9,
				info: false
		};	
		
		function pager ( renderTo, options ){		
			if(!renderTo.data("kendoPager")){		
				options = options || {};		
				var settings = extend(true, {}, DEFAULT_PAGER_SETTING , options ); 
				renderTo.kendoPager(settings);
			}		
			return renderTo.data("kendoPager");
		}

		var DEFAULT_UPLOAD_SETTING = {
			multiple : true,
			width: 300,
			showFileList : false,
			localization:{ select : '파일 선택' , dropFilesHere : '업로드할 파일들을 이곳에 끌어 놓으세요.' },
			async: {			
				autoUpload: true
			},
			upload: function (e) {								         
		    	 e.data = {};														    								    	 		    	 
		    }
		};
		
		function upload(renderTo, options){
			if(!renderTo.data("kendoUpload")){		
				options = options || {};		
				var settings = extend(true, {}, DEFAULT_UPLOAD_SETTING , options ); 
				renderTo.kendoUpload(settings);
			}		
			return renderTo.data("kendoUpload");		
		}
		
		var DEFAULT_DATASOURCE_SETTING = {
				transport:{
					read:{
						type :POST,
						dataType : JSON
					} 				
				},
				serverPaging: true,
				error:handleAjaxError,	
				pageSize: 10		
		};
		
		
		function datasource(url, options){		
			options = options || {};		
			var settings = extend(true, {}, DEFAULT_DATASOURCE_SETTING , options ); 
			if( defined(url) ){
				settings.transport.read.url = url;			
			}		
			var dataSource =  DataSource.create(settings);
			return dataSource;
		};

		var DEFAULT_AJAX_SETTING = {
			type : POST,	
			data : {},
			dataType : JSON,
			error:handleAjaxError 		
		};	


		function ajax ( url, options ){
			options = options || {};	
			var settings = extend(true, {}, DEFAULT_AJAX_SETTING , options ); 
			if( defined( url) ){
				settings.url = url;			
			}				
			return $.ajax(settings);		
		};	
		
			
		function exists ( element ){
			if( typeof element === "string")
				element = $(element);
			
			return  defined( element.data("role") );
		} 

		
		var DEFAULT_NOTIFICATION_SETTING = {
			autoHideAfter : 3000,
			title : null,
			position : {	pinned : true, top : 10, right : 10 },	
			stacking : "down",
			width : 300,
			templates : [{
				type : "warning",
				template : '<div class="notification-warning">#if(title){#<div class="notification-title">#= title #</div>#}#<div class="notification-mesage">#= message #</div></div>'
			},
			{
				type : "error",
				template : '<div class="notification-error">#if(title){#<div class="notification-title">#= title #</div>#}#<div class="notification-mesage">#= message #</div></div>'
			},
			{
				type : "info",
				template : '<div class="notification-info">#if(title){#<div class="notification-title">#= title #</div>#}#<div class="notification-mesage">#= message #</div></div>'
			}, 
			{
				type : "success",
				template : '<div class="notification-success">#if(title){#<div class="notification-title">#= title #</div>#}#<div class="notification-mesage">#= message #</div></div>'
			} ]		
		};
		
		function notification (options) {
			options = options || {};
			var renderToString = "#notification";
			if ($(renderToString).length == 0) {
				$('body').append(	'<span id="notification" style="display:none;"></span>');
			}		
			var settings = extend(true, {}, DEFAULT_NOTIFICATION_SETTING , options ); 
			var renderTo = $(renderToString) ;
			if (!renderTo.data("kendoNotification")) {
				renderTo.kendoNotification(settings);
			}
			return renderTo.data("kendoNotification");
		};
		
		function error(e){				
			handleAjaxError(e.xhr);
		}

		function culture(locale){
			 kendo.culture(locale);		
		}
		
		function enableBootstrapModalStack() {		
			$(document).on('show.bs.modal', '.modal', function () {
			    var zIndex = 1040 + (10 * $('.modal:visible').length);
			    $(this).css('z-index', zIndex);
			    setTimeout(function() {
			        $('.modal-backdrop').not('.modal-stack').css('z-index', zIndex - 1).addClass('modal-stack');
			    }, 0);
			});		
			$(document).on('hidden.bs.modal', '.modal', function () {
			    $('.modal:visible').length && $(document.body).addClass('modal-open');
			});
			
		}
		
		function enableStackingBootstrapModal(renderTo, handlers){		
			renderTo.on('hidden.bs.modal', function( event ) {
				if( handlers && isFunction(handlers['hidden.bs.modal'] ) ){
	            	handlers['hidden.bs.modal']();
	            }
				
	            $(this).removeClass( 'fv-modal-stack' );
	            $('body').data( 'fv_open_modals', $('body').data( 'fv_open_modals' ) - 1 );
	            });
			
			renderTo.on( 'shown.bs.modal', function ( event ) {			
	            if( handlers && isFunction(handlers['shown.bs.modal'] ) ){
	            	handlers['shown.bs.modal']();
	            }
				// keep track of the number of open modals            
	            if ( typeof( $('body').data( 'fv_open_modals' ) ) == 'undefined' )
	            {
	              $('body').data( 'fv_open_modals', 0 );
	            } 
	            // if the z-index of this modal has been set, ignore.
	            if ( $(this).hasClass( 'fv-modal-stack' ) )
	            {
	                 return;
	            }            
	            $(this).addClass( 'fv-modal-stack' );
	            $('body').data( 'fv_open_modals', $('body').data( 'fv_open_modals' ) + 1 );
	            $(this).css('z-index', 2040 + (10 * $('body').data( 'fv_open_modals' )));
	            $( '.modal-backdrop' ).not( '.fv-modal-stack' ).css( 'z-index', 1039 + (10 * $('body').data( 'fv_open_modals' )));
	            $( '.modal-backdrop' ).not( 'fv-modal-stack' ).addClass( 'fv-modal-stack' ); 
			});
		}
		
		extend(
			podo.ui , {	
			handleAjaxError : podo.ui.handleAjaxError || handleAjaxError,
			error : error,
			defined : podo.ui.defined || defined,
			datasource : podo.ui.datasource || datasource,
			ajax : podo.ui.ajax || ajax,
			listview : podo.ui.listview || listview,
			grid : podo.ui.grid || grid,
			pager : podo.ui.pager || pager,
			fx : kendo.fx,
			bind : kendo.bind,
			progress : kendo.ui.progress,
			culture : culture,
			stringify : kendo.stringify,
			template : kendo.template,
			upload : podo.ui.upload || upload,
			observable : kendo.observable,
			exists : exists,
			notification : podo.ui.notification || notification,
			data : podo.ui.data || {}
		});		
    	

    }(window, jQuery));
