package com.swipeselector
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	
	import spark.components.Button;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class SwipSelector extends Button
	{
		public function SwipSelector()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private var _selectedIndex : int = 0;
		
		private var selectedIndexChanged : Boolean = false;
		
		private var _dataProvider : ArrayCollection;
		
		private var dataProviderChanged : Boolean = false;
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}

		public function set selectedIndex(value:int):void
		{
			_selectedIndex = value;
		}

		public function get dataProvider():ArrayCollection
		{
			return _dataProvider;
		}

		public function set dataProvider(value:ArrayCollection):void
		{
			_dataProvider = value;
			
			dataProviderChanged = true;
			invalidateProperties();
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (dataProviderChanged)
			{
				dataProviderChanged = false;
						
				label = dataProvider.getItemAt(_selectedIndex) as String;
			}
			
			if (selectedIndexChanged)
			{
				selectedIndexChanged = false;
				
				label = dataProvider.getItemAt(_selectedIndex) as String;
			}
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