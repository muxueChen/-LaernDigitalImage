// 在 shadertoy 中，iResolution 表示画布像素高宽。
// 每个fragment的 gl_FragCoord的z接近0.0， 而w 为1.0， 而它的x, y分量，是相对于屏幕左下角为原点的屏幕坐标。什么意思？
// 假如，我们设定的viewport的渲染区域为(0, 0, 1280, 574) 这么大，那么，gl_Fragment的x分量 范围就在0~1280之间， y分量就在0~574之间。
void main(){
  vec2 st = gl_FragCoord.xy/iResolution.xy;
  // 变成正方形
  st.x *= iResolution.x/iResolution.y;
  vec3 color = vec3(0.0);
  float d = 0.0;

  // 将坐标映射到-1～1
  st = st *2.-1.;

  // 做距离场
  d = length( abs(st)-.3 );
  d = length( min(abs(st)-.3,0.) );
  d = length( max(abs(st)-.3,0.) );

  // Visualize the distance field
  gl_FragColor = vec4(vec3(fract(d*10.0)),1.0);

  // Drawing with the distance field
//   gl_FragColor = vec4(vec3( step(.3,d) ),1.0);
//   gl_FragColor = vec4(vec3( step(.3,d) * step(d,.4)),1.0);
//   gl_FragColor = vec4(vec3( smoothstep(.3,.4,d)* smoothstep(.6,.5,d)) ,1.0);
}