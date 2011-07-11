package com.popover
{
	import flash.events.Event;
	
	import mx.core.UIComponent;
	import mx.events.FlexMouseEvent;
	
	import spark.components.SkinnablePopUpContainer;
	import spark.components.VGroup;
	
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
			this.move(target.x, target.y);
			
			this.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, onMouseDownOutsideHandler);
			
			return this;
		}
		
		public function hide():void
		{
			this.removeEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, onMouseDownOutsideHandler);
			
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
	}
}