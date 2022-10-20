
float rectSDF(vec2 uv) {
    return 2.0 - length(uv*5.0);
}

void main() {
    vec2 uv = (2.0 * gl_FragCoord.xy - iResolution.xy)/min(iResolution.x, iResolution.y);
    float col = step(0.0, rectSDF(uv));
    gl_FragColor = vec4(vec3(1.0, 0.6, 0.0)*col, 1.0);
}