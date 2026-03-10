---
name: game-development
description: "Game architecture, game loops, physics, rendering, input handling, and multi-platform development across Unity, Godot, Unreal, Phaser, and Three.js."
---

# Game Development

> "A game is a series of interesting choices." -- Sid Meier

## When to Use
- Designing or implementing game architecture and systems
- Building game loops, physics simulations, or rendering pipelines
- Handling player input across platforms (keyboard, mouse, gamepad, touch)
- Choosing or working with game engines (Unity, Godot, Unreal, Phaser, Three.js)
- Implementing common game patterns like ECS, state machines, or scene graphs
- Optimizing game performance (frame rate, memory, draw calls)
- Building multiplayer or networked game systems

## Core Architecture Patterns

### The Game Loop
Every game revolves around a loop that processes input, updates state, and renders output. The loop must maintain consistent timing regardless of hardware speed.

**Fixed timestep with interpolation** is the gold standard:
- Physics and game logic run at a fixed rate (e.g., 60 updates/sec)
- Rendering runs as fast as possible, interpolating between states
- This prevents physics glitches on fast or slow hardware

**Key loop structure:**
1. Process input events
2. Accumulate elapsed time
3. Run fixed-step updates until caught up
4. Render with interpolation factor
5. Present frame

### Entity-Component-System (ECS)
Prefer composition over inheritance for game objects:
- **Entities** are just IDs (integers or UUIDs)
- **Components** are pure data (Position, Velocity, Sprite, Health)
- **Systems** operate on entities that have specific component combinations
- ECS gives cache-friendly iteration and easy extensibility
- Unity DOTS, Bevy (Rust), and Godot 4 all support ECS patterns

### Scene Graph and Spatial Organization
- Use hierarchical transforms for parent-child relationships (e.g., weapon attached to character)
- Implement spatial partitioning for collision and rendering: quad-trees (2D), octrees (3D), spatial hashing
- Keep the logical game world separate from the visual representation

## Physics and Collision

### 2D Physics Essentials
- Use AABB (Axis-Aligned Bounding Box) for broad-phase collision
- SAT (Separating Axis Theorem) for precise polygon collision
- Apply forces and impulses, not direct position manipulation
- Always use fixed timestep for physics to avoid tunneling

### 3D Physics
- Leverage engine physics (Unity PhysX, Godot Jolt, Unreal Chaos)
- Raycasting for line-of-sight, ground detection, and projectile traces
- Use collision layers/masks to control which objects interact
- Continuous collision detection (CCD) for fast-moving objects

### Common Pitfalls
- Never move kinematic bodies by setting position directly in physics engines
- Avoid frame-rate-dependent movement (always multiply by delta time)
- Use physics materials for friction/bounce, not custom code
- Separate collision shapes from visual meshes for performance

## Input Handling

### Cross-Platform Input Abstraction
Define actions, not keys:
- Map "Jump" to Spacebar, A-button, and screen-tap
- Support rebinding at runtime
- Handle input buffering for responsive controls (queue inputs for a few frames)

### Input Best Practices
- Process input at the start of the game loop, before updates
- Distinguish between pressed, held, and released states
- Implement dead zones for analog sticks (typically 0.15-0.25)
- Support simultaneous gamepad and keyboard without conflict
- For mobile: handle multi-touch, gestures, and virtual joysticks

## Engine-Specific Guidance

### Unity (C#)
- Use the new Input System package over the legacy Input class
- Prefer ScriptableObjects for game data (items, abilities, configs)
- Use Addressables for asset management in larger projects
- Leverage Unity DOTS/ECS for performance-critical systems (large entity counts)
- Use Cinemachine for camera systems, DOTween/LeanTween for tweening
- Profile with the Unity Profiler; target consistent frame times, not just FPS

### Godot (GDScript / C#)
- Use Godot 4.x with GDScript for rapid prototyping, C# for larger projects
- Leverage the scene-as-prefab model: compose complex objects from sub-scenes
- Use signals for decoupled communication between nodes
- AnimationPlayer and AnimationTree for complex animation state machines
- TileMaps for 2D level design; GridMap for 3D voxel-style levels
- Export variables for designer-friendly inspector controls

### Unreal Engine (C++ / Blueprints)
- Use Blueprints for gameplay logic and rapid iteration, C++ for core systems
- Gameplay Ability System (GAS) for abilities, buffs, and status effects
- Niagara for particle effects, Nanite for high-poly mesh rendering
- Use Data Tables and Data Assets for configuration-driven design
- Leverage Unreal's replication system for multiplayer (RPCs, replicated properties)

### Phaser (JavaScript/TypeScript) - 2D Web Games
- Phaser 3 with TypeScript for type safety and IDE support
- Use Scenes for state management (Menu, Gameplay, Pause, GameOver)
- Arcade Physics for simple games, Matter.js for complex physics
- Use texture atlases to minimize draw calls
- Leverage the Loader for asset preloading with progress bars

### Three.js (JavaScript/TypeScript) - 3D Web
- Use three.js with TypeScript; consider React Three Fiber for React projects
- Implement proper disposal of geometries, materials, and textures to avoid memory leaks
- Use InstancedMesh for many identical objects (trees, particles)
- Leverage post-processing (EffectComposer) for bloom, SSAO, tone mapping
- Use Web Workers for heavy computation off the main thread
- Consider cannon-es or Rapier WASM for physics

## Rendering and Graphics

### Performance Optimization
- **Batching:** Minimize draw calls by combining meshes and using texture atlases
- **LOD (Level of Detail):** Reduce polygon count for distant objects
- **Culling:** Frustum culling, occlusion culling, and backface culling
- **Object pooling:** Reuse bullets, particles, and enemies instead of instantiating/destroying
- **Shader optimization:** Minimize texture lookups, avoid branching in fragment shaders

### Visual Polish
- Screen shake for impacts (use Perlin noise, not random)
- Particle effects for feedback (hit sparks, dust, trails)
- Juice: squash-and-stretch, easing curves, anticipation frames
- Post-processing: bloom, vignette, color grading for mood

## Game State Management
- Use a finite state machine or hierarchical state machine for game flow
- Separate game state (serializable) from runtime state (non-serializable)
- Implement save/load by serializing game state to JSON or binary
- Use command pattern for undo/redo in strategy or puzzle games
- Event buses for decoupled communication between systems

## Multiplayer Considerations
- Choose the right model: authoritative server, peer-to-peer, or relay
- Implement client-side prediction and server reconciliation for responsive feel
- Use interpolation and extrapolation for smooth remote player movement
- Minimize bandwidth: send deltas, use bit packing, compress packets
- Handle latency, packet loss, and disconnections gracefully
- Consider using established networking libraries (Photon, Mirror, Netcode for GameObjects, ENet)

## Testing and Debugging
- Implement an in-game debug console for runtime inspection
- Use replay systems (record input, replay deterministically) for bug reproduction
- Automated playtesting: bots that simulate player behavior
- Visual debugging: draw collision shapes, velocity vectors, pathfinding graphs
- Profile early and often; performance issues compound quickly in games
