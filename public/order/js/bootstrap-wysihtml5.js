!function($, wysi) {
    "use strict";

    var templates = {
        "font-styles": "<li class='dropdown'>" +
                           "<a class='btn btn-alt dropdown-toggle' data-toggle='dropdown' href='#'>" +
                               "<i class='icon-font'></i>&nbsp;<span class='current-font'>Normal text</span>&nbsp;<b class='caret'></b>" +
                           "</a>" +
                           "<ul class='dropdown-menu'>" +
                               "<li><a data-wysihtml5-command='formatBlock' data-wysihtml5-command-value='div'>Normal text</a></li>" +
                               "<li><a data-wysihtml5-command='formatBlock' data-wysihtml5-command-value='h1'>Heading 1</a></li>" +
                               "<li><a data-wysihtml5-command='formatBlock' data-wysihtml5-command-value='h2'>Heading 2</a></li>" +
                           "</ul>" +
                       "</li>",
        "emphasis":    "<li>" +
                           "<div class='btn-group'>" +
                               "<a class='btn btn-alt' data-wysihtml5-command='bold' title='CTRL+B'>Bold</a>" +
                               "<a class='btn btn-alt' data-wysihtml5-command='italic' title='CTRL+I'>Italic</a>" +
                               "<a class='btn btn-alt' data-wysihtml5-command='underline' title='CTRL+U'>Underline</a>" +
                           "</div>" +
                       "</li>",
        "lists":       "<li>" +
                           "<div class='btn-group'>" +
                               "<a class='btn btn-alt' data-wysihtml5-command='insertUnorderedList' title='Unordered List'><i class='icon-list'></i></a>" +
                               "<a class='btn btn-alt' data-wysihtml5-command='insertOrderedList' title='Ordered List'><i class='icon-th-list'></i></a>" +
                               "<a class='btn btn-alt' data-wysihtml5-command='Outdent' title='Outdent'><i class='icon-indent-right'></i></a>" +
                               "<a class='btn btn-alt' data-wysihtml5-command='Indent' title='Indent'><i class='icon-indent-left'></i></a>" +
                           "</div>" +
                       "</li>",
        "link":        "<li>" +
                           "<div class='bootstrap-wysihtml5-insert-link-modal modal hide fade'>" +
                               "<div class='modal-header'>" +
                                   "<a class='close' data-dismiss='modal'>&times;</a>" +
                                   "<h3>Insert Link</h3>" +
                               "</div>" +
                               "<div class='modal-body'>" +
                                   "<input value='http://' class='bootstrap-wysihtml5-insert-link-url input-xlarge'>" +
                               "</div>" +
                               "<div class='modal-footer'>" +
                                   "<a href='#' class='btn btn-alt' data-dismiss='modal'>Cancel</a>" +
                                   "<a href='#' class='btn btn-alt btn-primary' data-dismiss='modal'>Insert link</a>" +
                               "</div>" +
                           "</div>" +
                           "<a class='btn btn-alt' data-wysihtml5-command='createLink' title='Link'><i class='icon-share'></i></a>" +
                       "</li>",
        "image":       "<li>" +
                           "<div class='bootstrap-wysihtml5-insert-image-modal modal hide fade'>" +
                               "<div class='modal-header'>" +
                                   "<a class='close' data-dismiss='modal'>&times;</a>" +
                                   "<h3>Insert Image</h3>" +
                               "</div>" +
                               "<div class='modal-body'>" +
                                   "<input value='http://' class='bootstrap-wysihtml5-insert-image-url input-xlarge'>" +
                               "</div>" +
                               "<div class='modal-footer'>" +
                                   "<a href='#' class='btn btn-alt' data-dismiss='modal'>Cancel</a>" +
                                   "<a href='#' class='btn btn-alt btn-primary insert_img' data-dismiss='modal'>Insert image</a>" +
                               "</div>" +
                           "</div>" +
                           "<a class='btn btn-alt' data-wysihtml5-command='insertImage' title='Insert image'><i class='icon-picture'></i></a>" +
                       "</li>",

        "html":
                       "<li>" +
                           "<div class='btn-group'>" +
                               "<a class='btn btn-alt' data-wysihtml5-action='change_view' title='Edit HTML'><i class='icon-pencil'></i></a>" +
                           "</div>" +
                       "</li>"
    };

    var defaultOptions = {
        "font-styles": true,
        "emphasis": true,
        "lists": true,
        "html": false,
        "link": true,
        "image": true,
        events: {},
        parserRules: {
            tags: {
                "b":  {},
                "i":  {},
                "br": {},
                "ol": {},
                "ul": {},
                "li": {},
                "h1": {},
                "h2": {},
                "blockquote": {},
                "u": 1,
                "img": {
                    "check_attributes": {
                        "width": "numbers",
                        "alt": "alt",
                        "src": "url",
                        "height": "numbers"
                    }
                },
                "a":  {
                    set_attributes: {
                        target: "_blank",
                        rel:    "nofollow"
                    },
                    check_attributes: {
                        href:   "url" // important to avoid XSS
                    }
                }
            }
        },
        stylesheets: []
    };

    var Wysihtml5 = function(el, options) {
        this.el = el;
        this.toolbar = this.createToolbar(el, options || defaultOptions);
        this.editor =  this.createEditor(options);

        window.editor = this.editor;

        $('iframe.wysihtml5-sandbox').each(function(i, el){
            $(el.contentWindow).off('focus.wysihtml5').on({
              'focus.wysihtml5' : function(){
                 $('li.dropdown').removeClass('open');
               }
            });
        });
    };

    Wysihtml5.prototype = {

        constructor: Wysihtml5,

        createEditor: function(options) {
            options = $.extend(defaultOptions, options || {});
		    options.toolbar = this.toolbar[0];

		    var editor = new wysi.Editor(this.el[0], options);

            if(options && options.events) {
                for(var eventName in options.events) {
                    editor.on(eventName, options.events[eventName]);
                }
            }

            return editor;
        },

        createToolbar: function(el, options) {
            var self = this;
            var toolbar = $("<ul/>", {
                'class' : "wysihtml5-toolbar",
                'style': "display:none"
            });

            for(var key in defaultOptions) {
                var value = false;

                if(options[key] !== undefined) {
                    if(options[key] === true) {
                        value = true;
                    }
                } else {
                    value = defaultOptions[key];
                }

                if(value === true) {
                    toolbar.append(templates[key]);

                    if(key == "html") {
                        this.initHtml(toolbar);
                    }

                    if(key == "link") {
                        this.initInsertLink(toolbar);
                    }

                    if(key == "image") {
                        this.initInsertImage(toolbar);
                    }
                }
            }

            toolbar.find("a[data-wysihtml5-command='formatBlock']").click(function(e) {
                var el = $(e.srcElement);
                self.toolbar.find('.current-font').text(el.html());
            });

            this.el.before(toolbar);

            return toolbar;
        },

        initHtml: function(toolbar) {
            var changeViewSelector = "a[data-wysihtml5-action='change_view']";
            toolbar.find(changeViewSelector).click(function(e) {
                toolbar.find('a.btn').not(changeViewSelector).toggleClass('disabled');
            });
        },

        initInsertImage: function(toolbar) {
            var self = this;
            var insertImageModal = toolbar.find('.bootstrap-wysihtml5-insert-image-modal');
            var urlInput = insertImageModal.find('.bootstrap-wysihtml5-insert-image-url');
            var insertButton = insertImageModal.find('a.btn-primary');
            var initialValue = urlInput.val();

            var insertImage = function() {
                var url = urlInput.val();
                urlInput.val(initialValue);
                self.editor.composer.commands.exec("insertImage", url);
            };

            urlInput.keypress(function(e) {
                if(e.which == 13) {
                    insertImage();
                    insertImageModal.modal('hide');
                }
            });

            insertButton.click(insertImage);

            insertImageModal.on('shown', function() {
                urlInput.focus();
            });

            insertImageModal.on('hide', function() {
                self.editor.currentView.element.focus();
            });

            toolbar.find('a[data-wysihtml5-command=insertImage]').click(function() {
                insertImageModal.modal('show');
                insertImageModal.on('click.dismiss.modal', '[data-dismiss="modal"]', function(e) {
					e.stopPropagation();
				});
				
				set_editor_dropper(urlInput);
				
                return false;
            });
        },

        initInsertLink: function(toolbar) {
            var self = this;
            var insertLinkModal = toolbar.find('.bootstrap-wysihtml5-insert-link-modal');
            var urlInput = insertLinkModal.find('.bootstrap-wysihtml5-insert-link-url');
            var insertButton = insertLinkModal.find('a.btn-primary');
            var initialValue = urlInput.val();

            var insertLink = function() {
                var url = urlInput.val();
                urlInput.val(initialValue);
                self.editor.composer.commands.exec("createLink", {
                    href: url,
                    target: "_blank",
                    rel: "nofollow"
                });
            };
            var pressedEnter = false;

            urlInput.keypress(function(e) {
                if(e.which == 13) {
                    insertLink();
                    insertLinkModal.modal('hide');
                }
            });

            insertButton.click(insertLink);

            insertLinkModal.on('shown', function() {
                urlInput.focus();
            });

            insertLinkModal.on('hide', function() {
                self.editor.currentView.element.focus();
            });

            toolbar.find('a[data-wysihtml5-command=createLink]').click(function() {
                insertLinkModal.modal('show');
                insertLinkModal.on('click.dismiss.modal', '[data-dismiss="modal"]', function(e) {
					e.stopPropagation();
				});
                return false;
            });


        }
    };

    $.fn.wysihtml5 = function (options) {
        return this.each(function () {
            var $this = $(this);
            $this.data('wysihtml5', new Wysihtml5($this, options));
        });
    };

    $.fn.wysihtml5.Constructor = Wysihtml5;

}(window.jQuery, window.wysihtml5);


