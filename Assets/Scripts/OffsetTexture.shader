Shader "Custom/OffsetTexture" {

	
	Properties {
        _TexStatic ("Static", 2D) = "white" {}
        _TexDynamic ("Dynamic", 2D) = "white" {}
		_AlphaValue("Alpha", float) = 0.01
		_Offset("DynamicOffset", float) = 0.0

		_ColorFactor("ColorFactor", float) = 1
    }
    SubShader {
        Tags { "RenderType"="Fade" }
        LOD 200
       
        CGPROGRAM
        #pragma surface surf Lambert
       
        sampler2D _TexStatic;
        sampler2D _TexDynamic;
 
        float _AlphaValue;
		float _Offset;
		float _ColorFactor;
 

        struct Input {
            float2 uv_TexStatic;
            float2 uv_TexDynamic;
			//float4 xy_Position : POSITION;
			float3 worldPos;
        };
 
        void surf (Input IN, inout SurfaceOutput o) {
            
			//o.Albedo = 0.6 * tex2D(_TexDynamic, float2(IN.uv_TexDynamic.x, IN.uv_TexDynamic.y + _Offset)).rgb + 0.4 * tex2D(_TexStatic, IN.uv_TexStatic).rgb;
            o.Alpha = 0.01;
			
        }
        ENDCG
    }
    FallBack "Diffuse"
	

	
}
