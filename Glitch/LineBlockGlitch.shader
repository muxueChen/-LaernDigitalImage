#iChannel0 "file://yy.jpg"

// 随机函数
float random(in vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))
                 * 43758.5453123);
}

float trunc(float x, float num_levels) {
    return floor(x * num_levels)/num_levels;
}

void main() {
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
    float truncTime = trunc(iTime, 4.0);// 截取整数部分
    // 得到8个平均分配的数
    float uv_trunc = random(vec2(trunc(uv.y, 8.0)+100.0*truncTime, 1.0));

    float uv_randomTrunc = 6.0 * trunc(iTime, 24.0 * uv_trunc);
    float blockLine_random = 0.5 * random(vec2(trunc(uv.y + uv_randomTrunc, 8.0 * 0.5), 1.0));
    blockLine_random += 0.5 * random(trunc(uv.yy + uv_randomTrunc, float2(7, 7)));
    blockLine_random = blockLine_random * 2.0 - 1.0;    
    blockLine_random = sign(blockLine_random) * saturate((abs(blockLine_random) - _Amount) / (0.4));
    blockLine_random = lerp(0, blockLine_random, _Offset);
    gl_FragColor = vec4(vec3(uv_randomTrunc), 1.0);
}