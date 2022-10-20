#iChannel0 "file://yy.jpg"

// 随机函数
float random(in vec2 st) {
    return fract(sin(dot(st.xy *iTime,
                         vec2(12.9898,78.233)))
                 * 43758.5453123);
}

void main() {
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
    vec2 temp_uv = ceil(uv*8.0);
    float displace = random(temp_uv);
    displace = pow(displace, 8.0) * pow(displace, 3.0);

    float r= texture2D(iChannel0, uv).r;
    temp_uv = vec2(uv.x + displace * 0.05, uv.y);
    float g = texture2D(iChannel0, temp_uv).g;
    temp_uv = vec2(uv.x - displace * 0.05, uv.y);
    float b = texture2D(iChannel0, temp_uv).b;
    gl_FragColor = vec4(r, g, b, 1.0);
}