package 
{
  import flash.display.Shape;

  public class Target extends Shape 
  {
    public function Target() 
    {
      graphics.lineStyle(4.0, 0x000000);
      graphics.beginFill(0xCCCCCC);
      graphics.drawCircle(0.0, 0.0, 8.0);
      graphics.endFill();
    }
  }
}
