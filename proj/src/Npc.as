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
    private var m_targetPos:Point;
    
    public function Npc()
    {
      m_desiredOrientation = new Orientation(kDesiredOrientationColor);
      addChild(m_desiredOrientation);
      
      m_currentOrietation = new Orientation(kCurrentOrientationColor);
      addChild(m_currentOrietation);
      
      m_targetPos = new Point();
    }
    
    public function setDesiredOrientationVisible(value:Boolean):void
    {
      m_desiredOrientation.visible = value;
    }
    
    public function updateDesiredOrientation(target:Object):void
    {
      const dx:Number = target.x - x;
      const dy:Number = target.y - y;
      const angleRad:Number = Math.atan2(dy, dx);
      const angleDeg:Number = angleRad * 180.0 / Math.PI;
      
      m_desiredOrientation.rotation = angleDeg;
      m_targetPos.x = target.x;
      m_targetPos.y = target.y;
      
      graphics.clear();
      if (m_desiredOrientation.visible)
      {
        graphics.lineStyle(0, kDesiredOrientationColor);
        graphics.moveTo(0.0, 0.0);
        graphics.lineTo(target.x - x, target.y - y);
      }
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
      
      const maxRotSpeed:Number = 50.0 * dt;
      const cappedDelta:Number = Math.max(Math.min(delta, maxRotSpeed), -maxRotSpeed);
      
      m_currentOrietation.rotation = m_currentOrietation.rotation + cappedDelta;
    }
  }
}
