#iChannel0 "../yy.jpg"
#iUniform vec4 overlay = vec4(1.0, 1.0, 1.0, 1.0) in {0.0, 1.0}

vec4 blend_normal(vec4 base, vec4 overlay) {
    vec4 dst;
    dst.rgb = overlay.rgb * overlay.a + base.rgb * (1.0 - overlay.a);
    dst.a = overlay.a + base.a - overlay.a * base.a;
    return dst;
}

void main() {
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
    vec4 origin = texture2D(iChannel0, uv);
    gl_FragColor = blend_normal(origin, overlay);
}