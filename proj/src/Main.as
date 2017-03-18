package 
{
  import flash.display.Shape;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.geom.Point;
  import flash.utils.getTimer;

  [SWF(width=500, height=250, frameRate=24)]
  public class Main extends Sprite 
  {
    public function Main()
    {
      const size:Number = 0.5 * stage.stageWidth;
      
      var demo0:Demo = new Demo(size, true);
      demo0.x = 0.25 * stage.stageWidth;
      demo0.y = 0.5 * stage.stageHeight;
      addChild(demo0);
      
      var demo1:Demo = new Demo(size, false);
      demo1.x = 0.75 * stage.stageWidth;
      demo1.y = 0.5 * stage.stageHeight;
      addChild(demo1);
    }
  }
}
