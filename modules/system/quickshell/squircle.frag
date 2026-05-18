#version 440
layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    float width;
    float height;
    float cornerRadius;
    float strokeWidth;
    vec4 fillColor;
    vec4 strokeColor;
} ubuf;

float squircleSDF(vec2 p, vec2 size, float r) {
    vec2 q = abs(p) - size + vec2(r);
    vec2 cornerSpace = max(q, 0.0);
    
    float p_norm = pow(cornerSpace.x, 4.5) + pow(cornerSpace.y, 4.5);
    float cornerDist = pow(p_norm, 1.0 / 4.5);
    
    return cornerDist + min(max(q.x, q.y), 0.0) - r;
}

void main() {
    vec2 halfSize = vec2(ubuf.width, ubuf.height) * 0.5;
    vec2 p = (qt_TexCoord0 * vec2(ubuf.width, ubuf.height)) - halfSize;
    
    // Applied the scaling factor mentioned in the original comment
    float r = ubuf.cornerRadius * 1.5286;
    
    float dist = squircleSDF(p, halfSize, r);
    float fwidth_dist = fwidth(dist);
    
    // Corrected edge parameter order to avoid undefined behavior
    float alpha = 1.0 - smoothstep(-fwidth_dist, fwidth_dist, dist);
    
    if (ubuf.strokeWidth > 0.0) {
        float innerDist = dist + ubuf.strokeWidth;
        float innerAlpha = 1.0 - smoothstep(-fwidth_dist, fwidth_dist, innerDist);
        vec4 color = mix(ubuf.strokeColor, ubuf.fillColor, innerAlpha);
        fragColor = color * alpha * ubuf.qt_Opacity;
    } else {
        fragColor = ubuf.fillColor * alpha * ubuf.qt_Opacity;
    }
}
