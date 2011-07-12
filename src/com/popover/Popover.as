package com.popover
{
	import flash.events.Event;
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	import mx.events.FlexMouseEvent;
	
	import spark.components.SkinnablePopUpContainer;
	import spark.components.VGroup;
	
	[SkinState("normal")]
	
	[SkinState("disabled")]
	
	[SkinState("top")]
	
	[SkinState("bottom")]
	
	public class Popover extends SkinnablePopUpContainer
	{
		public function Popover()
		{
			super();
			
			setStyle("skinClass", PopoverSkin);
		}
		
		[SkinPart(required="true")]
		public var customContentHolder:VGroup;
		
		private var _customContent : UIComponent;
		
		private var customContentChanged : Boolean;
		
		public function show(parent : UIComponent, target : UIComponent, customContent : UIComponent = null):Popover
		{
			if (customContent != null)
			{
				this.customContent = customContent;
			}
			
			this.open(parent);
			var globalPoint : Point = new Point(target.x, target.y);
			globalPoint = parent.contentToGlobal(globalPoint);
			var dx : Number = 0;
			var dy : Number = 0;
			
			if (globalPoint.y > parent.height / 2) // target is in bottom half of the view
			{
				dx = (target.width - this.width) / 2;
				dy = -(this.height + 20);	
				_isBottom = true;
				invalidateSkinState();
			}
			else
			{
				if (globalPoint.y - this.height <= 0)
				{
					dx = (target.width - this.width) / 2;
					dy = target.height;	
					_isTop = true;
					invalidateSkinState();
				}					
			}
			
			this.move(globalPoint.x + dx, globalPoint.y + dy);
			
			this.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, onMouseDownOutsideHandler);
			
			return this;
		}
		
		public function hide():void
		{
			this.removeEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, onMouseDownOutsideHandler);
			
			_isTop = false;
			_isBottom = false;
			invalidateSkinState();
			
			this.close();
		}
		
		private function onMouseDownOutsideHandler(event : Event):void
		{
			hide();
		}
		
		public function get customContent():UIComponent
		{
			return _customContent;
		}

		public function set customContent(value:UIComponent):void
		{
			if (value == null)
				return;
			
			_customContent = value;
			
			customContentChanged = true;
			
			invalidateProperties();
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (customContentChanged)
			{
				customContentChanged = false;
				
				if (customContentHolder.numChildren > 0)
				{
					customContentHolder.removeAllElements();
				}
				
				customContentHolder.addElement(customContent);
				
				invalidateDisplayList();
			}
		}
		
		override protected function getCurrentSkinState():String
		{
			return _isBottom ? "bottom" : _isTop ? "top" : "normal";
		} 
		
		private var _isBottom : Boolean = false
			
		private var _isTop : Boolean = false	
	}
}