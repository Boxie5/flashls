package org.mangui.hls.service {
    import flash.external.ExternalInterface;
    import flash.net.URLVariables;
    import flash.net.URLLoaderDataFormat;
    import flash.utils.ByteArray;

    import by.blooddy.crypto.Base64;

    import org.mangui.hls.constant.HLSKeys;
    import org.mangui.hls.hash.*;
    import org.mangui.hls.utils.*;

    public class QiService {
        private static const _SERVICE_HOST: String = "jedi.dev.qiniuapi.com";
        // for production, use https protocal, for staging, use http
        /*var url:String = "https://"*/
        private static const _SERVICE_PROTOCAL: String = "http://";

        private static function urlEncode(value: String): String {
            var result: String = "";
            var pattern1: RegExp = /\+/g;
            var pattern2: RegExp = /\//g;
            result = Base64.encode(Hex.toArray(value));
            result = result.replace(pattern1, "-").replace(pattern2, "_");
            return result;
        }

        private static function _getCurrentUrl(): String {
            return ExternalInterface.call("window.location.href.toString");
        }

        private static function _getUrlStringParams(url:String): URLVariables {
            var searchStr: String = "";
            if (url.split("?").length > 1) {
                searchStr = url.split("?", 2)[1];
            }

            return new URLVariables(searchStr);
        }

        private static function getEncodedSign(hub: String, vkey: String, timeStr: String): String {
            var data: String = "";
            data = "JEDI-X\n"
                 + "POST\n"
                 + _SERVICE_HOST + "\n"
                 + hub + "\n"
                 + vkey + "\n"
                 + timeStr + "\n"
                 + "\n\n";

            var hmac: HMAC = new HMAC(new SHA1());
            var sign: String = Hex.fromArray(hmac.compute(
                    Hex.toArray(Hex.fromString(HLSKeys.S_K)),
                    Hex.toArray(Hex.fromString(data))
                ));

            return urlEncode(sign);
        }

        private static function getJediXAuthorization(hub: String, vkey: String): String {
            var timeStr:String = String(int((new Date()).time/1000));
            var encodedSign: String = getEncodedSign(hub, vkey, timeStr);

            var timeByteArray: ByteArray = new ByteArray;
            timeByteArray.writeUTFBytes(timeStr);
            var encodedTimestamp: String = Base64.encode(timeByteArray);

            return "JEDI-X "
                + HLSKeys.A_K + ":"
                + encodedSign + ":"
                + encodedTimestamp;
        }

        public static function getQAuthorization(method: String, host: String, path: String, query: String="", contentType: String=""): String {
            var data: String = method
                            + " " + path
                            + (query ? "?" + query : "")
                            + "\nHost: " + host
                            + (contentType ? "\nContent-Type: " + contentType : "")
                            + "\n\n";
            var hmac: HMAC = new HMAC(new SHA1());
            var sign: String = Hex.fromArray(hmac.compute(
                    Hex.toArray(Hex.fromString("9jTaHxUYXse0fa6ysORgR-7pM1iIyIaZXZG0CgI5")),
                    Hex.toArray(Hex.fromString(data))
            ));

            return "Qiniu tqxKkjGm-YEA8EGFPRN2gpL7fc0pfmXz1sa7ywmt:" + urlEncode(sign);
        }

        private static function genGetQkeyUrl(hub: String, vkey: String): String {
            var vkeyByteArray: ByteArray = new ByteArray;
            vkeyByteArray.writeUTFBytes(vkey);
            var encodedVkey: String = Base64.encode(vkeyByteArray);

            return _SERVICE_PROTOCAL
                 + _SERVICE_HOST + "/v1/hubs/"
                 + hub + "/videos/"
                 + encodedVkey + "/qkey";
        }

        public static function getQkey(cb: Function, fb: Function): void {
            var variables: URLVariables = _getUrlStringParams(_getCurrentUrl());
            var hub: String = variables.hub || "";
            var vkey: String = variables.vkey || "";
            var jediXToken: String = getJediXAuthorization(hub, vkey);
            var url: String = genGetQkeyUrl(hub, vkey);

            Http.post(url).type(URLLoaderDataFormat.TEXT).setData({"key": "value"}).cb(cb).fb(fb).header("Authorization", jediXToken).send();
        }
    }
}
