void main() {
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
        vec3 color = vec3(0.0);
    vec2 bl = step(vec2(0.1, 0.2), uv);
    float pct = bl.x * bl.y;
    
    vec2 tr = step(vec2(0.1, 0.2), 1.0 - uv);
    pct *= tr.x * tr.y;
    color = vec3(pct);
    gl_FragColor = vec4(color, 1.0);
}