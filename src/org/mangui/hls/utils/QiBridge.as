package org.mangui.hls.utils {

    import flash.external.ExternalInterface;

    public class QiBridge {
        public static function isDRMEnabled(): Boolean {
            if (ExternalInterface) {
                return ExternalInterface.call("Jedi.Bridge.isCurrentVideoDRMEnabled") || false;
            }
            return false;
        }

        public static function getDRMLevel(): int {
            if (ExternalInterface) {
                return ExternalInterface.call("Jedi.Bridge.currentVideoDRMLevel") || 0;
            }

            return 0;
        }

        public static function getCurrentHub(): String {
            if (ExternalInterface) {
                return ExternalInterface.call("Jedi.Bridge.currentHub") || "";
            }
            return "";
        }

        public static function getCurrentVkey(): String {
            if (ExternalInterface) {
                return ExternalInterface.call("Jedi.Bridge.currentVkey") || "";
            }
            return "";
        }

        public static function getUKey(): String {
            if (ExternalInterface) {
                return ExternalInterface.call("Jedi.Bridge.getUKey") || "";
            }

            return "";
        }
    }
}
