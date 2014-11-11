Shader "Custom/TextureCoordinates/ChessOpt" {
Properties{
_MySliderValue ("This is a Slider", Range(0,10)) = 8
}
    SubShader {
        Pass {
            CGPROGRAM
            float _MySliderValue;
            
            #pragma vertex vert_img
            #pragma fragment frag

            #include "UnityCG.cginc"

            float4 frag(v2f_img i) : COLOR {
                bool p = fmod(i.uv.x*_MySliderValue,2.0) < 1.0;
                bool q = fmod(i.uv.y*_MySliderValue,2.0) > 1.0;
                return float4(float3((p && q) || !(p || q)),1.0);
            }
            ENDCG
        }
    }
}
