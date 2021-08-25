
void main() {
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
        vec3 color = vec3(0.0);
    vec2 bl = smoothstep(vec2(0.1, 0.1), vec2(0.2, 0.2), uv) - smoothstep(vec2(0.8, 0.8), vec2(0.9, 0.9), uv);
    bl = step(vec2(0.1),bl);
    float pct = bl.x * bl.y;
    color = vec3(step(0.1,pct));
    gl_FragColor = vec4(color, 1.0);
}