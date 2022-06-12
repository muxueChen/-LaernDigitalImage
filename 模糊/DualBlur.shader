// 双重模糊
#iChannel0 "file://霓虹中国.jpg"

vec4 getTexture(vec2 uv) {
    if (uv.x < 0.0 || uv.y < 0.0 || uv.x > iResolution.x || uv.y > iResolution.y) {
        return vec4(0.0);
    }
    return texture2D(iChannel0, uv/iResolution.xy);
}

vec4 Frag_DownSample(vec2 uv, vec2 size) {
    vec4 color = getTexture(uv) * 4;
    vec4 color1 = getTexture(uv.x - 1.0, uv.y - 1.0);
    vec4 color2 = getTexture(uv.x + 1.0, uv.y - 1.0);
    vec4 color3 = getTexture(uv.x - 1.0, uv.y + 1.0);
    vec4 color4 = getTexture(uv.x + 1.0, uv.y + 1.0);

    return (color+ color1 + color2 + color3 + color4)*0.125;
}

vec4 Frag_UpSample(vec2 uv, vec2 size) {
    vec2 uv00 = vec2(uv.x - 1.0 - 0.5, uv.y - 1.0 - 0.5);
    vec2 uv01 = vec2(uv.x - 1.0 - 0.5, uv.y + 1.0 + 0.5);
    vec2 uv02 = vec2(uv.x + 1.0 + 0.5, uv.y - 1.0 - 0.5);
    vec2 uv03 = vec2(uv.x + 1.0 + 0.5, uv.y + 1.0 + 0.5);

    vec2 uv04 = vec2(uv.x - 2.0, uv.y);
    vec2 uv05 = vec2(uv.x + 2.0, uv.y);
    vec2 uv06 = vec2(uv.x, uv.y - 2.0);
    vec2 uv07 = vec2(uv.x, uv.y + 2.0);
    
    vec4 uv00_Color = 0.05 * getTexture(uv00)*2.0;
    vec4 uv01_Color = 0.1 * getTexture(uv01)*2.0;
    vec4 uv02_Color = 0.15 * getTexture(uv02)*2.0;
    vec4 uv03_Color = 0.4 * getTexture(uv03)*2.0;
    
    vec4 uv04_Color = 0.15 * getTexture(uv04);
    vec4 uv05_Color = 0.1 * getTexture(uv05);
    vec4 uv06_Color = 0.05 * getTexture(uv06);
    vec4 uv07_Color = 0.05 * getTexture(uv07);
    
    vec4 color = (uv00_Color+uv01_Color+uv02_Color+uv03_Color+uv04_Color+uv05_Color+uv06_Color+uv07_Color)*0.083;
    return color;
}