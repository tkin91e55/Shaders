Shader "Custom/RampDiffuse" {
	Properties {
		_EmissiveColor ("Emissive Color", Color) = (1,1,1,1)
		_AmbientColor  ("Ambient Color", Color) = (1,1,1,1)
		_MySliderValue ("This is a Slider", Range(0,10)) = 2.5
		_RampTex ("Ramp Texture", 2D) = "white"{}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
        LOD 200
        
        CGPROGRAM
        #pragma surface surf BasicDiffuse
        
        float4 _EmissiveColor;
        float4 _AmbientColor;
        float _MySliderValue;
        sampler2D _RampTex;
        
        struct Input
        {
          	float2 uv_MainTex;
        };
        
        void surf (Input IN, inout SurfaceOutput o)
        {
            float4 c =  pow((_EmissiveColor + _AmbientColor), _MySliderValue);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        
        inline float4 LightingBasicDiffuse (SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
       	{
       	  	float difLight = max(0, dot (s.Normal, lightDir));
       	  	// Add this line
       	  	float rimLight = max(0, dot (s.Normal, viewDir));
       	  	// Modify this line
       	  	float dif_hLambert = difLight * 0.5 + 0.5;
       	  	// Add this line
       	  	float rim_hLambert = rimLight * 0.5 + 0.5;
       	  	// Modify this line
       	  	float3 ramp = tex2D(_RampTex, float2(dif_hLambert, rim_hLambert)).rgb;
       	  	
       	  	float4 col;
       	  	col.rgb = s.Albedo * _LightColor0.rgb * (ramp);
       	  	col.a = s.Alpha;
       	  	return col;
	}
        
		ENDCG
	} 
	FallBack "Diffuse"
}
