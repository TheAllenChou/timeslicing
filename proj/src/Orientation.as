package 
{
  import flash.display.Shape;

  public class Orientation extends Shape 
  {
    public function Orientation(color:uint) 
    {
      graphics.beginFill(color);
      graphics.moveTo(0.0, -6.0);
      graphics.lineTo(30.0, 0.0);
      graphics.lineTo(0.0, 6.0);
      graphics.lineTo(-6.0, 0.0);
      graphics.endFill();
    }
  }
}
