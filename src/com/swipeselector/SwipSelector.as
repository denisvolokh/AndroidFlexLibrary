package com.swipeselector
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import mx.collections.ArrayCollection;
	import mx.core.mx_internal;
	
	import spark.components.Button;
	import spark.components.DropDownList;
	import spark.components.supportClasses.SkinnableComponent;
	
	use namespace mx_internal;
	
	public class SwipSelector extends DropDownList
	{
		public function SwipSelector()
		{
			super();
			
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private var prevStageX : Number = 0;
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
		}
		
		private function onAddedToStage(event : Event):void
		{
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		private function onMouseDown(event : MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			prevStageX = event.stageX;
			trace("mouse down: ", prevStageX)
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
		}
		
		private function onMouseMove(event : MouseEvent):void
		{
			var delta : Number = prevStageX - event.stageX;
			prevStageX = event.stageX;
			if (delta < -1 || delta > 1)
			{
				this.scroller.horizontalScrollBar.value += (delta * 2);
			}
		}
		
		private function onTouchMove(event : TouchEvent):void
		{
			var delta : Number = prevStageX - event.stageX;
			prevStageX = event.stageX;
			if (delta < -1 || delta > 1)
			{
				this.scroller.horizontalScrollBar.value += (delta * 2);
			}
		}
		
		private function onMouseUp(event : MouseEvent):void
		{
			if (this.scroller.horizontalScrollBar && dataProvider && dataProvider.length > 0)
			{
				var scrollPointPerItem : Number = this.scroller.horizontalScrollBar.maximum / dataProvider.length;	
				trace("maximun: ", this.scroller.horizontalScrollBar.maximum);
				trace("perItem: ", scrollPointPerItem);
				trace("current Position: ", this.scroller.horizontalScrollBar.value);	
				
				var index : int = Math.round(this.scroller.horizontalScrollBar.value / scrollPointPerItem);
				
				setSelectedIndex(index, true);
			}
			
			stage.removeEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			closeDropDown(false);
		}
	}
}