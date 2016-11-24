package org.mangui.hls.utils {

    import org.mangui.hls.utils.Log;

    import flash.net.URLRequest;
    import flash.net.URLLoader;
    import flash.net.URLVariables;
    import flash.net.URLRequestHeader;
    import flash.events.Event;
    import flash.events.ErrorEvent;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;

    public class QURLLoader extends URLLoader {
        protected var _tempReq:URLRequest = null;

        public function QURLLoader() {
            super();
        }

        public function setReqTemp(tempReq: URLRequest): QURLLoader {
            if (this._tempReq) {
                Log.error("QURLLoader.reqTemp can be set for only once");
            } else {
                this._tempReq = tempReq;
            }
            return this;
        }

        public function type(mtype: String):QURLLoader {
            Log.warn("TODO> set request mimetype");
            return this;
        }

        public function header(key: String, value: String): QURLLoader {
            var headItem: URLRequestHeader = new URLRequestHeader(key, value);
            this._tempReq.requestHeaders.push(headItem);
            return this;
        }

        public function setData(_data:Object = null):QURLLoader {
            try{
                var dataToSend:URLVariables = new URLVariables();
                if (data) {
                    for (var key:String in dataToSend) {
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

        public function send():QURLLoader {
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

        public function cb(callback: Function):QURLLoader {
            try{
                this.addEventListener(Event.COMPLETE, callback);
            }
            catch (e:Error){
                Log.error("set http request callback error");
                /*Log.error(e);*/
            }
            finally{
                return this;
            }
        }

        public function fb(failback: Function):QURLLoader {
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
