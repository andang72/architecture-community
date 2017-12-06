(function (window, $, undefined) {
	
	var community = window.community = window.community || { model : {} , data : {}},
	extend = $.extend,
	Model = kendo.data.Model;

	community.model.ObjectAccessControlEntry = Model.define({ 		
		id: "id",
		fields: { 	
			id: { type: "number", defaultValue: 0 },			
			granting: { type: "boolean", defaultValue: false },			
			domainObjectClass: { type: "string", defaultValue: "" },			
			domainObjectId: { type: "number", defaultValue: 0 },			
			grantedAuthority: { type: "string", defaultValue: "" },			
			grantedAuthorityOwner:{ type: "string", defaultValue: "" },
			permission:{ type: "string", defaultValue: "" }
		}
	});
	
	community.model.User = Model.define({ 
		id : "userId",
		fields: { 			
			userId: { type: "number", defaultValue: 0 },			
			username: { type: "string", defaultValue: "" },			
			name: { type: "string", defaultValue: "" },			
			nameVisible: { type: "boolean", defaultValue: false },	
			firstName: { type: "string", defaultValue: "" },
			lastName: { type: "string", defaultValue: "" },
			email: { type: "string", defaultValue: "" },			
			emailVisible: { type: "boolean", defaultValue: false },					
			anonymous: { type: "boolean", defaultValue: true },			
			enabled: { type: "boolean", defaultValue: false },
			creationDate:{ type: "date" },			
			modifiedDate:{ type: "date"},
			properties: { type: "object", defaultValue : {} },
			roles: { type: "object", defaultValue: [] }
		},
		hasRole : function ( role ) {
			if( typeof( this.roles ) != "undefined" && $.inArray( role, this.roles ) >= 0 )
				return true
			else 
				return false;    	
	    },
	    copy : function ( target ){
		    	target.userId = this.get("userId");
		    	target.set("username", this.get("username"));
		    	target.set("name", this.get("name"));
		    	target.set("email", this.get("email"));
		    			    	
		    	if(this.get("creationDate") != null )
		    		target.set("creationDate", this.get("creationDate"));
		    	if(this.get("modifiedDate") != null )
		    		target.set("modifiedDate", this.get("modifiedDate"));
		    	target.set("enabled", this.get("enabled"));
		    	target.set("nameVisible", this.get("nameVisible"));
		    	target.set("emailVisible", this.get("emailVisible"));
		    	target.set("anonymous", this.get("anonymous"));
		    	if( typeof this.get("roles") === 'object' )
		    		target.set("roles", this.get("roles") );	
		    	if( typeof this.get("properties") === 'object' )
		    		target.set("properties", this.get("properties"));	    	
		}
	});
	
	community.model.Board = Model.define({ 
		id : "boardId",
		fields: { 			
			boardId: { type: "number", defaultValue: 0 },			
			objectType: { type: "number", defaultValue: 0 },			
			objectId: { type: "number", defaultValue: 0},			
			name: { type: "string", defaultValue: "" },	
			displayName: { type: "string", defaultValue: "" },
			description: { type: "string", defaultValue: "" },
			properties: { type: "object", defaultValue : {} },
			totalMessage: { type: "number", defaultValue: 0},
			totalViewCount: { type: "number", defaultValue: 0},
			totalThreadCount: { type: "number", defaultValue: 0},
			createThread: { type: "boolean", defaultValue: false },
			createThreadMessage: { type: "boolean", defaultValue: false },
			createAttachement: { type: "boolean", defaultValue: false },
			createComment: { type: "boolean", defaultValue: false },
			createImage: { type: "boolean", defaultValue: false },
			readComment: { type: "boolean", defaultValue: false },
			readable: { type: "boolean", defaultValue: false },
			writable: { type: "boolean", defaultValue: false },
			creationDate:{ type: "date" },
			modifiedDate:{ type: "date"}
		},
		copy : function ( target ){
		    	target.boardId = this.get("boardId");
		    	target.set("objectType", this.get("objectType"));
		    	target.set("objectId", this.get("objectId"));
		    	target.set("name", this.get("name"));
		    	target.set("displayName", this.get("displayName"));
		    	target.set("description", this.get("description"));
		    	target.set("totalMessage", this.get("totalMessage"));
		    	target.set("totalViewCount", this.get("totalViewCount"));
		    	target.set("totalThreadCount", this.get("totalThreadCount"));
		    	target.set("writable", this.get("writable"));
		    	target.set("readable", this.get("readable"));
		    	target.set("createImage", this.get("createImage"));
		    	target.set("createComment", this.get("createComment"));
		    	target.set("createAttachement", this.get("createAttachement"));
		    	target.set("createThread", this.get("createThread"));
		    	target.set("createThreadMessage", this.get("createThreadMessage"));
		    	if( typeof this.get("properties") === 'object' )
		    		target.set("properties", this.get("properties"));	  
		    	if(this.get("creationDate") != null )
		    		target.set("creationDate", this.get("creationDate"));
		    if(this.get("modifiedDate") != null )
		    		target.set("modifiedDate", this.get("modifiedDate"));
		}
		
	});

	
	community.model.Message = Model.define({ 		
		id: "messageId",
		fields: { 	
			user: { type: "object" , defaultValue : new community.model.User()},
			objectType: { type: "number", defaultValue: 0 },			
			objectId: { type: "number", defaultValue: 0 },			
			threadId: { type: "number", defaultValue: 0 },			
			messageId: { type: "number", defaultValue: 0 },			
			parentMessageId: { type: "number", defaultValue: 0 },			
			subject:{ type: "string", defaultValue: "" },			
			body:{type: "string", defaultValue: "" },			
			replyCount:{ type: "number", defaultValue: 0 },	
			properties: { type: "object", defaultValue : {} },
			creationDate:{ type: "date" },			
			modifiedDate:{ type: "date" }
		}
	});
	
	community.model.Thread = Model.define({ 
		id : "threadId",
		fields: { 	
			threadId: { type: "number", defaultValue: 0 },		
			objectType: { type: "number", defaultValue: 0 },		
			objectId: { type: "number", defaultValue: 0 },		
			latestMessage :{ type: "object", defaultValue: new community.model.Message() },	
			rootMessage	: { type: "object", defaultValue: new community.model.Message() },	
			messageCount: { type: "number", defaultValue: 0 },	
			viewCount: { type: "number", defaultValue: 0 },	
			properties: { type: "object", defaultValue : {} },
			creationDate: { type: "date" },			
			modifiedDate: { type: "date" }
		}
	});
	
	community.model.Attachment = Model.define({ 
		id : "attachmentId",
		fields: { 	
			attachmentId:{ type: "number", defaultValue: 0 },		
			objectType:{ type: "number", defaultValue: 0 },		
			objectId:{ type: "number", defaultValue: 0 },		
			name:{ type: "string", defaultValue: "" },
			contentType:{ type: "string", defaultValue: "" },
			downloadCount:{ type: "number", defaultValue: 0 },	
			size: { type: "number", defaultValue: 0 },	
			user: { type: "object" , defaultValue : new community.model.User()},
			properties: { type: "object", defaultValue : {} },
			creationDate: { type: "date" },			
			modifiedDate: { type: "date" }
		},
		formattedSize : function(){
			return kendo.toString(this.get("size"), "##,###");
		},	
		formattedCreationDate : function(){
	    	return kendo.toString(this.get("creationDate"), "g");
	    },
	    formattedModifiedDate : function(){
	    	return kendo.toString(this.get("modifiedDate"), "g");
	    }
	});
	
	
	
	function getUserProfileImage ( user ) {
		if( user != null && user.username != null &&  user.username.length > 0 )
			return encodeURI ('/download/avatar/' + user.username + '?height=96&width=96&time=' + kendo.guid() );
		else
			return "/images/no-avatar.png";
	}
	
	function getAttachmentThumbnailUrl ( attachment , thumbnail ){	
		if( attachment.attachmentId > 0 ){
			var _photoUrl = "/download/files/" + attachment.attachmentId + "/" + attachment.name ;	
			if( thumbnail ){
				_photoUrl = _photoUrl + '?thumbnail=true&height=120&width=120' ;
			}
			return encodeURI( _photoUrl + '&time=' + kendo.guid() );
		}
		return "/images/no-image.jpg";
	} 
	
	function getUserDisplayName (user){
		var displayName = "익명";
		if( user != null && !user.anonymous ){
			if( user.nameVisible )
			{
				displayName = user.name;
			}else{
				displayName = "**";
			}
		}
		return displayName ;
	}
	
	extend(community.data, {	
		getAttachmentThumbnailUrl :getAttachmentThumbnailUrl,
		getUserDisplayName : getUserDisplayName ,
		getUserProfileImage : getUserProfileImage
	});
	
	console.log("community.data initialized.");
	
}(window, jQuery));

