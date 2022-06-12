// 散景模糊
#iChannel0 "file://霓虹中国.jpg"

vec4 bokenBlur(vec2 uv, vec2 size) {
    return vec4(1.0);
}

half4 BokehBlur(VaryingsDefault i)
{
    half2x2 rot = half2x2(_GoldenRot);
    half4 accumulator = 0.0;
    half4 divisor = 0.0;

    half r = 1.0;
    half2 angle = half2(0.0, _Radius);

    for (int j = 0; j < _Iteration; j++) {
        r += 1.0 / r;
        angle = mul(rot, angle);
        half4 bokeh = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, float2(i.texcoord + _PixelSize * (r - 1.0) * angle));
        accumulator += bokeh * bokeh;
        divisor += bokeh;
    }
    return accumulator / divisor;
}