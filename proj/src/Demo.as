package 
{
  import flash.display.Shape;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.geom.Point;
  import flash.utils.getTimer;

  public class Demo extends Sprite 
  {
    private const kNumNpcs:uint = 12;
    private const kPeriod:Number = 5.0;
    
    private var m_size:Number;
    private var m_target:Target;
    private var m_aNpc:Vector.<Npc>;
    
    public function Demo(size:Number, showDesiredOritation:Boolean)
    {
      m_size = size;
      
      const radius:Number = 0.45 * m_size;
      m_aNpc = new Vector.<Npc>(kNumNpcs, true);
      for (var i:uint = 0; i < kNumNpcs; ++i)
      {
        var npc:Npc = new Npc();
        
        const theta:Number = ((i + 0.5) * 2.0 * Math.PI / kNumNpcs);
        npc.x = radius * Math.cos(theta);
        npc.y = radius * Math.sin(theta);
        npc.setDesiredOrientationVisible(showDesiredOritation);
        npc.updateDesiredOrientation({x:0.0, y:0.0});
        npc.setToDesiredOrientation();
        
        m_aNpc[i] = npc;
        addChild(npc);
      }
      
      m_target = new Target();
      addChild(m_target);
      
      addEventListener(Event.ENTER_FRAME, update);
    }
    
    private var m_timer:Number = 0.0;
    private var m_oldTime:int = 0;
    private function update(e:Event):void
    {
      const curTime:int = getTimer();
      const dt:Number = (curTime - m_oldTime) / 1000.0;
      m_timer += dt;
      
      const radius:Number = 0.2 * m_size;
      const period:Number = 2.0;
      const theta:Number = -m_timer * 2.0 * Math.PI / period;
      m_target.x = radius * Math.sin(theta);
      m_target.y = radius * Math.cos(theta);
      
      for (var i:uint = 0; i < kNumNpcs; ++i)
      {
        var npc:Npc = m_aNpc[i];
        npc.updateDesiredOrientation(m_target);
        npc.animate(dt);
      }
      
      m_oldTime = curTime;
    }
  }
}
