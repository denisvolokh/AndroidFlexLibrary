package com.ratingComponent
{
	import spark.components.SkinnableContainer;
	
	[SkinState("normal")]
	
	[SkinState("selected")]
	
	public class RatingStarContainer extends SkinnableContainer
	{
		public function RatingStarContainer()
		{
			super();
		}
		
		private var _selected : Boolean = false;
		
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
		
		override protected function getCurrentSkinState() : String
		{
			if (!selected)
				return "normal";
			
			return "selected"
		}
	}
}