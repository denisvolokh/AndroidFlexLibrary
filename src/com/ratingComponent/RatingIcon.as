package com.ratingComponent
{
	import flash.display.Bitmap;
	
	import spark.components.supportClasses.SkinnableComponent;
	import spark.primitives.BitmapImage;
	
	[SkinState("normal")]
	
	[SkinState("selected")]
	
	[Style(name="ratingIcon",type="ClassReference")]
	
	[Style(name="selectedRatingIcon",type="ClassReference")]
	
	public class RatingIcon extends SkinnableComponent
	{
		public function RatingIcon()
		{
			super();
		}
		
		[SkinPart("true")]
		public var bitmapIcon : BitmapImage;
		
		private var _selected : Boolean = false;
		
		private var selectedChanged : Boolean = false;
		
		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(value:Boolean):void
		{
			if (_selected == value)
				return;
			
			_selected = value;
			//selectedChanged = true;
			
			invalidateSkinState();
			//invalidateProperties();
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (selectedChanged)
			{
				selectedChanged = false;
				
				invalidateDisplayList();
			}
		}
		
		override protected function getCurrentSkinState() : String
		{
			if (!selected)
				return "normal";
			
			return "selected"
		}
	}
}