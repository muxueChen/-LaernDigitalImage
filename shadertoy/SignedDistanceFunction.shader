
vec2 fixUV(vec2 uv) {
    return 2. * (2.0 * uv - iResolution.xy)/min(iResolution.x, iResolution.y);
}

// 空间距离函数- 圆形
float sdfCircle(vec2 p, float r) {
    return length(p) - r;
}

// 空间距离函数- 矩形
float sdfRect(vec2 p, vec2 b) {
    vec2 d = abs(p) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {

    vec2 uv = fixUV(fragCoord);
    // float d = sdfCircle(uv, 0.7);
    float d = sdfRect(uv, vec2(1. + .2 * sin(iTime), 1.0 + .3 * cos(iTime)));
    
    vec3 color = 1. - sign(d) * vec3(0.4, 0.5, 0.6);
    color *=  1. - exp(-3. * abs(d));// 距离场
    color *= 0.8 + 0.2 * sin(100.0*abs(d));// 等高线
    color = mix(color, vec3(1.), smoothstep(0.005, 0.004, abs(d))); // 距离为0处画一条线

    if (iMouse.z > 0.0) {
        vec2 m = fixUV(iMouse.xy);
        float currentDistance = abs(sdfCircle(m, 0.7));
        color = mix(color, vec3(1., 1., 0.), smoothstep(0.01, 0., abs(length(uv-m) - currentDistance)));
        color = mix(color, vec3(1., 1., 0.), smoothstep(0.02, 0.01, length(uv-m)));
    }
   
    fragColor = vec4(color, 1.0);
}