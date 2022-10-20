#iChannel0 "file://test.png"
#iUniform float uRaidus = 5.0 in {1.0, 100.0}

float getDist(vec2 originUV, vec2 pixles, float flag) {
    vec2 tempUV = clamp(originUV + pixles, 0.0, 1.0);
    float a = texture(iChannel0, tempUV).a;
    if(flag > 0.001) {
        a = 1.0 - a;
    }
    if (a > 0.0) {
        return length(pixles);
    }
    return 1.0;
} 

void main() {
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
    vec2 pixleSize = 1.0/iResolution.xy;
    float flag = texture(iChannel0, uv).a;
    float dist = getDist(uv, vec2(0.0), flag);
    for (float i = 1.0; i < uRaidus; i += 6.0) {
        vec2 offset = pixleSize*i;
        vec2 uv1 = vec2(0.0, 1.0) * offset;
        vec2 uv2 = vec2(0.0, -1.0) * offset;
        vec2 uv3 = vec2(1.0, 0.0) * offset;
        vec2 uv4 = vec2(-1.0, 0.0) * offset;
        vec2 uv5 = vec2(1.0, 1.0) * offset;
        vec2 uv6 = vec2(1.0, -1.0) * offset;
        vec2 uv7 = vec2(-1.0, 1.0) * offset;
        vec2 uv8 = vec2(-1.0, -1.0) * offset;
        dist = min(dist, getDist(uv, uv1, flag));
        dist = min(dist, getDist(uv, uv2, flag));
        dist = min(dist, getDist(uv, uv3, flag));
        dist = min(dist, getDist(uv, uv4, flag));
        dist = min(dist, getDist(uv, uv5, flag));
        dist = min(dist, getDist(uv, uv6, flag));
        dist = min(dist, getDist(uv, uv7, flag));
        dist = min(dist, getDist(uv, uv8, flag));
    }
    float maxLength = length(pixleSize*(uRaidus-5.0));
    float sdf = smoothstep(maxLength, 0.0, dist);
    gl_FragColor = vec4(sdf);
}