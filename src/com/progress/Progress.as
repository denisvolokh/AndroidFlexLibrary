/*
	1. Simple indeterminate progress
	2. ... with label
	3. ... ... with details
	4. 

	TO-DO: 1. Round progress indicator

*/
package com.progress
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.StageOrientationEvent;
	
	import mx.events.FlexEvent;
	import mx.events.FlexMouseEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.BusyIndicator;
	import spark.components.Label;
	import spark.components.SkinnablePopUpContainer;
	
	[SkinState("normal")]
	
	[SkinState("disabled")]
	
	[SkinState("closed")]
	
	[SkinState("indeterminate")]
	
	[SkinState("indeterminateWithLabel")]
	
	[SkinState("indeterminateWithLabelAndDetails")]
	
	[SkinState("determinate")]
	
	[SkinState("determinateWithLabel")]
	
	[SkinState("determinateWithLabelAndDetails")]
	
	public class Progress extends SkinnablePopUpContainer
	{
		public function Progress()
		{
			super();
			
			setStyle("skinClass", ProgressSkin);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
		}
		
		private function onAddedToStageHandler(event : Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
			
			addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, onMouseDownOutsideHandler);			
			stage.addEventListener(flash.events.StageOrientationEvent.ORIENTATION_CHANGE, onOrientationChangedHandler);
		}
		
		[SkinPart(required="true")]
		public var busyIndicator:BusyIndicator;
		
		[SkinPart(required="true")]
		public var labelMessage:Label;
		
		[SkinPart(required="true")]
		public var labelDetails:Label;
		
		[SkinPart(required="true")]
		public var progressDiagram:ProgressDiagram;
		
		private static var _progress : Progress;
		
		private var _determinateProgressValue : Number = 0;
		
		private var determinateProgressValueChanged : Boolean = false;
		
		public function get determinateProgressValue():Number
		{
			return _determinateProgressValue;
		}
		
		public function set determinateProgressValue(value:Number):void
		{
			_determinateProgressValue = value;
			
			determinateProgressValueChanged = true;
			invalidateProperties();
		}
		
		private var _message : String;
		
		private var messageChanged : Boolean = false;
		
		public function get message():String
		{
			return _message;
		}

		public function set message(value:String):void
		{
			_message = value;
			
			messageChanged = true;
			invalidateProperties();
		}
		
		private var _details : String;
		
		private var detailsChanged : Boolean = false

		public function get details():String
		{
			return _details;
		}

		public function set details(value:String):void
		{
			_details = value;
			
			detailsChanged = true;
			invalidateProperties();
		}
		
		public static function showIndeterminateProgress(parentView : DisplayObjectContainer):Progress
		{
			if (!_progress)
			{
				_progress = new Progress();
			}
			
			_progress.isIndeterminate = true;
			_progress.invalidateSkinState();
			
			_progress.open(parentView, true);
			PopUpManager.centerPopUp(_progress);
			
			_progress.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, _progress.onMouseDownOutsideHandler);
			
			return _progress;
		}
		
		public static function showIndeterminateProgressWithMessage(parentView : DisplayObjectContainer, messageText : String = ""):Progress
		{
			if (!_progress)
			{
				_progress = new Progress();
			}
			
			_progress.isIndeterminateWithLabel = true;
			_progress.invalidateSkinState();
			
			_progress.message = messageText;
			
			_progress.open(parentView, true);
			PopUpManager.centerPopUp(_progress);
			
			_progress.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, _progress.onMouseDownOutsideHandler);
			
			return _progress;
		}
		
		public static function showIndeterminateProgressWithMessageAndDetails(parentView : DisplayObjectContainer, messageText : String = "", detailsText : String = ""):Progress
		{
			if (!_progress)
			{
				_progress = new Progress();
			}
			
			_progress.isIndeterminateWithLabelAndDetails = true;
			_progress.invalidateSkinState();
			
			_progress.message = messageText;
			_progress.details = detailsText;
			
			_progress.open(parentView, true);
			PopUpManager.centerPopUp(_progress);
			
			_progress.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, _progress.onMouseDownOutsideHandler);
			
			return _progress;
		}
		
		public static function showDeterminateProgress(parentView : DisplayObjectContainer, progressValue : Number = 0):Progress
		{
			if (!_progress)
			{
				_progress = new Progress();
			}
			
			_progress.isDeterminate = true;
			_progress.invalidateSkinState();
			
			_progress.determinateProgressValue = progressValue;
			
			_progress.open(parentView, true);
			PopUpManager.centerPopUp(_progress);
			
			_progress.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, _progress.onMouseDownOutsideHandler);
			
			return _progress;
		}
		
		public static function showDeterminateProgressWithMessage(parentView : DisplayObjectContainer, progressValue : Number = 0, messageText : String = ""):Progress
		{
			if (!_progress)
			{
				_progress = new Progress();
			}
			
			_progress.isDeterminateWithLabel = true;
			_progress.invalidateSkinState();
			
			_progress.determinateProgressValue = progressValue;
			_progress.message = messageText;
			
			_progress.open(parentView, true);
			PopUpManager.centerPopUp(_progress);
			
			_progress.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, _progress.onMouseDownOutsideHandler);
			
			return _progress;
		}
		
		public static function showDeterminateProgressWithMessageAndDetails(parentView : DisplayObjectContainer, progressValue : Number = 0, messageText : String = "", detailsText : String = ""):Progress
		{
			if (!_progress)
			{
				_progress = new Progress();
			}
			
			_progress.isDeterminateWithLabelAndDetails = true;
			_progress.invalidateSkinState();
			
			_progress.determinateProgressValue = progressValue;
			_progress.message = messageText;
			_progress.details = detailsText;
			
			_progress.open(parentView, true);
			PopUpManager.centerPopUp(_progress);
			
			_progress.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, _progress.onMouseDownOutsideHandler);
			
			return _progress;
		}
		
		public static function updateProgress(progressValue : Number):void
		{
			if (!_progress)
				return;
			
			_progress.determinateProgressValue = progressValue;
		}
		
		public static function updateMessage(messageText : String):void
		{
			if (!_progress)
				return;
			
			_progress.message = messageText;
		}
		
		public static function updateDetails(detailsText : String):void
		{
			if (!_progress)
				return;
			
			_progress.details = detailsText;
		}
		
		public static function hideProgress():void
		{
			if (_progress)
			{
				_progress.isDeterminate = false;
				_progress.isDeterminateWithLabel = false;
				_progress.isDeterminateWithLabelAndDetails = false;
				_progress.isIndeterminate = false;
				_progress.isIndeterminateWithLabel = false;
				_progress.isIndeterminateWithLabelAndDetails = false;
				_progress.invalidateSkinState();
				
				_progress.removeEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, _progress.onMouseDownOutsideHandler);
				_progress.stage.removeEventListener(flash.events.StageOrientationEvent.ORIENTATION_CHANGE, _progress.onOrientationChangedHandler);
				
				_progress.close();
				_progress = null;
			}
		}
		
		private function onMouseDownOutsideHandler(event : FlexMouseEvent):void
		{
			hideProgress()	
		}
		
		private function onOrientationChangedHandler(event : *):void
		{
			if (_progress)
			{
				PopUpManager.centerPopUp(_progress);				
			}
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (messageChanged && labelMessage)
			{
				messageChanged = false;
				labelMessage.text = message;
			}
			
			if (detailsChanged && labelDetails)
			{
				detailsChanged = false;
				labelDetails.text = details;
			}
			
			if (determinateProgressValueChanged && progressDiagram)
			{
				determinateProgressValueChanged = false;
				progressDiagram.arc = determinateProgressValue;
			}
		}
		
		override protected function getCurrentSkinState():String
		{
			if (isIndeterminate)
			{
				return "indeterminate"
			}
			
			if (isIndeterminateWithLabel)
			{
				return "indeterminateWithLabel"
			}
			
			if (isIndeterminateWithLabelAndDetails)
			{
				return "indeterminateWithLabelAndDetails"
			}
			
			if (isDeterminate)
			{
				return "determinate"
			}
			
			if (isDeterminateWithLabel)
			{
				return "determinateWithLabel"
			}
			
			if (isDeterminateWithLabelAndDetails)
			{
				return "determinateWithLabelAndDetails"
			}
			
			
			return "normal";
		}
		
		private var isIndeterminate : Boolean = false;
		
		private var isDeterminate : Boolean = false;
		
		private var isIndeterminateWithLabel : Boolean = false;
		
		private var isDeterminateWithLabel : Boolean = false;
		
		private var isIndeterminateWithLabelAndDetails : Boolean = false;
		
		private var isDeterminateWithLabelAndDetails : Boolean = false;
	}
}