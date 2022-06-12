// 高斯模糊
#iChannel0 "file://霓虹中国.jpg"

vec4 getTexture(vec2 uv) {
    if (uv.x < 0.0 || uv.y < 0.0 || uv.x > iResolution.x || uv.y > iResolution.y) {
        return vec4(0.0);
    }
    return texture2D(iChannel0, uv/iResolution.xy);
}

// 横向高斯
vec4 gaussian_horizontal(vec2 uv, vec2 size) {
    vec2 uv00 = vec2(uv.x - 3.0, uv.y);
    vec2 uv01 = vec2(uv.x - 2.0, uv.y);
    vec2 uv02 = vec2(uv.x - 1.0, uv.y);
    vec2 uv03 = vec2(uv.x, uv.y);
    vec2 uv04 = vec2(uv.x + 1.0, uv.y);
    vec2 uv05 = vec2(uv.x + 2.0, uv.y);
    vec2 uv06 = vec2(uv.x + 3.0, uv.y);

    vec4 uv00_Color = 0.05 * getTexture(uv00);
    vec4 uv01_Color = 0.1 * getTexture(uv01);
    vec4 uv02_Color = 0.15 * getTexture(uv02);
    vec4 uv03_Color = 0.4 * getTexture(uv03);
    vec4 uv04_Color = 0.15 * getTexture(uv04);
    vec4 uv05_Color = 0.1 * getTexture(uv05);
    vec4 uv06_Color = 0.05 * getTexture(uv06);

    return uv00_Color + uv01_Color + uv02_Color + uv03_Color + uv04_Color + uv05_Color + uv06_Color;
}

// 纵向高斯
vec4 gaussian_vertical(vec2 uv, vec2 size) {
    vec2 uv00 = vec2(uv.x, uv.y - 3.0);
    vec2 uv01 = vec2(uv.x, uv.y - 2.0);
    vec2 uv02 = vec2(uv.x, uv.y - 1.0);
    vec2 uv03 = vec2(uv.x, uv.y);
    vec2 uv04 = vec2(uv.x, uv.y + 1.0);
    vec2 uv05 = vec2(uv.x, uv.y + 2.0);
    vec2 uv06 = vec2(uv.x, uv.y + 3.0);
    vec2 uv07 = vec2(uv.x, uv.y + 4.0);
    
    vec4 uv00_Color = 0.05 * getTexture(uv00);
    vec4 uv01_Color = 0.1 * getTexture(uv01);
    vec4 uv02_Color = 0.15 * getTexture(uv02);
    vec4 uv03_Color = 0.4 * getTexture(uv03);
    vec4 uv04_Color = 0.15 * getTexture(uv04);
    vec4 uv05_Color = 0.1 * getTexture(uv05);
    vec4 uv06_Color = 0.05 * getTexture(uv06);

    return uv00_Color + uv01_Color + uv02_Color + uv03_Color + uv04_Color + uv05_Color + uv06_Color;
}

void main() {
    vec4 resultColor = gaussian_horizontal(gl_FragCoord.xy, iResolution.xy);
    gl_FragColor = resultColor;
}