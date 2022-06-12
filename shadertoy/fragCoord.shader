
vec3 Grid(vec2 uv) {
    vec3 col = vec3(0.0);
    vec2 cell  = 1.0 - 2. * abs(fract(uv) - 0.5);
    col = vec3(smoothstep(4. * fwidth(uv.x), 3.95 * fwidth(uv.x), cell.x));
    col += vec3(smoothstep(4. * fwidth(uv.y), 3.95 * fwidth(uv.y), cell.y));
    col.rb *= smoothstep(1.9 *fwidth(uv.x), 2. *fwidth(uv.x), abs(uv.x));
    col.gb *= smoothstep(1.9 *fwidth(uv.y), 2. *fwidth(uv.y), abs(uv.y));
    return col;
}

float segment(vec2 p, vec2 a, vec2 b, float w) {
    vec2 ba = b - a;
    vec2 pa = p - a;
    float proj = clamp(dot(pa, ba)/dot(ba, ba), 0.0, 1.0);
    float d  = length(proj * ba - pa);
    float f = 0.;
    if (d<=w) {
        f = 1.;
    }
    f = smoothstep(w, 0.95 * w, d);
    return f;
}
#define PI 3.14159265
vec2 fixUV(vec2 uv) {
    return 3. * (2.0 * uv - iResolution.xy)/min(iResolution.x, iResolution.y);
}

float func(float x) {
    float T = 4. + 2. * cos(iTime);
    return sin(2. * PI / T * x);
}

float plotFunc(vec2 uv) {
    float f = func(uv.x);
    return smoothstep(f - 0.01, f + 0.01, uv.y);
}

#define AA 4

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fixUV(fragCoord);
    vec3 col = Grid(uv);
    float count  = 0.0;
    for (int m = 0; m < AA; m++) {
        for (int n = 0; n < AA; n ++) {
            vec2 Offset  = (vec2(float(m), float(n) - 0.5 * float(AA)))/float(AA)*2.;
            count += plotFunc(fixUV(fragCoord + Offset));
        }
    }
    if (count > float(count * count)/2.) {
        count = float(AA*AA) - count;
    }
    // count
    col = vec3(plotFunc(uv));
    fragColor = vec4(col, 1.0);

}