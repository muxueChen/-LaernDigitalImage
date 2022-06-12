// 正弦函数
float plot(vec2 st, float pct){
  return  smoothstep( pct-0.02, pct, st.y) -
          smoothstep( pct, pct+0.02, st.y);
}
const float PI = 3.1415926;
void main() {
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
    float l = (uv.x+iTime)*2.0*PI;
    float y = sin(l)/4.0 + 0.5;
    
    vec3 color = vec3(0.6);
    float pct = plot(uv, y);
    color = (1.0-pct)*color+pct*vec3(0.0,1.0,0.0);
    gl_FragColor = vec4(color, 1.0);
}