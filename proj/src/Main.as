package 
{
  import flash.display.Shape;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.KeyboardEvent;
  import flash.geom.Point;
  import flash.text.TextField;
  import flash.text.TextFieldAutoSize;
  import flash.text.TextFormat;
  import flash.text.TextFormatAlign;
  import flash.ui.Keyboard;
  import flash.utils.getTimer;

  [SWF(width=500, height=300, frameRate=30)]
  public class Main extends Sprite 
  {
    private var m_demo0:Demo;
    private var m_demo1:Demo;
    
    private var m_title:TextField;
    private var m_frequencyText:TextField;
    
    public function Main()
    {
      const size:Number = 0.5 * stage.stageWidth;
      
      m_demo0 = new Demo(size, true);
      m_demo0.x = 0.25 * stage.stageWidth;
      m_demo0.y = 0.5 * stage.stageHeight;
      addChild(m_demo0);
      
      m_demo1 = new Demo(size, false);
      m_demo1.x = 0.75 * stage.stageWidth;
      m_demo1.y = 0.5 * stage.stageHeight;
      addChild(m_demo1);
      
      m_title = new TextField();
      m_title.autoSize = TextFieldAutoSize.CENTER;
      m_title.x = 0.5 * stage.stageWidth;
      m_title.y = 10.0;
      addChild(m_title);
      
      m_frequencyText = new TextField();
      m_frequencyText.autoSize = TextFieldAutoSize.CENTER;
      m_frequencyText.x = 0.5 * stage.stageWidth;
      m_frequencyText.y = 30.0;
      addChild(m_frequencyText);
      
      var subtitleFormat:TextFormat = new TextFormat();
      subtitleFormat.size = 12.0;
      subtitleFormat.font = "arial";
      subtitleFormat.bold = true;
      subtitleFormat.align = TextFormatAlign.CENTER;
      
      var subtitle0:TextField = new TextField();
      subtitle0.autoSize = TextFieldAutoSize.CENTER;
      subtitle0.x = m_demo0.x;
      subtitle0.y = stage.stageHeight - 25.0;
      subtitle0.text = "Debug: On";
      addChild(subtitle0);
      subtitle0.setTextFormat(subtitleFormat);
      
      var subtitle1:TextField = new TextField();
      subtitle1.autoSize = TextFieldAutoSize.CENTER;
      subtitle1.x = m_demo1.x;
      subtitle1.y = stage.stageHeight - 25.0;
      subtitle1.text = "Debug: Off";
      addChild(subtitle1);
      subtitle1.setTextFormat(subtitleFormat);
      
      stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownMode);
      stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownFrequency);
      
      var e:KeyboardEvent = new KeyboardEvent(KeyboardEvent.KEY_DOWN);
      e.keyCode = Keyboard.NUMBER_1; onKeyDownMode(e);
      e.keyCode = Keyboard.MINUS;    onKeyDownFrequency(e);
    }
    
    private function onKeyDownMode(e:KeyboardEvent):void 
    {
      var updateAll:Boolean;
      var syncInput:Boolean;
      var syncOutput:Boolean;
      switch (e.keyCode)
      {
        case Keyboard.NUMBER_1: updateAll =  true; syncInput =  true; syncOutput =  true; m_title.text = "Update All";                 break;
        case Keyboard.NUMBER_2: updateAll = false; syncInput = false; syncOutput = false; m_title.text = "Async Input / Async Output"; break;
        case Keyboard.NUMBER_3: updateAll = false; syncInput =  true; syncOutput = false; m_title.text = "Sync Input / Async Output";  break;
        case Keyboard.NUMBER_4: updateAll = false; syncInput =  true; syncOutput =  true; m_title.text = "Sync Input / Sync Output";    break;
        case Keyboard.NUMBER_5: updateAll = false; syncInput = false; syncOutput =  true; m_title.text = "Async Input / Sync Output";  break;
        default: return;
      }
      m_demo0.setMode(updateAll, syncInput, syncOutput);
      m_demo1.setMode(updateAll, syncInput, syncOutput);
      
      var titleFormat:TextFormat = new TextFormat();
      titleFormat.size = 14.0;
      titleFormat.font = "arial";
      titleFormat.bold = true;
      titleFormat.align = TextFormatAlign.CENTER;
      m_title.setTextFormat(titleFormat);
      
      m_frequencyText.visible = !updateAll;
    }
    
    private function onKeyDownFrequency(e:KeyboardEvent):void 
    {
      var framesPerUpdate:uint;
      switch (e.keyCode)
      {
        case Keyboard.EQUAL: framesPerUpdate = 1; m_frequencyText.text = "30Hz"; break;
        case Keyboard.MINUS: framesPerUpdate = 3; m_frequencyText.text = "10Hz"; break;
        default: return;
      }
      m_demo0.setFramersPerUpdate(framesPerUpdate);
      m_demo1.setFramersPerUpdate(framesPerUpdate);
      
      var frequencyFormat:TextFormat = new TextFormat();
      frequencyFormat.size = 12.0;
      frequencyFormat.font = "arial";
      frequencyFormat.bold = true;
      frequencyFormat.align = TextFormatAlign.CENTER;
      m_frequencyText.setTextFormat(frequencyFormat);
    }
  }
}
