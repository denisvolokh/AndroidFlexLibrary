package com.swipeselector
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	
	import spark.components.Button;
	import spark.components.DropDownList;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class SwipSelector extends DropDownList
	{
		public function SwipSelector()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
		}
		
		private function onAddedToStage(event : Event):void
		{
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseDown(event : MouseEvent):void
		{
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		private function onMouseMove(event : MouseEvent):void
		{
			
		}
		
		private function onMouseUp(event : MouseEvent):void
		{
			removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
	}
}