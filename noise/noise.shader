
void main() {
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
    uv=uv*2.0-1.0;
    uv.y *= 2.0;
    float x = radians(uv.x *360.0);
    float y = fract(sin(x*1.0)*1.0);
    float color = smoothstep(y-0.04, y-0.02, uv.y) - smoothstep(y+0.02, y+0.04, uv.y);
    gl_FragColor = vec4(vec3(color), 1.0);
}