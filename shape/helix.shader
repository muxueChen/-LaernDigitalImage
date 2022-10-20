#iChannel0 "file://miss.png"

void main() {
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
    vec4 people = texture2D(iChannel0, uv);
    
    float p2 = 3.0*radians(360.0);
    float t = fract(iTime/5.0);
    float pulse = 1.0 - step(t, 1.0 - uv.y);
    float arc = uv.y*p2;
    float targetX = sin(arc)/2.0 + 0.5;

    float lineW = 0.01;
    targetX = step(targetX-0.02, uv.x) - step(targetX+0.02, uv.x);
    targetX = targetX*pulse;
    vec4 lineColor = vec4(targetX);
    float depth = step(0.0, cos(arc));
    
    if(depth == 0.0) {
        gl_FragColor = people.a * people + (1.0 - people.a)*lineColor;
    } else {
        gl_FragColor = lineColor*lineColor.a + people*(1.0-lineColor.a)*people.a;
    }
}