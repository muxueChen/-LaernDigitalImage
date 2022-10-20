#iChannel0 "file://background.jpg"
#iChannel1 "file://front.png"
#iChannel2 "file://planet.png"

// 正常
vec4 blend_normal(vec4 A, vec4 B) {
    if (A.a == 0.0){
        return B;
    }
    if (B.a == 0.0) {
        return A;
    }
    vec4 dst;
    dst.rgb = B.rgb * B.a + A.rgb * (1.0 - B.a);
    dst.a = B.a + A.a - B.a * A.a;
    return dst;
}

// 正片叠底
vec4 blend_multiply(vec4 A, vec4 B) {
    if (A.a == 0.0){
        return B;
    }
    if (B.a == 0.0) {
        return A;
    }
    return vec4(A.rgb * B.rgb, max(A.a, B.b));
}

// 颜色加深
vec4 blend_ColorBurn(vec4 A, vec4 B) {
    if (A.a == 0.0){
        return B;
    }
    if (B.a == 0.0) {
        return A;
    }
    vec4 dst;
    dst.rgb = (A.rgb + B.rgb - 1.0)/B.rgb;
    dst.rgb = clamp(dst.rgb, 0.0, 1.0);
    dst.a = B.a + A.a - B.a * A.a;

    return dst;
}

// 线性加深
vec4 blend_LinerBurn(vec4 A, vec4 B) {
    if (A.a == 0.0){
        return B;
    }
    if (B.a == 0.0) {
        return A;
    }
    vec4 dst;
    dst.rgb = (A.rgb + B.rgb - 1.0);
    dst.rgb = clamp(dst.rgb, 0.0, 1.0);
    dst.a = B.a + A.a - B.a * A.a;

    return dst;
}

// 深色
vec4 blend_DarkerColor(vec4 A, vec4 B) {
    if (A.a == 0.0){
        return B;
    }
    if (B.a == 0.0) {
        return A;
    }
    vec4 dst;
    dst.rgb = max(A.rgb, B.rgb);
    dst.a = B.a + A.a - B.a * A.a;

    return dst;
}

vec4 blend_Lighten(vec4 A, vec4 B) {
    if (A.a == 0.0){
        return B;
    }
    if (B.a == 0.0) {
        return A;
    }
    vec4 dst;
    dst.rgb = max(A.rgb, B.rgb);
    dst.a = B.a + A.a - B.a * A.a;

    return dst;
}

//  滤色
vec4 blend_Screen(vec4 A, vec4 B) {
    if (A.a == 0.0){
        return B;
    }
    if (B.a == 0.0) {
        return A;
    }
    vec4 dst;
    dst.rgb = vec3(1.0) - (1.0-A.rgb)*(1.0-B.rgb);
    dst.a = B.a + A.a - B.a * A.a;
    return dst;
}

vec4 blend_ColorDodge(vec4 A, vec4 B) {
    if (A.a == 0.0){
        return B;
    }
    if (B.a == 0.0) {
        return A;
    }
    vec4 dst;
    dst.rgb = A.rgb + (A.rgb*B.rgb)/(1.0 - B.rgb);
    dst.a = B.a + A.a - B.a * A.a;
    return dst;
}

vec4 blend_LinearDodge(vec4 A, vec4 B) {
    if (A.a == 0.0){
        return B;
    }
    if (B.a == 0.0) {
        return A;
    }
    vec4 dst;
    dst.rgb = A.rgb + B.rgb;
    dst.rgb = clamp(dst.rgb, 0.0, 1.0);
    dst.a = B.a + A.a - B.a * A.a;
    return dst;
}

vec4 blend_Overlay(vec4 A, vec4 B) {
    if (A.a == 0.0){
        return B;
    }
    if (B.a == 0.0) {
        return A;
    }
    vec4 dst;
    dst.rgb = A.rgb + B.rgb;
    dst.rgb = clamp(dst.rgb, 0.0, 1.0);
    dst.a = B.a + A.a - B.a * A.a;
    return dst;
}

void main() {
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
    vec4 A = texture2D(iChannel0, uv);
    vec4 B = texture2D(iChannel1, uv);
    gl_FragColor = blend_Overlay(A, B);
}