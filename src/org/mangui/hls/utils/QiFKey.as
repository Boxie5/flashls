package org.mangui.hls.utils {
    import flash.utils.ByteArray;

    import by.blooddy.crypto.Base64;

    import org.mangui.hls.utils.Log;

    public final class QiFKey {

        private static function QiBase64ToUintVector(value: String): Vector.<uint> {
            var result: Vector.<uint> = new Vector.<uint>();
            var partIndex: int = 0;
            var originValue: ByteArray;

            try
            {
                originValue = Base64.decode(value);
            }
            catch (e:Error)
            {
                Log.error("`" + value + "` is not a valid base64 string")
                throw new Error("`" + value + "` is not a valid base64 string");
            }

            QiRoll(originValue);

            var temp:int = 0;
            for (var index: int = 0; index < 4; index++) {
                temp = originValue.readUnsignedInt();
                result[index] = temp;
            }

            return result;
        }

        private static function QiRoll(value: ByteArray): void {
            var index: int = 0;
            var temp:int = 0;
            for (index = 0; index < 16; index++) {
                if (index % 4 < 2) {
                    temp = value[index];
                    value[index] = value[4 * int(index / 4) + (3 - index % 4)];
                    value[4 * int(index / 4) + (3 - index % 4)] = temp;
                }
            }
        }

        private static function QiMix(value: Vector.<uint>, key: Vector.<uint>): void {
            var value0: uint = value[0];
            var value1: uint = value[1];
            var sum: uint = 0;
            const magic: uint = 0x5f3759df;

            for (var i:int = 0; i < 64; i++) {
                value0 += (((value1 << 4) ^ (value1 >>> 5)) + value1) ^ (sum + key[sum&3]);
                sum += magic;
                value1 += (((value0 << 4) ^ (value0 >>> 5)) + value0) ^ (sum + key[(sum>>>11)&3]);
            }

            value[0] = value0;
            value[1] = value1;
        }

        public static function QiFKeyGen(qKey: String, uKey: String = ""): ByteArray {
            var pattern1: RegExp = /\_/g;
            var pattern2: RegExp = /\-/g;
            qKey = qKey.replace(pattern1, "/").replace(pattern2, "+");
            uKey = uKey.replace(pattern1, "/").replace(pattern2, "+");

            var result: ByteArray = new ByteArray();

            if (!uKey) {
                result = Base64.decode(qKey);
                return result;
            }

            var value: Vector.<uint> = QiBase64ToUintVector(qKey);
            var key: Vector.<uint> = QiBase64ToUintVector(uKey);
            var part1: Vector.<uint> = value.slice(0, 2);
            var part2: Vector.<uint> = value.slice(2, 4);

            QiMix(part1, key);
            QiMix(part2, key);

            value[0] = part1[0];
            value[1] = part1[1];
            value[2] = part2[0];
            value[3] = part2[1];

            var index: int = 0
            for (; index < value.length; index++) {
                result.writeUnsignedInt(value[index]);
            }

            QiRoll(result);

            result.writeByte(10);
            return result;
        }
    }
}
