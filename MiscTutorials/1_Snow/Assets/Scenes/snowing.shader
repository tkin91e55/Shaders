Shader "Custom/snowing" {
    Properties {
        _MainTex ("Base", 2D) = "white" {}
        _Bump("Bump", 2D) = "bump" {}
        _Snow("Snow Level", Range(0,1)) = 0
        _SnowColor ("Snow Color", Color) = (1.0,1.0,1.0,1.0)
        _SnowDirection ("Snow Direction", Vector) = (0,1,0)
        _SnowDepth("Snow Depth", Range(0,0.3)) = 0.1
        _Wetness ("Wetness", Range(0, .5)) = 0.3
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 200
        
        CGPROGRAM
        #pragma surface surf Lambert vertex:vert
        
        sampler2D _MainTex;
        sampler2D _Bump;
        float _Snow;
        float4 _SnowColor;
        float4 _SnowDirection;
        float _SnowDepth;
        float _Wetness;
        
        struct Input {
            float2 uv_MainTex;
            float2 uv_Bump;
            //worldNormal must exist
            float3 worldNormal;
            INTERNAL_DATA
        };
        
        void vert (inout appdata_full v) {
         //convert local normal to world space
         float4 sn = mul(UNITY_MATRIX_IT_MV, _SnowDirection);
         if(dot(v.normal, sn.xyz) >= lerp(1,-1, (_Snow*2)/3)) {
            v.vertex.xyz += (sn.xyz + v.normal) * _SnowDepth * _Snow;
         }
        }
        
        void surf(Input IN, inout SurfaceOutput o) {
            half4 c = tex2D (_MainTex, IN.uv_MainTex);
            
            o.Normal = UnpackNormal(tex2D(_Bump, IN.uv_Bump));
            
            //float difference = step(0,dot(WorldNormalVector(IN, o.Normal), _SnowDirection.xyz) - lerp(1,-1,_Snow));
            float difference = dot(WorldNormalVector(IN, o.Normal), _SnowDirection.xyz) - lerp(1,-1,_Snow);
            difference = saturate(difference / _Wetness);
            o.Albedo = difference*_SnowColor.rgb + (1-difference) * c.rgb;
            o.Alpha = c.a;
        }
        
        ENDCG
    }
    FallBack "Diffuse"
}
