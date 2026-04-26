#version 450

// Mandatory precision for float operations
precision mediump float;

// 1. Inputs from the Vertex Shader
layout(location = 0) in vec4 u_color; // Assuming color is passed as a vertex attribute or vary
layout(location = 1) in vec2 v_texCoord;

// 2. Uniforms (The Texture)
layout(binding = 0) uniform sampler2D u_texture;

// 3. Output to the Screen
layout(location = 0) out vec4 outColor;

void main() {
    // Sample the distance from the alpha channel
    float dist = texture(u_texture, v_texCoord).a;

    // Threshold the value
    // 0.5 is the middle of the distance field.
    // smoothstep creates the sharp, anti-aliased edge.
    float alpha = smoothstep(0.45, 0.55, dist);

    // Output final color
    outColor = vec4(u_color.rgb, alpha * u_color.a);
}
