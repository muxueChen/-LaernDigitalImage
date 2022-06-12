#iChannel0 "file://DualBlur1.shader"

vec4 dualDown() {
    vec2 uv = gl_FragCoord.xy / iResolution.xy;
    vec2 halfpixel = 0.5 / iResolution.xy;
    float offset = 3.0;
    vec4 sum = texture2D(iChannel0, uv) * 4.0;
    sum += texture2D(iChannel0, uv - halfpixel.xy * offset);
    sum += texture2D(iChannel0, uv + halfpixel.xy * offset);
    sum += texture2D(iChannel0, uv + vec2(halfpixel.x, -halfpixel.y) * offset);
    sum += texture2D(iChannel0, uv - vec2(halfpixel.x, -halfpixel.y) * offset);
    return sum / 8.0;
}

void main() {
    gl_FragColor = dualDown();
}