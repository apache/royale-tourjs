package 
{
import org.apache.flex.events.Event;
import org.apache.flex.events.EventDispatcher;
import org.apache.flex.html.Label;
import org.apache.flex.storage.PermanentStorage;
import org.apache.flex.storage.events.FileEvent;
import org.apache.flex.storage.events.FileErrorEvent;

	public class FileIO extends EventDispatcher
	{
		public function FileIO()
		{
		}
		

		public const MAXINDEX:int = 20

		public var KSIndex:Vector.<FileIndex> = new Vector.<FileIndex>(MAXINDEX);
		
		public var lKSLast:int = -1;
		public var fKS:StringManager;		// Keystroke DB sorted by UPC
		public var szKS:String = "ksdct.txt";

		public var MAX_BUFFER:int = 512;
		public var szBuffer:Array = new Array(512);
		public var szTemp:String;

		public var szProductName:String;
		public var szSize:String;
		public var szSKU:String = "";
		public var szQuantity:String;
		public var szPurchasePrice:String;
		public var szRetailPrice:String;
		public var szUPCCode:String;
		public var szSimpleName:String;
		public var szDepartment:String;
		public var szSection:String;
		public var szOldQuantity:String;

		public var flPrice:Number;

		public var permanentStorage:PermanentStorage = new PermanentStorage();

		public function xgets(iMax:int, f:StringManager):String
		{
			var szTemp:String;
			var iRead:int;
			var i:int;
		
			iRead = Math.min(128, f.bytesAvailable);
			szTemp = f.read(iRead);
			for (i = 0; i < iRead && i < iMax; i++)
			{
				if (szTemp.charAt(i) == '\r')
				{
					f.position += i - iRead + 2;
					return szTemp.substring(0, i);
				}
			}
			return szTemp;
		}

		public var label:Label;
		
		public function openFiles():void
		{
			permanentStorage.addEventListener("ERROR", fileErrorHandler);			
			permanentStorage.addEventListener("READ", fileReadHandler);
			permanentStorage.addEventListener("WRITE", fileWriteHandler);
			
	        try {		
			  permanentStorage.readTextFromDataFile(szKS);
			}
			catch (e:Error)
			{
			  label.text = "unexpected error in readTextFromDataFile";
			}
		}
		
		public function fileErrorHandler(event:FileErrorEvent):void
		{
			label.text = event.errorMessage;
		}
		
		public function fileWriteHandler(event:FileEvent):void
		{
			label.text = "Wrote file";
		}
		
		public function fileReadHandler(event:FileEvent):void
		{
			var pb:int;
			var pc:int;
			var nLines:int = 0;
			var i:int;
			var j:int;
			var k:int;
			var x:int;
			var line:String;

			fKS = new StringManager();
			fKS.data = event.data;
			fKS.position = 0;
			
			label.text = "preparing inventory file... " + fKS.bytesAvailable.toString() + " bytes";
			nLines = 0;
			fKS.position = 0;
			while (fKS.bytesAvailable)
			{
				line = xgets(MAX_BUFFER, fKS);
				if (!line)
					break;
				nLines++;
				if (nLines % 1000 == 0)
					trace(".");
			}
			label.text = "building index... " + nLines.toString() + " lines";
			nLines = Math.floor(nLines / (MAXINDEX + 1));
			fKS.position = 0;
			for (i = 0; i < MAXINDEX; i++)
			{
				var fileIndex:FileIndex = new FileIndex();
				for (j = 0; j < nLines; j++)
				{
					lKSLast = fKS.position;
					line = xgets(MAX_BUFFER, fKS);
				}
				label.text = label.text + ".";
				pc = line.indexOf('\t');
				fileIndex.szIndex = line.slice(0, pc);
				fileIndex.lOffset = lKSLast;
				KSIndex[i] = fileIndex;
			}
			label.text = "done building index";
			dispatchEvent(new Event("ready"));
		}

		public function inInventory(s:String):Boolean
		{
			var pb:int;
			var pc:int;
			var cmp:int;
			var i:int;
			var lOffset:int = 0;
			var sz:String;
		
			for (i = 0; i < MAXINDEX; i++)
			{
				cmp = KSIndex[i].szIndex.localeCompare(s);
				if (cmp == 0)
				{
					lOffset = KSIndex[i].lOffset;
					sz = KSIndex[i].szIndex;
					break;
				}
				else if (cmp > 0)
				{
					break;
				}
				else
				{
					lOffset = KSIndex[i].lOffset;
					sz = KSIndex[i].szIndex;
				}
			}
		
			fKS.position = lOffset;
			label.text = "Searching from position " + lOffset.toString() + " " + fKS.bytesAvailable.toString() + " " + sz;
			while (fKS.bytesAvailable)
			{
				lKSLast = fKS.position;
				var line:String = xgets(MAX_BUFFER, fKS)
				if (!line)
					break;
				label.text = line;
				pb = line.indexOf('\t');	
	            if (pb < 0)
                    label.text += "no tab at column 0";
                else
                    label.text = line.slice(0, pb);		
				cmp = line.slice(0, pb).localeCompare(s);
				if (cmp == 0)
				{
					pc = line.indexOf('\t', pb + 1);
					szProductName = line.slice(pb + 1, pc);
					pb = pc + 1;
					szOldQuantity = line.substr(pb);
					return true;
				}
				else if (cmp > 0)
				{
					return false;
				}
			}
		
			lKSLast = -1;
			return false;
		}
		
		public function updateInventoryFile(szUPCCode:String, szQuantity:String):Boolean
		{
			var old:int;
			var cur:int;
		
			if (lKSLast != -1)
			{
				fKS.position = lKSLast;
			}
			else
			{
				return false;
			}
		
			old = parseInt(szOldQuantity, 10);
			cur = parseInt(szQuantity, 10);
		
			old += cur;
			szQuantity = old.toString();
			while (szQuantity.length < 4)
			    szQuantity = "0" + szQuantity;
			var newString:String = szUPCCode + "\t" + szProductName + "\t" + szQuantity;	
            label.text = newString;	
			fKS.write(newString);
			permanentStorage.writeTextToDataFile(szKS, fKS.data);
			return true;		
		}

	}
}

class FileIndex
{
	public var szIndex:String;
	public var lOffset:int;
}

class StringManager
{
  public var data:String;
  public var position:int;
  public function get bytesAvailable():int
  {
     return data.length - position;
  }
  public function read(numBytes:int):String
  {
     var s:String = data.substr(position, numBytes);
     position += numBytes;
     return s;
  }
  public function write(s:String):void
  {
	 var firstPart:String = data.substr(0, position);
	 var lastPart:String = data.substr(position + s.length);
	 data = firstPart + s + lastPart;
  }
}