// KawaseBlur 模糊
#iChannel0 "KawaseBlur3.shader"

vec4 getTexture(vec2 uv) {
    if (uv.x < 0.0 || uv.y < 0.0 || uv.x > iResolution.x || uv.y > iResolution.y) {
        return vec4(0.0);
    }
    return texture2D(iChannel0, uv/iResolution.xy);
}

vec4 kawaseBlur(vec2 uv, vec2 size, float pixelOffset) {
    vec2 uv00 = vec2(uv.x + pixelOffset+0.5, uv.y+pixelOffset+0.5);
    vec2 uv01 = vec2(uv.x + pixelOffset+0.5, uv.y - pixelOffset - 0.5);
    vec2 uv02 = vec2(uv.x - pixelOffset-0.5, uv.y - pixelOffset - 0.5);
    vec2 uv03 = vec2(uv.x - pixelOffset-0.5, uv.y+pixelOffset+0.5);

    vec4 uv00_Color = 0.25 * getTexture(uv00);
    vec4 uv01_Color = 0.25 * getTexture(uv01);
    vec4 uv02_Color = 0.25 * getTexture(uv02);
    vec4 uv03_Color = 0.25 * getTexture(uv03);

    return uv00_Color + uv01_Color + uv02_Color + uv03_Color;
}

void main() {
    vec4 color = kawaseBlur(gl_FragCoord.xy, iResolution.xy, 4.0);
    gl_FragColor = color;
}