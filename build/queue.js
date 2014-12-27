var Queue,QueueAction,__bind=function(t,e){return function(){return t.apply(e,arguments)}},__slice=[].slice;QueueAction=function(){function t(t,e,n){this.name=t,this.fn=e,this.options=n,this.result=__bind(this.result,this),this._perform=__bind(this._perform,this),this.reset()}return t.prototype.reset=function(){return this.performed=!1,this.active=!1,this.retries=0,this.error=!1},t.prototype._perform=function(t,e){return null==t&&(t=[]),this.active=!0,this._fnCallback=e,this.fn.apply(null,t.concat(this.result)),!0},t.prototype.result=function(){var t,e;return t=arguments[0],e=2<=arguments.length?__slice.call(arguments,1):[],null==t&&(t=null),this.active=!1,null!=t?this.error=!0:(this.error=!1,this.performed=!0),null!=this._fnCallback&&this._fnCallback.apply(null,[t].concat(e)),!0},t}(),Queue=function(){function t(t){var e;this.options=null!=t?t:{},this._queue={},(e=this.options).performer||(e.performer="async")}return t.prototype._elegibleQueueActionsArr=function(){var t,e,n,i;e=[],i=this._queue;for(n in i)t=i[n],t.active||t.performed||e.push(t);return e},t.prototype.hasAction=function(t){return null!=this._queue[t]},t.prototype.add=function(t,e,n){return null==n&&(n={}),this.hasAction(t)?!1:(this._queue[t]=new QueueAction(t,e,n,this),!0)},t.prototype.remove=function(t){return this.hasAction(t)?(delete this._queue[t],!0):!1},t.prototype.action=function(t){return this.hasAction(t)?this._queue[t]:!1},t.prototype.resetAction=function(){return this.hasAction(name)?(this._queue[name].reset(),!0):!1},t.prototype.anyActive=function(){var t,e,n,i;n=!1,i=this._queue;for(e in i)if(t=i[e],t.active){n=!0;break}return n},t.prototype.anyError=function(){var t,e,n,i;n=!1,i=this._queue;for(e in i)if(t=i[e],t.error){n=!0;break}return n},t.prototype.perform=function(t){var e;return e="_performer_"+this.options.performer,"function"!=typeof this[e]?!1:(this[e].call(this,t),!0)},t.prototype._performer_async=function(){var t,e,n,i;n=this._queue,i=[];for(e in n)t=n[e],i.push(t.active||t.performed?void 0:t._perform([]));return i},t.prototype._performer_sync=function(t){var e,n;return e=this._elegibleQueueActionsArr(),(n=function(i,r){return e[i]._perform(r,function(){return function(){var r,u,o,s;return u=arguments[0],r=2<=arguments.length?__slice.call(arguments,1):[],s=i+1,o=e.length-1,null==u?o>s?n(s,r):e[s]._perform(r,function(){var e,n;return n=arguments[0],e=2<=arguments.length?__slice.call(arguments,1):[],null!=t?t.apply(null,[n].concat(e)):void 0}):void 0}}(this))})(0,[])},t}(),window.Queue=Queue;//# sourceMappingURL=queue.js.map