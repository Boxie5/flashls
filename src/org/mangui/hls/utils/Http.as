package org.mangui.hls.utils {

    import org.mangui.hls.utils.QURLLoader;

    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;

    /*
    * using:
    * import org.mangui.hls.utils.Http
    *
    * Http.get(url).setData(data).type(mimeType).cb(callback).fb(fallback).send()
    *
    * Note: get/post/put should be the first one to call,
    *       while send should be the last one to call
    *       it doesn't matter to care about order for the other functions
    */

    public class Http {

        protected static function ajax(method: String, urlToRequest:String): QURLLoader {
            var req:URLRequest = new URLRequest(urlToRequest);
            req.method = method;

            var reqLoader:QURLLoader = new QURLLoader();
            reqLoader.setReqTemp(req);

            return reqLoader;
        }

        public static function get(urlToRequest:String): QURLLoader {
            return ajax(URLRequestMethod.GET, urlToRequest);
        }

        public static function post(urlToRequest:String): QURLLoader {
            return ajax(URLRequestMethod.POST, urlToRequest);
        }

        public static function put(urlToRequest:String): QURLLoader {
            return ajax(URLRequestMethod.PUT, urlToRequest);
        }

        public static function del(urlToRequest:String): QURLLoader {
            return ajax(URLRequestMethod.DELETE, urlToRequest);
        }
    }
}
