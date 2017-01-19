////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package navigator
{
	COMPILE::SWF
	{
		import flash.media.Sound;
		import flash.media.SoundChannel;
		import flash.utils.ByteArray;
	}
	
	/**
	 * The ActionScript typedefs for oordova.plugins.dialogs
	 * 
	 *  @externs
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class notification
	{		
		/**
		 *  alert.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public static function alert(message:String, alertCallback:Function, title:String = "Alert", buttonName:String = "OK"):void
		{
		}
		
		/**
		 *  confirm.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public static function confirm(message:String, confirmCallback:Function, title:String = "Confirm", buttonLabels:Array = null):void
		{
		}
		
		/**
		 *  prompt.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public static function prompt(message:String, promptCallback:Function, title:String = "Prompt", buttonLabels:Array = null, defaultText:String = ""):void
		{
		}
		
		/**
		 *  prompt.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public static function beep(times:int):void
		{
			COMPILE::SWF
			{	
				var sound:Sound = new Sound();
				var data:ByteArray = new ByteArray();
				var numSamples:int = 5000 * times;
				for (var i:int = 0; i < numSamples; i++)
				{
					var n:int = i + 100;
					for (; i < n; i++)
						data.writeFloat(1);
					n = i + 100;
					for (; i < n; i++)
						data.writeFloat(-1);
				}
				data.position = 0;
				sound.loadPCMFromByteArray(data, numSamples, "float", false);
				var channel:SoundChannel = sound.play();
			}
		}
		
	}
}
