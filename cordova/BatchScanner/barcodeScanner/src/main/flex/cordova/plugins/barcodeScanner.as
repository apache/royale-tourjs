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
package cordova.plugins
{
	COMPILE::SWF
	{
		import flash.desktop.NativeApplication;
		import org.apache.flex.core.Application;
		import org.apache.flex.core.View;
		import org.apache.flex.events.Event;
		import org.apache.flex.events.MouseEvent;
		import org.apache.flex.html.Panel;
		import org.apache.flex.html.Label;
		import org.apache.flex.html.TextInput;
		import org.apache.flex.html.TextButton;
		
		import cordova.plugins.barcodeScanner.Result;
	}
	
	/**
	 * The ActionScript typedefs for oordova.plugin.BarcodeScanner 
	 * 
	 *  @externs
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class barcodeScanner
	{
		/**
		 * scan.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public static function scan(success:Function, fail:Function):void
		{
			COMPILE::SWF
			{
				panel = new Panel();
				var label:Label = new Label();
				var textInput:TextInput = new TextInput();
				var okButton:TextButton = new TextButton();
				var cancelButton:TextButton = new TextButton();
				panel.width = 200;
				panel.height = 150;
				label.width = 180;
				label.height = 25;
				label.text = "Enter UPC Code";
				textInput.width = 180;
				textInput.height = 30;
				okButton.width = 80;
				okButton.height = 40;
				okButton.text = "OK";
				cancelButton.width = 80;
				cancelButton.height = 40;
				cancelButton.text = "Cancel";
				panel.addElement(label);
				label.x = 10;
				panel.addElement(textInput);
				textInput.x = 10;
				textInput.y = 30;
				panel.addElement(okButton);
				okButton.x = 10;
				okButton.y = 70;
				okButton.addEventListener("click", okHandler);
				panel.addElement(cancelButton);
				cancelButton.x = 110;
				cancelButton.y = 70;
				cancelButton.addEventListener("click", cancelHandler);
				var air:NativeApplication = NativeApplication.nativeApplication;
				var app:Application = air.activeWindow.stage.getChildAt(0)["flexjs_wrapper"] as Application;
				View(app.initialView).addElement(panel);
				successFunction = success;
				failFunction = fail;
			}
		}
		
		COMPILE::SWF
		private static var panel:Panel;
		
		COMPILE::SWF
		private static var successFunction:Function;
		
		COMPILE::SWF
		private static var failFunction:Function;
		
		COMPILE::SWF
		private static function okHandler(event:MouseEvent):void
		{
			var air:NativeApplication = NativeApplication.nativeApplication;
			var app:Application = air.activeWindow.stage.getChildAt(0)["flexjs_wrapper"] as Application;
			View(app.initialView).removeElement(panel);
			var textInput:TextInput = panel.getElementAt(1) as TextInput;
			var result:Result = new Result();
			result.text = textInput.text;
			successFunction(result);
		}
		
		COMPILE::SWF
		private static function cancelHandler(event:MouseEvent):void
		{
			var air:NativeApplication = NativeApplication.nativeApplication;
			var app:Application = air.activeWindow.stage.getChildAt(0)["flexjs_wrapper"] as Application;
			View(app.initialView).removeElement(panel);
			var textInput:TextInput = panel.getElementAt(1) as TextInput;
			failFunction();
		}

	}
}
