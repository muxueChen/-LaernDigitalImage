// 算法绘制
// 使用0.0-1.0之间的值在Y上绘制一条线
float plot(vec2 st, float pct){
  return  smoothstep( pct-0.02, pct, st.y) -
          smoothstep( pct, pct+0.02, st.y);
}
void main(){
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
    
    float y = smoothstep(0.1,0.9,uv.x);

    vec3 color = vec3(y);//背景色
    float pct = plot(uv, y);
    // 绘制一条绿色的线
    color = (1.0-pct)*color+pct*vec3(0.0, 1.0, 0.0);
    gl_FragColor = vec4(color,1.0);
}