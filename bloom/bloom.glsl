#iChannel0 "file://mipmap1_V.glsl"
#iChannel1 "file://mipmap0_V.glsl"
#iChannel2 "file://shape.glsl"


void main() {
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
    vec4 originColor = texture2D(iChannel2, uv);
    vec4 bloomColor = texture2D(iChannel1, uv);
    vec4 bloom1Color = texture2D(iChannel0, uv);
    gl_FragColor = originColor + bloom1Color + bloomColor;
}