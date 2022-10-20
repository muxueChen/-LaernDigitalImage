#iChannel0 "file://test.png"

#iUniform float uRadius = 10.0 in {0.0, 10.0}

float LookUp(vec2 p, vec2 offset) {
    vec2 uv = p + offset / iResolution.xy * uRadius;
    vec4 col = texture2D(iChannel0, uv);
    return col.a;
}
                                                
void main() {
    vec2 vTexCoord = gl_FragCoord.xy/iResolution.xy;

    float tl = LookUp(vTexCoord, vec2(-1.0, 1.0));
    float tc = LookUp(vTexCoord, vec2(0.0, 1.0));
    float tr = LookUp(vTexCoord, vec2(1.0, 1.0));
    
    float l = LookUp(vTexCoord, vec2(-1.0, 0.0));
    float r = LookUp(vTexCoord, vec2(1.0, 0.0));
    
    float bl = LookUp(vTexCoord, vec2(-1.0, -1.0));
    float bc = LookUp(vTexCoord, vec2(0.0, -1.0));
    float br = LookUp(vTexCoord, vec2(1.0, -1.0));
    
    float gx = tl - tr + 2.0 * l - 2.0 * r + bl - br;
    float gy = -tl - 2.0 * tc - tr + bl + 2.0 * bc + br;
    float gradient = abs(gx) + abs(gy);
    
    vec4 outColor = step(0.01, gradient) * vec4(1.0);
    outColor.a = clamp(gradient, 0., 1.);
    vec4 tex = texture2D(iChannel0, vTexCoord);
    tex.rgb *= tex.a;
    gl_FragColor = outColor * (1.0 -tex.a) + vec4(tex.a);
}