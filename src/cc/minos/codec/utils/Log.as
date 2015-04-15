/**
 * ...
 * Created by SiuzukZan<minoscc@gmail.com> on 04/15/2015 09:03
 */
package cc.minos.codec.utils {

	import flash.external.ExternalInterface;

	public final class Log {

		private static const INFO:String = "[INFO]";
		private static const DEBUG:String = "[DEBUG]";
		private static const WARN:String = "[WARN]";
		private static const ERROR:String = "[ERROR]";

		public static function info(...rest):void
		{
			output.apply(null, new Array(INFO).concat(rest));
		}

		public static function debug(...rest):void
		{
			output.apply(null, new Array(DEBUG).concat(rest));
		}

		public static function warn(...rest):void
		{
			output.apply(null, new Array(WARN).concat(rest));
		}

		public static function error(...rest):void
		{
			output.apply(null, new Array(ERROR).concat(rest));
		}

		private static function output(...rest):void
		{
			if (ExternalInterface.available)
				ExternalInterface.call.apply(null, new Array('console.log').concat(rest));
			else
				trace.apply(null, rest);
		}
	}
}
