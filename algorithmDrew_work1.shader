// 算法绘制
// 使用0.0-1.0之间的值在Y上绘制一条线
float plot(vec2 st, float pct){
  return  smoothstep( pct-0.02, pct, st.y) -
          smoothstep( pct, pct+0.02, st.y);
}

void main(){
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
    float x = uv.x;
    float y = mod(x,0.5);
    y = fract(x); // 仅仅返回数的小数部分
    y = ceil(x);  // 向正无穷取整
    y = floor(x); // 向负无穷取整
    y = sign(x);  // 提取 x 的正负号
    y = abs(x);   // 返回 x 的绝对值
    y = clamp(x,0.0,1.0); // 把 x 的值限制在 0.0 到 1.0
    y = min(0.0,x);   // 返回 x 和 0.0 中的较小值
    y = max(0.0,x);   // 返回 x 和 0.0 中的较大值  
    vec3 color = vec3(0.7);//背景色
    float pct = plot(uv, y);
    // 绘制一条绿色的线
    color = (1.0-pct)*color+pct*vec3(0.0, 1.0, 0.0);
    gl_FragColor = vec4(color,1.0);
}