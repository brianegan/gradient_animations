# gradient_animation

An example project demonstrating how to animate gradients!

<img align="right" src="demo.gif" alt="Image demonstrating the gradient animations">

## Getting Started

Run the app as you normally do with Flutter!

## Key Concepts

### Animations with ScrollController

  1. Define a begin and end gradient
  2. Every time the user scrolls, calculate how far down the list we are from 0.0 (top) - 1.0 (bottom) 
  3. Use `beginGradient.lerpTo(endGradient, 0.7)`

### Animations with Tweens

  1. Implement a Tween class, using static the `lerp` methods provide by the `LinearGradient` class.
  2. Create an `Animation<LinearGradient>` from the Tween using an `AnimationController`: `final animation = tween.animate(controller);`
  3. Redraw the gradient animation every time it changes using an `AnimatedBuilder`
  4. Provide a button to trigger the animation forward / backward
