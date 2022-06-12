#iChannel0 "file://DualBlur3.shader"

vec4 dualUpload() {
    vec2 uv = gl_FragCoord.xy / iResolution.xy;
    vec2 halfpixel = 0.5 / (iResolution.xy * 2.0);
    float offset = 3.0;
    vec4 sum = texture(iChannel0, uv +vec2(-halfpixel.x * 2.0, 0.0) * offset);
    sum += texture(iChannel0, uv + vec2(-halfpixel.x, halfpixel.y) * offset) * 2.0;
    sum += texture(iChannel0, uv + vec2(0.0, halfpixel.y * 2.0) * offset);
    sum += texture(iChannel0, uv + vec2(halfpixel.x, halfpixel.y) * offset) * 2.0;
    sum += texture(iChannel0, uv + vec2(halfpixel.x * 2.0, 0.0) * offset);
    sum += texture(iChannel0, uv + vec2(halfpixel.x, -halfpixel.y) * offset) * 2.0;
    sum += texture(iChannel0, uv + vec2(0.0, -halfpixel.y * 2.0) * offset);
    sum += texture(iChannel0, uv + vec2(-halfpixel.x, -halfpixel.y) * offset) * 2.0;

    return sum / 12.0;
}

void main() {
    gl_FragColor = dualUpload();
}