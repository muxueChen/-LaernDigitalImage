#iUniform float w = 0.5 in {0.5, 1.0}
#iUniform float h = 0.5 in {0.0, 1.0}
#iUniform float lineW = 0.5 in {0.0, 1.0}
#iUniform float rounded = 0.2 in {0.0, 1.0}
#iUniform int type = 1 in {1, 2}

float boxSDF(vec2 P, vec2 R) {
    vec2 q = abs(P) - R;
    return length(max(q, 0.0)) + min(max(q.x, q.y), 0.0);
}

float roundeRect(vec2 P, vec2 R, float r) {
    return boxSDF(P, R) - r;
}

void main() {
    vec2 uv = (gl_FragCoord.xy*2.0 - iResolution.xy)/min(iResolution.x, iResolution.y);
    float viewW = w;
    float viewH = (iResolution.y/iResolution.x) * h;
    if (iResolution.x > iResolution.y) {
        viewW = iResolution.x/iResolution.y * w;
        viewH = h;
    }

    float roundedW = min(viewW, viewH) * rounded;
    vec2 rect = vec2(viewW - roundedW, viewH - roundedW);
    float d = roundeRect(uv, rect, roundedW);
    
    float outlineW = 0.1 * lineW;
    float c = 0.0;
    if (type == 1) {
        c = 1.0 - smoothstep(-0.01, 0.0, d);
    } else {
        c = smoothstep(-0.0 - outlineW - 0.03, 0.0 - outlineW - 0.02, d) - smoothstep(-0.01, 0.0, d);
    }
    float rectD = boxSDF(uv, vec2(viewW, viewH));
    float rectC = smoothstep(-0.03, -0.02, rectD) - smoothstep(0.0, 0.01, rectD);
    gl_FragColor = vec4(c);
}