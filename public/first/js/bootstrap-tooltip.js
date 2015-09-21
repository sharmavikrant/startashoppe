!function(e){"use strict";var t=function(e,t){this.init("tooltip",e,t)};t.prototype={constructor:t,init:function(t,n,r){var i,s;this.type=t;this.$element=e(n);this.options=this.getOptions(r);this.enabled=true;if(this.options.trigger!="manual"){i=this.options.trigger=="hover"?"mouseenter":"focus";s=this.options.trigger=="hover"?"mouseleave":"blur";this.$element.on(i,this.options.selector,e.proxy(this.enter,this));this.$element.on(s,this.options.selector,e.proxy(this.leave,this))}this.options.selector?this._options=e.extend({},this.options,{trigger:"manual",selector:""}):this.fixTitle()},getOptions:function(t){t=e.extend({},e.fn[this.type].defaults,t,this.$element.data());if(t.delay&&typeof t.delay=="number"){t.delay={show:t.delay,hide:t.delay}}return t},enter:function(t){var n=e(t.currentTarget)[this.type](this._options).data(this.type);if(!n.options.delay||!n.options.delay.show){n.show()}else{n.hoverState="in";setTimeout(function(){if(n.hoverState=="in"){n.show()}},n.options.delay.show)}},leave:function(t){var n=e(t.currentTarget)[this.type](this._options).data(this.type);if(!n.options.delay||!n.options.delay.hide){n.hide()}else{n.hoverState="out";setTimeout(function(){if(n.hoverState=="out"){n.hide()}},n.options.delay.hide)}},show:function(){var e,t,n,r,i,s,o;if(this.hasContent()&&this.enabled){e=this.tip();this.setContent();if(this.options.animation){e.addClass("fade")}s=typeof this.options.placement=="function"?this.options.placement.call(this,e[0],this.$element[0]):this.options.placement;t=/in/.test(s);e.remove().css({top:0,left:0,display:"block"}).appendTo(t?this.$element:document.body);n=this.getPosition(t);r=e[0].offsetWidth;i=e[0].offsetHeight;switch(t?s.split(" ")[1]:s){case"bottom":o={top:n.top+n.height,left:n.left+n.width/2-r/2};break;case"top":o={top:n.top-i,left:n.left+n.width/2-r/2};break;case"left":o={top:n.top+n.height/2-i/2,left:n.left-r};break;case"right":o={top:n.top+n.height/2-i/2,left:n.left+n.width};break}e.css(o).addClass(s).addClass("in")}},setContent:function(){var e=this.tip();e.find(".tooltip-inner").html(this.getTitle());e.removeClass("fade in top bottom left right")},hide:function(){function r(){var t=setTimeout(function(){n.off(e.support.transition.end).remove()},500);n.one(e.support.transition.end,function(){clearTimeout(t);n.remove()})}var t=this,n=this.tip();n.removeClass("in");e.support.transition&&this.$tip.hasClass("fade")?r():n.remove()},fixTitle:function(){var e=this.$element;if(e.attr("title")||typeof e.attr("data-original-title")!="string"){e.attr("data-original-title",e.attr("title")||"").removeAttr("title")}},hasContent:function(){return this.getTitle()},getPosition:function(t){return e.extend({},t?{top:0,left:0}:this.$element.offset(),{width:this.$element[0].offsetWidth,height:this.$element[0].offsetHeight})},getTitle:function(){var e,t=this.$element,n=this.options;e=t.attr("data-original-title")||(typeof n.title=="function"?n.title.call(t[0]):n.title);e=e.toString().replace(/(^\s*|\s*$)/,"");return e},tip:function(){return this.$tip=this.$tip||e(this.options.template)},validate:function(){if(!this.$element[0].parentNode){this.hide();this.$element=null;this.options=null}},enable:function(){this.enabled=true},disable:function(){this.enabled=false},toggleEnabled:function(){this.enabled=!this.enabled},toggle:function(){this[this.tip().hasClass("in")?"hide":"show"]()}};e.fn.tooltip=function(n){return this.each(function(){var r=e(this),i=r.data("tooltip"),s=typeof n=="object"&&n;if(!i)r.data("tooltip",i=new t(this,s));if(typeof n=="string")i[n]()})};e.fn.tooltip.Constructor=t;e.fn.tooltip.defaults={animation:true,delay:0,selector:false,placement:"top",trigger:"hover",title:"",template:'<div class="tooltip"><div class="tooltip-arrow"></div><div class="tooltip-inner"></div></div>'}}(window.jQuery)