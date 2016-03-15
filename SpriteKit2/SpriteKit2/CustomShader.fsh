void main(){
    vec4 color = SKDefaultShading();
    vec4 noiseSample = texture2D(noiseTexture,v_tex_coord);
    if (noiseSample.a < threshold) {
        color.a = 0.0;
    }
    color.rgb *= color.a;
    gl_FragColor = color;
}