package com.gallery
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.IVisualElement;
	import mx.effects.Parallel;
	
	import spark.components.BorderContainer;
	import spark.components.Group;
	import spark.components.SkinnableContainer;
	import spark.effects.Animate;
	import spark.effects.animation.MotionPath;
	import spark.effects.animation.SimpleMotionPath;
	import spark.layouts.BasicLayout;
	
	[DefaultProperty("content")]
	public class Gallery extends SkinnableContainer
	{
		private var _content : Array;
		
		private var _pendingSelectedIndex : int = -1;
		
		private var _selectedIndex : int = -1;
		
		private var _selectedChild : IVisualElement;
		
		private var _rightChild : IVisualElement;
		
		private var _rightChildIndex : int = -1;
		
		private var _leftChild : IVisualElement;
		
		private var _leftChildIndex : int = -1;
		
		private var prevStageX : Number = 0;
		
		private var animate : Animate;
		
		private var pagesContainer : Group;
		
		private var _p : Parallel = new Parallel();
		
		private var _selectedChildAnimation : Animate;
		
		private var _selectedChildMotion : SimpleMotionPath = new SimpleMotionPath("x");
		
		private var _rightChildMotion : SimpleMotionPath = new SimpleMotionPath("x");
		
		private var _leftChildMotion : SimpleMotionPath = new SimpleMotionPath("x");
		
		public function Gallery()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedOnStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStageHandler);
			
			setStyle("skinClass", GallerySkin);
		}
		
		private function onAddedOnStageHandler(event : Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedOnStageHandler);
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownEventClick);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUpEventClick);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpEventClick);
		}
		
		private function onRemovedFromStageHandler(event : Event):void
		{
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownEventClick);
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUpEventClick);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpEventClick);
		}
		
		private function onMouseDownEventClick(event : MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveEventClick);
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
					if ((selectedIndex + 1) <= content.length - 1)
					{
						_rightChildIndex = selectedIndex + 1
						_rightChild = _content[_rightChildIndex];
						contentGroup.addElement(_rightChild);
						_rightChild.width = this.width;
						_rightChild.x = _selectedChild.x + _rightChild.width;	
					}
				}
			}
			else if (delta >= 0)
			{
				if (!_leftChild)
				{
					if (selectedIndex - 1 >= 0)
					{
						_leftChildIndex = selectedIndex - 1;
						_leftChild = _content[_leftChildIndex];
						contentGroup.addElement(_leftChild);
						_leftChild.width = this.width;
						_leftChild.x = _selectedChild.x - _leftChild.width;	
					}
				}
			}
			
			_selectedChild.x += delta;
			
			if (_leftChild)
			{
				_leftChild.x += delta;
			}
			
			if (_rightChild)
			{
				_rightChild.x += delta;
			}
			
			trace("x: ", _selectedChild.x);
		}
		
		private function onMouseUpEventClick(event : MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveEventClick);
			if (_selectedChild.x < -(this.width / 3))
			{
				this._pendingSelectedIndex = _rightChildIndex;
				invalidateProperties();
			}
			else if (_selectedChild.x >= this.width / 3)
			{
				this._pendingSelectedIndex = _leftChildIndex;
				invalidateProperties();
			}
			
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
					_leftChildIndex = -1;
				}
				
				if (this._rightChild)
				{
					contentGroup.removeElement(this._rightChild)
					this._rightChild = null;
					_rightChildIndex = -1;
				}
			}
			
			_selectedChild = _content[_selectedIndex];
			contentGroup.addElement(_selectedChild);
			_selectedChild.x = 0;
			
			/*_selectedChildAnimation = new Animate(_selectedChild);
			_selectedChildAnimation.duration = 400;
			var v:Vector.<MotionPath> = new Vector.<MotionPath>();
			v.push(_selectedChildMotion);
			_selectedChildAnimation.motionPaths = v;
			_selectedChildMotion.valueFrom = _selectedChild.x;
			_selectedChildMotion.valueTo = 0;			
			_selectedChildAnimation.play();*/
			
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