package com.rating
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import spark.components.Group;
	import spark.components.HGroup;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.layouts.HorizontalAlign;
	import spark.layouts.VerticalAlign;
	
	[SkinState("normal")]
	
	[SkinState("disabled")]
	
	[Event(name="currentValueChanged", type="flash.events.Event")]
	
	public class Rating extends SkinnableComponent
	{
		[SkinPart("true")]
		public var iconsHolder : HGroup;
		
		public function Rating()
		{
			super();
		}
		
		private var _ratingIconStyleName : String;

		private var ratingIconStyleNameChanged : Boolean = false;
		
		public function get ratingIconStyleName():String
		{
			return _ratingIconStyleName;
		}

		public function set ratingIconStyleName(value:String):void
		{
			_ratingIconStyleName = value;
			
			ratingIconStyleNameChanged = true;
			invalidateProperties();
		}
		
		private var _currentValue : Number = -1;
		
		private var currentValueChanged : Boolean = false;
		
		public function get currentValue():Number
		{
			return _currentValue + 1;
		}

		public function set currentValue(value:Number):void
		{
			if (_currentValue == value)
				return;
				
			_currentValue = value;
			
			currentValueChanged = true;
			invalidateProperties();
		}
		
		private var _maxRatingValue : Number = 5;
		
		private var maxRatingValueChanged : Boolean = false;
		
		public function get maxRatingValue():Number
		{
			return _maxRatingValue;
		}

		public function set maxRatingValue(value:Number):void
		{
			if (_maxRatingValue == value)
				return;
			
			_maxRatingValue = value;
			
			maxRatingValueChanged = true;
			invalidateProperties();
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (maxRatingValueChanged)
			{
				maxRatingValueChanged = false;
				
				setupRatingIcons();
				invalidateDisplayList();
			}
			
			if (currentValueChanged)
			{
				currentValueChanged = false;
				
				setupCurrentValue(_currentValue);
				invalidateDisplayList();
				
				dispatchEvent(new Event("currentValueChanged"));
			}
		}

		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if (instance == iconsHolder)
			{
				iconsHolder.verticalAlign = VerticalAlign.MIDDLE;
				iconsHolder.horizontalAlign = HorizontalAlign.CENTER
				
				setupRatingIcons();
			}
		}
		
		private function setupRatingIcons():void
		{
			iconsHolder.removeAllElements();			
			
			for (var i:int = 0; i < maxRatingValue; i++) {
				var icon : RatingStarContainer = new RatingStarContainer();
				icon.setStyle("skinClass", RatingStarContainerSkin);
				iconsHolder.addElement(icon);
				icon.addEventListener(MouseEvent.CLICK, handleIconClick);
			}
			
			setupCurrentValue(_currentValue);
		}
		
		private function setupCurrentValue(index : int):void
		{
			for (var i:int = 0; i < iconsHolder.numChildren; i++) 
			{
				var _icon : RatingStarContainer = RatingStarContainer(iconsHolder.getElementAt(i));
				
				if (i <= _currentValue)
				{
					_icon.selected = true;
				}
				else
				{
					_icon.selected = false;
				}
			}
		}
		
		private function handleIconClick(event : MouseEvent):void
		{
			var icon : RatingStarContainer = RatingStarContainer(event.currentTarget);
			var index : int = iconsHolder.getElementIndex(icon);
			
			if (index == 0)
			{
				currentValue = (icon.selected)? -1:index; 
			}
			else
			{
				currentValue = index;
			}
		}
	}
}