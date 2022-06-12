void main() {
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
    
    float y = smoothstep(0.2, 0.3, length(uv-0.5)) - smoothstep(0.3, 0.4, length(uv-0.5));
    gl_FragColor = vec4(y);
}