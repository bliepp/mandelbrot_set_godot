# Mandelbrot Set (Godot Engine)
A fast shader to visualize the mandelbrot set written in the Godot Shader Language.

It basically consists of an ColorRect with a shader applied to it. Since Godot shaders until now only support single precision floats (no doubles) the zoom comes to an end very quickly. Nevertheless it is a pretty fast implementation due to the GPU support of the shader.
