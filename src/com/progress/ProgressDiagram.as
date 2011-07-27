package com.progress 
{
	
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	
	import mx.core.UIComponent;
	
	public class ProgressDiagram extends UIComponent
	{
		public function ProgressDiagram()
		{
			super();
		}
		
		private var _borderColor : uint = 0x000000;
		
		private var isBorderColorChanged : Boolean = false;
		
		private var _fillColor : uint = 0x000000;
		
		private var isFillColorChanged : Boolean = false;
		
		private var _lineColor : uint = 0x000000;
		
		private var isLineColorChanged : Boolean = false;
		
		private var _lineThickness : Number = 3;
		
		private var isLineThicknessChanged : Boolean = false;
		
		private var _radius : Number = 0;
		
		private var isRadiusChanged : Boolean = false;
		
		private var _arc : Number = 0;
		
		private var isArcChanged : Boolean = false;
		
		private var startAngle : Number = -90;
		
		public function get borderColor():uint
		{
			return _borderColor;
		}

		public function set borderColor(value:uint):void
		{
			_borderColor = value;
			
			isBorderColorChanged = true;
			invalidateProperties();
		}

		public function get arc():Number
		{
			return _arc;
		}

		public function set arc(value:Number):void
		{
			_arc = startAngle + value * 3.6;
			
			if (value == 0)
			{
				this.visible = false;
			}
			else
			{
				this.visible = true;	
			}
			
			isArcChanged = true;
			invalidateProperties();			
		}

		public function get radius():Number
		{
			return _radius;
		}

		public function set radius(value:Number):void
		{
			_radius = value;
			
			isRadiusChanged = true;
			invalidateProperties();
		}

		public function get lineColor():uint
		{
			return _lineColor;
		}

		public function set lineColor(value:uint):void
		{
			_lineColor = value;
			
			isLineColorChanged = true;
			invalidateProperties();
		}

		public function get fillColor():uint
		{
			return _fillColor;
		}

		public function set fillColor(value:uint):void
		{
			_fillColor = value;
			
			isFillColorChanged = true;
			invalidateProperties();
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (isArcChanged)
			{
				doDraw();
				isArcChanged = false;
			}
			
			if (isRadiusChanged)
			{
				doDraw();
				isRadiusChanged = false;
			}
			
			if (isFillColorChanged)
			{
				doDraw();
				isFillColorChanged = false;
			}
			
			if (isLineColorChanged)
			{
				doDraw();
				isLineColorChanged = false;
			}
			
			if (isLineThicknessChanged)
			{
				doDraw();
				isLineThicknessChanged = false;
			}
			
			if (isBorderColorChanged)
			{
				doDraw();
				isBorderColorChanged = false;
			}
		}
		
		private function doDraw():void
		{
			var r : Number = _radius;
			if (r == 0)
			{
				r = Math.min(unscaledHeight / 2, unscaledWidth / 2) - 5;					
			}
			
			graphics.clear();
			graphics.lineStyle(_lineThickness, _lineColor);
			graphics.drawCircle(unscaledWidth / 2,unscaledHeight / 2, r);
			
			graphics.beginFill(_fillColor);
			
			
			drawWedge(this, unscaledWidth / 2,unscaledHeight / 2, r, startAngle, _arc);
		}
		
		protected function drawWedge(t:Sprite, x : Number, y : Number, radius : Number, bA : Number, eA : Number):void 
		{
			var degToRad : Number = Math.PI/180;
			if (eA < bA) eA += 360;
			var r : Number = radius;
			var n : Number = Math.ceil((eA-bA)/45);
			var theta : Number = ((eA-bA)/n)*degToRad;
			var cr : Number = radius/Math.cos(theta/2);
			var angle : Number = bA*degToRad;
			var cangle : Number = angle-theta/2;
			t.graphics.moveTo(x, y);
			t.graphics.lineTo(x+r*Math.cos(angle), y+r*Math.sin(angle));
			for (var i:int=0;i < n;i++)	{
				angle += theta;
				cangle += theta;
				var endX : Number = r*Math.cos (angle);
				var endY : Number = r*Math.sin (angle);
				var cX : Number = cr*Math.cos (cangle);
				var cY : Number = cr*Math.sin (cangle);
				t.graphics.curveTo(x+cX,y+cY, x+endX,y+endY);
			}
			t.graphics.lineTo(x, y);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			doDraw();
		}
	}
}