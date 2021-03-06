package org.mangui.hls.utils {

    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;

    import org.mangui.hls.utils.QiURLLoader;

    /*
    * using:
    * import org.mangui.hls.utils.Http
    *
    * Http.get(url).setData(data).type(mimeType).cb(callback).fb(fallback).send()
    *
    * Note: get/post/put should be the first one to call,
    *       while send should be the last one to call
    *       it doesn't make sense for the other functions's order
    */

    public class Http {

        protected static function ajax(method: String, urlToRequest:String): QiURLLoader {
            var req:URLRequest = new URLRequest(urlToRequest);
            req.method = method;

            var reqLoader:QiURLLoader = new QiURLLoader();
            reqLoader.setReqTemp(req);

            return reqLoader;
        }

        public static function get(urlToRequest:String): QiURLLoader {
            return ajax(URLRequestMethod.GET, urlToRequest);
        }

        public static function post(urlToRequest:String): QiURLLoader {
            return ajax(URLRequestMethod.POST, urlToRequest);
        }

        public static function put(urlToRequest:String): QiURLLoader {
            return ajax(URLRequestMethod.PUT, urlToRequest);
        }

        public static function del(urlToRequest:String): QiURLLoader {
            return ajax(URLRequestMethod.DELETE, urlToRequest);
        }
    }
}
