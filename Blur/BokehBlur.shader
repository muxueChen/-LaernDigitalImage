#iChannel0 "file://lyf.jpg"

void main() {
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
    vec4 color = texture2D(iChannel0, uv);
    gl_FragColor = color;
}