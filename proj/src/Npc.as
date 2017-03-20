package 
{
  import flash.display.Graphics;
  import flash.display.Sprite;
  import flash.geom.Point;

  public class Npc extends Sprite 
  {
    static private const kDesiredOrientationColor:uint = 0xCC0000;
    static private const kCurrentOrientationColor:uint = 0x000000;
    
    private var m_desiredOrientation:Orientation;
    private var m_currentOrietation:Orientation;
    
    public function Npc()
    {
      m_desiredOrientation = new Orientation(kDesiredOrientationColor);
      addChild(m_desiredOrientation);
      
      m_currentOrietation = new Orientation(kCurrentOrientationColor);
      addChild(m_currentOrietation);
    }
    
    public function setDesiredOrientationVisible(value:Boolean):void
    {
      m_desiredOrientation.visible = value;
    }
    
    public function setDesiredOrientationValue(rotation:Number, debugTarget:Object):void
    {
      m_desiredOrientation.rotation = rotation;
      
      if (!m_desiredOrientation.visible)
        return;
      
      if (!debugTarget)
        return;
        
      graphics.clear();
      graphics.lineStyle(0, kDesiredOrientationColor);
      graphics.moveTo(0.0, 0.0);
      graphics.lineTo(debugTarget.x - x, debugTarget.y - y);
    }
    
    public function setToDesiredOrientation():void
    {
      m_currentOrietation.rotation = m_desiredOrientation.rotation;
    }
    
    public function animate(dt:Number):void
    {
      var delta:Number = m_desiredOrientation.rotation - m_currentOrietation.rotation;
      while (delta > 180.0)
        delta -= 360.0;
       while (delta < -180.0)
        delta += 360.0;
      
      const maxRotSpeed:Number = 25.0 * dt;
      const cappedDelta:Number = Math.max(Math.min(delta, maxRotSpeed), -maxRotSpeed);
      
      m_currentOrietation.rotation = m_currentOrietation.rotation + cappedDelta;
    }
  }
}
