import { Canvas } from '@react-three/fiber'
import { Experience } from './components/Experience'
import { Interface } from './components/Interface'
import { AudioEngine } from './systems/AudioEngine'
import { useSymphonyStore } from './stores/symphonyStore'

function App() {
  const { audioEnabled } = useSymphonyStore()

  return (
    <div style={{ width: '100vw', height: '100vh', background: 'black' }}>
      <Canvas
        camera={{ position: [0, 0, 8], fov: 60 }}
        gl={{ 
          antialias: true,
          alpha: true,
          powerPreference: "high-performance"
        }}
        dpr={[1, 2]}
      >
        <Experience />
      </Canvas>
      
      <Interface />
      {audioEnabled && <AudioEngine />}
    </div>
  )
}

export default App
