package com.gallery
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.IVisualElement;
	
	import spark.components.BorderContainer;
	
	[DefaultProperty("content")]
	public class Gallery extends BorderContainer
	{
		private var _content : Array;
		
		private var _pendingSelectedIndex : int = -1;
		
		private var _selectedIndex : int = -1;
		
		private var _selectedChild : IVisualElement;
		
		public function Gallery()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedOnStageHandler);
		}
		
		private function onAddedOnStageHandler(event : Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedOnStageHandler);
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownEventClick);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUpEventClick);
		}
		
		private function onMouseDownEventClick(event : MouseEvent):void
		{
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveEventClick);
		}
		
		private function onMouseMoveEventClick(event : MouseEvent):void
		{
			_selectedChild.x += 10; 
		}
		
		private function onMouseUpEventClick(event : MouseEvent):void
		{
			removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveEventClick);
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (_pendingSelectedIndex != -1)
			{
				updateSelectedIndex(_pendingSelectedIndex);
				_pendingSelectedIndex = -1;
			}
		}
		
		private function updateSelectedIndex(index : int):void
		{
			var oldIndex : int = selectedIndex;
			_selectedIndex = index;
			
			if (numElements > 0)
			{
				removeElementAt(0);
			}
			
			_selectedChild = _content[_selectedIndex];
			addElement(_selectedChild);
			
			//dispatch event
		}
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}

		public function set selectedIndex(value:int):void
		{
			if (_selectedIndex == value) return;
			
			_pendingSelectedIndex = value;
			invalidateProperties();
		}
		
		[Bindable]
		[ArrayElementType("mx.core.IVisualElement")]
		public function get content():Array
		{
			return _content;
		}

		public function set content(value:Array):void
		{
			_content = value;
			
			selectedIndex = ( _pendingSelectedIndex == -1 )?0:_pendingSelectedIndex;
		}

	}
}