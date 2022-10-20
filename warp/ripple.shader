// 转置
#iChannel0 "file://yy.jpg"            
#iUniform float uRadius = 0.0 in {0.0, 1.0}
#iUniform vec2 uCenter = vec2(0.0, 50.0) in {0.0, 100.0}
#iUniform int uType = 1 in {1, 2}
#iUniform float uWidth = 10.0 in {0.01, 100.0}
#iUniform float uHeight = 10.0 in {0.0, 100.0}

float create_ripple(vec2 coord, vec2 ripple_coord, float scale, float radius, float phase) {
    float dist = distance(coord, ripple_coord);
    return sin(dist/scale + phase) * smoothstep(radius, 0.0, dist);
}

vec2 get_normals_asyn(vec2 coord, vec2 ripple_coord, float scale, float radius, float phase) {
    return vec2(
        create_ripple(coord, ripple_coord, scale, radius, phase),
        -create_ripple(coord, ripple_coord, scale, radius, phase)
    ) * 0.25;
}

void main() {
    vec2 uSize = iResolution.xy;
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
    float diag = length(uSize);//

    vec2 normals = vec2(0);
    normals = get_normals_asyn(uv*uSize, uCenter, uWidth, diag*uRadius, 0.0) * uHeight;

    uv+=normals/uSize.xy;
    if(uv==clamp(uv,0.,1.)){
        gl_FragColor = texture2D(iChannel0, uv);
    }else {
        gl_FragColor = vec4(0);
    }
}