package 
{
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.geom.Point;

  public class Demo extends Sprite 
  {
    private const kNumNpcs:uint = 10;
    private const kPeriod:Number = 3.0;
    private const kTitleSize:Number = 14.0;
    
    private var m_size:Number;
    private var m_target:Target;
    private var m_aNpc:Vector.<Npc>;
    
    private var m_updateAll:Boolean;
    private var m_syncInput:Boolean;
    private var m_syncOutput:Boolean;
    
    private var m_maxBatchSize:uint;
    private var m_batchSize:uint;
    private var m_iJobParamsBegin:uint;
    private var m_iJobParamsEnd:uint;
    private var m_aJobParams:Vector.<JobParams>;
    private var m_iNextJobResults:uint;
    private var m_jobResultsRingBuffer:Vector.<JobResults>;
    
    private var m_framesPerUpdate:uint;
    
    public function Demo(size:Number, showDesiredOritation:Boolean)
    {
      m_size = size;
      
      var i:uint;
      
      const radius:Number = 0.45 * m_size;
      m_aNpc = new Vector.<Npc>(kNumNpcs, true);
      for (i = 0; i < kNumNpcs; ++i)
      {
        var npc:Npc = new Npc();
        
        const theta:Number = ((i + 0.5) * 2.0 * Math.PI / kNumNpcs);
        npc.x = radius * Math.cos(theta);
        npc.y = radius * Math.sin(theta);
        npc.setDesiredOrientationVisible(showDesiredOritation);
        npc.setToDesiredOrientation();
        
        m_aNpc[i] = npc;
        addChild(npc);
      }
      
      m_target = new Target();
      addChild(m_target);
      
      m_maxBatchSize = 2 * kNumNpcs;
      m_aJobParams = new Vector.<JobParams>(kNumNpcs, true);
      m_jobResultsRingBuffer = new Vector.<JobResults>(m_maxBatchSize, true);
      
      setMode(true, true, true);
      setFramersPerUpdate(1);
      
      addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }
    
    private function onAddedToStage(e:Event):void 
    {
      removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
      stage.addEventListener(Event.ENTER_FRAME, updateFrame);
    }
    
    private var m_frameCounter:uint = 0;
    private var m_timer:Number = 0.0;
    private function updateFrame(e:Event):void
    {
      const dt:Number = 1.0 / stage.frameRate;
      m_timer += dt;
      
      updateTarget(dt);
      
      if (m_updateAll || (m_frameCounter++ % m_framesPerUpdate) == 0)
      {
        updateJobs(dt);
        queryJobResults(dt);
      }
      
      animateNpcs(dt);
    }
    
    public function reset():void
    {
      m_batchSize = 0;
      m_iJobParamsBegin = 0;
      m_iJobParamsEnd = 0;
      m_iNextJobResults = 0;
      m_timer = 0.0;
      m_frameCounter = 0;
      
      for (var i:uint = 0; i < kNumNpcs; ++i)
      {
        var npc:Npc = m_aNpc[i];
        var jobParams:JobParams = new JobParams();
        jobParams.m_key = npc;
        jobParams.m_input = new Input();
        setupInput(jobParams);
        doJob(jobParams);
        var output:Output = jobParams.m_output;
        npc.setDesiredOrientationValue(output.m_rotation, output.m_target);
        npc.setToDesiredOrientation();
      }
    }
    
    public function setUpdateAll(updateAll:Boolean):void
    {
      m_updateAll = updateAll;
    }
    
    public function setMode(updateAll:Boolean, syncInput:Boolean = true, syncOutput:Boolean = false):void
    {
      m_updateAll = updateAll;
      m_syncInput = syncInput;
      m_syncOutput = syncOutput;
      reset();
    }
    
    public function setFramersPerUpdate(value:uint):void
    {
      m_framesPerUpdate = Math.max(1, value);
      reset();
    }
    
    private function setupNewBatch():uint
    {
      m_batchSize = 0;
      m_iJobParamsBegin = 0;
      m_iJobParamsEnd = 0;
      
      for (var i:uint = 0; i < kNumNpcs; ++i)
      {
        var npc:Npc = m_aNpc[i];
        var jobParams:JobParams = new JobParams();
        jobParams.m_key = npc;
      }
      
      return kNumNpcs;
    }
    
    private function setupInput(jobParams:JobParams):void
    {
      var input:Input = new Input();
      input.m_target = new Point(m_target.x, m_target.y);
      
      jobParams.m_input = input;
    }
    
    private function doJob(jobParams:JobParams):void
    {
      var npc:Npc = jobParams.m_key;
      var input:Input = jobParams.m_input;
      
      const dx:Number = input.m_target.x - npc.x;
      const dy:Number = input.m_target.y - npc.y;
      const angleRad:Number = Math.atan2(dy, dx);
      const angleDeg:Number = angleRad * 180.0 / Math.PI;
      
      var output:Output = new Output();
      output.m_target = input.m_target;
      output.m_rotation = angleDeg;
      jobParams.m_output= output;
    }
    
    private function getOutput(key:*):Output
    {
      var i:int = m_iNextJobResults - 1;
      if (i < 0)
        i += m_jobResultsRingBuffer.length;
      
      do
      {
        var jobResults:JobResults = m_jobResultsRingBuffer[i];
        if (!jobResults)
          return null;
          
        if (key == jobResults.m_key)
        {
          return jobResults.m_output;
        }
        
        if (--i < 0)
        {
          i += m_jobResultsRingBuffer.length;
        }
      } while (i != m_iNextJobResults);
      return null;
    }
    
    private function saveResults(jobParams:JobParams):void
    {
      var jobResults:JobResults = m_jobResultsRingBuffer[m_iNextJobResults] = new JobResults();
      jobResults.m_key = jobParams.m_key;
      jobResults.m_output = jobParams.m_output;
      m_iNextJobResults = (m_iNextJobResults + 1) % m_maxBatchSize;
    }
    
    private function updateTarget(dt:Number):void
    {
      const radius:Number = 0.2 * m_size;
      const theta:Number = (-m_timer - 0.5 * kPeriod) * 2.0 * Math.PI / kPeriod;
      m_target.x = radius * Math.sin(theta);
      m_target.y = radius * Math.cos(theta);
    }
    
    private function updateJobs(dt:Number):void
    {
      var i:uint;
      var npc:Npc;
      var input:Input;
      var output:Output;
      var jobParams:JobParams;
      var jobResults:JobResults;
      
      if (m_updateAll)
      {
        for (i = 0; i < kNumNpcs; ++i)
        {
          npc = m_aNpc[i];
          
          jobParams = new JobParams();
          jobParams.m_key = npc;
          jobParams.m_input = new Input();
          setupInput(jobParams);
          doJob(jobParams);
          saveResults(jobParams);
        }
      }
      else
      {
        // start new batch?
        if (m_iJobParamsBegin == m_batchSize)
        {
          if (m_syncOutput)
          {
            for (i = 0; i < m_batchSize; ++i)
            {
              saveResults(m_aJobParams[i]);
            }
          }
          
          m_batchSize = setupNewBatch();
          
          for (i = 0; i < kNumNpcs; ++i)
          {
            npc = m_aNpc[i];
            jobParams = m_aJobParams[i] = new JobParams();
            jobParams.m_key = npc;
            
            if (m_syncInput)
            {
              setupInput(jobParams);
            }
          }
        }
        
        // start jobs
        const kNumJobsPerUpdate:uint = 1;
        var numJobsStarted:uint = 0;
        while (m_iJobParamsEnd < m_batchSize && numJobsStarted < kNumJobsPerUpdate)
        {
          if (!m_syncInput)
          {
            jobParams = m_aJobParams[m_iJobParamsEnd];
            setupInput(jobParams);
          }
          
          ++m_iJobParamsEnd;
          ++numJobsStarted;
        }
        
        // do jobs
        for (i = m_iJobParamsBegin; i < m_iJobParamsEnd; ++i)
        {
          jobParams = m_aJobParams[i];
          doJob(jobParams);
        }
        
        // finish jobs
        while (m_iJobParamsBegin < m_iJobParamsEnd)
        {
          jobParams = m_aJobParams[m_iJobParamsBegin++];
          
          if (!m_syncOutput)
          {
            saveResults(jobParams);
          }
        }
      }
    }
    
    private function queryJobResults(dt:Number):void
    {
      for (var i:uint = 0; i < kNumNpcs; ++i)
      {
        var npc:Npc = m_aNpc[i];
        var output:Output = getOutput(npc);
        if (!output)
          continue;
        
        npc.setDesiredOrientationValue(output.m_rotation, output.m_target);
      }
    }
    
    private function animateNpcs(dt:Number):void
    {
      for (var i:uint = 0; i < kNumNpcs; ++i)
      {
        var npc:Npc = m_aNpc[i];
        npc.animate(dt);
      }
    }
  }
}
