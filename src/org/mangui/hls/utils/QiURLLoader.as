package org.mangui.hls.utils {

    import flash.net.URLRequest;
    import flash.net.URLLoader;
    import flash.net.URLVariables;
    import flash.net.URLRequestHeader;
    import flash.net.URLLoaderDataFormat;
    import flash.events.Event;
    import flash.events.ErrorEvent;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;

    public final class QiURLLoader extends URLLoader {
        protected var _tempReq:URLRequest = null;

        public function QiURLLoader() {
            super();
        }

        public function setReqTemp(tempReq: URLRequest): QiURLLoader {
            if (this._tempReq) {
                Log.error("QiURLLoader.reqTemp can be set for only once");
            } else {
                this._tempReq = tempReq;
            }
            return this;
        }

        public function type(mtype: String):QiURLLoader {
            mtype = mtype.toLowerCase();
            switch (mtype)
            {
                case URLLoaderDataFormat.BINARY:
                case URLLoaderDataFormat.TEXT:
                case URLLoaderDataFormat.VARIABLES:
                    this.dataFormat = mtype;
                    break;
                default :
                    break;
            }

            return this;
        }

        public function header(key: String, value: String): QiURLLoader {
            var headItem: URLRequestHeader = new URLRequestHeader(key, value);
            this._tempReq.requestHeaders.push(headItem);
            return this;
        }

        public function setData(_data:Object = null):QiURLLoader {
            try{
                var dataToSend:URLVariables = new URLVariables();
                if (_data) {
                    for (var key:String in _data) {
                        dataToSend[key] = _data[key];
                    }
                }
                _tempReq.data = dataToSend;
            }
            catch (e:Error){
                Log.error("append http request data error");
                /*Log.error(_data);*/
            }
            finally{
                return this;
            }
        }

        public function send():QiURLLoader {
            try{
                this.load(_tempReq);
            }
            catch (e:Error){
                Log.warn("send http request failed");
                /*Log.warn(_data);*/
            }
            finally{
                return this;
            }
        }

        public function cb(callback: Function):QiURLLoader {
            try{
                var self:QiURLLoader = this;
                /*this.addEventListener(Event.COMPLETE, callback);*/
                this.addEventListener(Event.COMPLETE, function():void {
                    callback(self.data);
                });
            }
            catch (e:Error){
                Log.error("set http request callback error");
                /*Log.error(e);*/
            }
            finally{
                return this;
            }
        }

        public function fb(failback: Function):QiURLLoader {
            try{
                this.addEventListener(IOErrorEvent.IO_ERROR, failback);
                this.addEventListener(SecurityErrorEvent.SECURITY_ERROR, failback);
            }
            catch (e:Error){

            }
            finally{
                return this;
            }
        }
    }
}
