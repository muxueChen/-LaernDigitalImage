
#define TMIN 0.1
#define TMAX 20.
#define PRECISION .001
#define RAYMARCH_TIME 128
#define AA 3

vec2 fixUV(vec2 uv) {
    return (2. * uv - iResolution.xy)/min(iResolution.x, iResolution.y);
}

//  空间中点到物体表面的距离-球形
float sdfSphere(vec3 p) {
    return length(p - vec3(0.0, 0.0, 2.0)) - 1.5;
}

// rayMarch 技术
float rayMarch(vec3 ro, vec3 rd) {
    float t = TMIN;
    for (int i = 0; i < RAYMARCH_TIME && t < TMAX; i++) {
        vec3 p = ro + t *rd;
        float d = sdfSphere(p);
        if (d < PRECISION) {
            break;
        }
        t += d;
    }
    return t;
}

// 计算法向量
vec3 calcNormal(vec3 p) {
    const float h = 0.0001;
    const vec2 k = vec2(1.0, -1.0);
    return normalize(k.xyy*sdfSphere(p + k.xyy*h) + 
                     k.yyx*sdfSphere(p + k.yyx*h) + 
                     k.yxy*sdfSphere(p + k.yxy*h) +
                     k.xxx*sdfSphere(p + k.xxx*h));
}

vec3 render(vec2 uv) {
    vec3 color = vec3(0.0);
    vec3 ro = vec3(0.0, 0.0, -1.5);
    vec3 rd = normalize(vec3(uv, 0.0) - ro);
    float t = rayMarch(ro, rd);
    if(t < TMAX) {
        vec3 p = ro + t * rd;
        vec3 n = calcNormal(p);
        vec3 light = vec3(2. * cos(iTime), 1., 2. * sin(iTime));
        float dif = clamp(dot(normalize(light - p), n), 0.0, 1.0);
        float amb = 0.5 + 0.5 *dot(n, vec3(0.0, 1.0, 0.0));

        color = amb *vec3(0.25, 0.25, 0.25) + dif*vec3(1.);
    }
    return sqrt(color);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec3 color = vec3(0.0);
    for (int m = 0; m < AA; m++) {
        for (int n = 0; n < AA; n++) {
            vec2 offset = 2. * (vec2(float(m), float(n))/float(AA) - 0.5);
            vec2 uv = fixUV(fragCoord + offset);
            color += render(uv);
        }
    }
    color /= float(AA * AA);
    fragColor = vec4(color, 1.0);
}