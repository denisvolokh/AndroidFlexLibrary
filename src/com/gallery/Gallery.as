package com.gallery
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.IVisualElement;
	
	import spark.components.BorderContainer;
	import spark.components.Group;
	import spark.components.SkinnableContainer;
	import spark.effects.Animate;
	import spark.layouts.BasicLayout;
	
	[DefaultProperty("content")]
	public class Gallery extends SkinnableContainer
	{
		private var _content : Array;
		
		private var _pendingSelectedIndex : int = -1;
		
		private var _selectedIndex : int = -1;
		
		private var _selectedChild : IVisualElement;
		
		private var _rightChild : IVisualElement;
		
		private var _leftChild : IVisualElement;
		
		private var prevStageX : Number = 0;
		
		private var animate : Animate;
		
		private var pagesContainer : Group;
		
		public function Gallery()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedOnStageHandler);
			
			setStyle("skinClass", GallerySkin);
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
			prevStageX = event.stageX;
		}
		
		private function onMouseMoveEventClick(event : MouseEvent):void
		{
			var delta : Number = event.stageX - prevStageX;
			prevStageX = event.stageX;
			trace("delta: ", delta);
			
			if (delta < 0)
			{
				if (!_rightChild)
				{
					_rightChild = _content[2];
					contentGroup.addElement(_rightChild);
					_rightChild.width = this.width;
					_rightChild.x = this.width;
				}
			}
			else if (delta >= 0)
			{
				if (!_leftChild)
				{
					_leftChild = _content[0];
					contentGroup.addElement(_leftChild);
					_leftChild.width = this.width;
					_leftChild.x = - this.width;
					
				}
			}
			
			if (_leftChild)
			{
				_leftChild.x += delta;
				trace("_leftChild.x: ", _leftChild.x);				
			}
			
			if (_rightChild)
			{
				_rightChild.x += delta;
				trace("_rightChild.x: ", _rightChild.x);
			}
			_selectedChild.x += delta;
			
			trace("x: ", _selectedChild.x);
		}
		
		private function onMouseUpEventClick(event : MouseEvent):void
		{
			removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveEventClick);
			if (_selectedChild.x < -(this.width / 3))
			{
				this._pendingSelectedIndex = 2;
				invalidateProperties();
			}
			else if (_selectedChild.x >= this.width / 3)
			{
				this._pendingSelectedIndex = 0;
				invalidateProperties();
			}
			else
			{
				_selectedChild.x = 0;
				if (_rightChild)
				{
					_rightChild.x = this.width;	
				}
				if (_leftChild)
				{
					_leftChild.x = - this.width;	
				}	
			}
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
		
		override protected function createChildren():void
		{
			super.createChildren();
			
		}
		
		private function updateSelectedIndex(index : int):void
		{
			var oldIndex : int = selectedIndex;
			_selectedIndex = index;
			
			if (contentGroup.numElements > 0)
			{
				contentGroup.removeElementAt(0);
				if (this._leftChild)
				{
					contentGroup.removeElement(this._leftChild)
					this._leftChild = null;	
				}
				
				if (this._rightChild)
				{
					contentGroup.removeElement(this._rightChild)
					this._rightChild = null;	
				}
			}
			
			_selectedChild = _content[_selectedIndex];
			contentGroup.addElement(_selectedChild);
			_selectedChild.x = 0;
			
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