function set_editor_dropper(image_id) {
	
	var check_image_id = $(image_id).attr('id');
	if(check_image_id == undefined) {
		var new_image_id = Math.random() * 1000;
		new_image_id = parseInt(new_image_id * 10);		
		new_image_id = 'dropper_'+new_image_id;
		$(image_id).attr('id', new_image_id)
		image_id = new_image_id;
	}
	
	image_type = 'content';
	hide_mode = false;
	
	if(hide_mode) {
		$('#'+image_id).css('display', 'none');
	}
	
	//var image_type =  $('#'+image_id).data('image-type');
	
	var tpl = '<div id="upload_' + image_id + '" class="drop_container">';
		tpl += '<div id="drop" class="drop_zone">';
			tpl += 'Drop Here';
			tpl += '<a>Browse</a>';
			tpl += '<input type="file" id="image_' + image_id + '" name="' + image_type + '" />';
		tpl += '</div>';
		tpl += '<ul></ul>';
		tpl += '</div>';
		
	
	$('#'+image_id).after(tpl);
	
	var drop_zone = '#upload_'+image_id;
	var drop_zone_list = $(drop_zone + ' ul');	 
	
	/*if($.inArray(image_id, image_preview) == -1) {
		var image_already = $('#'+image_id).val();	
		var catalog_image = parseInt($('#'+image_id).data('catalog-image'));
		image_preview.push(image_id);
		
		if(catalog_image) {
			$(drop_zone_list).load('index.php?route=common/login/image&tag=li&catalog=1&image=' + image_already);	
		} else {
			$(drop_zone_list).load('index.php?route=common/login/image&tag=li&image=' + image_already);	
		}
	}*/

	// Initialize the jQuery File Upload plugin
    $('#image_'+image_id).fileupload({
		url : 'upload.php',
		
        // This element will accept file drag/drop uploading
        dropZone: $(drop_zone),
		
		// Request Type
		dataType : 'json',
		
		formData : function (form) {
			var formdata = [{ name: 'output', value: 'content' }];
		    return formdata;
		},
		
		dragover : function (e) {
			$('#upload_'+image_id).addClass('dropzone-dragover');
			$('#upload_'+image_id).on('dragleave', function (e) {
	    		$('#upload_'+image_id).removeClass('dropzone-dragover');
			});
		},
		
		start : function (e) {
			$('#upload_'+image_id).removeClass('dropzone-dragover');
		},
		
        // This function is called when a file is added to the queue;
        // either via the browse button, or via drag/drop:
        add: function (e, data) {
		
			var tpl = $('<li class="wait">&nbsp;<img src="view/image/ajaxloader.gif" alt="" / height="50" width="50"></li>');

			// Append the file name and file size //data.files[0].name // formatFileSize(data.files[0].size)
			tpl.find('span').text('').append('');
			
			data.context = tpl.appendTo(drop_zone_list);
			
            var jqXHR = data.submit();
        },

        progress: function(e, data){

            // Calculate the completion percentage of the upload
            var progress = parseInt(data.loaded / data.total * 100, 10);

            // Update the hidden input field and trigger a change
            // so that the jQuery knob plugin knows to update the dial
            //data.context.find('input').val(progress).change();

            if(progress == 100){
				$('.wait').remove();
				
               // data.context.removeClass('working');
            }
        },

        fail:function(e, data){
            // Something has gone wrong!
            data.context.addClass('error');
        },
        
        done: function (e, data) {
        	//alert(data.result['preview']);
        	//$(drop_zone_list).append(preview_image);
			
        	$('#'+image_id).val(data.result['path']);
			
        	//drop_zone_list.html(data.result['preview']);
			$('.insert_img').trigger('click');
        }

    });

    // Helper function that formats the file sizes
    function formatFileSize(bytes) {
        if (typeof bytes !== 'number') {
            return '';
        }

        if (bytes >= 1000000000) {
            return (bytes / 1000000000).toFixed(2) + ' GB';
        }

        if (bytes >= 1000000) {
            return (bytes / 1000000).toFixed(2) + ' MB';
        }

        return (bytes / 1000).toFixed(2) + ' KB';
    }
	
	$('#upload_' + image_id + ' .drop_zone a').click(function(){
		// Simulate a click on the file input button
		// to show the file browser dialog
		$(this).parent().find('input').click();
	});
	 
}
	
	