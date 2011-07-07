package com.toast
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import spark.components.Label;
	import spark.components.SkinnablePopUpContainer;
	
	public class ToastMessage extends SkinnablePopUpContainer
	{
		public static const SHORT : Number = 2;
		
		public static const LONG : Number = 5;
		
		[SkinPart(required="true")]
		public var _messageLabel:Label;
		
		private var _message:String;
		
		private static var thisToast : ToastMessage;
		
		public function ToastMessage()
		{
			super();
			
			setStyle("skinClass", ToastMessageSkin);
		}
		
		private static var toastTimer : Timer;
		
		private static var callBack : Function;
		
		public static function showToast(message : String, parent : DisplayObjectContainer, duration : Number = SHORT, callBackFunction : Function = null):ToastMessage
		{
			if (!thisToast)
			{
				thisToast = new ToastMessage();
				thisToast.message = message;
			}
			
			callBack = callBackFunction;
			
			thisToast.open(parent);
			thisToast.move(50, 50);
			
			toastTimer = new Timer(duration * 1000, 1);
			toastTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			toastTimer.start();
			
			return thisToast;
		}
		
		private static function onTimerComplete(event : TimerEvent):void
		{
			closeToast();
		}
		
		public static function closeToast():void
		{
			if (toastTimer && toastTimer.running)
			{
				toastTimer.stop();
				toastTimer = null;
			}
			
			if (callBack != null)
			{
				callBack.call();
			}
			
			thisToast.close();
			thisToast = null;
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties()
			
			_messageLabel.text = message;
		}
		
		public function get message():String
		{
			return _message;
		}
		
		public function set message(value:String):void
		{
			_message = value;
		}
	}
}