package org.mangui.hls.service {
    import flash.external.ExternalInterface;
    import flash.net.URLVariables;
    import flash.utils.ByteArray;

    import by.blooddy.crypto.Base64;

    import org.mangui.hls.constant.HLSKeys;
    import org.mangui.hls.hash.*;
    import org.mangui.hls.utils.*;

    public class QService {
        private static const _SERVICE_HOST:String = "jedi.qiniuapi.com";

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

        public static function getEncodedSign(hub: String, vkey: String, timeStr: String): String {
            var data: String = "";
            data = "JEDI-QKEY\n"
                 + "GET\n"
                 + _SERVICE_HOST + "\n"
                 + hub + "\n"
                 + vkey + "\n"
                 + timeStr + "\n"
                 + "\n\n";

            var hmac: HMAC = new HMAC(new SHA1());
            var sign: ByteArray = hmac.compute(
                    Hex.toArray(Hex.fromString(HLSKeys.S_K)),
                    Hex.toArray(Hex.fromString(data)));

            return Base64.encode(sign);
        }

        public static function getQkey(cb: Function): void {
            var variables:URLVariables = _getUrlStringParams(_getCurrentUrl());
            var hub:String = variables.hub || "";
            var vkey:String = variables.vkey || "";
            var timeStr:String = String((new Date()).time);
            var encodedVkey: String = Base64.encode(Hex.toArray(vkey));
            var encodedTimestamp: String = Base64.encode(Hex.toArray(timeStr));

            var encodedSign: String = getEncodedSign(hub, vkey, timeStr);
            var jediXToken: String = "JEDI-X "
                        + HLSKeys.A_K + ":"
                        + encodedSign + ":"
                        + encodedTimestamp;

            var url:String = "https://"
                        + _SERVICE_HOST + "/v1/hubs/"
                        + hub + "/videos/"
                        + encodedVkey + "/qkey";

            Http.get(url).cb(cb).header("Authorization", jediXToken).send();
        }
    }
}
